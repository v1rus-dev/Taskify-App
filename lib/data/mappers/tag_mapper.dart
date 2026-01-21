import 'package:drift/drift.dart';
import 'package:flutter/painting.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/domain/entities/tag.dart';

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
