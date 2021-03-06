class CreateHwsResourcesTables < ActiveRecord::Migration[6.1]
  def self.up
    enable_extension 'pgcrypto' unless extensions.include?('pgcrypto')
    create_table :resources, id: :uuid, force: true do |t|
      t.string   :name
      t.text     :description
      t.string   :resource_type # fungible_backed, fungible_soft, non_fungibe
      t.jsonb    :schema, default: {}
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
