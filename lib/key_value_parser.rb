class KeyValueParser < ApplicationController
  def initialize(query)
    @query = query
  end

  def parse
    result = []

    if query_object == 'NO-OBJ'
      parse_key.each do |key|
        next if key == ':'
        result << sanitize_redis_key(key)[0]
      end
    else
      redis.smembers(query_predicate).each do |member|
        if sanitize_redis_key(member).last == query_object
          result << sanitize_redis_key(member).first
        end
      end
    end

    result
  end

  private

  def parse_key
    redis.keys.each_with_object([]) do |key, keys|
      splitted_key = sanitize_redis_key(key)

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

  def query_object
    result_clause = @query.split('WHERE')
    start_of = result_clause[1].index("'")
    end_of = result_clause[1].rindex("'")

    result_clause[1][start_of..end_of].tr("'", '')
  rescue
    return 'NO-OBJ'
  end

  def sanitize_redis_key(key)
    key.split(':')
  end

  def redis
    Redis.new
  end
end
