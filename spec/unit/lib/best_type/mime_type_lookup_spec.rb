require 'spec_helper'
require 'best_type/config'
require 'best_type/mime_type_lookup'

describe BestType::MimeTypeLookup do
  let(:config) {
    BestType::Config.new(
      extension_to_mime_type_overrides: {
        'custom' => 'custom/type'
      },
      mime_type_to_dc_type_overrides: {
        'custom/type' => 'Custom'
      }
    )
  }
  let(:mime_type_lookup) {
    BestType::MimeTypeLookup.new(config)
  }

  context ".for_file_name" do
    context "works as expected for various file extensions" do
      let(:ext_to_mime_type_mapping) {
        {
          'file.txt' => 'text/plain',
          'file.html' => 'text/html',
          'file.jpeg' => 'image/jpeg',
          'file.jpg' => 'image/jpeg',
          'file.JPG' => 'image/jpeg',
          'file.JpG' => 'image/jpeg',
          'file.jPg' => 'image/jpeg',
          'something.tar.gz' => 'application/gzip',
          'why.did.i.name.this.file.like.this.jpg' => 'image/jpeg',
          '.htaccess' => 'application/octet-stream',
        }
      }
      it do
        ext_to_mime_type_mapping.each do |filename, mime_type|
          expect(mime_type_lookup.for_file_name(filename)).to eq(mime_type)
        end
      end
    end

    it "can identify custom file extensions from the gem's internal_custom_mapping.yml file" do
      expect(mime_type_lookup.for_file_name('myfile.test')).to eq('test/type')
    end

    context "can identify custom file extensions passed in via configuration" do
      it do
        expect(mime_type_lookup.for_file_name('myfile.custom')).to eq('custom/type')
      end
    end
  end

end
