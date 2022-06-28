# frozen_string_literal: true

require_relative 'hash_pivot/version'
require_relative 'hash_pivot/table'
require 'hash_pivot/error/not_implemented_error'
module HashPivot
  # rubocop:disable Layout/LineLength

  # @param [Array<Hash>] data
  # @param [Array] group
  # @param [Object] pivot_in
  # @param [Array,Hash,nil] pivot_header
  # @return [Hash]
  # @param [Class<HashPivot::Repository::HashRepository,HashPivot::Repository::StructRepository,HashPivot::Repository::ActiveRecordRepository>] repository
  # @param [Proc] block
  def self.pivot(data, group, pivot_in, pivot_header, repository: HashPivot::Repository::HashRepository, &block)
    pivot_kinds = if pivot_header.is_a?(Array)
                    transform_to_hash(pivot_header)
                  else
                    pivot_header
                  end
    Table.new(data, repository: repository).pivot(group, pivot_in, pivot_kinds, &block)
  end

  # rubocop:enable Layout/LineLength

  def self.transform_to_hash(array)
    array.each_with_object({}) { |kind, memo| memo[kind] = kind }
  end
  private_class_method :transform_to_hash
end
