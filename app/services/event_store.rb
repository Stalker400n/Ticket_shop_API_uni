class EventStore
  FILE = Rails.root.join("db", events.json)
  LOCK = Mutex.new

  class Duplicate < StandardError; end

  class << self
    def all
      LOCK.synchronize { read }
    end

    def find(id)
      LOCK.synchronize{read.find { |e| e["kodas"] == id}  }
    end


    private

    def read
      if File.exist?(FILE)
        return JSON.parse(File.read(FILE)).fetch("bilietai", [])
      else
        return []
      end
    end

    def write

    end

  end
end

