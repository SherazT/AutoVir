# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'ALLOWALL'
}