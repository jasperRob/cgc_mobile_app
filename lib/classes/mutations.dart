class Mutations {

  static const CREATE_GAME = """
    mutation Mutations(\$createGameClubId: String, \$createGameNumMinutes: Int, \$createGamePlayerIds: [String], \$createGameEnded: Boolean) {
      createGame(clubId: \$createGameClubId, numMinutes: \$createGameNumMinutes, playerIds: \$createGamePlayerIds, ended: \$createGameEnded) {
        ok
        game {
          id
          active
          numHoles
          holes {
            edges {
              node {
                id
                holeNum
                par
                scores {
                  edges {
                    node {
                      id
                      value
                      player {
                        id
                        firstName
                        lastName
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  """;

  static const CREATE_REQUEST = """
    mutation Mutations(\$requestFriendSourceId: String!, \$requestFriendTargetId: String!) {
      requestFriend(sourceId: \$requestFriendSourceId, targetId: \$requestFriendTargetId) {
        request {
          id
          source {
            id
          }
          target {
            id
          }
        }
      }
    }
  """;

  static const ACCEPT_REQUEST = """
    mutation Mutations(\$acceptRequestRequestId: String!) {
      acceptRequest(requestId: \$acceptRequestRequestId) {
        ok
      }
    }
  """;


}
