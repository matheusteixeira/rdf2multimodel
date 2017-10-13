class GraphAdapter

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def insert_data
    data.each do |d|
      session.query(insert_query(d), triples: [d])
    end
  end

  private

  def insert_query(data)
    types = type(data)

    insert_query = <<-QUERY
      UNWIND {triples} as triple
      MERGE (p1:#{types[:subject]} {name:triple[0]})
      MERGE (p2:#{types[:object]} {name:triple[2]})
      MERGE (p1)-[:#{types[:predicate]}]-(p2)
    QUERY
  end

  def type(d)
    { predicate: normalize_predicate(d[1]), subject: 'default', object: 'default' }
  end

  def normalize_predicate(string)
    string.parameterize.underscore.upcase
  end

  def session
    Database::Session.instance
  end
end