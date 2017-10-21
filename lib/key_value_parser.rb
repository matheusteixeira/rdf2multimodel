class KeyValueParser < ApplicationController
  def initialize(query)
    @query = query
  end

  def parse
    parse_key.each_with_object([]) do |key, result|
      next if key == ':'
      result << key.split(':')[0]
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
