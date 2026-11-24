require "test_helper"

class EventStoreTest < ActiveSupport::TestCase
  setup {use_temp_store}

  test "empty at start" do
    assert_equal [], EventStore.all
  end

  test "create saves to a file" do
    EventStore.create(valid_event)
    saved = JSON.parse(File.read(EventStore.file))["bilietai"]
    assert_equal ["REN-001"], saved.map{ |e| e["kodas"]}
  end

  test "create rejects duplicate event code" do
    EventStore.create(valid_event)
    assert_raises(EventStore::Duplicate){EventStore.create(valid_event)}
  end

  test "find returns event or nil" do
    EventStore.create(valid_event)
    assert_equal "REN-001", EventStore.find("REN-001")["kodas"]
    assert_nil EventStore.find("REN-999")
  end

  test "update replaces event" do
    EventStore.create(valid_event)
    EventStore.update("REN-001", valid_event("pavadinimas" => "Naujas"))
    assert_equal "Naujas", EventStore.find("REN-001")["pavadinimas"]
  end

  test "update returns nil for non existent event" do
    assert_nil EventStore.update("REN-001", valid_event)
  end

  test "delete returns true then false" do
    EventStore.create(valid_event)
    assert EventStore.delete("REN-001")
    assert_not EventStore.delete("REN-999")
  end

  test "next_code continues after the highest code" do
    EventStore.create(valid_event("kodas" => "REN-006"))
    assert_equal "REN-007", EventStore.next_code
  end
end
