// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_database.dart';

// ignore_for_file: type=lint
class $DbUsersTable extends DbUsers with TableInfo<$DbUsersTable, DbUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, passwordHash, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_users';
  @override
  VerificationContext validateIntegrity(Insertable<DbUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DbUsersTable createAlias(String alias) {
    return $DbUsersTable(attachedDatabase, alias);
  }
}

class DbUser extends DataClass implements Insertable<DbUser> {
  final int id;
  final String username;
  final String passwordHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DbUser(
      {required this.id,
      required this.username,
      required this.passwordHash,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DbUsersCompanion toCompanion(bool nullToAbsent) {
    return DbUsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbUser(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DbUser copyWith(
          {int? id,
          String? username,
          String? passwordHash,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DbUser(
        id: id ?? this.id,
        username: username ?? this.username,
        passwordHash: passwordHash ?? this.passwordHash,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DbUser copyWithCompanion(DbUsersCompanion data) {
    return DbUser(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbUser(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, passwordHash, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbUser &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DbUsersCompanion extends UpdateCompanion<DbUser> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DbUsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DbUsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String passwordHash,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : username = Value(username),
        passwordHash = Value(passwordHash);
  static Insertable<DbUser> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DbUsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? passwordHash,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DbUsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbUsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DbCustomersTable extends DbCustomers
    with TableInfo<$DbCustomersTable, DbCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, phone, address, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_customers';
  @override
  VerificationContext validateIntegrity(Insertable<DbCustomer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCustomer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DbCustomersTable createAlias(String alias) {
    return $DbCustomersTable(attachedDatabase, alias);
  }
}

class DbCustomer extends DataClass implements Insertable<DbCustomer> {
  final int id;
  final String name;
  final String? phone;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DbCustomer(
      {required this.id,
      required this.name,
      this.phone,
      this.address,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DbCustomersCompanion toCompanion(bool nullToAbsent) {
    return DbCustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbCustomer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCustomer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DbCustomer copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DbCustomer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DbCustomer copyWithCompanion(DbCustomersCompanion data) {
    return DbCustomer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCustomer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, address, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCustomer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DbCustomersCompanion extends UpdateCompanion<DbCustomer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DbCustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DbCustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DbCustomer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DbCustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? address,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DbCustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DbEntriesTable extends DbEntries
    with TableInfo<$DbEntriesTable, DbEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES db_customers (id) ON DELETE CASCADE'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerId,
        type,
        amount,
        description,
        date,
        tags,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DbEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DbEntriesTable createAlias(String alias) {
    return $DbEntriesTable(attachedDatabase, alias);
  }
}

class DbEntry extends DataClass implements Insertable<DbEntry> {
  final int id;
  final int customerId;
  final String type;
  final double amount;
  final String? description;
  final DateTime date;
  final String? tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DbEntry(
      {required this.id,
      required this.customerId,
      required this.type,
      required this.amount,
      this.description,
      required this.date,
      this.tags,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<int>(customerId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DbEntriesCompanion toCompanion(bool nullToAbsent) {
    return DbEntriesCompanion(
      id: Value(id),
      customerId: Value(customerId),
      type: Value(type),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbEntry(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int>(json['customerId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int>(customerId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<DateTime>(date),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DbEntry copyWith(
          {int? id,
          int? customerId,
          String? type,
          double? amount,
          Value<String?> description = const Value.absent(),
          DateTime? date,
          Value<String?> tags = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DbEntry(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        description: description.present ? description.value : this.description,
        date: date ?? this.date,
        tags: tags.present ? tags.value : this.tags,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DbEntry copyWithCompanion(DbEntriesCompanion data) {
    return DbEntry(
      id: data.id.present ? data.id.value : this.id,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      date: data.date.present ? data.date.value : this.date,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbEntry(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customerId, type, amount, description,
      date, tags, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbEntry &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.date == this.date &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DbEntriesCompanion extends UpdateCompanion<DbEntry> {
  final Value<int> id;
  final Value<int> customerId;
  final Value<String> type;
  final Value<double> amount;
  final Value<String?> description;
  final Value<DateTime> date;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DbEntriesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DbEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int customerId,
    required String type,
    required double amount,
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : customerId = Value(customerId),
        type = Value(type),
        amount = Value(amount);
  static Insertable<DbEntry> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DbEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? customerId,
      Value<String>? type,
      Value<double>? amount,
      Value<String?>? description,
      Value<DateTime>? date,
      Value<String?>? tags,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DbEntriesCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbEntriesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DbTagsTable extends DbTags with TableInfo<$DbTagsTable, DbTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_tags';
  @override
  VerificationContext validateIntegrity(Insertable<DbTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DbTagsTable createAlias(String alias) {
    return $DbTagsTable(attachedDatabase, alias);
  }
}

class DbTag extends DataClass implements Insertable<DbTag> {
  final int id;
  final String name;
  final String? color;
  final DateTime createdAt;
  const DbTag(
      {required this.id,
      required this.name,
      this.color,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DbTagsCompanion toCompanion(bool nullToAbsent) {
    return DbTagsCompanion(
      id: Value(id),
      name: Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory DbTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbTag copyWith(
          {int? id,
          String? name,
          Value<String?> color = const Value.absent(),
          DateTime? createdAt}) =>
      DbTag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color.present ? color.value : this.color,
        createdAt: createdAt ?? this.createdAt,
      );
  DbTag copyWithCompanion(DbTagsCompanion data) {
    return DbTag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class DbTagsCompanion extends UpdateCompanion<DbTag> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<DateTime> createdAt;
  const DbTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DbTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DbTag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DbTagsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? color,
      Value<DateTime>? createdAt}) {
    return DbTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DbRemindersTable extends DbReminders
    with TableInfo<$DbRemindersTable, DbReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES db_customers (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, customerId, title, description, dueDate, isCompleted, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_reminders';
  @override
  VerificationContext validateIntegrity(Insertable<DbReminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbReminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DbRemindersTable createAlias(String alias) {
    return $DbRemindersTable(attachedDatabase, alias);
  }
}

class DbReminder extends DataClass implements Insertable<DbReminder> {
  final int id;
  final int customerId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime createdAt;
  const DbReminder(
      {required this.id,
      required this.customerId,
      required this.title,
      this.description,
      required this.dueDate,
      required this.isCompleted,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<int>(customerId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DbRemindersCompanion toCompanion(bool nullToAbsent) {
    return DbRemindersCompanion(
      id: Value(id),
      customerId: Value(customerId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: Value(dueDate),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory DbReminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbReminder(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int>(json['customerId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int>(customerId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbReminder copyWith(
          {int? id,
          int? customerId,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? dueDate,
          bool? isCompleted,
          DateTime? createdAt}) =>
      DbReminder(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        dueDate: dueDate ?? this.dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
      );
  DbReminder copyWithCompanion(DbRemindersCompanion data) {
    return DbReminder(
      id: data.id.present ? data.id.value : this.id,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbReminder(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, customerId, title, description, dueDate, isCompleted, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbReminder &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt);
}

class DbRemindersCompanion extends UpdateCompanion<DbReminder> {
  final Value<int> id;
  final Value<int> customerId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> dueDate;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  const DbRemindersCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DbRemindersCompanion.insert({
    this.id = const Value.absent(),
    required int customerId,
    required String title,
    this.description = const Value.absent(),
    required DateTime dueDate,
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : customerId = Value(customerId),
        title = Value(title),
        dueDate = Value(dueDate);
  static Insertable<DbReminder> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DbRemindersCompanion copyWith(
      {Value<int>? id,
      Value<int>? customerId,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? dueDate,
      Value<bool>? isCompleted,
      Value<DateTime>? createdAt}) {
    return DbRemindersCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbRemindersCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DbAuditLogsTable extends DbAuditLogs
    with TableInfo<$DbAuditLogsTable, DbAuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbAuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, action, entityType, entityId, details, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<DbAuditLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbAuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbAuditLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id']),
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DbAuditLogsTable createAlias(String alias) {
    return $DbAuditLogsTable(attachedDatabase, alias);
  }
}

class DbAuditLog extends DataClass implements Insertable<DbAuditLog> {
  final int id;
  final String action;
  final String entityType;
  final int? entityId;
  final String? details;
  final DateTime createdAt;
  const DbAuditLog(
      {required this.id,
      required this.action,
      required this.entityType,
      this.entityId,
      this.details,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<int>(entityId);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DbAuditLogsCompanion toCompanion(bool nullToAbsent) {
    return DbAuditLogsCompanion(
      id: Value(id),
      action: Value(action),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory DbAuditLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbAuditLog(
      id: serializer.fromJson<int>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int?>(json['entityId']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int?>(entityId),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbAuditLog copyWith(
          {int? id,
          String? action,
          String? entityType,
          Value<int?> entityId = const Value.absent(),
          Value<String?> details = const Value.absent(),
          DateTime? createdAt}) =>
      DbAuditLog(
        id: id ?? this.id,
        action: action ?? this.action,
        entityType: entityType ?? this.entityType,
        entityId: entityId.present ? entityId.value : this.entityId,
        details: details.present ? details.value : this.details,
        createdAt: createdAt ?? this.createdAt,
      );
  DbAuditLog copyWithCompanion(DbAuditLogsCompanion data) {
    return DbAuditLog(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbAuditLog(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, action, entityType, entityId, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbAuditLog &&
          other.id == this.id &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class DbAuditLogsCompanion extends UpdateCompanion<DbAuditLog> {
  final Value<int> id;
  final Value<String> action;
  final Value<String> entityType;
  final Value<int?> entityId;
  final Value<String?> details;
  final Value<DateTime> createdAt;
  const DbAuditLogsCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DbAuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required String action,
    required String entityType,
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : action = Value(action),
        entityType = Value(entityType);
  static Insertable<DbAuditLog> custom({
    Expression<int>? id,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? details,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DbAuditLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? action,
      Value<String>? entityType,
      Value<int?>? entityId,
      Value<String?>? details,
      Value<DateTime>? createdAt}) {
    return DbAuditLogsCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbAuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$LedgerDatabase extends GeneratedDatabase {
  _$LedgerDatabase(QueryExecutor e) : super(e);
  $LedgerDatabaseManager get managers => $LedgerDatabaseManager(this);
  late final $DbUsersTable dbUsers = $DbUsersTable(this);
  late final $DbCustomersTable dbCustomers = $DbCustomersTable(this);
  late final $DbEntriesTable dbEntries = $DbEntriesTable(this);
  late final $DbTagsTable dbTags = $DbTagsTable(this);
  late final $DbRemindersTable dbReminders = $DbRemindersTable(this);
  late final $DbAuditLogsTable dbAuditLogs = $DbAuditLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dbUsers, dbCustomers, dbEntries, dbTags, dbReminders, dbAuditLogs];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('db_customers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('db_entries', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('db_customers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('db_reminders', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$DbUsersTableCreateCompanionBuilder = DbUsersCompanion Function({
  Value<int> id,
  required String username,
  required String passwordHash,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DbUsersTableUpdateCompanionBuilder = DbUsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> passwordHash,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$DbUsersTableFilterComposer
    extends Composer<_$LedgerDatabase, $DbUsersTable> {
  $$DbUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DbUsersTableOrderingComposer
    extends Composer<_$LedgerDatabase, $DbUsersTable> {
  $$DbUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DbUsersTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $DbUsersTable> {
  $$DbUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DbUsersTableTableManager extends RootTableManager<
    _$LedgerDatabase,
    $DbUsersTable,
    DbUser,
    $$DbUsersTableFilterComposer,
    $$DbUsersTableOrderingComposer,
    $$DbUsersTableAnnotationComposer,
    $$DbUsersTableCreateCompanionBuilder,
    $$DbUsersTableUpdateCompanionBuilder,
    (DbUser, BaseReferences<_$LedgerDatabase, $DbUsersTable, DbUser>),
    DbUser,
    PrefetchHooks Function()> {
  $$DbUsersTableTableManager(_$LedgerDatabase db, $DbUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DbUsersCompanion(
            id: id,
            username: username,
            passwordHash: passwordHash,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String passwordHash,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DbUsersCompanion.insert(
            id: id,
            username: username,
            passwordHash: passwordHash,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbUsersTableProcessedTableManager = ProcessedTableManager<
    _$LedgerDatabase,
    $DbUsersTable,
    DbUser,
    $$DbUsersTableFilterComposer,
    $$DbUsersTableOrderingComposer,
    $$DbUsersTableAnnotationComposer,
    $$DbUsersTableCreateCompanionBuilder,
    $$DbUsersTableUpdateCompanionBuilder,
    (DbUser, BaseReferences<_$LedgerDatabase, $DbUsersTable, DbUser>),
    DbUser,
    PrefetchHooks Function()>;
typedef $$DbCustomersTableCreateCompanionBuilder = DbCustomersCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DbCustomersTableUpdateCompanionBuilder = DbCustomersCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$DbCustomersTableReferences
    extends BaseReferences<_$LedgerDatabase, $DbCustomersTable, DbCustomer> {
  $$DbCustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DbEntriesTable, List<DbEntry>>
      _dbEntriesRefsTable(_$LedgerDatabase db) => MultiTypedResultKey.fromTable(
          db.dbEntries,
          aliasName:
              $_aliasNameGenerator(db.dbCustomers.id, db.dbEntries.customerId));

  $$DbEntriesTableProcessedTableManager get dbEntriesRefs {
    final manager = $$DbEntriesTableTableManager($_db, $_db.dbEntries)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dbEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DbRemindersTable, List<DbReminder>>
      _dbRemindersRefsTable(_$LedgerDatabase db) =>
          MultiTypedResultKey.fromTable(db.dbReminders,
              aliasName: $_aliasNameGenerator(
                  db.dbCustomers.id, db.dbReminders.customerId));

  $$DbRemindersTableProcessedTableManager get dbRemindersRefs {
    final manager = $$DbRemindersTableTableManager($_db, $_db.dbReminders)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dbRemindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DbCustomersTableFilterComposer
    extends Composer<_$LedgerDatabase, $DbCustomersTable> {
  $$DbCustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> dbEntriesRefs(
      Expression<bool> Function($$DbEntriesTableFilterComposer f) f) {
    final $$DbEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dbEntries,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbEntriesTableFilterComposer(
              $db: $db,
              $table: $db.dbEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dbRemindersRefs(
      Expression<bool> Function($$DbRemindersTableFilterComposer f) f) {
    final $$DbRemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dbReminders,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbRemindersTableFilterComposer(
              $db: $db,
              $table: $db.dbReminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DbCustomersTableOrderingComposer
    extends Composer<_$LedgerDatabase, $DbCustomersTable> {
  $$DbCustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DbCustomersTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $DbCustomersTable> {
  $$DbCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> dbEntriesRefs<T extends Object>(
      Expression<T> Function($$DbEntriesTableAnnotationComposer a) f) {
    final $$DbEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dbEntries,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.dbEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> dbRemindersRefs<T extends Object>(
      Expression<T> Function($$DbRemindersTableAnnotationComposer a) f) {
    final $$DbRemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dbReminders,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbRemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.dbReminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DbCustomersTableTableManager extends RootTableManager<
    _$LedgerDatabase,
    $DbCustomersTable,
    DbCustomer,
    $$DbCustomersTableFilterComposer,
    $$DbCustomersTableOrderingComposer,
    $$DbCustomersTableAnnotationComposer,
    $$DbCustomersTableCreateCompanionBuilder,
    $$DbCustomersTableUpdateCompanionBuilder,
    (DbCustomer, $$DbCustomersTableReferences),
    DbCustomer,
    PrefetchHooks Function({bool dbEntriesRefs, bool dbRemindersRefs})> {
  $$DbCustomersTableTableManager(_$LedgerDatabase db, $DbCustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DbCustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            address: address,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DbCustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            address: address,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DbCustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {dbEntriesRefs = false, dbRemindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dbEntriesRefs) db.dbEntries,
                if (dbRemindersRefs) db.dbReminders
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dbEntriesRefs)
                    await $_getPrefetchedData<DbCustomer, $DbCustomersTable,
                            DbEntry>(
                        currentTable: table,
                        referencedTable: $$DbCustomersTableReferences
                            ._dbEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DbCustomersTableReferences(db, table, p0)
                                .dbEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items),
                  if (dbRemindersRefs)
                    await $_getPrefetchedData<DbCustomer, $DbCustomersTable,
                            DbReminder>(
                        currentTable: table,
                        referencedTable: $$DbCustomersTableReferences
                            ._dbRemindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DbCustomersTableReferences(db, table, p0)
                                .dbRemindersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DbCustomersTableProcessedTableManager = ProcessedTableManager<
    _$LedgerDatabase,
    $DbCustomersTable,
    DbCustomer,
    $$DbCustomersTableFilterComposer,
    $$DbCustomersTableOrderingComposer,
    $$DbCustomersTableAnnotationComposer,
    $$DbCustomersTableCreateCompanionBuilder,
    $$DbCustomersTableUpdateCompanionBuilder,
    (DbCustomer, $$DbCustomersTableReferences),
    DbCustomer,
    PrefetchHooks Function({bool dbEntriesRefs, bool dbRemindersRefs})>;
typedef $$DbEntriesTableCreateCompanionBuilder = DbEntriesCompanion Function({
  Value<int> id,
  required int customerId,
  required String type,
  required double amount,
  Value<String?> description,
  Value<DateTime> date,
  Value<String?> tags,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DbEntriesTableUpdateCompanionBuilder = DbEntriesCompanion Function({
  Value<int> id,
  Value<int> customerId,
  Value<String> type,
  Value<double> amount,
  Value<String?> description,
  Value<DateTime> date,
  Value<String?> tags,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$DbEntriesTableReferences
    extends BaseReferences<_$LedgerDatabase, $DbEntriesTable, DbEntry> {
  $$DbEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DbCustomersTable _customerIdTable(_$LedgerDatabase db) =>
      db.dbCustomers.createAlias(
          $_aliasNameGenerator(db.dbEntries.customerId, db.dbCustomers.id));

  $$DbCustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$DbCustomersTableTableManager($_db, $_db.dbCustomers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DbEntriesTableFilterComposer
    extends Composer<_$LedgerDatabase, $DbEntriesTable> {
  $$DbEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DbCustomersTableFilterComposer get customerId {
    final $$DbCustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.dbCustomers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbCustomersTableFilterComposer(
              $db: $db,
              $table: $db.dbCustomers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbEntriesTableOrderingComposer
    extends Composer<_$LedgerDatabase, $DbEntriesTable> {
  $$DbEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DbCustomersTableOrderingComposer get customerId {
    final $$DbCustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.dbCustomers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbCustomersTableOrderingComposer(
              $db: $db,
              $table: $db.dbCustomers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbEntriesTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $DbEntriesTable> {
  $$DbEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DbCustomersTableAnnotationComposer get customerId {
    final $$DbCustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.dbCustomers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbCustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.dbCustomers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbEntriesTableTableManager extends RootTableManager<
    _$LedgerDatabase,
    $DbEntriesTable,
    DbEntry,
    $$DbEntriesTableFilterComposer,
    $$DbEntriesTableOrderingComposer,
    $$DbEntriesTableAnnotationComposer,
    $$DbEntriesTableCreateCompanionBuilder,
    $$DbEntriesTableUpdateCompanionBuilder,
    (DbEntry, $$DbEntriesTableReferences),
    DbEntry,
    PrefetchHooks Function({bool customerId})> {
  $$DbEntriesTableTableManager(_$LedgerDatabase db, $DbEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DbEntriesCompanion(
            id: id,
            customerId: customerId,
            type: type,
            amount: amount,
            description: description,
            date: date,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int customerId,
            required String type,
            required double amount,
            Value<String?> description = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DbEntriesCompanion.insert(
            id: id,
            customerId: customerId,
            type: type,
            amount: amount,
            description: description,
            date: date,
            tags: tags,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DbEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$DbEntriesTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$DbEntriesTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DbEntriesTableProcessedTableManager = ProcessedTableManager<
    _$LedgerDatabase,
    $DbEntriesTable,
    DbEntry,
    $$DbEntriesTableFilterComposer,
    $$DbEntriesTableOrderingComposer,
    $$DbEntriesTableAnnotationComposer,
    $$DbEntriesTableCreateCompanionBuilder,
    $$DbEntriesTableUpdateCompanionBuilder,
    (DbEntry, $$DbEntriesTableReferences),
    DbEntry,
    PrefetchHooks Function({bool customerId})>;
typedef $$DbTagsTableCreateCompanionBuilder = DbTagsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> color,
  Value<DateTime> createdAt,
});
typedef $$DbTagsTableUpdateCompanionBuilder = DbTagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> color,
  Value<DateTime> createdAt,
});

class $$DbTagsTableFilterComposer
    extends Composer<_$LedgerDatabase, $DbTagsTable> {
  $$DbTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DbTagsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $DbTagsTable> {
  $$DbTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DbTagsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $DbTagsTable> {
  $$DbTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DbTagsTableTableManager extends RootTableManager<
    _$LedgerDatabase,
    $DbTagsTable,
    DbTag,
    $$DbTagsTableFilterComposer,
    $$DbTagsTableOrderingComposer,
    $$DbTagsTableAnnotationComposer,
    $$DbTagsTableCreateCompanionBuilder,
    $$DbTagsTableUpdateCompanionBuilder,
    (DbTag, BaseReferences<_$LedgerDatabase, $DbTagsTable, DbTag>),
    DbTag,
    PrefetchHooks Function()> {
  $$DbTagsTableTableManager(_$LedgerDatabase db, $DbTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbTagsCompanion(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbTagsCompanion.insert(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbTagsTableProcessedTableManager = ProcessedTableManager<
    _$LedgerDatabase,
    $DbTagsTable,
    DbTag,
    $$DbTagsTableFilterComposer,
    $$DbTagsTableOrderingComposer,
    $$DbTagsTableAnnotationComposer,
    $$DbTagsTableCreateCompanionBuilder,
    $$DbTagsTableUpdateCompanionBuilder,
    (DbTag, BaseReferences<_$LedgerDatabase, $DbTagsTable, DbTag>),
    DbTag,
    PrefetchHooks Function()>;
typedef $$DbRemindersTableCreateCompanionBuilder = DbRemindersCompanion
    Function({
  Value<int> id,
  required int customerId,
  required String title,
  Value<String?> description,
  required DateTime dueDate,
  Value<bool> isCompleted,
  Value<DateTime> createdAt,
});
typedef $$DbRemindersTableUpdateCompanionBuilder = DbRemindersCompanion
    Function({
  Value<int> id,
  Value<int> customerId,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> dueDate,
  Value<bool> isCompleted,
  Value<DateTime> createdAt,
});

final class $$DbRemindersTableReferences
    extends BaseReferences<_$LedgerDatabase, $DbRemindersTable, DbReminder> {
  $$DbRemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DbCustomersTable _customerIdTable(_$LedgerDatabase db) =>
      db.dbCustomers.createAlias(
          $_aliasNameGenerator(db.dbReminders.customerId, db.dbCustomers.id));

  $$DbCustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$DbCustomersTableTableManager($_db, $_db.dbCustomers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DbRemindersTableFilterComposer
    extends Composer<_$LedgerDatabase, $DbRemindersTable> {
  $$DbRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$DbCustomersTableFilterComposer get customerId {
    final $$DbCustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.dbCustomers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbCustomersTableFilterComposer(
              $db: $db,
              $table: $db.dbCustomers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbRemindersTableOrderingComposer
    extends Composer<_$LedgerDatabase, $DbRemindersTable> {
  $$DbRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$DbCustomersTableOrderingComposer get customerId {
    final $$DbCustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.dbCustomers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbCustomersTableOrderingComposer(
              $db: $db,
              $table: $db.dbCustomers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbRemindersTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $DbRemindersTable> {
  $$DbRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DbCustomersTableAnnotationComposer get customerId {
    final $$DbCustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.dbCustomers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbCustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.dbCustomers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbRemindersTableTableManager extends RootTableManager<
    _$LedgerDatabase,
    $DbRemindersTable,
    DbReminder,
    $$DbRemindersTableFilterComposer,
    $$DbRemindersTableOrderingComposer,
    $$DbRemindersTableAnnotationComposer,
    $$DbRemindersTableCreateCompanionBuilder,
    $$DbRemindersTableUpdateCompanionBuilder,
    (DbReminder, $$DbRemindersTableReferences),
    DbReminder,
    PrefetchHooks Function({bool customerId})> {
  $$DbRemindersTableTableManager(_$LedgerDatabase db, $DbRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbRemindersCompanion(
            id: id,
            customerId: customerId,
            title: title,
            description: description,
            dueDate: dueDate,
            isCompleted: isCompleted,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int customerId,
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime dueDate,
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbRemindersCompanion.insert(
            id: id,
            customerId: customerId,
            title: title,
            description: description,
            dueDate: dueDate,
            isCompleted: isCompleted,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DbRemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$DbRemindersTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$DbRemindersTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DbRemindersTableProcessedTableManager = ProcessedTableManager<
    _$LedgerDatabase,
    $DbRemindersTable,
    DbReminder,
    $$DbRemindersTableFilterComposer,
    $$DbRemindersTableOrderingComposer,
    $$DbRemindersTableAnnotationComposer,
    $$DbRemindersTableCreateCompanionBuilder,
    $$DbRemindersTableUpdateCompanionBuilder,
    (DbReminder, $$DbRemindersTableReferences),
    DbReminder,
    PrefetchHooks Function({bool customerId})>;
typedef $$DbAuditLogsTableCreateCompanionBuilder = DbAuditLogsCompanion
    Function({
  Value<int> id,
  required String action,
  required String entityType,
  Value<int?> entityId,
  Value<String?> details,
  Value<DateTime> createdAt,
});
typedef $$DbAuditLogsTableUpdateCompanionBuilder = DbAuditLogsCompanion
    Function({
  Value<int> id,
  Value<String> action,
  Value<String> entityType,
  Value<int?> entityId,
  Value<String?> details,
  Value<DateTime> createdAt,
});

class $$DbAuditLogsTableFilterComposer
    extends Composer<_$LedgerDatabase, $DbAuditLogsTable> {
  $$DbAuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DbAuditLogsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $DbAuditLogsTable> {
  $$DbAuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DbAuditLogsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $DbAuditLogsTable> {
  $$DbAuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DbAuditLogsTableTableManager extends RootTableManager<
    _$LedgerDatabase,
    $DbAuditLogsTable,
    DbAuditLog,
    $$DbAuditLogsTableFilterComposer,
    $$DbAuditLogsTableOrderingComposer,
    $$DbAuditLogsTableAnnotationComposer,
    $$DbAuditLogsTableCreateCompanionBuilder,
    $$DbAuditLogsTableUpdateCompanionBuilder,
    (
      DbAuditLog,
      BaseReferences<_$LedgerDatabase, $DbAuditLogsTable, DbAuditLog>
    ),
    DbAuditLog,
    PrefetchHooks Function()> {
  $$DbAuditLogsTableTableManager(_$LedgerDatabase db, $DbAuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbAuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbAuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbAuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<int?> entityId = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbAuditLogsCompanion(
            id: id,
            action: action,
            entityType: entityType,
            entityId: entityId,
            details: details,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String action,
            required String entityType,
            Value<int?> entityId = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbAuditLogsCompanion.insert(
            id: id,
            action: action,
            entityType: entityType,
            entityId: entityId,
            details: details,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbAuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$LedgerDatabase,
    $DbAuditLogsTable,
    DbAuditLog,
    $$DbAuditLogsTableFilterComposer,
    $$DbAuditLogsTableOrderingComposer,
    $$DbAuditLogsTableAnnotationComposer,
    $$DbAuditLogsTableCreateCompanionBuilder,
    $$DbAuditLogsTableUpdateCompanionBuilder,
    (
      DbAuditLog,
      BaseReferences<_$LedgerDatabase, $DbAuditLogsTable, DbAuditLog>
    ),
    DbAuditLog,
    PrefetchHooks Function()>;

class $LedgerDatabaseManager {
  final _$LedgerDatabase _db;
  $LedgerDatabaseManager(this._db);
  $$DbUsersTableTableManager get dbUsers =>
      $$DbUsersTableTableManager(_db, _db.dbUsers);
  $$DbCustomersTableTableManager get dbCustomers =>
      $$DbCustomersTableTableManager(_db, _db.dbCustomers);
  $$DbEntriesTableTableManager get dbEntries =>
      $$DbEntriesTableTableManager(_db, _db.dbEntries);
  $$DbTagsTableTableManager get dbTags =>
      $$DbTagsTableTableManager(_db, _db.dbTags);
  $$DbRemindersTableTableManager get dbReminders =>
      $$DbRemindersTableTableManager(_db, _db.dbReminders);
  $$DbAuditLogsTableTableManager get dbAuditLogs =>
      $$DbAuditLogsTableTableManager(_db, _db.dbAuditLogs);
}
