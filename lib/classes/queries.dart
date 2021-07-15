import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Queries {

  static const GET_CLUB = """
    query Query(\$nodeId: ID!) {
      node(id: \$nodeId) {
        ... on Club {
          id
          email
          phone
          address
          city
          state
          country
          zipCode
          windDirection
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
        club {
          id
          name
        }
      }
    }
  ''';

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
          club {
            id
            name
            country
          }
          numHoles
          holes {
            edges {
              node {
                id
                holeNum
                par
                distance
                start
                finish
                scores {
                  edges {
                    node {
                      id
                      value
                      player {
                        id
                      }
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
              }
            }
          }
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
            players {
              edges {
                node {
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
  ''';

}
