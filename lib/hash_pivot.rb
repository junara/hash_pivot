# frozen_string_literal: true

require_relative 'hash_pivot/version'
require_relative 'hash_pivot/table'
require 'hash_pivot/error/not_implemented_error'
module HashPivot
  # @param [Array<Hash>] data
  # @param [Array] group
  # @param [Object] pivot_in
  # @param [Array] pivot_kinds
  # @return [Hash]
  def self.pivot(data, group, pivot_in, pivot_kinds, repository: HashPivot::Repository::HashRepository, &block)
    Table.new(data, repository: repository).pivot(group, pivot_in, pivot_kinds, &block)
  end
end
