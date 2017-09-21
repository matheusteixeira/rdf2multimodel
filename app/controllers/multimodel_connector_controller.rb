class MultimodelConnectorController < ApplicationController
  def insert
    ::GraphAdapter.new(data).insert_data
    ::KeyValueAdapter.new(data).insert_data

    head :ok
  end

  private

  def data
    JSON.parse(params[:data])
  end
end
