require 'mime-types'

module BestType
  class MimeTypeLookup

    attr_reader :config

    FALLBACK_MIME_TYPE_VALUE = 'application/octet-stream'.freeze

    def initialize(config)
      @config = config
    end

    def for_file_name(file_name_or_path)
      # Normalize format of file_name_or_path
      file_name_or_path = file_name_or_path.downcase

      extension = File.extname(file_name_or_path)
      extension = extension[1..-1] unless extension.empty?

      # Check config overrides first
      unless extension.empty?
        mime_type = @config.extension_to_mime_type_overrides.fetch(extension, nil)
        return mime_type unless mime_type.nil?
      end

      # Fall back to regular lookup
      detected_mime_types = MIME::Types.of(file_name_or_path)
      detected_mime_types.empty? ? FALLBACK_MIME_TYPE_VALUE : detected_mime_types.first.content_type
    end

  end
end
