class MultimodelConnectorController < ApplicationController
  def insert
    ::GraphAdapter.new(data).insert_data
    ::KeyValueAdapter.new(data).insert_data

    render json: 'Data has been insert with success!'.to_json, status: :ok
  end

  private

  def data
    JSON.parse(params[:data])
  end
end
