# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

module BestType
  class DcTypeLookup
    attr_reader :config

    COLLECTION = 'Collection'
    DATASET = 'Dataset'
    EVENT = 'Event'
    INTERACTIVE_RESOURCE = 'InteractiveResource'
    MOVING_IMAGE = 'MovingImage'
    PHYSICAL_OBJECT = 'PhysicalObject'
    SERVICE = 'Service'
    SOFTWARE = 'Software'
    SOUND = 'Sound'
    STILL_IMAGE = 'StillImage'
    TEXT = 'Text'

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
      # Normalize format of file_name_or_path
      file_name_or_path = file_name_or_path.downcase

      for_mime_type(@mime_type_lookup.for_file_name(file_name_or_path))
    end

    def for_mime_type(mime_type)
      # Normalize format of mime_type
      mime_type = mime_type.downcase

      # Check config overrides first
      dc_type = @config.mime_type_to_dc_type_overrides.fetch(mime_type, nil)
      return dc_type unless dc_type.nil?

      mimes_to_dc = {
        /^image/ => STILL_IMAGE,
        /^video/ => MOVING_IMAGE,
        /^audio/ => SOUND,
        /^text/ => TEXT,
        %r{^application/(pdf|msword)} => TEXT,
        %r{excel|spreadsheet|xls|application/sql} => DATASET,
        /^application/ => SOFTWARE
      }

      dc_type = mimes_to_dc.find { |pattern, _type_val| mime_type =~ pattern }
      dc_type.nil? ? FALLBACK_DC_TYPE : dc_type.last
    end
  end
end
