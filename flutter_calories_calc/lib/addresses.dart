import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'reversegeocode.dart';


class AddressesPage extends StatefulWidget {
  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();
  List<Map<String, dynamic>> addresses = [];
  Map<String, dynamic> selectedAddress = {};
  ReverseGeocode reverseGeocode = ReverseGeocode(); // Initialize ReverseGeocode

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  void loadAddresses() async {
    final dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> addressList = await dbHelper.getAddresses();
    
    // Remove duplicates based on 'id'
    addressList = addressList.toSet().toList();

    setState(() {
      addresses = addressList;
      if (addressList.isNotEmpty) {
        selectedAddress = addressList[0];
        displayAddress(selectedAddress);
      }
    });
  }

  void displayAddress(Map<String, dynamic> address) {
    addressController.text = address['address'];
    idController.text = address['id'].toString();
  }

  void clearFields() {
    addressController.clear();
    idController.clear();
  }

  void addAddress() async {
    final dbHelper = DatabaseHelper();
    final newAddress = {'address': addressController.text};
    await dbHelper.insertAddress(newAddress);
    loadAddresses();
    clearFields();
  }

  void updateAddress() async {
    final dbHelper = DatabaseHelper();
    final updatedAddress = {
      'id': selectedAddress['id'],
      'address': addressController.text
    };
    await dbHelper.updateAddress(updatedAddress);
    loadAddresses();
    clearFields();
  }

  void deleteAddress() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteAddress(selectedAddress['id']);
    loadAddresses();
    clearFields();
  }

  void getLatLong() async {
    Map<String, double> latLong =
        await reverseGeocode.getLatLongFromAddress(addressController.text);
    setState(() {
      latController.text = latLong['latitude'].toString();
      longController.text = latLong['longitude'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<Map<String, dynamic>>(
              value: selectedAddress,
              items: addresses.map((address) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: address,
                  key: UniqueKey(),
                  child: Text(address['address']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAddress = value!;
                  displayAddress(selectedAddress);
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: clearFields,
                  child: Text('CLEAR'),
                ),
                ElevatedButton(
                  onPressed: addAddress,
                  child: Text('ADD'),
                ),
                ElevatedButton(
                  onPressed: updateAddress,
                  child: Text('UPDATE'),
                ),
                ElevatedButton(
                  onPressed: deleteAddress,
                  child: Text('DELETE'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getLatLong,
              child: Text('GEOCODE'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: latController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: longController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
