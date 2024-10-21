import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'model.dart';
import 'package:chef_today/objectbox.g.dart'; // created by `dart run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<Note> _noteBox;

  ObjectBox._create(this._store) {
    _noteBox = Box<Note>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.

    // Note: set macosApplicationGroup for sandboxed macOS applications, see the
    // info boxes at https://docs.objectbox.io/getting-started for details.

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
        directory:
            path.join((await getApplicationDocumentsDirectory()).path, 'obx'),
        macosApplicationGroup: 'objectbox');
    return ObjectBox._create(store);
  }

  bool isEmpty() {
    return _noteBox.isEmpty();
  }

  void putDemoData() async {
    final directory =
        path.join((await getApplicationDocumentsDirectory()).path, 'demo');
    final demoNotes = [
      Note(
          text: '咖喱鸡', imgPath: path.join(directory, '1.png'), owner: 'myself'),
      Note(text: '酸菜鱼', imgPath: path.join(directory, '2.png')),
      Note(text: '鱼香肉丝', imgPath: path.join(directory, '3.png')),
      Note(text: '锅包肉', imgPath: path.join(directory, '4.png')),
      Note(text: '麻婆豆腐', imgPath: path.join(directory, '5.png')),
      Note(text: '漏奶华', imgPath: path.join(directory, '6.png')),
      Note(text: '红烧肉', imgPath: path.join(directory, '7.png')),
      Note(text: '可乐鸡翅', imgPath: path.join(directory, '8.png')),
      Note(text: '糖醋排骨', imgPath: path.join(directory, '9.png')),
      Note(text: '地三鲜', imgPath: path.join(directory, '10.png')),
      Note(text: '拔丝土豆', imgPath: path.join(directory, '11.png')),
      Note(text: '板栗烧鸡', imgPath: path.join(directory, '12.png')),
    ];
    _noteBox.putMany(demoNotes);
  }

  List<Note> getNotes() {
    // Query for all notes, sorted by their date in descending order.
    final builder = _noteBox.query().order(Note_.date, flags: Order.descending);

    // Build the query and retrieve the results synchronously.
    final query = builder.build();
    final notes = query.find();

    // Don't forget to close the query when done to free resources.
    query.close();

    return notes;
  }

  int getNotesCount() => _noteBox.count();

  void deleteNoteById(int id) => _noteBox.remove(id);

  List<Note> getMyNotes() {
    // Query for notes where the owner is 'myself', sorted by their date in descending order.
    final builder = _noteBox
        .query(Note_.owner.equals('myself')) // 添加 owner 条件
        .order(Note_.date, flags: Order.descending);

    // Build the query and retrieve the results synchronously.
    final query = builder.build();
    final notes = query.find();

    // Don't forget to close the query when done to free resources.
    query.close();

    return notes;
  }

  int getMyNotesCount() {
    // Query for notes where the owner is 'myself', sorted by their date in descending order.
    final builder = _noteBox
        .query(Note_.owner.equals('myself')) // 添加 owner 条件
        .order(Note_.date, flags: Order.descending);

    // Build the query and retrieve the results synchronously.
    final query = builder.build();
    final count = query.count();

    // Don't forget to close the query when done to free resources.
    query.close();

    return count;
  }

  /// Add a note.
  ///
  /// To avoid frame drops, run ObjectBox operations that take longer than a
  /// few milliseconds, e.g. putting many objects, asynchronously.
  /// For this example only a single object is put which would also be fine if
  /// done using [Box.put].
  addNote(String text, String imgPath) =>
      _noteBox.put(Note(text: text, imgPath: imgPath, owner: 'myself'));

  removeNote(int id) => _noteBox.remove(id);
}
