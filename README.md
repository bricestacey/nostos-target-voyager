# Nostos Target Driver: Voyager ILS

This is a Voyager target driver for Nostos.

See [Nostos](https://github.com/bricestacey/nostos) for more information.

## Installation

Add the following to your Gemfile and run `bundle install`

    gem 'nostos-target-voyager'

## Configuration

In `config/application.rb` add the following options:

    config.target_voyager.sip = {
      :host = '',
      :port = '',
      :username = '',
      :password = '',
      :operator = '',
      :location = ''
    }
    config.target_voyager.db = {
      :adapter  => 'oracle_enhanced',
      :database => '', # This is most likely VGER
      :username => '',
      :password => ''
    }

Note that `username` and `location` is the operator id and location code used to sign into the SIP server (or Circulation module). `operator` is the operator id used for creating items. Theoretically they should be identical, however it is not required.

For more information on how to configure your Voyager system for SIP see the manual _Voyager 7.2 Interface to Self Check Modules Using 3M SIP User's Guide, November 2009_

# Author

Nostos was written by [Brice Stacey](https://github.com/bricestacey)
