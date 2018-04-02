module BestType
  class DcTypeLookup

    attr_reader :config

    FALLBACK_DC_TYPE = 'Software'.freeze

    def initialize(mime_type_lookup_instance)
      @mime_type_lookup = mime_type_lookup_instance
      @config = @mime_type_lookup.config
    end

    def for_file_name(file_name_or_path)
      for_mime_type(@mime_type_lookup.for_file_name(file_name_or_path))
    end

    def for_mime_type(mime_type)
      # Check config overrides first
      dc_type = @config.mime_type_to_dc_type_overrides.fetch(mime_type, nil)
      return dc_type unless dc_type.nil?

      mimes_to_dc = {
        /^image/ => 'StillImage',
        /^video/ => 'MovingImage',
        /^audio/ => 'Sound',
        /^text/ => 'Text',
        /^application\/(pdf|msword)/ => 'Text',
        /excel|spreadsheet|xls|application\/sql/ => 'Dataset',
        /^application/ => 'Software'
      }

      dc_type = mimes_to_dc.find { |pattern, _type_val| mime_type =~ pattern }
      dc_type.nil? ? FALLBACK_DC_TYPE : dc_type.last
    end

  end
end
