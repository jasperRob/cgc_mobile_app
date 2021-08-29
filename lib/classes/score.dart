import 'export.dart';

class Score extends CGCObject {
  late User player;
  late int value;

  Score(String id, bool active, int value) : super(id, active) {
    this.value = value;
  }

  factory Score.fromJSON(dynamic data) {
    Score score = Score(
      data['id'],
      true,
      data["value"]
    );
    if (data["player"] != null) {
      score.player = User.fromJSON(data["player"]);
    }
    return score;
  }
}


