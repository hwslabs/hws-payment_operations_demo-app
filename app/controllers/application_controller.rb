# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_forgery_protection

  def index
    render status: :ok, json: { success: 200, tables: ActiveRecord::Base.connection.tables }
  end
end
