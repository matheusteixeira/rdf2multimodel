# Parse query and queries in Redis
class KeyValueParser < ApplicationController
  # "SELECT ?p WHERE { ?p IS_A_FRIEND_OF ?r } LIMIT 1"

  # "SELECT ?p WHERE { ?p IS_A_FRIEND_OF ?x . ?x LIKES Snowboarding } LIMIT 1"

  # MATCH p=()-[r:IS_A_FRIEND_OF]->() RETURN p

  def initialize(query)
    @query = query
  end

  def parse
    parse_key.each_with_object([]) do |key, result|
      next if key == ':'
      result << "#{key.split(':')}, #{redis.smembers(key)}"
    end
  end

  def parse_key
    redis.keys.each_with_object([]) do |key, keys|
      splitted_key = key.split(':')

      if splitted_key[1] == query_predicate
        keys << "#{splitted_key[0]}:#{splitted_key[1]}"
      end
    end
  end

  def query_predicate
    @query.split('{')[1].split(' ').each do |element|
      return element.humanize.upcase unless element.include?('?')
    end
  end

  def redis
    Redis.new
  end
end
