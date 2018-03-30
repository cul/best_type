# best_type

A pure-ruby library for selecting the best MIME type for a file name, or DC type for a file name / MIME type.

### Installation

```bash
gem install best_type
```

### Standalone Usage

```ruby
require 'best_type'

TODO: Provide usage examples
```

### Rails Usage

Gemfile:
```ruby
gem 'best_type'
```

Adding Custom Overrides via initializer (config/initializers/best_type.rb):
```ruby
# via hash
BestType.configure({
  extension_to_mime_type_overrides:
    'ext': 'mime/type'
  mime_type_to_dc_type_overrides:
    'mime/type': 'GreatType'
})

# via YAML file, based on Rails environment:
BestType.configure(YAML.load_file('config/best_type.yml')[Rails.env])
```

### Running Tests (for developers):

Tests are great and we should run them.  Here's how:

```sh
bundle exec rake best_type:ci
```
