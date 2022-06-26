# frozen_string_literal: true

class HashPivotUser < ActiveRecord::Base; end
HashPivotUserStruct = Struct.new(:id, :role, :team, :age, keyword_init: true)

RSpec.describe HashPivot do
  it 'has a version number' do
    expect(HashPivot::VERSION).not_to be_nil
  end

  context 'when Array of Hash is used for data' do
    let(:data) do
      [
        { id: 1, role: 'guest', team: 'rabbit', age: 1 },
        { id: 2, role: 'guest', team: 'mouse', age: 2 },
        { id: 3, role: 'guest', team: 'rabbit', age: 3 },
        { id: 4, role: 'admin', team: 'mouse', age: 4 }
      ]
    end
    # rubocop:disable RSpec/ExampleLength

    it 'grouped by team and pivoted in role' do
      expect(
        described_class.pivot(data, :role, :team, %w[rabbit mouse])
      ).to eq [
        { role: 'guest',
          'rabbit' => [
            { id: 1, role: 'guest', team: 'rabbit', age: 1 },
            { id: 3, team: 'rabbit', role: 'guest', age: 3 }
          ],
          'mouse' => [{ id: 2, team: 'mouse', role: 'guest', age: 2 }] },
        { role: 'admin',
          'rabbit' => [],
          'mouse' => [{ id: 4, team: 'mouse', role: 'admin', age: 4 }] }
      ]
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength

    it 'grouped by team and pivoted in role without pivot_kinds' do
      expect(
        described_class.pivot(data, :role, :team, nil)
      ).to eq [
        { role: 'guest',
          'rabbit' => [
            { id: 1, role: 'guest', team: 'rabbit', age: 1 },
            { id: 3, team: 'rabbit', role: 'guest', age: 3 }
          ],
          'mouse' => [{ id: 2, team: 'mouse', role: 'guest', age: 2 }] },
        { role: 'admin',
          'mouse' => [{ id: 4, team: 'mouse', role: 'admin', age: 4 }] }
      ]
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength
    it 'output sumed age of grouped by team and pivoted in role' do
      expect(
        described_class.pivot(data, :role, :team, %w[rabbit mouse]) { |a| a.sum { |b| b[:age] } }
      ).to eq [
        { role: 'guest',
          'rabbit' => 4,
          'mouse' => 2 },
        { role: 'admin',
          'rabbit' => 0,
          'mouse' => 4 }
      ]
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'when Array of Struct is used for data' do
    let(:data) do
      [
        HashPivotUserStruct.new(id: 1, role: 'guest', team: 'rabbit', age: 1),
        HashPivotUserStruct.new(id: 2, role: 'guest', team: 'mouse', age: 2),
        HashPivotUserStruct.new({ id: 3, role: 'guest', team: 'rabbit', age: 3 }),
        HashPivotUserStruct.new({ id: 4, role: 'admin', team: 'mouse', age: 4 })
      ]
    end
    # rubocop:disable RSpec/ExampleLength

    it 'grouped by team and pivoted in role' do
      expect(
        described_class.pivot(data, :role, :team, %w[rabbit mouse],
                              repository: HashPivot::Repository::StructRepository)
      ).to eq [
        { role: 'guest',
          'rabbit' => [
            { id: 1, role: 'guest', team: 'rabbit', age: 1 },
            { id: 3, team: 'rabbit', role: 'guest', age: 3 }
          ],
          'mouse' => [{ id: 2, team: 'mouse', role: 'guest', age: 2 }] },
        { role: 'admin',
          'rabbit' => [],
          'mouse' => [{ id: 4, team: 'mouse', role: 'admin', age: 4 }] }
      ]
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength

    it 'grouped by team and pivoted in role without pivot_kinds' do
      expect(
        described_class.pivot(data, :role, :team, nil,
                              repository: HashPivot::Repository::StructRepository)
      ).to eq [
        { role: 'guest',
          'rabbit' => [
            { id: 1, role: 'guest', team: 'rabbit', age: 1 },
            { id: 3, team: 'rabbit', role: 'guest', age: 3 }
          ],
          'mouse' => [{ id: 2, team: 'mouse', role: 'guest', age: 2 }] },
        { role: 'admin',
          'mouse' => [{ id: 4, team: 'mouse', role: 'admin', age: 4 }] }
      ]
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength
    it 'output summed age of grouped by team and pivoted in role' do
      expect(
        described_class.pivot(data, :role, :team, %w[rabbit mouse],
                              repository: HashPivot::Repository::StructRepository) { |a| a.sum { |b| b[:age] } }
      ).to eq [
        { role: 'guest',
          'rabbit' => 4,
          'mouse' => 2 },
        { role: 'admin',
          'rabbit' => 0,
          'mouse' => 4 }
      ]
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'when ActiveRecord is used for data' do
    let(:data) { HashPivotUser.all }

    before do
      HashPivotUser.destroy_all
      create(:hash_pivot_user, id: 1, role: 'guest', team: 'rabbit', age: 1)
      create(:hash_pivot_user, id: 2, role: 'guest', team: 'mouse', age: 2)
      create(:hash_pivot_user, id: 3, role: 'guest', team: 'rabbit', age: 3)
      create(:hash_pivot_user, id: 4, role: 'admin', team: 'mouse', age: 4)
    end

    after { HashPivotUser.destroy_all }

    # rubocop:disable RSpec/ExampleLength

    it 'output grouped by team and pivoted in role' do
      expect(
        described_class.pivot(data, :role, :team, %w[rabbit mouse],
                              repository: HashPivot::Repository::ActiveRecordRepository)
      ).to eq [
        { role: 'guest',
          'rabbit' => [
            { id: 1, role: 'guest', team: 'rabbit', age: 1 },
            { id: 3, team: 'rabbit', role: 'guest', age: 3 }
          ],
          'mouse' => [{ id: 2, team: 'mouse', role: 'guest', age: 2 }] },
        { role: 'admin',
          'rabbit' => [],
          'mouse' => [{ id: 4, team: 'mouse', role: 'admin', age: 4 }] }
      ]
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength

    it 'output grouped by team and pivoted in role without pivot_kinds' do
      expect(
        described_class.pivot(data, :role, :team, nil,
                              repository: HashPivot::Repository::ActiveRecordRepository)
      ).to eq [
        { role: 'guest',
          'rabbit' => [
            { id: 1, role: 'guest', team: 'rabbit', age: 1 },
            { id: 3, team: 'rabbit', role: 'guest', age: 3 }
          ],
          'mouse' => [{ id: 2, team: 'mouse', role: 'guest', age: 2 }] },
        { role: 'admin',
          'mouse' => [{ id: 4, team: 'mouse', role: 'admin', age: 4 }] }
      ]
    end
    # rubocop:enable RSpec/ExampleLength

    # rubocop:disable RSpec/ExampleLength

    it 'output sumed age of grouped by team and pivoted in role' do
      expect(
        described_class.pivot(HashPivotUser.all, :role, :team, %w[rabbit mouse],
                              repository: HashPivot::Repository::ActiveRecordRepository) { |a| a.sum { |b| b[:age] } }
      ).to eq [
        { role: 'guest',
          'rabbit' => 4,
          'mouse' => 2 },
        { role: 'admin',
          'rabbit' => 0,
          'mouse' => 4 }
      ]
    end

    # rubocop:enable RSpec/ExampleLength
  end
end
