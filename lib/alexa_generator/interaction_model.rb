require 'alexa_generator/intent_schema'
require 'alexa_generator/sample_utterance_template'
require 'alexa_generator/slot_binding'

require 'set'

module AlexaGenerator
  class InteractionModel
    attr_reader :intents

    class Builder
      def initialize
        @intents = []
        @bindings = []
        @utterance_templates = []
      end

      def add_intent(name, &block)
        builder = Intent.build(name, &block)
        @bindings.concat(builder.bindings)
        @utterance_templates.concat(builder.utterance_templates)
        @intents.push(builder.create)
      end

      def create
        InteractionModel.new(@intents, @utterance_templates, @bindings)
      end
    end

    def initialize(intents, utterance_templates, slot_bindings)
      # Validate that utterance templates reference only defined slots
      all_referenced_slots = utterance_templates.map(&:referenced_slots).flatten
      slot_names = Set.new(intents.map(&:slots).flatten.map(&:name))
      undefined_slots = all_referenced_slots.reject { |x| slot_names.include?(x) }

      if undefined_slots.any?
        raise AlexaSyntaxError,
              "The following slots referenced in utterances are undefined: #{undefined_slots.join ','}"
      end

      @intents = Hash[ intents.map {|x| [x.name, x]} ]

      @utterance_templates = utterance_templates.group_by { |x| x.intent_name }
      @slot_bindings = slot_bindings.group_by { |x| x.slot_name }
    end

    def intent_schema
      intents = []

      @intents.values.each do |intent|
        if intent.slots.any?
          slots = []

          intent.slots.each do |slot|
            slots << {name: slot.name, type: slot.type}
          end

          intents << {intent: intent.name, slots: slots}
        else
          intents << {intent: intent.name}
        end
      end

      { intents: intents }
    end

    def sample_utterances(intent_name)
      templates = @utterance_templates[intent_name] || []
      slot_types = collect_slot_types
      utterances = Set.new

      templates.each do |template|
        # Consider only the slots that are referenced in this template
        relevant_slots = template.referenced_slots

        # Amazon wants only the LITERAL ones
        relevant_slots.select! do |s|
          AlexaGenerator::Slot::SlotType.literal?(slot_types[s.to_sym])
        end

        # Compute all possible value bindings for the relevant slots
        slot_values = relevant_slots.
            # Extract value bindings for each slot
            map { |slot| @slot_bindings[slot] }

        if slot_values.any?
          slot_value_combinations = slot_values.first

          if slot_values.count > 1
            remaining_values = slot_values[1..-1]
            slot_value_combinations = slot_value_combinations.product(*remaining_values)
          else
            slot_value_combinations = slot_value_combinations.map { |x| [x] }
          end

          slot_value_combinations.each do |value_binding|
            raw_template = template.template.dup

            value_binding.each do |binding|
              binding.bind_to_template!( raw_template )
            end

            utterances.add( raw_template )
          end
        # If there are no slot values, then just stuff the untouched template into utterances.
        else
          utterances.add( template.template )
        end
      end

      utterances.sort.map do |utterance|
        "#{intent_name} #{utterance}"
      end
    end

    def slot_type_values(slot_type)
      bindings = Set.new
      @intents.values.each do |intent|
        intent.slots.each do |slot|
          if slot.type.to_s == slot_type.to_s
            bindings += slot.bindings
          end
        end
      end
      bindings.to_a
    end

    def custom_slot_types
      slots = collect_slot_types
      custom_types = slots.values.select do |x|
        AlexaGenerator::Slot::SlotType.custom?(x)
      end
      Set.new(custom_types).to_a
    end

    def collect_slot_types
      out = {}
      @intents.values.each do |intent|
        intent.slots.map do |slot|
          out[slot.name.to_sym] = slot.type.to_s
        end
      end
      out
    end

    def self.build(&block)
      builder = Builder.new
      block.call(builder)
      builder.create
    end
  end
end
