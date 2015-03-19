require "htmlentities"

module BirdOfParadise
  class Tweet
    def self.html_decoder
      @html_decoder ||= HTMLEntities.new
    end

    def initialize( user_name:        ,
                    user_screen_name: ,
                    user_followed:    ,
                    created_at:       ,
                    full_text:        ,
                    mention: )
      @user_name        = user_name
      @user_screen_name = user_screen_name
      @user_followed    = user_followed
      @created_at       = created_at
      @full_text        = self.class.html_decoder.decode(full_text)
      @mention          = mention
    end

    attr_reader :user_name, :user_screen_name, :created_at, :full_text

    def user_followed?
      @user_followed
    end

    def mention?
      @mention
    end

    def lines(width)
      [header_line(width)] +
      full_text.lines.flat_map { |line| wrap(line.rstrip, width) }
    end

    private

    def header_line(width)
      from = "#{user_name} @#{user_screen_name}"
      at   = created_at.strftime("%d/%m/%Y %H:%M")

      max_from = width - (at.size + 1)
      if from.size > max_from
        from[(max_from - 1)..-1] = "\u2026"
      end

      [from, at].join(" " * (width - (from.size + at.size)))
    end

    def wrap(line, width)
      while (long_line = line.match(/^.{#{width + 1}}/))
        if (i = long_line.to_s.rindex(/\s/))
          line[long_line.begin(0) + i, 1] = "\n"
        else
          line[long_line.end(0), 0] = "\n"
        end
      end
      line.lines.map(&:rstrip)
    end
  end
end
