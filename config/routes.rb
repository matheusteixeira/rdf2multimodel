Rails.application.routes.draw do
  # Insert data into Redis (Key/Value)
  post '/save-triple-to-redis', to: 'key_value_adapter#insert'

  # Redis get by key
  get '/recover-object-redis', to: 'key_value_adapter#load_data'

  # Insert data into Neo4j (Graph)
  post '/save-triple-to-neo4j', to: 'graph_adapter#insert'

  # Insert data both to Neo4j (Graph) and Redis (Key/Value)
  post '/insert-data', to: 'multimodel_connector#insert'

  # Parse SPARQL query -- To Cypher
  post '/parse', to: 'parser#parse'
end
