# README

# Setup
- Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
  - then install Rails: `gem install rails`
- Install [Redis](https://redis.io/topics/quickstart)
- Install [Neo4j](https://neo4j.com/docs/operations-manual/current/installation/)

# How to Use?
- Start **Neo4j Server** with:
    `bundle exec rake neo4j:start`
- Start the **Application Server** with:
    `bundle exec rails s -p 3010`

## Save triple in Redis and Neo4j at the Same Time:
 - Send a POST to `http://localhost:3010/insert-data` with body:
    ```json
    {"data": "[[\"John\",\"Is a Friend of\",\"James\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"]]" }
    ```
    It'll persist this graph in Redis Following the strategy:
     - `"subject predicate" => "object"`
    It'll persist this graph in Neo4j Following the strategy:
    - `subject:Type -[predicate]- object:Type`


## Save triple in Redis:
 - Send a POST to `http://localhost:3010/save-triple-to-redis` with body:
    ```json
    {"data": "[[\"John\",\"Is a Friend of\",\"James\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"]]" }
    ```
    It'll persist this graph in Redis Following the strategy:
     - `"subject predicate" => "object"`

- Given a `subject predicate` you can discover which `object` it refers to using:
  - GET `http://localhost:3010/recover-object-redis?data=["subject", "predicate"]`
    - Will return `object`

## Save triple in Neo4j:
- Send a POST to `http://localhost:3010/save-triple-to-neo4j` with body:
   ```json
   {"data": "[[\"John\",\"Is a Friend of\",\"James\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"]]" }
   ```
   It'll persist this graph in Neo4j Following the strategy:
    - `subject:Type -[predicate]- object:Type`
- The Values stored in Neo4j chan be checked in the UI
 - Acess: `localhost:7474`
   - Run queries
    - `MATCH (n:Person) RETURN n LIMIT 25`
    - `MATCH p=()-[r:IS_A_FRIEND_OF]->() RETURN p LIMIT 25`


  - Simple SPARQL to Cypher Adapter for a FOAF query:
    `http://localhost:3010/parse?query=SELECT ?p WHERE { ?p r:IS_A_FRIEND_OF ?p . } LIMIT 5}`
    json: `{"query": "SELECT ?p WHERE { ?p r:IS_A_FRIEND_OF ?p . } LIMIT 1" }`
    translates to: `MATCH p=()-[r:IS_A_FRIEND_OF]->() RETURN p LIMIT 1`

### Observation:
 For testing purposes this projects abstracts a graph as an Array like:
```
 [[subject0, predicate0, object0],
  [subject1, predicate1, object1]]
 ```

 ### Tested using:
  ```
   [["John", "Is a Friend of", "James"],
   ["James", "Is a Friend of", "Jesse"],
   ["Jill", "Is a friend of", "Doug"],
   ["Jill", "Likes", "Snowboarding"],
   ["Snowboarding", "Is a", "Sport"]].to_json
   ```
