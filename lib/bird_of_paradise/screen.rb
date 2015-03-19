require "io/console"

require_relative "feed"
require_relative "event"

module BirdOfParadise
  class Screen
    def initialize(rurses_screen, q, screen_name, timeline, mentions)
      @rurses_screen = rurses_screen
      @q             = q
      @panels        = Rurses::PanelStack.new
      @timeline      = Feed.new( title:    screen_name,
                                 tweets:   timeline,
                                 selected: true )
      @mentions      = Feed.new(title: "@", tweets: mentions, selected: false)

      layout
      update
      watch_for_resize
    end

    attr_reader :rurses_screen, :q, :panels, :timeline, :mentions
    private     :rurses_screen, :q, :panels, :timeline, :mentions

    def update
      timeline.redraw
      mentions.redraw
      panels.refresh_in_memory
      Rurses.update_screen
    end

    def add_tweet_to_feeds(tweet)
      timeline << tweet if tweet.user_followed?
      mentions << tweet if tweet.mention?
    end

    def switch_column
      timeline.selected = !timeline.selected?
      mentions.selected = !mentions.selected?
    end

    def move_up
      selected_feed.move_up
    end

    def move_down
      selected_feed.move_down
    end

    def resize
      lines, columns = $stdout.winsize
      rurses_screen.resize(lines: lines, columns: columns)

      timeline_width, mentions_width, lines = calculate_column_sizes
      panels.remove(timeline.window)
      panels.remove(mentions.window)
      layout
    end

    private

    def layout
      timeline_width, mentions_width, lines = calculate_column_sizes
      [
        { x:       0,              columns: timeline_width, feed: timeline },
        { x:       timeline_width, columns: mentions_width, feed: mentions }
      ].each do |details|
        window = Rurses::Window.new(
          lines:   lines,
          columns: details[:columns],
          x:       details[:x],
          y:       0
        )
        window.create_subwindow(
          name:           :content,
          top_padding:    1,
          left_padding:   1,
          right_padding:  1,
          bottom_padding: 1
        )
        panels.add(window)
        details[:feed].window = window
      end
    end

    def calculate_column_sizes
      screen_size    = rurses_screen.size
      mentions_width = screen_size[:columns] / 2
      timeline_width = screen_size[:columns] - mentions_width
      [timeline_width, mentions_width, screen_size[:lines]]
    end

    def watch_for_resize
      Signal.trap(:SIGWINCH) do
        q << Event.new(name: :resize_screen)
      end
    end

    def selected_feed
      [timeline, mentions].find(&:selected?)
    end
  end
end
