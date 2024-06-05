require 'spec_helper'
require 'best_type/config'

describe BestType::Config do
  let(:config) {
    BestType::Config.new(
      extension_to_mime_type_overrides: {
        'custom' => 'custom/type',
        'OTHER' => 'Other/Type',
      },
      mime_type_to_dc_type_overrides: {
        'custom/type' => 'Custom',
        'OTHER/TYPE' => 'Other',
      },
      mime_type_to_pcdm_type_overrides: {
        'custom/type' => 'Custom',
        'OTHER/TYPE' => 'Other',
      }
    )
  }

  context '#initialize' do
    it  'creates a new Config instance with the base configuration from internal_config_options.yml '\
        'file, merges in user config values, and downcases override keys as expected (but not override values)' do
      expect(config.extension_to_mime_type_overrides).to include({
        'test' => 'test/type',
        'custom' => 'custom/type',
        'other' => 'Other/Type', # NOTE: They key here has been downcased
      })
      expect(config.mime_type_to_dc_type_overrides).to include({
        'test/type' => 'Test',
        'custom/type' => 'Custom',
        'other/type' => 'Other', # NOTE: They key here has been downcased
      })
      expect(config.mime_type_to_pcdm_type_overrides).to include({
        'test/type' => 'Test',
        'custom/type' => 'Custom',
        'other/type' => 'Other', # NOTE: They key here has been downcased
      })
    end
  end

  context "private methods" do
    context '#add_extension_to_mime_type_overrides' do
      it do
        expect(config.extension_to_mime_type_overrides).to include({
          'test' => 'test/type',
          'custom' => 'custom/type'
        })
        config.send(:add_extension_to_mime_type_overrides, {'zzz' => 'zzz/type'})
        expect(config.extension_to_mime_type_overrides).to include({
          'test' => 'test/type',
          'custom' => 'custom/type',
          'zzz' => 'zzz/type'
        })
      end
    end

    context '#add_mime_type_to_dc_type_overrides' do
      it do
        expect(config.mime_type_to_dc_type_overrides).to include({
          'test/type' => 'Test',
          'custom/type' => 'Custom',
        })
        config.send(:add_mime_type_to_dc_type_overrides, {'zzz/type' => 'Zzz'})
        expect(config.mime_type_to_dc_type_overrides).to include({
          'test/type' => 'Test',
          'custom/type' => 'Custom',
          'zzz/type' => 'Zzz'
        })
      end
    end

    context '#stringify_user_config_options_keys!' do
      let(:options) {
        {
          :option1 => 'value',
          :option2 => 'value',
          'option3' => 'value',
          'option4' => 'value'
        }
      }
      let(:options_with_stringified_keys) {
        {
          'option1' => 'value',
          'option2' => 'value',
          'option3' => 'value',
          'option4' => 'value'
        }
      }
      it "converts as expected" do
        config.send(:stringify_user_config_options_keys!, options)
        expect(options).to eq(options_with_stringified_keys)
      end
    end
  end

end
