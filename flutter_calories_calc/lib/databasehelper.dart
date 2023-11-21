import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;


class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async {
    bool databaseExists = await checkDatabaseExists();
    if (!databaseExists) {
      await _createDatabase();
      await insertInitialData();
    }
  }

  Future<bool> checkDatabaseExists() async {
    String path = join(await getDatabasesPath(), 'FlutterCaloriesCalc_db.sqlite');
    return databaseFactory.databaseExists(path);
  }

  Future<void> _createDatabase() async {
    String path = join(await getDatabasesPath(), 'FlutterCaloriesCalc_db.sqlite');
    _database = await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> insertInitialData() async {
    await insertFoodsFromFile();
    await insertAddressesFromFile();
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
        date TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE meal_plan_food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_plan_id INTEGER,
        food_id INTEGER,
        FOREIGN KEY (meal_plan_id) REFERENCES meal_plan(id),
        FOREIGN KEY (food_id) REFERENCES foods(id)
      );
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

  // function to insert a food item in the 'meal_plan_food_items' table
  Future<int> insertMealPlanFoodItem(Map<String, dynamic> mealPlanFoodItem) async {
    Database db = await database;
    return await db.insert('meal_plan_food_items', mealPlanFoodItem);
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

  Future<void> insertFoodsFromFile() async {
    try {
      String foodsData = await rootBundle.loadString('foods');
      List<String> foodsList = foodsData.split('\n');

      Database db = await database;
      Batch batch = db.batch();

      for (String foodLine in foodsList) {
        List<String> foodInfo = foodLine.split('    '); // Split by your delineator
        String name = foodInfo[0].trim();
        int calories = int.tryParse(foodInfo[1].trim()) ?? 0; // Parse calories as int

        batch.insert('foods', {'name': name, 'calories': calories});
      }

      await batch.commit();
      print('Foods inserted successfully.');
    } catch (e) {
      print('Error inserting foods: $e');
    }
  }

  Future<void> insertAddressesFromFile() async {
    try {
      String addresses = await rootBundle.loadString('addresses');
      List<String> addressList = addresses.split('\n');

      Database db = await database;
      Batch batch = db.batch();

      for (String address in addressList) {
        batch.insert('addresses', {'address': address});
      }

      await batch.commit();
      print('Addresses inserted successfully.');
    } catch (e) {
      print('Error inserting addresses: $e');
    }
  }

  Future<int> clearFoodsTable() async {
    Database db = await database;
    return await db.delete('foods');
  }

  Future<int> clearMealPlanTable() async {
    Database db = await database;
    return await db.delete('meal_plan');
  }

  Future<int> clearAddressesTable() async {
    Database db = await database;
    return await db.delete('addresses');
  }

  Future<void> clearAllTables() async {
    await clearFoodsTable();
    await clearMealPlanTable();
    await clearAddressesTable();
    print('All tables cleared.');
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'FlutterCaloriesCalc_db.sqlite');
    if (await databaseExists(path)) {
      Database? db = _database;
      if (db != null && db.isOpen) {
        await db.close();
      }
      await deleteDatabase(path);
      _database = null; // Reset the database reference after deletion
      print('Database file deleted successfully.');
    } else {
      print('Database file does not exist.');
    }
  }
}
