# frozen_string_literal: true

require_relative './repository/hash_repository'
require_relative './repository/active_record_repository'
require_relative './repository/struct_repository'

module HashPivot
  class Table
    # @param [Array<Hash>] data
    def initialize(data, repository: HashPivot::Repository::HashRepository)
      @data = data
      @repository = repository
    end

    # @param [Array, Object] group
    # @param [Object] pivot_in
    # @param [Array] pivot_kinds
    def pivot(group, pivot_in, pivot_kinds, &block)
      group = [group] unless group.is_a?(Array)
      @repository.hash_by_group(@data, group, pivot_in).each_with_object([]) do |(key, array), memo|
        hash = pivot_with_sum(pivot_kinds, array, pivot_in, &block)

        memo << key.merge(hash)
      end
    end

    def pivot_with_sum(pivot_kinds, array, pivot_in, &block)
      pivot_kinds ||= array.map { |h| h[pivot_in] }.uniq.compact
      pivot_kinds.each_with_object({}) do |pivot_kind, memo|
        pivoted_data = array.select { |h| h[pivot_in] == pivot_kind }
        memo[pivot_kind] = if block
                             yield(pivoted_data)
                           else
                             pivoted_data
                           end
      end
    end
  end
end
