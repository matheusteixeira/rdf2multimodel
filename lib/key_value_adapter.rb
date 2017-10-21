class KeyValueAdapter
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def insert_data
    data.each do |triple|
      save_triple_sp(triple)
      save_triple_p(triple)
    end
  end

  # Save Triple as SP* => O
  def save_triple_sp(triple)
    redis.sadd(key_sp(triple), value_sp(triple))
  end

  def load_data
    key = "#{data.first.upcase}:#{data.second.upcase}"

    redis.smembers(key)
  end

  def key_sp(triple)
    "#{triple.first.upcase}:#{triple.second.upcase}"
  end

  def value_sp(triple)
    triple[2].upcase
  end

  # Save Triple as *P* => SPO
  def save_triple_p(triple)
    redis.sadd(key_p(triple), value_p(triple))
  end

  def key_p(triple)
    triple.second.upcase
  end

  def value_p(triple)
    "#{triple.first.upcase}:#{triple.second.upcase}:#{triple.last.upcase}"
  end

  private

  def redis
    Redis.new
  end
end
