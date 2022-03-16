ENV['APP_ENV'] = 'test'

require_relative '../app/application'
require 'rack/test'
require 'json'
require 'database_cleaner-active_record'
require 'database_cleaner-redis'

describe 'API' do
  include Rack::Test::Methods

  def app
    Application
  end

  it 'displays home page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'returns correct target' do
    get '/foo?json=true'
    expect(last_response).to be_ok
    parsed = JSON.parse(last_response.body)
    expect(parsed['exists']).to be_a TrueClass
    expect(parsed['target']).to eq('bar')
  end

  it 'returns 404' do
    get '/__DOES_NOT_EXIST!__'
    expect(last_response.status).to eq(404)
  end

  it 'returns exists: false on 404' do
    get '/__DOES_NOT_EXIST!__?json=true'
    expect(last_response.status).to eq(404)
    parsed = JSON.parse(last_response.body)
    expect(parsed['exists']).to be_a FalseClass
  end

  it 'redirects' do
    get '/foo'
    expect(last_response.status).to eq(302)
    expect(last_response.header['Location']).to eq('bar')
  end

  it 'shortens url' do
    DatabaseCleaner.cleaning do
      target = 'http://example.com'
      post '/', { target: }
      parsed = JSON.parse(last_response.body)
      url = parsed['url']
      expect(url).not_to be_empty
      expect(parsed['url_full']).to eq("#{last_request.base_url}/#{url}")
      expect(parsed['base_url']).to eq(last_request.base_url)
      expect(parsed['target']).to eq(target)
      # Test redirect
      get "/#{url}"
      expect(last_response.header['Location']).to eq(target)
      # Test JSON response
      get "/#{url}?json=true"
      parsed = JSON.parse(last_response.body)
      expect(parsed['exists']).to be_a TrueClass
      expect(parsed['target']).to eq(target)
    end
  end

  it 'prefixes URLs without protocol with //' do
    DatabaseCleaner.cleaning do
      post '/', { target: 'http://example.com'}
      parsed = JSON.parse(last_response.body)
      expect(parsed['target']).to eq('http://example.com')
      post '/', { target: '//example.com'}
      parsed = JSON.parse(last_response.body)
      expect(parsed['target']).to eq('//example.com')
      post '/', { target: 'example.com'}
      parsed = JSON.parse(last_response.body)
      expect(parsed['target']).to eq('//example.com')
    end
  end
end
