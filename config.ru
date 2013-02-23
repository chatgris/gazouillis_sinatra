# encoding: utf-8
require 'bundler'

Bundler.require

require './gazouillis_sinatra'

run GazoullisSinatra

map '/assets' do
  run Sinatra::Sprockets.environment
end

gazouillis_options = {
  oauth: {
    consumer_key:    ENV["CONSUMER_KEY"],
    consumer_secret: ENV["CONSUMER_SECRET"],
    token:           ENV["TOKEN"],
    token_secret:    ENV["TOKEN_SECRET"]
  }
}
Tweets.new('/1/statuses/sample.json', gazouillis_options).open!
