import 'export.dart';

class Req extends CGCObject {
  late User source;
  late User target;

  Req(String id, bool active) : super(id, active);

  factory Req.fromJSON(dynamic data) {
    Req score = Req(
      data['id'],
      data['active']
    );
    if (data["source"] != null) {
      score.source = User.fromJSON(data["source"]);
    }
    if (data["target"] != null) {
      score.target = User.fromJSON(data["target"]);
    }
    return score;
  }
}


