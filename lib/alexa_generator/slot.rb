module AlexaGenerator
  class Slot
    module SlotType
      LITERAL = :"AMAZON.LITERAL"
      NUMBER = :"AMAZON.NUMBER"
      DATE = :"AMAZON.DATE"
      TIME = :"AMAZON.TIME"
      DURATION = :"AMAZON.DURATION"
      ACTOR = :"AMAZON.Actor"
      ADMINISTRATIVE_AREA = :"AMAZON.AdministrativeArea"
      AGGREGATE_RATING = :"AMAZON.AggregateRating"
      AIRLINE = :"AMAZON.Airline"
      AIRPORT = :"AMAZON.Airport"
      ANIMAL = :"AMAZON.Animal"
      ARTIST = :"AMAZON.Artist"
      AT_CITY = :"AMAZON.AT_CITY"
      AT_REGION = :"AMAZON.AT_REGION"
      ATHLETE = :"AMAZON.Athlete"
      AUTHOR = :"AMAZON.Author"
      BOOK = :"AMAZON.Book"
      BOOK_SERIES = :"AMAZON.BookSeries"
      BROADCAST_CHANNEL = :"AMAZON.BroadcastChannel"
      CIVIC_STRUCTURE = :"AMAZON.CivicStructure"
      COLOR = :"AMAZON.Color"
      COMIC = :"AMAZON.Comic"
      CORPORATION = :"AMAZON.Corporation"
      COUNTRY = :"AMAZON.Country"
      CREATIVE_WORK_TYPE = :"AMAZON.CreativeWorkType"
      DAY_OF_WEEK = :"AMAZON.DayOfWeek"
      DE_CITY = :"AMAZON.DE_CITY"
      DE_FIRST_NAME = :"AMAZON.DE_FIRST_NAME"
      DE_REGION = :"AMAZON.DE_REGION"
      DESSERT = :"AMAZON.Dessert"
      DEVICE_TYPE = :"AMAZON.DeviceType"
      DIRECTOR = :"AMAZON.Director"
      DRINK = :"AMAZON.Drink"
      EDUCATIONAL_ORGANIZATION = :"AMAZON.EducationalOrganization"
      EUROPE_CITY = :"AMAZON.EUROPE_CITY"
      EVENT_TYPE = :"AMAZON.EventType"
      FESTIVAL = :"AMAZON.Festival"
      FICTIONAL_CHARACTER = :"AMAZON.FictionalCharacter"
      FINANCIAL_SERVICE = :"AMAZON.FinancialService"
      FOOD = :"AMAZON.Food"
      FOOD_ESTABLISHMENT = :"AMAZON.FoodEstablishment"
      GAME = :"AMAZON.Game"
      GB_CITY = :"AMAZON.GB_CITY"
      GB_FIRST_NAME = :"AMAZON.GB_FIRST_NAME"
      GB_REGION = :"AMAZON.GB_REGION"
      GENRE = :"AMAZON.Genre"
      LANDFORM = :"AMAZON.Landform"
      LANDMARKS_OR_HISTORICAL_BUILDINGS = :"AMAZON.LandmarksOrHistoricalBuildings"
      LANGUAGE = :"AMAZON.Language"
      LOCAL_BUSINESS = :"AMAZON.LocalBusiness"
      LOCAL_BUSINESS_TYPE = :"AMAZON.LocalBusinessType"
      MEDICAL_ORGANIZATION = :"AMAZON.MedicalOrganization"
      MONTH = :"AMAZON.Month"
      MOVIE = :"AMAZON.Movie"
      MOVIE_SERIES = :"AMAZON.MovieSeries"
      MOVIE_THEATER = :"AMAZON.MovieTheater"
      MUSIC_ALBUM = :"AMAZON.MusicAlbum"
      MUSIC_CREATIVE_WORK_TYPE = :"AMAZON.MusicCreativeWorkType"
      MUSIC_EVENT = :"AMAZON.MusicEvent"
      MUSIC_GROUP = :"AMAZON.MusicGroup"
      MUSICIAN = :"AMAZON.Musician"
      MUSIC_PLAYLIST = :"AMAZON.MusicPlaylist"
      MUSIC_RECORDING = :"AMAZON.MusicRecording"
      MUSIC_VENUE = :"AMAZON.MusicVenue"
      MUSIC_VIDEO = :"AMAZON.MusicVideo"
      ORGANIZATION = :"AMAZON.Organization"
      PERSON = :"AMAZON.Person"
      POSTAL_ADDRESS = :"AMAZON.PostalAddress"
      PROFESSIONAL = :"AMAZON.Professional"
      PROFESSIONAL_TYPE = :"AMAZON.ProfessionalType"
      RADIO_CHANNEL = :"AMAZON.RadioChannel"
      RESIDENCE = :"AMAZON.Residence"
      ROOM = :"AMAZON.Room"
      SCREENING_EVENT = :"AMAZON.ScreeningEvent"
      SERVICE = :"AMAZON.Service"
      SOCIAL_MEDIA_PLATFORM = :"AMAZON.SocialMediaPlatform"
      SOFTWARE_APPLICATION = :"AMAZON.SoftwareApplication"
      SOFTWARE_GAME = :"AMAZON.SoftwareGame"
      SPORT = :"AMAZON.Sport"
      SPORTS_EVENT = :"AMAZON.SportsEvent"
      SPORTS_TEAM = :"AMAZON.SportsTeam"
      STREET_ADDRESS = :"AMAZON.StreetAddress"
      TELEVISION_CHANNEL = :"AMAZON.TelevisionChannel"
      TV_EPISODE = :"AMAZON.TVEpisode"
      TV_SEASON = :"AMAZON.TVSeason"
      TV_SERIES = :"AMAZON.TVSeries"
      US_CITY = :"AMAZON.US_CITY"
      US_FIRST_NAME = :"AMAZON.US_FIRST_NAME"
      US_STATE = :"AMAZON.US_STATE"
      VIDEO_GAME = :"AMAZON.VideoGame"
      WEATHER_CONDITION = :"AMAZON.WeatherCondition"
      WRITTEN_CREATIVE_WORK_TYPE = :"AMAZON.WrittenCreativeWorkType"

      def self.literal?(value)
        [:LITERAL, LITERAL].include?(value.to_sym)
      end

      def self.custom?(value)
        !literal?(value) && !value.to_s.start_with?('AMAZON.')
      end
    end

    class Builder
      attr_reader :bindings

      def initialize(name, type)
        @name = name
        @type = type
        @bindings = []
      end

      def add_binding(value)
        add_bindings(value)
      end

      def add_bindings(*values)
        @bindings.concat(values)
      end

      def create
        Slot.new(@name, @type, @bindings)
      end
    end

    attr_reader :name, :type, :bindings

    def initialize(name, type, bindings)
      @name = name.to_sym
      @type = type
      @bindings = bindings
    end

    def self.build(name, type, &block)
      builder = Builder.new(name, type)
      block.call(builder) if block
      builder
    end
  end
end
