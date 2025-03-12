import 'package:flutter/material.dart';

void main() {
  runApp(const DoctorProfileApp());
}

class DoctorProfileApp extends StatelessWidget {
  const DoctorProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorProfileScreen(),
    );
  }
}

class DoctorProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Colors.blue, size: 50),
              const SizedBox(height: 10),
              const Text(
                "Doctor Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://via.placeholder.com/100"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.upload, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 15),
              buildTextField("Dr. Name", nameController),
              buildTextField("Qualification", qualificationController),
              buildTextField("Experience", experienceController),
              buildTextField("Dr. ID", idController),
              buildTextField("Clinic Address", addressController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.blue.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
