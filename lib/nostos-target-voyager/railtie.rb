require 'rails'

module Target
  module Voyager
    class Railtie < Rails::Railtie
      config.target_voyager = ActiveSupport::OrderedOptions.new
      config.target_voyager.sip = ActiveSupport::OrderedOptions.new
      config.target_voyager.db = ActiveSupport::OrderedOptions.new

      initializer "target_voyager.configure" do |app|
        config_file = File.join(Rails.root, 'config', 'target_voyager.yml')

        if File.exists?(config_file)
          CONFIG = YAML::load(File.open(config_file))

          Target::Voyager.configure do |config|
            config.sip = CONFIG["sip"]
            config.db = CONFIG["db"]
          end

          ::Voyager::AR::Base.establish_connection(Target::Voyager.config.db)
        end
      end
    end
  end
end
