module BestType
  class Config

    attr_reader :extension_to_mime_type_overrides, :mime_type_to_dc_type_overrides

    def initialize(user_config_options = {})
      # Get defaults from internal_custom_mapping.yml in gem
      gem_dir = Gem::Specification.find_by_name('best_type').gem_dir
      internal_config_file_path = File.join(gem_dir, 'config/internal_config_options.yml')
      internal_config_options = YAML.load_file(internal_config_file_path)

      @extension_to_mime_type_overrides = internal_config_options['extension_to_mime_type_overrides']
      @mime_type_to_dc_type_overrides = internal_config_options['mime_type_to_dc_type_overrides']

      stringify_user_config_options_keys!(user_config_options)
      add_extension_to_mime_type_overrides(user_config_options['extension_to_mime_type_overrides']) if user_config_options.key?('extension_to_mime_type_overrides')
      add_mime_type_to_dc_type_overrides(user_config_options['mime_type_to_dc_type_overrides']) if user_config_options.key?('mime_type_to_dc_type_overrides')
    end

    private

    def add_extension_to_mime_type_overrides(overrides)
      @extension_to_mime_type_overrides.merge!(overrides)
    end

    def add_mime_type_to_dc_type_overrides(overrides)
      @mime_type_to_dc_type_overrides.merge!(overrides)
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
