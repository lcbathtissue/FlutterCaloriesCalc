  Map<String, dynamic> newFood = {
    'name': 'Apple',
    'calories': 95,
  };
  int insertedId = await dbHelper.insertFood(newFood);
  print('Inserted ID: $insertedId');
  
  Map<String, dynamic> newNewFood = {
    'name': 'Golden Apple',
    'calories': 110,
  };
  insertedId = await dbHelper.insertFood(newNewFood);
  print('Inserted ID: $insertedId');

  List<Map<String, dynamic>> foods = await dbHelper.getFoods();
  print('All foods: $foods');

  Map<String, dynamic> updatedFood = {
    'id': 2, 
    'name': 'Bad Apple',
    'calories': 999,
  };
  int rowsAffected = await dbHelper.updateFood(updatedFood);
  print('Rows affected during update: $rowsAffected');

  int deletedId = 1; 
  int rowsDeleted = await dbHelper.deleteFood(deletedId);
  print('Rows deleted: $rowsDeleted');


  Map<String, dynamic> newMealPlan = {
    'food_id': 1, 
    'date': '2023-11-20', 
  };
  int insertedMealPlanId = await dbHelper.insertMealPlan(newMealPlan);
  print('Inserted Meal Plan ID: $insertedMealPlanId');

  Map<String, dynamic> newNewMealPlan = {
    'food_id': 2, 
    'date': '2023-12-01', 
  };
  insertedMealPlanId = await dbHelper.insertMealPlan(newNewMealPlan);
  print('Inserted Meal Plan ID: $insertedMealPlanId');

  List<Map<String, dynamic>> mealPlans = await dbHelper.getMealPlans();
  print('All Meal Plans: $mealPlans');

  Map<String, dynamic> updatedMealPlan = {
    'id': 2, 
    'food_id': 1, 
    'date': '2024-01-01', 
  };
  int rowsAffectedMealPlan = await dbHelper.updateMealPlan(updatedMealPlan);
  print('Rows affected during Meal Plan update: $rowsAffectedMealPlan');

  int deletedMealPlanId = 1; 
  int rowsDeletedMealPlan = await dbHelper.deleteMealPlan(deletedMealPlanId);
  print('Rows deleted in Meal Plan: $rowsDeletedMealPlan');


  Map<String, dynamic> newAddress = {
    'address': '123 Main St', 
  };
  int insertedAddressId = await dbHelper.insertAddress(newAddress);
  print('Inserted Address ID: $insertedAddressId');

  Map<String, dynamic> newNewAddress = {
    'address': '456 Test Rd', 
  };
  insertedAddressId = await dbHelper.insertAddress(newNewAddress);
  print('Inserted Address ID: $insertedAddressId');

  List<Map<String, dynamic>> addresses = await dbHelper.getAddresses();
  print('All Addresses: $addresses');

  Map<String, dynamic> updatedAddress = {
    'id': 3, 
    'address': '999 Suceess Cres', 
  };
  int rowsAffectedAddress = await dbHelper.updateAddress(updatedAddress);
  print('Rows affected during Address update: $rowsAffectedAddress');

  int deletedAddressId = 1; 
  int rowsDeletedAddress = await dbHelper.deleteAddress(deletedAddressId);
  print('Rows deleted in Address: $rowsDeletedAddress');