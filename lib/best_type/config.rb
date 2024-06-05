# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

module BestType
  class Config
    attr_reader :extension_to_mime_type_overrides, :mime_type_to_dc_type_overrides, :mime_type_to_pcdm_type_overrides

    def initialize(user_config_options = {})
      # Get defaults from internal_custom_mapping.yml in gem
      gem_dir = Gem::Specification.find_by_name('best_type').gem_dir
      internal_config_file_path = File.join(gem_dir, 'config/internal_config_options.yml')
      internal_config_options = YAML.load_file(internal_config_file_path)

      @extension_to_mime_type_overrides = internal_config_options['extension_to_mime_type_overrides'] || {}
      @mime_type_to_dc_type_overrides = internal_config_options['mime_type_to_dc_type_overrides'] || {}
      @mime_type_to_pcdm_type_overrides = internal_config_options['mime_type_to_pcdm_type_overrides'] || {}

      stringify_user_config_options_keys!(user_config_options)
      if user_config_options.key?('extension_to_mime_type_overrides')
        add_extension_to_mime_type_overrides(user_config_options['extension_to_mime_type_overrides'])
      end
      if user_config_options.key?('mime_type_to_dc_type_overrides')
        add_mime_type_to_dc_type_overrides(user_config_options['mime_type_to_dc_type_overrides'])
      end
      return unless user_config_options.key?('mime_type_to_pcdm_type_overrides')

      add_mime_type_to_pcdm_type_overrides(user_config_options['mime_type_to_pcdm_type_overrides'])
    end

    private

    # Returns a new Hash with downcased keys
    def downcase_hash_keys(hsh)
      hsh.transform_keys(&:downcase)
    end

    def downcase_hash_keys_and_values(hsh)
      hsh.map { |k, v| [k.downcase, v.downcase] }.to_h
    end

    def add_extension_to_mime_type_overrides(overrides)
      @extension_to_mime_type_overrides.merge!(downcase_hash_keys_and_values(overrides))
    end

    def add_mime_type_to_dc_type_overrides(overrides)
      @mime_type_to_dc_type_overrides.merge!(downcase_hash_keys(overrides))
    end

    def add_mime_type_to_pcdm_type_overrides(overrides)
      @mime_type_to_pcdm_type_overrides.merge!(downcase_hash_keys(overrides))
    end

    def stringify_user_config_options_keys!(user_config_options)
      user_config_options_keys = user_config_options.keys
      user_config_options_keys.each do |key|
        if key.is_a?(Symbol)
          val = user_config_options.delete(key)
          user_config_options[key.to_s] = val
        end
      end
      user_config_options_keys
    end
  end
end
