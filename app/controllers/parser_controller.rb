class ParserController < ApplicationController
  # "SELECT ?p WHERE { ?p r:IS_A_FRIEND_OF ?p . } LIMIT 1"

  # "SELECT ?p WHERE { ?p r:IS_A_FRIEND_OF ?x . ?x LIKES Snowboarding } LIMIT 1"

  # MATCH p=()-[r:IS_A_FRIEND_OF]->() RETURN p

  def parse
    result = execute(translate_pattern + translate_result + query_modifier)

    # TODO: Return result as a triple
    render json: result
  end

  def translate_result
    translated = ''

    result_clause.first.split.each do |r|
      next if r == 'SELECT'
      translated << "#{r.remove('?')} "
    end

    translated.prepend('RETURN ')
  end

  def translate_pattern
    translated = 'MATCH p=()-'

    translated += query_pattern.first.sub('{', '[').remove("?p").sub(' . ', ']->()').remove(" ")
  end

  def result_clause
    params[:query].split('WHERE')
  end

  def query_pattern
    result_clause.second.split('}')
  end

  def query_modifier
    query_pattern.last
  end

  def execute(query)
    session.query(query)
  end

  def session
    Database::Session.instance
  end
end
