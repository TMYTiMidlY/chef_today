import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  int id;

  String text;
  String imgPath;
  String? owner;

  /// Note: Stored in milliseconds without time zone info.
  @Property(type: PropertyType.date)
  DateTime date;

  Note(
      {required this.text,
      required this.imgPath,
      this.owner,
      this.id = 0,
      DateTime? date})
      : date = date ?? DateTime.now();
}
