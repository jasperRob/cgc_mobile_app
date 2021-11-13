import 'export.dart';

class User extends CGCObject {
  late Club club;
  late List<User> friends;
  late List<Req> requests;
  late String firstName;
  late String lastName;
  late String email;
  late String gender;
  late String birthDate;
  late int handicap;
  late int totalGames;
  late bool admin;

  User(String id, bool active, bool admin, String firstName, String lastName, String email, 
      String gender, String birthDate, int handicap, int totalGames, 
      List<User> friends, List<Req> requests) : super(id, active) {
    this.admin = admin;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.gender = gender;
    this.birthDate = birthDate;
    this.handicap = handicap;
    this.friends = friends;
    this.requests = requests;
  }

  factory User.fromJSON(dynamic data) {

    List<User> friends = [];
    if (data["friends"] != null) {
      friends = new List<User>.from(data["friends"]["edges"].map((item) {
        return User.fromJSON(item["node"]);
      }));
    }

    List<Req> requests = [];
    if (data["requests"] != null) {
      requests = new List<Req>.from(data["requests"]["edges"].map((item) {
        return Req.fromJSON(item["node"]);
      }));
    }

    User user = User(
      // Graphene appends class name then Base64 encodes any ID.
      data['id'],
      data['active'],
      data['admin'],
      data["firstName"],
      data["lastName"],
      data["email"],
      data["gender"],
      data["birthDate"],
      data["handicap"],
      data["totalGames"],
      friends,
      requests
    );

    if (data["club"] != null) {
      user.club = Club.fromJSON(data["club"]);
    }
    return user;
  }

  String fullName() {
    return this.firstName + " " + this.lastName;
  }
}


