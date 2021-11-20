class Queries {

  static const GET_CLUB = """
    query Query(\$nodeId: ID!) {
      node(id: \$nodeId) {
        ... on Club {
          id
          name
          active
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
  """;

  static const GET_USER = """
    query Query(\$nodeId: ID!) {
      node(id: \$nodeId) {
        ... on User {
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


  static const GET_USERS_BY_KEYWORD = '''
    query Query(\$usersByKeywordKeyword: String!) {
      usersByKeyword(keyword: \$usersByKeywordKeyword) {
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
  ''';

  static const GET_USER_BY_EMAIL = """
    query Query(\$userByEmailEmail: String!) {
      userByEmail(email: \$userByEmailEmail) {
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
        friends {
          edges {
            node {
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
      }
    }
  """;


  static const GET_USER_FRIENDS = '''
    query Query(\$nodeId: ID!) {
      node(id: \$nodeId) {
        ... on User {
          friends {
            edges {
              node {
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
        }
      }
    }
  ''';

  static const GET_USER_FRIENDS_AND_REQUESTS = """
    query Query(\$nodeId: ID!) {
      node(id: \$nodeId) {
        ... on User {
          friends {
            edges {
              node {
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
          requests {
            edges {
              node {
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
        }
      }
    }
  """;


  static const GET_GAME = """
    query Query(\$nodeId: ID!) {
      node(id: \$nodeId) {
        ... on Game {
          id
          numHoles
          active
          ended
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
          holes {
            edges {
              node {
                id
                holeNum
                par
                distance
                scores {
                  edges {
                    node {
                      id
                      player {
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
                      value
                    }
                  }
                }
              }
            }
          }
          players {
            edges {
              node {
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
        }
      }
    }
  """;

  static const GET_ACTIVE_GAMES = """
    query Query(\$userId: String!) {
      activeGamesByUserId(userId: \$userId) {
        id
        numHoles
        active
        ended
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
  """;

  static const GET_ENDED_GAMES = """
    query Query(\$userId: String!) {
      endedGamesByUserId(userId: \$userId) {
        id
        numHoles
        active
        ended
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
  """;


  static const GET_ALL_GAMES = '''
    query Query(\$allGamesEnded: Boolean) {
      allGames(ended: \$allGamesEnded) {
        edges {
          node {
            id
            numHoles
            active
            ended
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
    }
  ''';

}
