require "test_helper"

class SchemaValidatorTest < ActiveSupport::TestCase
  test "check shows no errors on a valid json" do
    assert_empty SchemaValidator.check(valid_event)
  end

  test "check rejects bad code" do
    assert_not_empty SchemaValidator.check(valid_event("kodas" => "TavoMama"))
  end

  test "check rejects bad date format" do
    assert_not_empty SchemaValidator.check(valid_event("data" => "12.12.2026"))
  end

  test "check rejects unknown event type" do
    assert_not_empty SchemaValidator.check(valid_event("tipas" => "skibidis"))
  end

  test "check rejects missing field" do
    event = valid_event
    event.delete("pavadinimas")
    assert_not_empty SchemaValidator.check(event)
  end
end
