require "twitter"

require_relative "event"
require_relative "tweet"

module BirdOfParadise
  class Stream
    def initialize(auth, q = Event.q)
      @rest_client      = Twitter::REST::Client.new do |config|
        auth.authenticate(config)
      end
      @streaming_client = Twitter::Streaming::Client.new do |config|
        auth.authenticate(config)
      end
      @q           = q
      @followings  = @rest_client.friend_ids.to_a
    end

    attr_reader :rest_client, :streaming_client, :q, :followings
    private     :rest_client, :streaming_client, :q, :followings

    def screen_name
      @screen_name ||= rest_client.user.screen_name
    end

    def timeline
      rest_client.home_timeline.map { |tweet| build_tweet(tweet) }
    end

    def mentions
      rest_client.mentions_timeline.map { |tweet| build_tweet(tweet) }
    end

    def read
      @thread = Thread.new(streaming_client, q) do |stream, queue|
        stream.user do |message|
          case message
          when Twitter::Streaming::FriendList
            update_followings(message)
          when Twitter::Tweet
            queue_tweet(message)
          end
        end
      end
    end

    private

    def update_followings(list)
      @followings = list
    end

    def queue_tweet(tweet)
      q << Event.new(name: :add_tweet, details: build_tweet(tweet))
    end

    def build_tweet(tweet)
      Tweet.new(
        user_name:        tweet.user.name,
        user_screen_name: tweet.user.screen_name,
        user_followed:    followings.include?(tweet.user.id),
        created_at:       tweet.created_at,
        full_text:        tweet.full_text,
        mention:          tweet.user_mentions.any? { |um|
          um.screen_name == screen_name
        }
      )
    end
  end
end
