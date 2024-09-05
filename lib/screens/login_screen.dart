import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Firestore
import 'package:helper/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String enteredName = '';
  String enteredPwd = '';
  bool isLoading = false; // For disabling the button during login

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch the list of users from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('name', isEqualTo: enteredName)
          .where('password', isEqualTo: enteredPwd)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If user is found, navigate to home screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        // Show error dialog if credentials are incorrect
        showErrorDialog();
      }
    } catch (e) {
      // Handle error
      showErrorDialog();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: const Text('Invalid username or password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        enteredName = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Adjust hint text color
                      filled: true,
                      fillColor: Colors.white.withOpacity(
                          0.9), // Adjusted opacity for better visibility
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                    ),
                    style: const TextStyle(
                        color: Colors.black), // Text color inside the input
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        enteredPwd = value;
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Adjust hint text color
                      filled: true,
                      fillColor: Colors.white.withOpacity(
                          0.9), // Adjusted opacity for better visibility
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                    ),
                    style: const TextStyle(
                        color: Colors.black), // Text color inside the input
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        isLoading ? null : login, // Disable button when loading
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLoading ? 'Logging in...' : 'Login',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
