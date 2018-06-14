require_relative 'boot'

require 'rails/all'
#require 'openssl'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Boxalino
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths << Rails.root.join('lib')
    #config.autoload_paths << "#{config.root}/app/controllers/p13n_service"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_coookie_name', expire_after: 30.days

    #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end
end
