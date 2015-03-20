require_relative "cursor"

module BirdOfParadise
  class Feed
    MAX_TWEETS = 200

    def initialize(window: nil, title: , tweets: [ ], selected: )
      @window  = window
      @title   = title
      @tweets  = Cursor.new(tweets)
      @changed = true

      self.selected = selected
    end

    attr_reader :window

    attr_reader :title, :tweets
    private     :title, :tweets

    def window=(new_window)
      @window       = new_window
      self.selected = @selected

      mark_changed
    end

    def selected=(boolean)
      @selected = boolean

      if window
        if @selected
          window.draw_border
        else
          window.clear
        end
        window.move_cursor(x: 2, y: 0)
        window.draw_string(title[0..(window.columns - 4)])
      end

      mark_changed
    end

    def selected?
      @selected
    end

    def changed?
      @changed
    end

    def mark_changed
      @changed = true
    end

    def <<(tweet)
      tweets.add(tweet)

      mark_changed
    end

    def move_up
      tweets.move_up

      mark_changed
    end

    def move_down
      tweets.move_down

      mark_changed
    end

    def redraw
      if changed?
        content = window.subwindow(:content)
        size    = content.size
        content.clear
        tweets
          .lines(count: size[:lines], width: size[:columns])
          .each do |line, cursor_location|
            if line
              attributes = selected? && cursor_location ? %i[bold] : [ ]
              content.style(*attributes) do
                content.draw_string_on_a_line(line)
              end
            else
              content.skip_line
            end
          end
      end

      @changed = false
    end
  end
end
