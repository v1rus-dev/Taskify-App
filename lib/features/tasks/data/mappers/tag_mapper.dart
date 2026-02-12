import 'package:drift/drift.dart';
import 'package:flutter/painting.dart';
import 'package:taskify/core/database/app_database.dart' as db;
import 'package:taskify/features/tasks/domain/models/tag.dart';

extension CustomTagDbMapper on db.CustomTagsTableData {
  CustomTagEntity toDomain() {
    return CustomTagEntity(
      id: id,
      title: title,
      color: Color(colorValue),
    );
  }
}

extension CustomTagDomainMapper on CustomTagEntity {
  db.CustomTagsTableCompanion toInsertCompanion() {

    return db.CustomTagsTableCompanion(
      title: Value(title),
      colorValue: Value(color.toARGB32()),
    );
  }
}

