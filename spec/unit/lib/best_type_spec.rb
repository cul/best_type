require 'spec_helper'
require 'best_type'
require 'best_type/mime_type_lookup'
require 'best_type/dc_type_lookup'

describe BestType do

  context ".mime_type" do
    it "returns a new MimeTypeLookup instance" do
      expect(described_class.mime_type).to be_a(BestType::MimeTypeLookup)
    end
  end

  context ".dc_type" do
    it "returns a new DcTypeLookup instance" do
      expect(described_class.dc_type).to be_a(BestType::DcTypeLookup)
    end
  end

  context ".config" do
    it "returns a new Config instance" do
      expect(described_class.config).to be_a(BestType::Config)
    end
  end

  context ".configure" do
    before(:context) {
      described_class.configure(
        extension_to_mime_type_overrides: {
          'custom' => 'custom/type'
        },
        mime_type_to_dc_type_overrides: {
          'custom/type' => 'Custom'
        }
      )
    }
    after(:context) {
      described_class.configure({}) # don't let this configuration affect other tests outside of this context
    }
    it "returns a new Config instance with the base configuration from internal_config_options.yml file and any provided user config values merged in" do
      expect(described_class.config.extension_to_mime_type_overrides).to eq({
        'test' => 'test/type',
        'mp4' => 'video/mp4',
        'custom' => 'custom/type'
      })
      expect(described_class.config.mime_type_to_dc_type_overrides).to eq({
        'test/type' => 'Test',
        'custom/type' => 'Custom'
      })
    end
  end

end
