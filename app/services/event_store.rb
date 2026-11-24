class EventStore
  LOCK = Mutex.new

  class Duplicate < StandardError; end

  class << self
    attr_writer :file

    def file
      @file ||= Rails.root.join("db", "events.json")
    end

    def all
      LOCK.synchronize { read }
    end

    def find(id)
      LOCK.synchronize{read.find { |e| e["kodas"] == id}  }
    end

    def next_code
      LOCK.synchronize do
        max = read.map {|e| e["kodas"][/\d+/].to_i}.max || 0
        return format("REN-%03d", max + 1)
      end
    end

    def create(event)
      LOCK.synchronize do
        events = read
        raise Duplicate, "Event #{event['kodas']} already exists" if events.any? {|e| e["kodas"] == event["kodas"]}
        events << event
        write(events)
        return event
      end
    end

    def update(id, event)
      LOCK.synchronize do
        events = read
        index = events.index {|e| e["kodas"] == id} or return nil
        events[index] = event
        write(events)
        return event
      end
    end

    def delete(id)
      LOCK.synchronize do
        events = read
        return false unless events.reject! {|e| e["kodas"] == id}
        write(events)
        return true
      end
    end

    private

    def read
      if File.exist?(file)
        return JSON.parse(File.read(file)).fetch("bilietai", [])
      else
        return []
      end
    end

    def write(events)
      tmp = "#{file}.tmp"
      File.write(tmp, JSON.pretty_generate({ "bilietai" => events}))
      File.rename(tmp, file)
    end

  end
end

