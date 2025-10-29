class AuditLog {
  final int? id;
  final String action;
  final String entityType;
  final int? entityId;
  final String? details;
  final DateTime createdAt;

  AuditLog({
    this.id,
    required this.action,
    required this.entityType,
    this.entityId,
    this.details,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'entity_type': entityType,
      'entity_id': entityId,
      'details': details,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AuditLog.fromMap(Map<String, dynamic> map) {
    return AuditLog(
      id: map['id'] as int?,
      action: map['action'] as String,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as int?,
      details: map['details'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
