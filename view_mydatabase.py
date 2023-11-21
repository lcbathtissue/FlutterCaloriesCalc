import sqlite3

# Connect to the database
conn = sqlite3.connect('FlutterCaloriesCalc_db.sqlite')

# Create a cursor object
cursor = conn.cursor()

# Execute SQL queries and print results for foods table
cursor.execute('SELECT * FROM foods')
print("Data in 'foods' table:")
print("(id INTEGER, name TEXT, calories INTEGER)")
for row in cursor.fetchall():
    print(row)

# Execute SQL queries and print results for meal_plan table 
cursor.execute('SELECT * FROM meal_plan')
print("\nData in 'meal_plan' table:")
print("(id INTEGER, date TEXT)")
for row in cursor.fetchall():
    print(row)

# Execute SQL queries and print results for meal_plan_food_items table
cursor.execute('SELECT * FROM meal_plan_food_items')
print("\nData in 'meal_plan_food_items' table:")
print("(id INTEGER, meal_plan_id INTEGER, food_id INTEGER")
for row in cursor.fetchall():
    print(row)

# Execute SQL queries and print results for addresses table
cursor.execute('SELECT * FROM addresses')
print("\nData in 'addresses' table:")
print("(id INTEGER, address TEXT)")
for row in cursor.fetchall():
    print(row)

# Close the cursor and connection
cursor.close()
conn.close()
