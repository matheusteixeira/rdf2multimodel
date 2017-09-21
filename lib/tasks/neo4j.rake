namespace :neo4j do
  task :install => :environment do
    load 'neo4j/rake_tasks/neo4j_server.rake'
  end
end
