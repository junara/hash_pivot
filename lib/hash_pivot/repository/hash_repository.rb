# frozen_string_literal: true

require_relative './base'

module HashPivot
  module Repository
    class HashRepository
      include HashPivot::Repository::Base

      def translate_data(data)
        data
      end
    end
  end
end
