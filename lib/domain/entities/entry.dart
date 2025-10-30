class Entry {
  final int? id;
  final int customerId;
  final EntryType type;
  final double amount;
  final String? description;
  final DateTime date;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Entry({
    this.id,
    required this.customerId,
    required this.type,
    required this.amount,
    this.description,
    DateTime? date,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : date = date ?? DateTime.now(),
        tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'type': type.name,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'tags': tags.join(','),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'] as int?,
      customerId: map['customer_id'] as int,
      type: EntryType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => EntryType.debit,
      ),
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] as String?,
      date: DateTime.parse(map['date'] as String),
      tags: (map['tags'] as String?)
              ?.split(',')
              .where((t) => t.isNotEmpty)
              .toList() ??
          [],
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Entry copyWith({
    int? id,
    int? customerId,
    EntryType? type,
    double? amount,
    String? description,
    DateTime? date,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Entry(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum EntryType {
  credit,
  debit,
}
