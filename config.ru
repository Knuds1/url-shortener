# frozen_string_literal: true

$LOAD_PATH << 'lib'

require 'sassc'
require 'rack/sassc'

use Rack::SassC, {
  css_location: 'app/public/css',
  scss_location: 'app/public/scss'
}

require 'rack/contrib/json_body_parser'
use Rack::JSONBodyParser

require_relative 'app/application'
run Application
