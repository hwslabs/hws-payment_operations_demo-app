# frozen_string_literal: true

class TransactionsController < ApplicationController # :nodoc:
  def fetch_status
    status = Hws::PaymentOperationsDemo::VirtualAccount.fetch_transaction_status(params[:transaction_id])
    if status.nil?
      render status: 404, json: { success: false, message: "Cannot find transaction with id #{params[:transaction_id]}" }
      return
    end
    render status: 200, json: status
  rescue StandardError => e
    Rails.logger.error  "#{e.class} - #{e.message} | Trace: #{e.backtrace}"
    render status: 500, json: { success: false, code: e.message }
  end

  def show
    render status: 200, json: Hws::Transactions.get_entry(params[:id])
  end
end
