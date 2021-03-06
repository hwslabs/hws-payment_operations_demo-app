class CreateHwsTransactionTables < ActiveRecord::Migration[6.1]
  def self.up
    enable_extension 'pgcrypto' unless extensions.include?('pgcrypto')
    create_table :transaction_groups, id: :uuid, force: true do |t|
      t.string   :name
      t.text     :description
      t.jsonb    :tags
      t.timestamps
    end

    create_table :transaction_entries, id: :uuid, force: true do |t|
      t.uuid     :transaction_group_id
      t.integer  :value
      t.datetime :txn_time
      t.jsonb    :immutable_tags
      t.jsonb    :mutable_tags

      t.timestamps
    end

    add_index :transaction_entries, :immutable_tags, using: :gin
    add_index :transaction_entries, :mutable_tags, using: :gin
    add_index :transaction_entries, :txn_time
  end

  def self.down
    drop_table :transaction_groups
    drop_table :transaction_entries
  end
end
