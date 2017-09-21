# README

# Setup
- Install ruby
  - then: `gem install rails`
- Install redis
- Install neo4j
  - then: `bundle exec rake neo4j:start`

# How to Use?
- Start the **Server** with: `bundle exec rails s -p 3010`

## Redis:
 - Send a POST to `http://localhost:3010/save-triple-to-redis` with body:
    ```json
    {"data": "[[\"John\",\"Is a Friend of\",\"James\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"]]" }
    ```
    It'll persist this graph in Redis Following the strategy:
     - `"subject predicate" => "object"`

- Given a `subject predicate` you can discover which `object` it refers to using:
  - GET `http://localhost:3010/recover-object-redis?data=["subject", "predicate"]`
    - Will return `object`

## Neo4j:
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
    `http://localhost:3010/parse`
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
