ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "tmpdir"

module ActiveSupport
  class TestCase

    def use_temp_store(events = [])
      EventStore.file = File.join(Dir.mktmpdir, "events.json")
      File.write(EventStore.file, {"bilietai" => events}.to_json)
    end

    teardown {EventStore.file = nil}

    def valid_event(overrides = {})
      {
        "kodas" => "REN-001", "tipas" => "koncertas", "pavadinimas" => "Kauno džiazo vakaras",
        "data" => "2026-11-20", "trukme_minutemis" => 120,
        "organizatorius" => { "pavadinimas" => "Džiazo namai", "el_pastas" => "info@dziazonamai.lt" },
        "vieta" => {
          "pavadinimas" => "Žalgirio arena", "miestas" => "Kaunas", "talpa" => 15000,
          "sektoriai" => [{
            "kodas" => "A", "pavadinimas" => "Parteris",
            "bilieto_kaina" => { "valiuta" => "EUR", "suma" => 65.0 },
            "bilietai" => [
              { "busena" => "parduotas", "eilute" => 1, "vietos_numeris" => 12, "pardavimo_data" => "2026-10-01" },
              { "busena" => "laisvas", "eilute" => 2, "vietos_numeris" => 5 }
            ]
          }]
        }
      }.merge(overrides)
    end
  end
end
