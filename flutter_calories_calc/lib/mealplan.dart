import 'package:flutter/material.dart';
import 'databasehelper.dart';

class MealPlan extends StatefulWidget {
  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  final TextEditingController targetCaloriesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List<Map<String, dynamic>> foodItems = [];
  List<bool> checkboxStates = []; 
  Color textColor = Colors.black;
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    targetCaloriesController.text = "200";
    dateController.text = _getFormattedDate(DateTime.now());
    _fetchFoodItems(); 
  }

  String _getFormattedDate(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  void _fetchFoodItems() async {
    List<Map<String, dynamic>> fetchedItems = await DatabaseHelper().getFoods();
    setState(() {
      foodItems = fetchedItems;
      checkboxStates = List.generate(fetchedItems.length, (index) => false); 
    });
  }

  void _updateTotalCalories() {
    int total = 0;
    int targetCalories = int.tryParse(targetCaloriesController.text) ?? 0; 
    for (int i = 0; i < foodItems.length; i++) {
      if (checkboxStates[i]) {
        total += foodItems[i]['calories'] as int;
      }
    }
    setState(() {
      totalCalories = total;
      textColor = (totalCalories <= targetCalories) ? Colors.black : Colors.red;
    });
  }

  int calculateTotalCalories() {
    int total = 0;
    for (int i = 0; i < foodItems.length; i++) {
      if (checkboxStates[i]) {
        total += foodItems[i]['calories'] as int;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            TextField(
              controller: targetCaloriesController,
              decoration: InputDecoration(
                labelText: 'Target Calories per Day',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            Text(
              'Total Calories: $totalCalories',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(foodItems[index]['name']),
                    value: checkboxStates[index],
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxStates[index] = value ?? false; 
                        _updateTotalCalories();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
