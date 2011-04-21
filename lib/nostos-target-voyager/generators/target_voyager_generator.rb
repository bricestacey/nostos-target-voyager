require 'rails/generators'

module TargetVoyager
  class InstallGenerator < Rails::Generators::Base
    def configure
      # Ask DB Questions
      puts "Database Configuration:"
      puts "The following fields are required to establish a connection with your Voyager server."
      db = {}
      db[:database] = ask('database: [VGER]')
      db[:database] = 'VGER' if db[:database].blank?
      db[:username] = ask('username (e.g. ro_XXXDB): []')
      db[:password] = ask('password: []')

      # Ask SIP Questions
      puts "SIP Configuration:"
      sip = {}
      sip[:host] = ask('Host: []')
      sip[:port] = ask('Port: [7031]')
      sip[:port] = '7031' if sip[:port].blank?
      sip[:username] = ask('Username (the operator used to sign into SIP. This will determine the allowed privleges and will be the operator used for circulation transactions): []')
      sip[:password] = ask('Password: []')
      sip[:operator] = ask('Operator (the operator used to create short records. This overrides the operator used to sign in. It is recommended that you create a cataloging operator for this driver so that you can easily identify records created in your ILS): []')
      sip[:location] = ask('Location: []')

      # Configure application settings
      create_file File.join(Rails.root, 'config', 'target_voyager.yml'), <<CONFIG
# Target Voyager Configuration

# Database
db:
  adapter:  'oracle_enhanced'
  database: '#{db[:database]}'
  username: '#{db[:username]}'
  password: '#{db[:password]}'

# SIP
sip:
  host:     '#{sip[:host]}'
  port:     '#{sip[:port]}'
  username: '#{sip[:username]}'
  password: '#{sip[:password]}'
  operator: '#{sip[:operator]}'
  location: '#{sip[:location]}'
CONFIG

    end
  end
end
