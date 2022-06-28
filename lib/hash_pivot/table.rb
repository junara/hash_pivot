# frozen_string_literal: true

require_relative './repository/hash_repository'
require_relative './repository/active_record_repository'
require_relative './repository/struct_repository'

module HashPivot
  class Table
    # rubocop:disable Layout/LineLength

    # @param [Array<Hash>] data
    # @param [Class<HashPivot::Repository::HashRepository,HashPivot::Repository::StructRepository,HashPivot::Repository::ActiveRecordRepository>] repository
    def initialize(data, repository: HashPivot::Repository::HashRepository)
      @data = data
      @repository = repository
    end

    # rubocop:enable Layout/LineLength

    # @param [Array, Object] group
    # @param [Object] pivot_in
    # @param [Hash,nil] pivot_kinds
    # @param [Proc] block
    # @return [Array<Hash>]
    def pivot(group, pivot_in, pivot_kinds, &block)
      group = [group] unless group.is_a?(Array)
      @repository.hash_by_group(@data, group, pivot_in).each_with_object([]) do |(key, array), memo|
        hash = transpose_with(pivot_kinds, array, pivot_in, &block)

        memo << key.merge(hash)
      end
    end

    private

    # @param [Hash,nil] pivot_kinds
    # @param [Array] array
    # @param [Object] pivot_in
    # @param [Proc] block
    # @return [Hash]
    def transpose_with(pivot_kinds, array, pivot_in, &block)
      pivot_kinds ||= calculated_pivot_kinds_from(array, pivot_in)
      pivot_kinds.each_with_object({}) do |(pivot_kind, pivot_label), memo|
        pivoted_data = array.select { |h| h[pivot_in] == pivot_kind }
        memo[pivot_label] = block ? yield(pivoted_data) : pivoted_data
      end
    end

    # @param [Array] array
    # @param [Object] pivot_in
    # @return [Hash]
    def calculated_pivot_kinds_from(array, pivot_in)
      array.map { |h| h[pivot_in] }.uniq.compact.each_with_object({}) { |kind, memo| memo[kind] = kind }
    end
  end
end
