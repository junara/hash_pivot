# frozen_string_literal: true

require_relative './base'

module HashPivot
  module Repository
    class StructRepository
      include HashPivot::Repository::Base

      def translate_data(data)
        data.map do |r|
          attribute_names = r.members
          attribute_names.each_with_object({}).with_index do |(attribute_name, memo), index|
            memo[attribute_name] = r[index]
          end
        end
      end
    end
  end
end
