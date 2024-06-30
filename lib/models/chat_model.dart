import 'package:chat_app/models/user_model.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable{
  String? id;
  String? title;
  String? description;
  List<UserModel?>? users;

  ChatModel({this.id, this.title, this.description, this.users});

  ChatModel.fromJson(Map<String, dynamic> json) {
    description = json["description"];
    id = json["id"];
    title = json["title"];
    List<dynamic> ?jsonUsers = json["users"];

    users = jsonUsers
        ?.map((dynamic jsonUser) => UserModel.fromJson(jsonUser))
        .toList();
    print(users);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> listOfUsers = users!
        .map(
          (e) => e!.toJson(),
        )
        .toList();
    return {
      "id": id,
      "title": title,
      "description": description,
      "users": listOfUsers
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
