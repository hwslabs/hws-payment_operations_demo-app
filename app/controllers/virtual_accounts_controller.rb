# frozen_string_literal: true

class VirtualAccountsController < ApplicationController # :nodoc:
  before_action :load_va, except: [:create, :fetch_status]

  def activate
    @va.activate
    render status: 200, json: { success: true }
  rescue StandardError => e
    Rails.logger.error  "#{e.class} - #{e.message} | Trace: #{e.backtrace}"
    render status: 500, json: { success: false, code: e.message }
  end

  def deactivate
    @va.deactivate
    render status: 200, json: { success: true }
  rescue StandardError => e
    Rails.logger.error  "#{e.class} - #{e.message} | Trace: #{e.backtrace}"
    render status: 500, json: { success: false, code: e.message }
  end

  def balance
    bal = @va.balance
    render status: 200, json: { success: true, data: bal }
  end

  def create
    va = Hws::PaymentOperationsDemo::VirtualAccount.create(name: params['name'], description: params['description'])
    render status: 201, json: { success: true, data: va.as_json }
  rescue Hws::PaymentOperationsDemo::Exceptions::EntityNotFoundError, Hws::Connectors::Exception::Error, StandardError => e
    Rails.logger.error  "#{e.class} - #{e.message} | Trace: #{e.backtrace}"
    render status: 500, json: { success: false, code: e.message }
  end

  def show
    render status: 200, json: { success: true, data: @va.as_json }
  end

  def transfer
    tr_params = transfer_params.to_h
    resp = @va.transfer_funds(amount: tr_params['amount'], payment_type: tr_params['payment_type'], beneficiary: tr_params['beneficiary'])
    render status: 200, json: { success: true, data: resp }
  rescue StandardError => e
    Rails.logger.error  "#{e.class} - #{e.message} | Trace: #{e.backtrace}"
    render status: 500, json: { success: false, code: e.message }
  end

  def fetch_status
    status = Hws::PaymentOperationsDemo::VirtualAccount.fetch_transaction_status(params[:reference_number])
    render status: 200, json: status
  rescue StandardError => e
    Rails.logger.error  "#{e.class} - #{e.message} | Trace: #{e.backtrace}"
    render status: 500, json: { success: false, code: e.message }
  end

  private

  def transfer_params
    params.permit([:amount, :payment_type, beneficiary: [:upi_id, :account_number, :account_ifsc, :note]])
  end

  def load_va
    @va = Hws::PaymentOperationsDemo::VirtualAccount.of(params['id'])
  rescue Hws::PaymentOperationsDemo::Exceptions::EntityNotFoundError => e
    render status: 404, json: { success: false, code: e.message }
  end
end
