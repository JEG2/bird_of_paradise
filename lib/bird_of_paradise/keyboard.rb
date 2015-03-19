require_relative "event"

module BirdOfParadise
  class Keyboard
    def initialize(q = Event.q, &key_reader)
      @q          = q
      @key_reader = key_reader
    end

    attr_reader :q, :key_reader
    private     :q, :key_reader

    def read
      @thread = Thread.new(q, key_reader) do |events, keys|
        loop do
          case keys.call
          when "\t"
            events << Event.new(name: :switch_column)
          when :UP_ARROW, "k", "p", "w"
            events << Event.new(name: :move_up)
          when :DOWN_ARROW, "j", "n", "s"
            events << Event.new(name: :move_down)
          when "q"
            events << Event.new(name: :exit)
          end
          sleep 0.1
        end
      end
    end
  end
end
