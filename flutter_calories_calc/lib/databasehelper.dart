import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async {
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'FlutterCaloriesCalc_db.sqlite');
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        calories INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE meal_plan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_id INTEGER,
        date TEXT,
        FOREIGN KEY (food_id) REFERENCES foods(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        address TEXT
      )
    ''');
  }

  // CRUD operations for the 'foods' table
  Future<int> insertFood(Map<String, dynamic> food) async {
    Database db = await database;
    return await db.insert('foods', food);
  }

  Future<List<Map<String, dynamic>>> getFoods() async {
    Database db = await database;
    return await db.query('foods');
  }

  Future<int> updateFood(Map<String, dynamic> food) async {
    Database db = await database;
    return await db.update('foods', food,
        where: 'id = ?', whereArgs: [food['id']]);
  }

  Future<int> deleteFood(int id) async {
    Database db = await database;
    return await db.delete('foods', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for the 'meal_plan' table
  Future<int> insertMealPlan(Map<String, dynamic> mealPlan) async {
    Database db = await database;
    return await db.insert('meal_plan', mealPlan);
  }

  Future<List<Map<String, dynamic>>> getMealPlans() async {
    Database db = await database;
    return await db.query('meal_plan');
  }

  Future<int> updateMealPlan(Map<String, dynamic> mealPlan) async {
    Database db = await database;
    return await db.update('meal_plan', mealPlan,
        where: 'id = ?', whereArgs: [mealPlan['id']]);
  }

  Future<int> deleteMealPlan(int id) async {
    Database db = await database;
    return await db.delete('meal_plan', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for the 'addresses' table
  Future<int> insertAddress(Map<String, dynamic> address) async {
    Database db = await database;
    return await db.insert('addresses', address);
  }

  Future<List<Map<String, dynamic>>> getAddresses() async {
    Database db = await database;
    return await db.query('addresses');
  }

  Future<int> updateAddress(Map<String, dynamic> address) async {
    Database db = await database;
    return await db.update('addresses', address,
        where: 'id = ?', whereArgs: [address['id']]);
  }

  Future<int> deleteAddress(int id) async {
    Database db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }


  Future<void> insertAddressesFromFile() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File file = File('${appDocDir.path}/addresses.txt');

      if (await file.exists()) {
        List<String> addresses = await file.readAsLines();

        Database db = await database;
        Batch batch = db.batch();

        for (String address in addresses) {
          batch.insert('addresses', {'address': address});
        }

        await batch.commit();
        print('Addresses inserted successfully.');
      } else {
        print('File not found.');
      }
    } catch (e) {
      print('Error inserting addresses: $e');
    }
  }


}
