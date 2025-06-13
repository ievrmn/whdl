class Room {
  final String id;
  final String name;
  final List<String> members; // قائمة أيدي الأعضاء
  final DateTime createdAt;

  Room({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': members,
      'createdAt': createdAt.toUtc(),
    };
  }

  factory Room.fromMap(String id, Map<String, dynamic> map) {
    return Room(
      id: id,
      name: map['name'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}