import 'package:flutter/material.dart';

class BabyRegistryScreen extends StatefulWidget {
  @override
  _BabyRegistryScreenState createState() => _BabyRegistryScreenState();
}

class _BabyRegistryScreenState extends State<BabyRegistryScreen> {
  String? selectedLanguage;
  String? selectedGender;
  String? selectedVaccine;
  List<String> languages = ['English', 'Kiswahili', 'Arabic','Other'];
  List<String> genders = ['Male', 'Female'];
  List<String> vaccineTypes = ['BCG', 'Polio', 'MMR', 'DPT', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baby Registry'),
        centerTitle: true,
        backgroundColor: Colors.blue[500],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: selectedGender,
              items: genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Mother's Phone",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Vaccine Type',
                border: OutlineInputBorder(),
              ),
              value: selectedVaccine,
              items: vaccineTypes.map((String vaccine) {
                return DropdownMenuItem<String>(
                  value: vaccine,
                  child: Text(vaccine),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedVaccine = newValue;
                });
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              value: selectedLanguage,
              items: languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement schedule vaccination
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white,
              ),
              child: Text('Schedule Vaccination'),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement update functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




