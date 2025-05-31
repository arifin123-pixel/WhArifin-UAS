import 'message_model.dart';

class DosenModel {
  final int id;
  final String fullName;
  final String avatar;
  final List<MessageModel> messages;

  DosenModel({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.messages,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) => DosenModel(
    id: json['id'],
    fullName: json['full_name'],
    avatar: json['avatar'],
    messages: (json['messages'] as List)
        .map((msg) => MessageModel.fromJson(msg))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'avatar': avatar,
    'messages': messages.map((msg) => msg.toJson()).toList(),
  };
}
