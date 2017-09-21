class GraphAdapterController < ApplicationController
  def insert
    ::KeyValueAdapter.new(data).insert_data

    head :ok
  end

  private

  def data
    JSON.parse(params[:data])
  end
end
