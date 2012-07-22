# encoding: utf-8
require 'bundler'

Bundler.require

require './gazouillis_sinatra'

run GazoullisSinatra

map '/assets' do
  run Sinatra::Sprockets.environment
end

gazouillis_options = {
  auth:
  {
    user: ENV['TWITTER_USER'],
    passord: ENV['TWITTER_PASS']
  }
}
Tweets.new('/1/statuses/sample.json', gazouillis_options).open!
