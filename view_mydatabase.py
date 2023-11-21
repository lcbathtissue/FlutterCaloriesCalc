import sqlite3

# Connect to the database
conn = sqlite3.connect('FlutterCaloriesCalc_db.sqlite')

# Create a cursor object
cursor = conn.cursor()

# Execute SQL queries and print results for foods table
cursor.execute('SELECT * FROM foods')
print("Data in 'foods' table:")
for row in cursor.fetchall():
    print(row)

# Execute SQL queries and print results for meal_plan table
cursor.execute('SELECT * FROM meal_plan')
print("\nData in 'meal_plan' table:")
for row in cursor.fetchall():
    print(row)

# Execute SQL queries and print results for addresses table
cursor.execute('SELECT * FROM addresses')
print("\nData in 'addresses' table:")
for row in cursor.fetchall():
    print(row)

# Close the cursor and connection
cursor.close()
conn.close()
