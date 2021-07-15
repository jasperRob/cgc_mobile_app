
import 'game.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'globals.dart' as globals;

class GraphQLUtils {

  static Future<dynamic> getAllClubs() async {
    final String queryString = """
      {
        allClubs {
          edges {
            node {
              id
              name
            }
          }
        }
      }
    """;
    String token = await globals.storage.read(key: "token");

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
      ),
    );

    var value = await client.query(
      QueryOptions(
        documentNode: gql(queryString),
      ),
    );
    if (value.exception != null) {
      // return value.exception;
      return Future.error(value.exception.toString());
    }
    return value;
  }

  static Future<dynamic> addUser(String firstName, String lastName, String email, String password, String birthDate, String gender, int handicap, String clubId) async {
    final String mutationString = """
    mutation {
      createUser(
        firstName: \"$firstName\", 
        lastName: \"$lastName\", 
        email: \"$email\", 
        password: \"$password\",
        birthDate: \"$birthDate\",
        gender: \"$gender\",
        handicap: $handicap,
        clubId: \"$clubId\",
        ) {
        ok
      }
    }
    """;
    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
      ),
    );
 
    var value = await client.mutate(
      MutationOptions(
        documentNode: gql(mutationString),
        onCompleted: (dynamic resultData) {
          return resultData;
        }
      ),
    );
    if (value.hasException) {
      return Future.error(value.exception.toString());
    }
    return value;
  }

  static Future<QueryResult> login(String email, String password) async {
    final String mutationString = """
    mutation {
      login(email: \"$email\", password: \"$password\") {
        ok
        token
      }
    }
    """;

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,

      ),
    );


    var value = await client.mutate(
      MutationOptions(
        documentNode: gql(mutationString),
        onCompleted: (dynamic resultData) {
          return resultData;
        }
      ),
    );
    if (value.hasException) {
      return Future.error(value.exception.toString());
    }
    
    return value;
  
  }

  static Future<dynamic> getUserData(String email) async {
    final String queryString = """
      query {
        userByEmail(email: \"$email\") {
          id
          firstName
          lastName
          email
          password
          birthDate
          handicap
          totalGames
          avgScore
          created
          updated
          club {
            id
            name
            email
            phone
            address
            state
            country
            zipCode
            created
            updated
          }
        }
      }
    """;
    String token = await globals.storage.read(key: "token");

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
        headers: {
          "Authorization": "Bearer " + token
        },
      ),
    );

    var value = await client.query(
      QueryOptions(
        documentNode: gql(queryString),
      ),
    );
    if (value.exception != null) {
      // return value.exception;
      return Future.error(value.exception.toString());
    }
    return value;
  }

  static Future<dynamic> createGameWithGame(Game game) async {
    // List<String> pids = List<String>.from(game.players.map((player) { return player.id; }) );
    // print(pids);
    return createGameWithData(
      game.club.id, 
      game.numHoles, 
      List<String>.from(game.players.map((player) { return player.id; }) )
    );
  }

  static Future<dynamic> createGameWithData(String clubId, int numHoles, List<String> playerIds) async {
    // Stringify player Id list
    String pIds = playerIds.map((id) { return "\"" + id + "\""; }).toList().toString();

    final String mutationString = """
    mutation {
      createGame(
        clubId: \"$clubId\", 
        numHoles: $numHoles
        playerIds: $pIds
        ) {
        ok
        game {
          id
          club {
            id 
            name
            state
            country
          }
          numHoles
          active
          players {
            edges {
              node {
                user {
                  id
                  firstName
                  lastName
                }
              }
            }
          }
          holes {
            edges {
              node {
                id
                holeNum
                par
              }
            }
          }
          created
        }
      }
    }
    """;

    String token = await globals.storage.read(key: "token");

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
        headers: {
          "Authorization": "Bearer " + token
        },
      ),
    );

 
    var value = await client.mutate(
      MutationOptions(
        documentNode: gql(mutationString),
        onCompleted: (dynamic resultData) {
          return resultData;
        }
      ),
    );
    if (value.hasException) {
      return Future.error(value.exception.toString());
    }
    return value;
  }
  static Future<dynamic> finishGame(String gameId) async {

    final String mutationString = """
    mutation {
      finishGame(
        gameId: \"$gameId\", 
        ) {
        ok
      }
    }
    """;

    String token = await globals.storage.read(key: "token");

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
        headers: {
          "Authorization": "Bearer " + token
        },
      ),
    );

 
    var value = await client.mutate(
      MutationOptions(
        documentNode: gql(mutationString),
        onCompleted: (dynamic resultData) {
          return resultData;
        }
      ),
    );
    if (value.hasException) {
      return Future.error(value.exception.toString());
    }
    return value;
  }

  static Future<dynamic> getHolesByGameId(String gameId) async {
    final String queryString = """
      query {
        holesByGameId(gameId: \"$gameId\") {
          id
          gameId
          holeNum
          par
          created
          updated
        }
      }
    """;

    String token = await globals.storage.read(key: "token");

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
        headers: {
          "Authorization": "Bearer " + token
        },
      ),
    );

    var value = await client.query(
      QueryOptions(
        documentNode: gql(queryString),
      ),
    );
    if (value.hasException) {
      return Future.error(value.exception.toString());
    }
    return value;
  }

  static Future<dynamic> getClubById(String clubId) async {
    final String queryString = """
      query {
        clubById(id: \"$clubId\") {
          id
          name
          state
        }
      }
    """;

    String token = await globals.storage.read(key: "token");

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
        headers: {
          "Authorization": "Bearer " + token
        },
      ),
    );

    var value = await client.query(
      QueryOptions(
        documentNode: gql(queryString),
      ),
    );
    if (value.hasException) {
      return Future.error(value.exception.toString());
    }
    return value;
  }

  static Future<dynamic> submitScore(String gameId, String holeId, String userId, int score) async {
    final String mutationString = """
      mutation {
        submitScore(
          gameId: \"$gameId\",
          holeId: \"$holeId\",
          userId: \"$userId\",
          score: $score
        ) {
          ok
          score {
            id
            score
            player {
              id
              winner
              user {
                id
                firstName
                lastName
              }
            }
          }
        }
      }
    """;

    String token = await globals.storage.read(key: "token");

    GraphQLClient client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(
        uri: globals.uri,
        headers: {
          "Authorization": "Bearer " + token
        },
      ),
    );

    var value = await client.mutate(
      MutationOptions(
        documentNode: gql(mutationString),
      ),
    );
    if (value.hasException) {
      return Future.error(value.exception.toString());
    }
    return value;
  }
}
