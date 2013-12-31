require 'minitest/autorun'
require 'json/query'
describe Json::Query do

  describe Json::Query::Parser do
    it "parses a single field query" do
      intermediate_rep = Json::Query::Parser.new.parse "x"
      assert_equal [{field_matcher: "x" }], intermediate_rep
    end
    
    it "parses a single all array query" do
      intermediate_rep = Json::Query::Parser.new.parse "[]"
      assert_equal [{all_array_matcher:"[]"}], intermediate_rep
    end

    it "parses all array with field after query" do
      intermediate_rep = Json::Query::Parser.new.parse "[].foo"
      assert_equal [{all_array_matcher:"[]"}, {field_matcher: "foo" }], intermediate_rep
    end
  end

  describe Json::Query::Transformer do
    it "transforms a field_matcher into a FieldMatcher for that field" do
      result = Json::Query::Transformer.new.apply({field_matcher: Parslet::Slice.new("x",0) })

      assert_equal Json::Query::FieldMatcher, result.class
      assert_equal "x", result.field
      refute result.field.respond_to?(:line_and_column)
      refute result.field.respond_to?(:str)
    end
  end

  describe Json::Query::FieldMatcher do
    it "plucks the value of a field" do
      matcher = Json::Query::FieldMatcher.new "x"
      assert_equal "ablahblah", matcher.match({"x" => "ablahblah"})
    end
  end

  it "plucks a field" do
    result = Json::Query.query "foo", {"foo" => 1}
    assert_equal 1, result
  end

  it "plucks all fields in an array" do
    skip "wip"
    result = Json::Query.query "[].foo", [{"foo" => 1}, {"foo" => 2}]
    assert_equal [1, 2], result
  end
  # "foo.bar", {"foo"=> {"bar"=> 1}}
  # => 1
  # "foo[].bar", {"foo"=> [{"bar"=> 1}]}
  # => [1]
  # "foo[].bar", {"foo"=> [{"bar"=> 1}, {"bar"=> 2}]}
  # => [1, 2]

  # "foo[1].bar", {"foo"=> [{"bar"=> 1}, {"bar"=> 2}]}
  # => 2
end