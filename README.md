# Json::Query

A simple query language for plucking values out of json objects.

* more light weight than json-path

## Installation

Add this line to your application's Gemfile:

    gem 'json-query'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json-query

## Usage

```ruby
require 'json/query'

Json::Query.query "foo", {"foo" => 1}
# => 1
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
