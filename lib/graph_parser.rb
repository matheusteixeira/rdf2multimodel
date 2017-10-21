class GraphParser < ApplicationController
  def initialize(query)
    @query = query
  end

  def parse
    query_result = execute(translate_pattern + translate_result + query_modifier)
    result = []

    query_result.to_a.each_with_object(result) do |res|
      result << res.p[:name]
    end
  end

  def translate_result
    translated = ''

    result_clause.first.split.each do |r|
      next if r == 'SELECT'
      translated << "#{r.remove('?')} "
    end

    translated.prepend(' RETURN ')
  end

  def translate_pattern
    str = result_clause[1].split(' ')
    arr = []

    str.each do |element|
      arr << element if element.include?('?')
    end

    pattern_hash = { n0: arr[0].remove('?'), n1: arr[1].remove('?'), n2: find_object }

    build_pattern_translation(pattern_hash[:n0], pattern_hash[:n1], pattern_hash[:n2])
  end

  def build_pattern_translation(predicate, subject, object)
    subjects = extract_subjects
    "MATCH (#{predicate})-[:#{subjects[0]}]->(#{subject})-[:#{subjects[1]}]->(n2 { name: #{object} })"
  end

  def extract_subjects
    subjects = []

    result_clause[1].split('{')[1].split(' ').each do |keyword|
      subjects << keyword unless KEY_TERMS.any? { |term| keyword.include?(term) }
    end

    subjects
  end

  def result_clause
    @query.split('WHERE')
  end

  def query_modifier
    @query.split('}')[1].to_s
  end

  def find_object
    start_of = result_clause[1].index("'")
    end_of = result_clause[1].rindex("'")

    result_clause[1][start_of..end_of]
  end

  def execute(query)
    session.query(query)
  end

  def session
    Database::Session.instance
  end

  KEY_TERMS = ['.', '}', '?', 'LIMIT', 'ORDER', 'BY', "'"].freeze
end
