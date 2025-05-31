class Rank {
  int? id;
  String? name;
  String? description;
  bool? status;

  // Constructor
  Rank({
    this.id,
    this.name,
    this.description,
    this.status,
  });

  // Chuyển từ Map sang đối tượng Rank
  factory Rank.fromMap(Map<String, dynamic> map) {
    return Rank(
      id: map['id'] as int?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      status: map['status'] as bool?,
    );
  }

  // Chuyển từ đối tượng Rank sang Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
    };
  }
}
