import 'package:equatable/equatable.dart';

class MassageModel extends Equatable {
  String? id;
  String? content;
  String? imageLink;
  String? voiceLink;
  String? chatId;
  String? senderId;
  String? senderName;
  int? sendTime;
  int? durationInSecond;

  MassageModel(
      {this.id,
      this.chatId,
      this.senderName,
      this.imageLink,
      this.voiceLink,
      this.sendTime,
      this.durationInSecond,
      this.content,
      this.senderId});

  MassageModel.fromJson(Map<String, dynamic> json)
      : this(
          chatId: json["chatId"],
          content: json["content"],
          sendTime: json["sendTime"],
          durationInSecond: json["durationInSecond"],
          senderName: json["senderName"],
          imageLink: json["imageLink"],
          voiceLink: json["voiceLink"],
          senderId: json["senderId"],
          id: json["id"],
        );

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "content": content,
      "durationInSecond": durationInSecond,
      "senderName": senderName,
      "senderId": senderId,
      "sendTime": sendTime,
      "id": id,
      "imageLink": imageLink,
      "voiceLink": voiceLink,
    };
  }

  @override
  List<Object?> get props => [id];
}
