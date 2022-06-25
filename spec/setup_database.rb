# frozen_string_literal: true

ActiveRecord::Base.configurations = { 'test' => { adapter: 'sqlite3', database: ':memory:' } }
ActiveRecord::Base.establish_connection :test
ActiveRecord::Migration.verbose = false
class MigrateSqlDatabase < ActiveRecord::Migration[6.1]
  def self.up
    create_table(:hash_pivot_users) do |t|
      t.string :role
      t.string :team
      t.integer :age
    end
  end
end

MigrateSqlDatabase.up
