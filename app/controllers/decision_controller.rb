class DecisionController < ApplicationController
  def decide
    result = if params[:query].split('{').second.count('?') > 2
               GraphParser.new(params[:query]).parse
             else
               KeyValueParser.new(params[:query]).parse
             end

    render json: result, status: :ok
  end
end
