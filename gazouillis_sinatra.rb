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
    erb :index
  end

end