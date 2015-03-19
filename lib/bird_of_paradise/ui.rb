require "rurses"

require_relative "event"
require_relative "screen"
require_relative "keyboard"

module BirdOfParadise
  class UI
    def initialize(event_q = Event.q)
      @event_q  = event_q
      @exit_q   = Queue.new
      @screen   = nil
      @keyboard = Keyboard.new { Rurses.get_key }
    end

    attr_reader :event_q, :exit_q, :screen, :keyboard
    private     :event_q, :exit_q, :screen, :keyboard

    def show(screen_name: , timeline: , mentions: )
      Rurses.program(
        modes: %i[c_break no_echo keypad non_blocking hide_cursor]
      ) do |screen|
        @screen = Screen.new(screen, event_q, screen_name, timeline, mentions)

        listen_for_events
        keyboard.read

        wait_for_exit
      end
    end

    private

    def listen_for_events
      @event_thread = Thread.new(event_q) do |q|
        loop do
          event = q.shift
          case event.name
          when :add_tweet
            screen.add_tweet_to_feeds(event.details)
          when :resize_screen
            screen.resize
          when :switch_column
            screen.switch_column
          when :move_up
            screen.move_up
          when :move_down
            screen.move_down
          when :exit
            start_exit
            break
          end
          screen.update
        end
      end
    end

    def start_exit
      exit_q << :exit
    end

    def wait_for_exit
      exit_q.shift
    end
  end
end
