require "json/query/version"
require 'parslet'
module Json
  module Query
    class Parser < Parslet::Parser
      # x.y
      # => field_matcher(x), field_matcher(y)
      # []x
      # => all_array_matcher(), field_matcher(x)
      # x
      # => field_matcher(x)
      root(:query)
      rule(:query) do
         matcher.repeat(1,1) >> (
            all_array_matcher |
            (str('.') >> field_matcher) 
            ).repeat
      end
      rule(:matcher) do 
          field_matcher     |
          all_array_matcher
      end
      rule(:all_array_matcher) {str('[]').as(:all_array_matcher)}
      rule(:field_matcher) { (match('[a-zA-Z_]') >> match('\w').repeat).as(:field_matcher) }
    end


    class Transformer <Parslet::Transform
      rule(field_matcher: simple(:field)) { FieldMatcher.new field.str }
    end

    def self.query q, json
      parsed_q = Parser.new.parse q
      Transformer.new.apply(parsed_q)[0].match(json)
    end

    class FieldMatcher
      attr_reader :field
      def initialize field
        @field = field
      end

      def match json
        json[field]
      end
    end
  end
end
