class Mutations {

  static const CREATE_GAME = """
    mutation Mutations(\$createGameClubId: String, \$createGameNumMinutes: Int, \$createGamePlayerIds: [String], \$createGameEnded: Boolean, \$createGameWindStrength: Float) {
      createGame(clubId: \$createGameClubId, numMinutes: \$createGameNumMinutes, playerIds: \$createGamePlayerIds, ended: \$createGameEnded, windStrength: \$createGameWindStrength) {
        ok
        game {
          id
          active
          numHoles
          ended
          holes {
            edges {
              node {
                id
                holeNum
                par
                distance
              }
            }
          }
        }
      }
    }
  """;

  static const UPDATE_USER = """
    mutation Mutations(\$userId: String!, \$gender: String, \$handicap: Int) {
      updateUser(userId: \$userId, gender: \$gender, handicap: \$handicap) {
        ok
        user {
          id
          firstName
          lastName
          email
          birthDate
          gender
          handicap
          totalGames
          admin
          active
          club {
            id
            active
            name
            email
            phone
            address
            city
            state
            country
            zipCode
            windDirection
            windStrength
          }
        }
      }
    }
  """;
  
  static const CREATE_GUEST_USER = """
    mutation Mutations(\$clubId: String!, \$email: String!, \$firstName: String, \$lastName: String, \$handicap: Int, \$guest: Boolean, \$gender: String, \$admin: Boolean, \$totalGames: Int) {
      createUser(clubId: \$clubId, email: \$email, firstName: \$firstName, lastName: \$lastName, handicap: \$handicap, guest: \$guest, gender: \$gender, admin: \$admin, totalGames: \$totalGames) {
        ok
        user {
          id
          firstName
          lastName
          email
          birthDate
          gender
          handicap
          totalGames
          admin
          active
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
