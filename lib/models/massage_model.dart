import 'package:equatable/equatable.dart';

class MassageModel extends Equatable {
  String? id;
  String? content;
  String? chatId;
  String? senderId;
  String? senderName;
  int? sendTime;

  MassageModel(
      {this.id,
      this.chatId,
      this.senderName,
      this.sendTime,
      this.content,
      this.senderId});

  MassageModel.fromJson(Map<String, dynamic> json)
      : this(
          chatId: json["chatId"],
          content: json["content"],
          sendTime: json["sendTime"],
          senderName: json["senderName"],
          senderId: json["senderId"],
          id: json["id"],
        );

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "content": content,
      "senderName": senderName,
      "senderId": senderId,
      "sendTime": sendTime,
      "id": id,
    };
  }

  @override
  List<Object?> get props => [id];
}
