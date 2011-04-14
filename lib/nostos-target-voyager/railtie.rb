require 'rails'

module Target
  module Voyager
    class Railtie < Rails::Railtie
      config.target_voyager = ActiveSupport::OrderedOptions.new
      config.target_voyager.sip = ActiveSupport::OrderedOptions.new
      config.target_voyager.db = ActiveSupport::OrderedOptions.new

      initializer "target_voyager.configure" do |app|
        Target::Voyager.configure do |config|
          config.sip = app.config.target_voyager[:sip]
          config.db = app.config.target_voyager[:db]
        end
      end

      initializer "target_voyager.establish_connection", :after => "target_voyager.configure" do |app|
        VoyagerGem::AR::Base.establish_connection(Target::Voyager.config.db)
      end
    end
  end
end
