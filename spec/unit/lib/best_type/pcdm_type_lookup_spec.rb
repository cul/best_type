require 'spec_helper'
require 'best_type/config'
require 'best_type/mime_type_lookup'
require 'best_type/pcdm_type_lookup'
require 'csv'
require 'yaml'

describe BestType::PcdmTypeLookup do
  let(:config) {
    BestType::Config.new(
      extension_to_mime_type_overrides: {
        'custom' => 'custom/type'
      },
      mime_type_to_pcdm_type_overrides: {
        'custom/type' => 'Custom'
      }
    )
  }
  let(:mime_type_lookup) {
    BestType::MimeTypeLookup.new(config)
  }
  let(:pcdm_type_lookup) {
    described_class.new(mime_type_lookup)
  }

  context '#initialize' do
    it "it stores a copy of the passed-in MimeTypeLookup instance" do
      expect(pcdm_type_lookup.instance_variable_get(:@mime_type_lookup)).to eq(mime_type_lookup)
    end
    it "sets its config to the config of the passed-in MimeTypeLookup instance" do
      expect(pcdm_type_lookup.config).to eq(mime_type_lookup.config)
    end
  end

  context '#for_file_name' do
    let(:file_name) { 'file.jpeg' }
    it "uses its internal MimeTypeLookup instance to convert the passed in filename to a mime type, and then passes that mime type to #for_mime_type" do
      expect(pcdm_type_lookup.instance_variable_get(:@mime_type_lookup)).to receive(:for_file_name).with(file_name).and_call_original
      pcdm_type_lookup.for_file_name(file_name)
    end
  end

  context '#for_mime_type' do
    context "works as expected to" do
      CSV.open("spec/fixtures/pcdm-type-verifications.csv").each do |row|
        mime_type, dc_type = row
        it "map #{mime_type} to #{dc_type}" do
          expect(pcdm_type_lookup.for_mime_type(mime_type)).to eq(dc_type)
        end
      end
    end

    it "falls back to FALLBACK_DC_TYPE when given mime type is not real, and cannot be resolved to any internal or custom mapping" do
      expect(pcdm_type_lookup.for_mime_type('definitelynotreal/veryfake')).to eq(pcdm_type_lookup.fallback_type)
    end

    it "can identify custom file extensions from the gem's internal_custom_mapping.yml file" do
      expect(pcdm_type_lookup.for_mime_type('test/type')).to eq('Test')
    end

    context "can identify custom file extensions passed in via configuration" do
      it do
        expect(pcdm_type_lookup.for_mime_type('custom/type')).to eq('Custom')
      end
    end
  end

end
