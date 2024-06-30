import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String? email;

  String? id;
  String? name;

  UserModel({this.email, this.id, this.name});

  UserModel.fromJson(Map<String, dynamic> json)
      : this(id: json["id"], email: json["email"], name: json["name"]);

  Map<String, dynamic> toJson() {
    return {"id": id, "email": email, "name": name};
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
