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
```

### Add Custom Overrides
```ruby
BestType.configure({
  extension_to_mime_type_overrides:
    'custom': 'custom/type'
  mime_type_to_dc_type_overrides:
    'custom/type': 'Custom'
})

BestType.mime_type.for_file_name('myfile.custom') # 'custom/type'
BestType.dc_type.for_file_name('myfile.custom') # 'Custom'
BestType.dc_type.for_mime_type('custom/type') # 'Custom'

```

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
    
test:
  extension_to_mime_type_overrides:
    'better': 'better/type'
  mime_type_to_dc_type_overrides:
    'better/type': 'Better'

production:
  extension_to_mime_type_overrides:
    'best': 'best/type'
  mime_type_to_dc_type_overrides:
    'best/type': 'Best'
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
