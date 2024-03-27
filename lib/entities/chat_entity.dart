class ChatEntity {
  final String userId;
  final String username;
  final String chat;
  final int profileIndex;

  ChatEntity(
      {required this.userId, required this.username, required this.chat, required this.profileIndex});

  factory ChatEntity.fromMap(Map<String, dynamic> map) {
    return ChatEntity(
      userId: map['userId'],
      username: map['username'],
      chat: map['chat'],
      profileIndex: map['profileIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'chat': chat,
      'profileIndex': profileIndex,
    };
  }
}
