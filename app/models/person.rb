require 'neo4j'

Neo4j::ActiveBase.current_session = session

session.query('CREATE CONSTRAINT ON (p:Person) ASSERT p.uuid IS UNIQUE')

class Person
  include Neo4j::ActiveNode
  property :name

  has_many :in, :known_people, type: false, model_class: false
end
