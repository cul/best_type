module BestType
  class PcdmTypeLookup

    attr_reader :config

    # https://github.com/duraspace/pcdm/blob/master/pcdm-ext/file-format-types.rdf
    ARCHIVE = "Archive".freeze
    AUDIO = "Audio".freeze
    DATABASE = "Database".freeze
    DATASET = "Dataset".freeze
    EMAIL = "Email".freeze
    FONT = "Font".freeze
    HTML = "HTML".freeze
    IMAGE = "Image".freeze
    PAGE_DESCRIPTION = "PageDescription".freeze
    PRESENTATION = "Presentation".freeze
    SOFTWARE = "Software".freeze
    SOURCE_CODE = "SourceCode".freeze
    SPREADSHEET = "Spreadsheet".freeze
    STRUCTURED_TEXT = "StructuredText".freeze
    TEXT = "Text".freeze
    UNKNOWN = "Unknown".freeze
    UNSTRUCTURED_TEXT = "UnstructuredText".freeze
    VIDEO = "Video".freeze
    WEBSITE = "Website".freeze

    # these include values that will not be derived from MIME/content types
    VALID_TYPES = [
      ARCHIVE, AUDIO, DATABASE, DATASET, EMAIL, FONT, HTML, IMAGE, PAGE_DESCRIPTION, PRESENTATION, SOFTWARE,
      SOURCE_CODE, SPREADSHEET, STRUCTURED_TEXT, TEXT, UNKNOWN, UNSTRUCTURED_TEXT, VIDEO, WEBSITE
    ].freeze

    FALLBACK_TYPE = UNKNOWN

    def initialize(mime_type_lookup_instance)
      @mime_type_lookup = mime_type_lookup_instance
      @config = @mime_type_lookup.config
    end

    def fallback_type
      FALLBACK_TYPE
    end

    def valid_type?(value)
      VALID_TYPES.include? value
    end

    def for_file_name(file_name_or_path)
      for_mime_type(@mime_type_lookup.for_file_name(file_name_or_path))
    end

    def for_mime_type(mime_type)
      # Check config overrides first
      file_type = @config.mime_type_to_pcdm_type_overrides.fetch(mime_type, nil)
      return file_type unless file_type.nil?

      mimes_to_type = {
        /^image/i => IMAGE,
        /^video/i => VIDEO,
        /^audio/i => AUDIO,
        /^text/i => {
          /\/css/i => SOURCE_CODE,
          /\/html/i => HTML,
          /.+/ => TEXT
        },
        /excel|spreadsheet|xls/i => SPREADSHEET,
        /application\/sql/i => DATABASE,
        /csv/i => DATASET,
        /octet.stream/i => UNKNOWN,
        /^application/i => {
          /\/access/i => DATABASE,
          /\/css/i => SOURCE_CODE,
          /\/html/i => HTML,
          /\/mbox/i => EMAIL,
          /\/mp4/i => VIDEO,
          /\/mp4a/i => AUDIO,
          /\/msaccess/i => DATABASE,
          /\/mxf/i => VIDEO,
          /\/(pdf|msword)/i => PAGE_DESCRIPTION,
          /\/postscript/i => PAGE_DESCRIPTION,
          /\/powerpoint/i => PRESENTATION,
          /\/rtf/i => PAGE_DESCRIPTION,
          /\/sql/i => DATABASE,
          /\/swf/ => VIDEO,
          /\/vnd.ms-asf/i => VIDEO,
          /\/vnd.ms-word/i => PAGE_DESCRIPTION,
          /\/vnd.ms-wpl/i => PAGE_DESCRIPTION,
          /\/vnd.oasis.opendocument.text/i => PAGE_DESCRIPTION,
          /\/vnd.openxmlformats-officedocument.presentation/i => PRESENTATION,
          /\/vnd.openxmlformats-officedocument.wordprocessingml/i => PAGE_DESCRIPTION,
          /\/vnd.ms-powerpoint/i => PRESENTATION,
          /\/vnd.sun.xml.calc/i => SPREADSHEET,
          /\/vnd.sun.xml.impress/i => PRESENTATION,
          /\/vnd.sun.xml.writer/i => PAGE_DESCRIPTION,
          /\/xml/i => STRUCTURED_TEXT,
          /\/x.mspublisher/i => PAGE_DESCRIPTION,
          /\/x.shockwave-flash/ => VIDEO,
          /\/x.spss/i => DATASET,
          /\/zip/i => ARCHIVE,
          /.+/ => UNKNOWN
        }
      }

      file_type = mimes_to_type.detect { |pattern, _type_val| mime_type =~ pattern }
      return fallback_type unless file_type
      if file_type&.last.is_a? Hash
        file_type = file_type.last.detect { |pattern, _type_val| mime_type =~ pattern }
      end
      file_type.nil? ? fallback_type : file_type.last
    end

  end
end
