require 'neo4j-core'

module Database
  class Session
    SESSION = Neo4j::Session.open(:server_db,
                                  'http://localhost:7474',
                                  basic_auth: { username: 'neo4j', password: '123qwe' })

    def self.instance
      SESSION
    end
  end
end
