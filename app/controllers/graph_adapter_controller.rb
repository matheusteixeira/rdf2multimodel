class GraphAdapterController < ApplicationController
  def insert
    ::KeyValueAdapter.new(data).insert_data
  end

  private

  def data
    JSON.parse(params[:data])
  end
end
