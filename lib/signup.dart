import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hang_over/username.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isButtonDisabled = true;
  bool _isPasswordVisible = false;
  bool _isPasswordVisible1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 43, 80),
        title: const Text(
            "HangOver",
            style: TextStyle(color: Colors.white),
          ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop(); // Add functionality to navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.35,
                      child: Image.asset("assets/images/img.png")),
                ),
              ),
              const SizedBox(height: 30.0),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 16.0),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    maxLength: 64,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onChanged: (value) {
                      setState(() {
                        _isButtonDisabled =
                        !_isFormValid(); // Update button disabled status based on form validity
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Email',
                      hintText: 'hangover@email.com',
                      labelStyle:
                      TextStyle(color: Color.fromARGB(255, 14, 43, 80)),
                      hintStyle:
                      TextStyle(color: Color.fromARGB(55, 14, 43, 80)),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Color.fromARGB(255, 14, 43, 80),
                      ),
                      counterText: "",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(fontSize: 16.0),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 20,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    // onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onChanged: (value) {
                      setState(() {
                        _isButtonDisabled =
                        !_isFormValid(); // Update button disabled status based on form validity
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Password',
                      hintText: 'Password',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 14, 43, 80)),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(55, 14, 43, 80)),
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Color.fromARGB(255, 14, 43, 80),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(255, 14, 43, 80),
                        ),
                      ),
                      counterText: "",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    style: const TextStyle(fontSize: 16.0),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 20,
                    obscureText: !_isPasswordVisible1,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _isFormValid() ? _handleSignUp : null,
                    onChanged: (value) {
                      setState(() {
                        _isButtonDisabled =
                        !_isFormValid(); // Update button disabled status based on form validity
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Confirm Password',
                      hintText: 'Confirm Password',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 14, 43, 80)),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(55, 14, 43, 80)),
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Color.fromARGB(255, 14, 43, 80),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible1 = !_isPasswordVisible1;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(255, 14, 43, 80),
                        ),
                      ),
                      counterText: "",
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.97,
                    constraints: const BoxConstraints(maxWidth: 400.0),
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _handleSignUp,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color.fromRGBO(14, 43, 80, .5);
                            } else if (states.contains(MaterialState.pressed)) {
                              return const Color.fromRGBO(14, 43, 80, .5);
                            }
                            return const Color.fromRGBO(14, 43, 80, 1);
                          },
                        ),
                      ),
                      child: const Text(
                        "SignUp",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white, // Background color of the button area
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Have an account"),
            TextButton(
              onPressed: () {
                // Add your button action here
                Navigator.of(context).pop(); // Add functionality to navigate back

              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromRGBO(
                          255, 255, 255, 1);
                    }
                    return const Color.fromRGBO(255, 255, 255, 1);
                  },
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.white; // Color when hovered
                  },
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Color.fromARGB(255, 14, 43, 80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle sign-up button press
  void _handleSignUp() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Perform sign-up if validation passes
    if (_isFormValid()) {
      // Add your sign-up logic here
      sendPostRequest();
    }
  }

  // Method to check form validity
  bool _isFormValid() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Add validation logic
    final bool isEmailValid = email.isNotEmpty && isValidEmail(email);
    final bool isPasswordValid = password.isNotEmpty &&
        password == confirmPassword &&
        password.length >= 5;

    return isEmailValid && isPasswordValid;

  }

  // Method to validate email format
  bool isValidEmail(String email) {
    String emailRegex =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Regular expression for email validation
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  String hashPassword(String password) {
    var bytes =
    utf8.encode(password); // Convert the password string to UTF-8 bytes
    var digest =
    sha256.convert(bytes); // Generate the SHA-256 hash of the password
    return digest.toString(); // Convert the hash digest to a hexadecimal string
  }

  Future<void> sendPostRequest() async {
    // Define the URL of the Flask API endpoint
    await dotenv.load(fileName: ".env");

    // Define the URL of the Flask API endpoint
    String? url = dotenv.env['API_URL'];
    String? apiKey = dotenv.env['API_KEY'];
    String hashedPassword = hashPassword(_passwordController.text.trim());
    try {
      // Send the POST request
      http.Response response = await http.post(
        Uri.parse('${url!}/signUp'),
        body: {
          'email': _emailController.text.trim(),
          'password': hashedPassword,
          'api_key': apiKey!,
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = json.decode(response.body);
        print(data);
        if (data['message'] == 'False') {
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Account already exits on this email!'),
            ));
          } else {
            Fluttertoast.showToast(
              msg: 'Account already exits on this email!',
              toastLength: Toast.LENGTH_SHORT,
              // Duration for which the toast is visible
              gravity: ToastGravity.BOTTOM,
              // Position of the toast message
              timeInSecForIosWeb: 1,
              // Time for iOS web
              backgroundColor: Colors.grey[700],
              // Background color of the toast
              textColor: Colors.white,
              // Text color of the toast message
              fontSize: 16.0, // Font size of the toast message
            );
          }
        } else if (data['message'] == 'wrong') {
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Something went wrong!'),
            ));
          } else {
            Fluttertoast.showToast(
              msg: 'Something went wrong!',
              toastLength: Toast.LENGTH_SHORT,
              // Duration for which the toast is visible
              gravity: ToastGravity.BOTTOM,
              // Position of the toast message
              timeInSecForIosWeb: 1,
              // Time for iOS web
              backgroundColor: Colors.grey[700],
              // Background color of the toast
              textColor: Colors.white,
              // Text color of the toast message
              fontSize: 16.0, // Font size of the toast message
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserName()),
          );
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Account created successfully!'),
            ));
          } else {
            Fluttertoast.showToast(
              msg: 'Account created successfully!',
              toastLength: Toast.LENGTH_SHORT,
              // Duration for which the toast is visible
              gravity: ToastGravity.BOTTOM,
              // Position of the toast message
              timeInSecForIosWeb: 1,
              // Time for iOS web
              backgroundColor: Colors.grey[700],
              // Background color of the toast
              textColor: Colors.white,
              // Text color of the toast message
              fontSize: 16.0, // Font size of the toast message
            );
          }
        }
      } else {
        // Handle error response
        if (kIsWeb) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong!'),
          ));
        } else {
          Fluttertoast.showToast(
            msg: 'Something went wrong!',
            toastLength: Toast.LENGTH_SHORT,
            // Duration for which the toast is visible
            gravity: ToastGravity.BOTTOM,
            // Position of the toast message
            timeInSecForIosWeb: 1,
            // Time for iOS web
            backgroundColor: Colors.grey[700],
            // Background color of the toast
            textColor: Colors.white,
            // Text color of the toast message
            fontSize: 16.0, // Font size of the toast message
          );
        }
      }
    } catch (e) {
      // Handle exceptions
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!'),
          ),
        );
        print('Exception: $e');
      }
    }
  }
}
