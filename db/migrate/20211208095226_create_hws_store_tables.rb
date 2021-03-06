class CreateHwsStoreTables < ActiveRecord::Migration[6.1]
  def self.up
    enable_extension 'pgcrypto' unless extensions.include?('pgcrypto')

    create_table :stores, id: :uuid do |t|
      t.string   :name
      t.text     :description
      t.jsonb    :data, default: {}
      t.decimal  :value, precision: 15, scale: 2 
      t.jsonb    :schema, default: {}
      t.jsonb    :tags, default: {}
      t.timestamps
    end

    create_table :owners, id: :uuid do |t|
      t.string   :name
      t.text     :description
      t.jsonb    :tags, default: {}
      t.timestamps
    end

    create_join_table :stores, :owners, column_options: { type: :uuid } do |t|
      t.index %I[store_id owner_id]
      t.index %I[owner_id store_id]
    end

    add_index :stores, :tags, using: :gin
    add_index :owners, :tags, using: :gin
  end

  def self.down
    drop_table :owners_stores
    drop_table :owners
    drop_table :stores
  end
end
