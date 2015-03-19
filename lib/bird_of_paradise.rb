require_relative "bird_of_paradise/version"
require_relative "bird_of_paradise/authentication"
require_relative "bird_of_paradise/stream"
require_relative "bird_of_paradise/ui"

module BirdOfParadise
  module_function

  def fly
    Thread.abort_on_exception = true

    auth = Authentication.new
    abort "Could not load Twitter authentication." unless auth.can_load?

    stream = Stream.new(auth)
    ui     = UI.new
    stream.read
    ui.show(
      screen_name: stream.screen_name,
      timeline:    stream.timeline,
      mentions:    stream.mentions
    )
  end
end
