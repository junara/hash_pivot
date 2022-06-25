# frozen_string_literal: true

require_relative './base'

module HashPivot
  module Repository
    class ActiveRecordRepository
      include HashPivot::Repository::Base
      # @param [ActiveRecord::Relation] data
      def translate_data(data)
        attribute_names = data.model.attribute_names
        data.pluck(*attribute_names).map do |r|
          attribute_names.each_with_object({}).with_index do |(attribute_name, memo), index|
            memo[attribute_name.to_sym] = r[index]
          end
        end
      end
    end
  end
end
