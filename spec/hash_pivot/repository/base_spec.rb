# frozen_string_literal: true

require 'rspec'

module HashPivot
  module Repository
    class ErrorRepository
      include HashPivot::Repository::Base
    end
  end
end

RSpec.describe HashPivot::Repository::Base do
  context 'when condition' do
    it 'raise error' do
      expect do
        HashPivot::Repository::ErrorRepository.new([{ team: 'rabbit', role: 'guest' }], :team, :role)
      end.to raise_error(HashPivot::Error::NotImplementedError)
    end
  end
end
