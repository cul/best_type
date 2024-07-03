# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength

module BestType
  class PcdmTypeLookup
    attr_reader :config

    # https://github.com/duraspace/pcdm/blob/master/pcdm-ext/file-format-types.rdf
    ARCHIVE = 'Archive'
    AUDIO = 'Audio'
    DATABASE = 'Database'
    DATASET = 'Dataset'
    EMAIL = 'Email'
    FONT = 'Font'
    HTML = 'HTML'
    IMAGE = 'Image'
    PAGE_DESCRIPTION = 'PageDescription'
    PRESENTATION = 'Presentation'
    SOFTWARE = 'Software'
    SOURCE_CODE = 'SourceCode'
    SPREADSHEET = 'Spreadsheet'
    STRUCTURED_TEXT = 'StructuredText'
    TEXT = 'Text'
    UNKNOWN = 'Unknown'
    UNSTRUCTURED_TEXT = 'UnstructuredText'
    VIDEO = 'Video'
    WEBSITE = 'Website'

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
      # Normalize format of file_name_or_path
      file_name_or_path = file_name_or_path.downcase

      for_mime_type(@mime_type_lookup.for_file_name(file_name_or_path))
    end

    def for_mime_type(mime_type)
      # Normalize format of mime_type
      mime_type = mime_type.downcase

      # Check config overrides first
      file_type = @config.mime_type_to_pcdm_type_overrides.fetch(mime_type, nil)
      return file_type unless file_type.nil?

      mimes_to_type = {
        /^image/i => IMAGE,
        /^video/i => VIDEO,
        /^audio/i => AUDIO,
        /^text/i => {
          %r{/css}i => SOURCE_CODE,
          %r{/html}i => HTML,
          /.+/ => TEXT
        },
        /excel|spreadsheet|xls/i => SPREADSHEET,
        %r{application/sql}i => DATABASE,
        /csv/i => DATASET,
        /octet.stream/i => UNKNOWN,
        /^application/i => {
          %r{/access}i => DATABASE,
          %r{/css}i => SOURCE_CODE,
          %r{/html}i => HTML,
          %r{/x-iwork-keynote}i => PRESENTATION,
          %r{/x-iwork-numbers}i => SPREADSHEET,
          %r{/x-iwork-pages}i => PAGE_DESCRIPTION,
          %r{/mbox}i => EMAIL,
          %r{/mp4}i => VIDEO,
          %r{/mp4a}i => AUDIO,
          %r{/msaccess}i => DATABASE,
          %r{/mxf}i => VIDEO,
          %r{/(pdf|msword)}i => PAGE_DESCRIPTION,
          %r{/postscript}i => PAGE_DESCRIPTION,
          %r{/powerpoint}i => PRESENTATION,
          %r{/rtf}i => PAGE_DESCRIPTION,
          %r{/sql}i => DATABASE,
          %r{/swf} => VIDEO,
          %r{/vnd.ms-asf}i => VIDEO,
          %r{/vnd.ms-word}i => PAGE_DESCRIPTION,
          %r{/vnd.ms-wpl}i => PAGE_DESCRIPTION,
          %r{/vnd.oasis.opendocument.text}i => PAGE_DESCRIPTION,
          %r{/vnd.openxmlformats-officedocument.presentation}i => PRESENTATION,
          %r{/vnd.openxmlformats-officedocument.wordprocessingml}i => PAGE_DESCRIPTION,
          %r{/vnd.ms-powerpoint}i => PRESENTATION,
          %r{/vnd.sun.xml.calc}i => SPREADSHEET,
          %r{/vnd.sun.xml.impress}i => PRESENTATION,
          %r{/vnd.sun.xml.writer}i => PAGE_DESCRIPTION,
          %r{/xml}i => STRUCTURED_TEXT,
          %r{/x.mspublisher}i => PAGE_DESCRIPTION,
          %r{/x.shockwave-flash} => VIDEO,
          %r{/x.spss}i => DATASET,
          %r{/zip}i => ARCHIVE,
          /.+/ => UNKNOWN
        }
      }

      file_type = mimes_to_type.detect { |pattern, _type_val| mime_type =~ pattern }
      return fallback_type unless file_type

      file_type = file_type.last.detect { |pattern, _type_val| mime_type =~ pattern } if file_type&.last.is_a? Hash
      file_type.nil? ? fallback_type : file_type.last
    end
  end
end
