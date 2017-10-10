class GraphAdapterController < ApplicationController
  def insert
    ::GraphAdapter.new(data).insert_data
  end

  private

  def data
    JSON.parse(params[:data])
  end
end
