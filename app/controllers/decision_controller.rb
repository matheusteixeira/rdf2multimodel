class DecisionController < ApplicationController
  # "SELECT ?p WHERE { ?p r:IS_A_FRIEND_OF ?p . } LIMIT 1"

  # "SELECT ?p WHERE { ?p r:IS_A_FRIEND_OF ?x . ?x LIKES Snowboarding } LIMIT 1"

  # MATCH p=()-[r:IS_A_FRIEND_OF]->() RETURN p

  def decide
    result = if params[:query].split('{').second.count('?') > 2
               GraphParser.new(params[:query]).parse
             else
               KeyValueParser.new(params[:query]).parse
             end

    render json: result, status: :ok
  end
end
