import 'package:chat_app/constants.dart';

class Message {
  final String id;
  final String message;

  Message(this.message,this.id);

  factory Message.fromjson(jsonData) {
    return Message(jsonData[KMessage],jsonData[KId]);
  }
}
