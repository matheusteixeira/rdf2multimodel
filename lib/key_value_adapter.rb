class KeyValueAdapter

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def insert_data
    data.each do |triple|
      save_triple(triple)
    end
  end

  def save_triple(triple)
    redis.sadd(key(triple), value(triple))
  end

  def load_data
    key = "#{data.first}:#{data.second}"

    render json: redis.smembers(key), head: :ok
  end

  def key(triple)
    "#{triple.first}:#{triple.second}"
  end

  # TODO: Insert it using predicate => subject:predicate:object

  def value(triple)
    triple[2]
  end

  private

  def redis
    Redis.new
  end
end
