require 'rails'

module Target
  module Voyager
    class Railtie < Rails::Railtie
      config.target_voyager = ActiveSupport::OrderedOptions.new

      initializer "target_voyager.configure" do |app|
        Target::Voyager.configure do |config|
          config.host = app.config.target_voyager[:host]
          config.port = app.config.target_voyager[:port]
          config.username = app.config.target_voyager[:username]
          config.password = app.config.target_voyager[:password]
          config.operator = app.config.target_voyager[:operator]
          config.location = app.config.target_voyager[:location]
        end
      end
    end
  end
end
