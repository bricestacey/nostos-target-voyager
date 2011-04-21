require 'voyager'
require 'nostos-target-voyager/railtie' if defined?(Rails)
require 'nostos-target-voyager/config'
require 'nostos-target-voyager/record'
require 'nostos-target-voyager/generators/target_voyager_generator' if defined?(Rails)

module Target
  module Voyager
    def self.config
      @@config ||= Target::Voyager::Config.new
    end

    def self.configure
      yield self.config
    end

    # Target Interface
    def self.find(id)
      id = id.to_s unless id.is_a?(String)

      item_barcode = ::Voyager::AR::Item::Barcode.includes(:item => [:circ_transaction, :bib_text]).where(:item_barcode => id).first

      if item_barcode
        Target::Voyager::Record.new(:id => item_barcode.item_barcode,
                                    :title => item_barcode.item.bib_text.title,
                                    :due_date => item_barcode.item.circ_transaction.try(:current_due_date),
                                    :charged => !item_barcode.item.circ_transaction.nil?)
      else
        nil
      end
    end

    def self.create(item = {})
      return nil if item.id.nil? || item.title.nil?

      # Check if the item already exists.
      if ::Voyager::AR::Item::Barcode.where(:item_barcode => item.id.to_s).exists?
        item_barcode = ::Voyager::AR::Item::Barcode.includes(:item => [:circ_transaction, :bib_text]).where(:item_barcode => item.id.to_s).first
        return Target::Voyager::Record.new(:id => item_barcode.item_barcode,
                                    :title => item_barcode.item.bib_text.title,
                                    :due_date => item_barcode.item.circ_transaction.try(:current_due_date),
                                    :charged => !item_barcode.item.circ_transaction.nil?)
      end

      # Title should truncate to 32 characters and append "/ *12345*"
      title = "#{item.title[0..31]} / *#{item.id}*"

      # Illiad encodes strings in Windows-1252, but Voyager SIP requires all messages be ASCII.
      if item.class.to_s == 'Source::Illiad'
        title = Iconv.iconv('ASCII//IGNORE', 'Windows-1252', title).join
      end
      # Illiad encodes strings in Windows-1252, but Voyager SIP requires all messages be ASCII.

      ::Voyager::SIP::Client.new(config.sip[:host], config.sip[:port]) do |sip|
        sip.login(config.sip[:username], config.sip[:password], config.sip[:location]) do |response|
          # First be sure that an item doesn't already exist.
          sip.item_status(item.id) do |item_status|
            unless item_status[:AF] == 'Item barcode not found.  Please consult library personnel for assistance.'
              # Item already exists
              # This should pretty much never happen since we check above for existence.
              return Target::Voyager::Record.new(:id => item.id,
                                                 :title => item_status[:AJ],
                                                 :due_date => item_status[:AH],
                                                 :charged => !item_status[:AH].empty?)
            else
              # Item doesn't exist
              sip.create_bib(config.sip[:operator], title, item.id) do |response|
                # Bib/MFHD/Item created. Store values.
                #
                # Values must be stored in order to delete the items via SIP.
                # Note: Voyager does not return mfhd_id.
                Rails::logger.info "Successfully created item with barcode #{item.id}"
                return Target::Voyager::Record.new(:id => item.id,
                                                   :title => title,
                                                   :due_date => nil,
                                                   :charged => false)
              end
            end
          end
        end
      end
      nil
    end

    def self.charged
      ::Voyager::AR::Item.joins(:circ_transaction).includes(:circ_transaction, :bib_text, :barcode).where(:item_type_id => 24).all.map do |item|
        Target::Voyager::Record.new(:id => item.barcode.item_barcode,
                                    :title => item.bib_item.bib_text.title,
                                    :due_date => item.circ_transaction.current_due_date,
                                    :charged => !item.circ_transaction.nil?)
      end
    end
  end
end
