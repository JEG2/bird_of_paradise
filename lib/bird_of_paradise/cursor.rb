module BirdOfParadise
  class Cursor
    MAX_TWEETS = 200

    def initialize(tweets)
      @tweets = tweets
      @at     = tweets.first
    end

    attr_reader :tweets, :at
    private     :tweets, :at

    def add(tweet)
      tweets.unshift(tweet)

      while tweets.size > MAX_TWEETS && at != tweets.last
        tweets.pop
      end
    end

    def move_up
      @at = tweets[[tweets.index(@at) - 1, 0].max]
    end

    def move_down
      @at = tweets[[tweets.index(@at) + 1, tweets.size - 1].min]
    end

    def lines(count: , width: )
      lines = [ ]

      i     = tweets.index(at)
      newer = i.nonzero? ? "\u2191".rjust(width) : nil
      older = "\u2193".rjust(width)
      catch(:full) do
        tweets[i..-1].each do |tweet|
          [tweet.lines(width), nil].flatten.each do |line|
            lines << [line, at == tweet]
            throw :full if lines.size >= count - 2
          end
        end
      end
      if lines.size < count - 2
        older = nil
        catch(:padded) do
          tweets[0...i].reverse_each do |tweet|
            [tweet.lines(width), nil].flatten.reverse_each do |line|
              lines.unshift([line, false])
              throw :padded if lines.size >= count - 2
            end
          end
        end
      end

      [newer] + lines + [older]
    end
  end
end
