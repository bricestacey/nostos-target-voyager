module Target
  module Voyager
    class Record
      def initialize(attributes = {})
        @id = attributes[:id]
        @title = attributes[:title]
        @charged = attributes[:charged]
        begin
          @due_date = DateTime.strptime(attributes[:due_date], '%Y%m%d    %H%M%S')
        rescue
          @due_date = attributes[:due_date]
        end
      end

      attr_reader :id, :title, :due_date

      def charged?(force = false)
        if force then
          r = Target::Voyager.find(@id)
          @charged = r.charged
          @due_date = r.due_date
        end

        @charged
      end

      private

      attr_reader :charged
      attr_writer :id, :title, :charged

      def due_date=(date)
        @due_date = DateTime.strptime(date, '%Y%m%d    %H%M%S')
      end
    end
  end
end
