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

# 1. Persistence

## 1.1. Persist triple at Redis and Neo4j at the Same Time:
 - Send a POST to `http://localhost:3010/insert-data` with body:
    ```json
    { "data": "[[\"John\",\"Is a Friend of\",\"James\"],[\"John\",\"Is a Friend of\",\"Jill\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"James\",\"Is a Friend of\",\"Jill\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"], [\"Doug\",\"Plays\",\"RPG\"]]" }
    ```
    It'll persist this graph in Redis Following the strategy:
     - `"subject predicate" => "object"`
    It'll persist this graph in Neo4j Following the strategy:
    - `subject:Type -[predicate]- object:Type`


## 1.2. Persist triple at Redis only:
 - **POST**:
 ```
 http://localhost:3010/save-triple-to-redis
 ```
 - With **BODY**:
    ```json
    { "data": "[[\"John\",\"Is a Friend of\",\"James\"],[\"John\",\"Is a Friend of\",\"Jill\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"James\",\"Is a Friend of\",\"Jill\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"], [\"Doug\",\"Plays\",\"RPG\"]]" }
    ```
It'll persist this graph in Redis Following the strategy:
     - `"subject:predicate" => "object"` and `predicate => subject:predicate:object`

## 1.3. Persist triple at Neo4j olny:
- **POST**:
 ```
 http://localhost:3010/save-triple-to-neo4j
 ```
 With **BODY**:
   ```json
   {"data": "[[\"John\",\"Is a Friend of\",\"James\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"]]" }
   ```
It'll persist this graph in Neo4j Following the strategy:
    - `subject:Type -[predicate]- object:Type`

  The Values stored in Neo4j chan be checked via GUI
   - Acess: `localhost:7474`
     - Run queries
      - `MATCH (n:Person) RETURN n LIMIT 25`
      - `MATCH p=()-[r:IS_A_FRIEND_OF]->() RETURN p LIMIT 25`

### Observation:
 For testing purposes this projects abstracts a graph as an Array like:
```
 [[subject 0, predicate 0, object 0],
  [subject 1, predicate 1, object 1]]
 ```

 ### Tested using:
  ```
  "[[\"John\",\"Is a Friend of\",\"James\"],[\"John\",\"Is a Friend of\",\"Jill\"],[\"James\",\"Is a Friend of\",\"Jesse\"],[\"James\",\"Is a Friend of\",\"Jill\"],[\"Jill\",\"Is a friend of\",\"Doug\"],[\"Jill\",\"Likes\",\"Snowboarding\"],[\"Snowboarding\",\"Is a\",\"Sport\"], [\"Doug\",\"Plays\",\"RPG\"]]"
  ```

# 2. Querying

- You can test Querying sending a GET request to `/parse`.
- You should send a SPARQL query as PARAM `query`.

## 2.1 Querying Examples:

  - **GET**:
  ```
  http://localhost:3010/parse?query=SELECT ?p WHERE { ?p IS_A_FRIEND_OF ?x . ?x LIKES 'Snowboarding' }
  ```
  - For the test data mentioned above, it'll return:
    - John
    - James

  - **GET**:
  ```
  http://localhost:3010/parse?query=SELECT ?p WHERE { ?p IS_A_FRIEND_OF ?x . ?x PLAYS 'RPG' }
  ```
  - For the test data mentioned above, it'll return:
    - Jill

  - **GET**:
  ```
  http://localhost:3010/parse?query=SELECT ?p WHERE { ?p IS_A_FRIEND_OF ?r }
  ```
  - For the test data mentioned above, it'll return:
    - Jill
    - John
    - James

  - **GET**:
  ```
  http://localhost:3010/parse?query=SELECT ?p WHERE { ?p IS_A_FRIEND_OF 'Jesse' }
  ```
  - For the test data mentioned above, it'll return:
    - James
