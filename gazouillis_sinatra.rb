# encoding: utf-8
require "bundler/setup"
Bundler.require(:default)
require 'sinatra/base'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/object'
require './connections'
require './tweets'

class GazoullisSinatra < Sinatra::Base
  helpers Sinatra::Sprockets::Helpers
  set :server, :thin
  $listeners = Connections.new
  if ENV["REDISTOGO_URL"]
    redis_uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new(host: redis_uri.host, port: redis_uri.port, password: redis_uri.password)
  else
    $redis = Redis.new
  end
  $redis.del "tweets_count"

  configure :production do
    require 'newrelic_rpm'
  end

  Sinatra::Sprockets.configure do |config|
    config.app = self

    ['stylesheets', 'javascripts', 'images'].each do |dir|
      config.append_path(File.join('assets', dir))
      config.js_compressor  = Uglifier.new(mangle: false)
      config.css_compressor = false
      config.digest = false
      config.compress = false
      config.debug = false

      config.precompile = ['application.js']
    end
  end

  get '/events', provides: 'text/event-stream' do
    stream(:keep_open) {|connection| $listeners.join(connection) }
  end

  get '/' do
    @tweets_count = $redis.get('tweets_count').to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    @tweets_total = $redis.get('tweets_total').to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    erb :index
  end

end
