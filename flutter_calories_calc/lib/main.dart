import 'package:flutter/material.dart';
import 'databasehelper.dart'; 
import 'mealplan.dart';
import 'addresses.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.initDatabase(); 
  // await dbHelper.deleteDatabaseFile();  // for full reset of database
  // await dbHelper.clearAllTables();  // empties tables but they will not be re-initialized with data from files without full delete
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterCaloriesCalc App Navigation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                // Navigate to the MealPlan screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlan()),
                );
              },
              child: Text('MEAL PLANS'),
            ),

            SizedBox(height: 20), // Add spacing between buttons

            ElevatedButton(
              onPressed: () {
                // Navigate to the MealPlan screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressesPage()),
                );
              },
              child: Text('ADDRESSES'),
            ),

          ],
        ),
      ),
    );
  }
}
