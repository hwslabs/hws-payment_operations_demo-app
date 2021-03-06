class CreateHwsInstrumentsTables < ActiveRecord::Migration[6.1]
  def self.up
    enable_extension 'pgcrypto' unless extensions.include?('pgcrypto')

    create_table :instrument_configs, id: :uuid do |t| # payout
      t.string   :connector_id # Hws::Connectors::Hypto::{VirtualAccounts, Payouts, UPI}, Hws::Connectors::YesBank::{...}, ...
      t.string   :executor_id # Hws::Instruments::Executors::Hypto::VirtualAccounts
      t.jsonb    :connector_credentials, default: {}
      t.jsonb    :connector_actions, default: {} # {'action:send_to_bank': Hws::Connector::Payout::SendToBankRequest, ..}
      t.timestamps
    end

    create_table :instruments, id: :uuid do |t|
      t.belongs_to :instrument_config, type: :uuid, foreign_key: true
      t.string     :external_identifier # VAN for virtual acc, UPI ID for UPI, nil for payouts
      t.jsonb      :value, default: {}
      t.jsonb      :connector_actions, default: {} # {'action:send_to_bank': {acc_no: '', ifsc, ref_no, amount, payent_mode, note}, ..}
      t.jsonb      :allowed_actions, default: [] # array of actions which are enabled for the instrument
      t.timestamps
    end

    # TODO - Decide if connector_id can be made the primary key of this table
    add_index :instrument_configs, :connector_id, unique: true

    add_index :instruments, :value, using: :gin
    add_index :instruments, %I[external_identifier instrument_config_id], name: 'e_i_index'
  end

  def self.down
    drop_table :instruments
    drop_table :instrument_configs
  end
end
