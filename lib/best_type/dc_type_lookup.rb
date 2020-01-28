module BestType
  class DcTypeLookup

    attr_reader :config

    COLLECTION = 'Collection'.freeze
    DATASET = 'Dataset'.freeze
    EVENT = 'Event'.freeze
    INTERACTIVE_RESOURCE = 'InteractiveResource'.freeze
    MOVING_IMAGE = 'MovingImage'.freeze
    PHYSICAL_OBJECT = 'PhysicalObject'.freeze
    SERVICE = 'Service'.freeze
    SOFTWARE = 'Software'.freeze
    SOUND = 'Sound'.freeze
    STILL_IMAGE = 'StillImage'.freeze
    TEXT = 'Text'.freeze

    # these include values that will not be derived from MIME/content types
    VALID_TYPES = [
      COLLECTION, EVENT, INTERACTIVE_RESOURCE, MOVING_IMAGE, PHYSICAL_OBJECT,
      SERVICE, SOFTWARE, SOUND, STILL_IMAGE, TEXT
    ].freeze

    FALLBACK_DC_TYPE = SOFTWARE

    def initialize(mime_type_lookup_instance)
      @mime_type_lookup = mime_type_lookup_instance
      @config = @mime_type_lookup.config
    end

    def fallback_type
      FALLBACK_DC_TYPE
    end

    def valid_type?(value)
      VALID_TYPES.include? value
    end

    def for_file_name(file_name_or_path)
      for_mime_type(@mime_type_lookup.for_file_name(file_name_or_path))
    end

    def for_mime_type(mime_type)
      # Check config overrides first
      dc_type = @config.mime_type_to_dc_type_overrides.fetch(mime_type, nil)
      return dc_type unless dc_type.nil?

      mimes_to_dc = {
        /^image/ => STILL_IMAGE,
        /^video/ => MOVING_IMAGE,
        /^audio/ => SOUND,
        /^text/ => TEXT,
        /^application\/(pdf|msword)/ => TEXT,
        /excel|spreadsheet|xls|application\/sql/ => DATASET,
        /^application/ => SOFTWARE
      }

      dc_type = mimes_to_dc.find { |pattern, _type_val| mime_type =~ pattern }
      dc_type.nil? ? FALLBACK_DC_TYPE : dc_type.last
    end

  end
end
