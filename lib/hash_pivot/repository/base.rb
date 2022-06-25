# frozen_string_literal: true

module HashPivot
  module Repository
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # @param [Array<Hash>,ActiveRecord::Relation] data
        # @param [Array] group
        # @param [Object] pivot_in
        # @return [Hash]
        def hash_by_group(data, group, pivot_in)
          new(data, group, pivot_in).hash_by_group
        end
      end

      # @param [Array<Hash>] data
      # @param [Array] group
      # @param [Object] pivot_in
      def initialize(data, group, pivot_in)
        @data = translate_data(data)
        @group = group
        @pivot_in = pivot_in
      end

      # @return [Hash]
      def hash_by_group
        @data.group_by do |hash|
          @group.each_with_object({}) do |key, memo_obj|
            memo_obj[key] = hash[key]
          end
        end
      end

      # @param [Array<Hash>] _data
      # @return [Array<Hash>]
      def translate_data(_data)
        raise HashPivot::Error::NotImplementedError, 'translate_data is not implemented'
      end
    end
  end
end
