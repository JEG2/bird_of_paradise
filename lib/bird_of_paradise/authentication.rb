require "dotenv"

module BirdOfParadise
  class Authentication
    VARIABLES = %w[
      TWITTER_CONSUMER_KEY
      TWITTER_CONSUMER_SECRET
      TWITTER_ACCESS_TOKEN
      TWITTER_ACCESS_TOKEN_SECRET
    ]

    def initialize(file = File.expand_path("~/.bird_of_paradise"))
      @file = file
    end

    attr_reader :file

    def loaded?
      VARIABLES.all? { |var| ENV.include?(var) }
    end

    def can_load?
      if !loaded? && File.exist?(file)
        Dotenv.load(file)
      end

      if !loaded?
        ask
      end

      loaded?
    end

    def ask
      VARIABLES.each do |var|
        print "Please enter your #{var}:  "
        value = gets.strip
        redo unless value =~ /\S/
        ENV[var] = value
      end
      save
    end

    def save
      open(file, "w") do |env|
        VARIABLES.each do |var|
          env.puts "#{var}=#{ENV[var]}"
        end
      end
    end

    def authenticate(twitter_client_config)
      VARIABLES.each do |var|
        twitter_client_config.send(
          "#{var.sub(/\ATWITTER_/, '').downcase}=",
          ENV[var]
        )
      end
    end
  end
end
