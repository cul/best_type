# best_type

A pure-ruby library for selecting the best MIME type for a file name or DC type (http://dublincore.org/2012/06/14/dctype) for a file name / MIME type.

### Installation

```bash
gem install best_type
```

### Usage

```ruby
# require the gem
require 'best_type'

# detect mime type for file names
BestType.mime_type.for_file_name('myfile.jpg') # 'image/jpeg'

# detect mime type for file names (including full file path)
BestType.mime_type.for_file_name('/path/to/some/file.jpg') # 'image/jpeg'

# detect dc type for file names
BestType.dc_type.for_file_name('myfile.jpg') # 'StillImage'

# detect dc type for file names (including full file path)
BestType.dc_type.for_file_name('/path/to/some/file.jpg') # 'StillImage'

# detect dc type for mime types
BestType.dc_type.for_mime_type('image/jpeg') # 'StillImage'

# detect dc type for file names (including full file path)
BestType.pcdm_type.for_file_name('/path/to/some/file.jpg') # 'Image'

# detect dc type for mime types
BestType.pcdm_type.for_mime_type('image/jpeg') # 'Image'
```

### Add Custom Overrides
```ruby
BestType.configure({
  extension_to_mime_type_overrides:
    'custom': 'custom/type'
  mime_type_to_dc_type_overrides:
    'custom/type': 'CustomDC'
  mime_type_to_pcdm_type_overrides:
    'custom/type': 'CustomPCDM'
})

BestType.mime_type.for_file_name('myfile.custom') # 'custom/type'
BestType.dc_type.for_file_name('myfile.custom') # 'CustomDC'
BestType.pcdm_type.for_mime_type('custom/type') # 'CustomPCDM'
```

**Note 1: For extension_to_mime_type_overrides overrides, both keys and values should be lower case, file extension and mime type values are converted to lower case before they are checked.  If you supply capitalized keys or values for extension_to_mime_type_overrides, they will be automatically converted to lower case.**

**Note 2: For mime_type_to_dc_type_overrides or mime_type_to_pcdm_type_overrides overrides, keys should be lower case because mime type values are converted to lower case before they are checked.  If you supply capitalized keys for mime_type_to_dc_type_overrides or mime_type_to_pcdm_type_overrides, they will be automatically converted to lower case.**

**Note 1: For all of the key-value pair overrides above, keys should be lower case, since comparison values are converted to lower case before they are checked.  If you supply capitalized keys in your list of overrides, they will be automatically converted to lower case.**


### Recommended Setup For Rails

Add best_type to your Gemfile:
```ruby
gem 'best_type'
```

And then call it from anywhere!

If you want to set custom overrides, the best place to do so is in a Rails initializer:
```ruby
# config/initializers/best_type.rb

BestType.configure({
  extension_to_mime_type_overrides:
    'custom': 'custom/type'
  mime_type_to_dc_type_overrides:
    'custom/type': 'Custom'
  mime_type_to_pcdm_type_overrides:
    'custom/type': 'Custom'
})
```

You may also want to consider using a YAML file for configuration:
```ruby
# config/initializers/best_type.rb

BestType.configure(YAML.load_file(File.join(Rails.root, 'config/best_type.yml'))[Rails.env])
```

```yaml
# config/initializers/best_type.rb

development:
  extension_to_mime_type_overrides:
    'good': 'good/type'
  mime_type_to_dc_type_overrides:
    'good/type': 'Good'
  mime_type_to_pcdm_type_overrides:
    'good/type': 'Goodly'

test:
  extension_to_mime_type_overrides:
    'better': 'better/type'
  mime_type_to_dc_type_overrides:
    'better/type': 'Better'
  mime_type_to_pcdm_type_overrides:
    'best/type': 'Betterly'

production:
  extension_to_mime_type_overrides:
    'best': 'best/type'
  mime_type_to_dc_type_overrides:
    'best/type': 'Best'
  mime_type_to_pcdm_type_overrides:
    'best/type': 'Bestly'
```

### Running Tests (for developers):

Tests are great and we should run them.  Here's how:

```sh
bundle exec rake best_type:ci
```

### Building the Gem and Pushing to RubyGems (for developers):

```sh
bundle exec rake release
```
