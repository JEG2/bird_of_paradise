module BirdOfParadise
  class Event
    def self.q
      @q ||= Queue.new
    end

    def initialize(name: , details: nil)
      @name    = name
      @details = details
    end

    attr_reader :name, :details
  end
end
