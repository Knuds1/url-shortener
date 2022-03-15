# frozen_string_literal: true

require 'redis'
require 'nanoid'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'sinatra/reloader'

# URL Shortener
class Application < Sinatra::Base
  include ERB::Util
  register Sinatra::ActiveRecordExtension

  protocol_pattern = Regexp.new(%r{\A(?:https?|mailto|tel):}).freeze

  configure :development do
    register Sinatra::Reloader

    after_reload do
      puts 'reloaded'
    end
  end

  redis = Redis.new

  def initialize
    super()
    @title = 'URL Shortener'
    @description = 'A simple URL shortener made with Ruby & Sinatra'
    @author = 'Knuds1'
  end

  get '/' do
    erb :index, locals: {
      text: 'Shorten a URL'
    }
  end

  get '/:url' do |url|
    target = redis.get("shorturl:#{url}")
    unless target
      target = Shorturls.find_by(url:)&.target
      redis.set("shorturl:#{url}", target) if target
    end
    if params[:json] == 'true'
      # If JSON is requested, return JSON instead of redirecting
      if target
        json exists: true, target:
      else
        status 404
        json exists: false
      end
    elsif target
      # Redirect if it is a short-URL
      status 302
      response['Location'] = target
      halt
    else
      raise Sinatra::NotFound
    end
  end

  post '/' do
    retries = 0
    begin
      # https://zelark.github.io/nano-id-cc/
      size = ENV['NANOID_SIZE'].to_i
      size = 11 if size.zero?

      url = Nanoid.generate(size:)
      response_html = params[:response_html] == 'true'

      target = params[:target].to_s.strip
      if target.empty?
        # Invalid request
        if response_html
          redirect to('/'), 302
        else
          error 400
        end
      end

      target = "https://#{target}" unless protocol_pattern.match?(target)

      Shorturls.create(url:, target:)
      if response_html
        erb :result, locals: {
          url:
        }
      else
        json url:, url_full: "#{request.base_url}/#{url}", base_url: request.base_url,
             target:
      end
    rescue ActiveRecord::RecordNotUnique
      # If a collision occurs (extremely rare), generate a new URL.
      retry if (retries += 1) <= 3
      error 500
    end
  end

  error Sinatra::NotFound do
    @title = '404 - Not Found'

    erb :not_found
  end

  error 400 do
    @title = 'Invalid request'

    erb :error
  end

  error 500 do
    @title = 'Oops! Something went wrong'

    erb :error
  end
end

require_relative 'models'
