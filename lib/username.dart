import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final TextEditingController _userNameController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 43, 80),
        title: const Center(
          child: Text(
            "HangOver",
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.35,
                    child: Image.asset("assets/images/img.png"),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: TextFormField(
                    controller: _userNameController,
                    style: const TextStyle(fontSize: 16.0),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onChanged: (value) {
                      _checkFormValidity();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Username',
                      hintText: 'Username',
                      labelStyle:
                      TextStyle(color: Color.fromARGB(255, 14, 43, 80)),
                      hintStyle:
                      TextStyle(color: Color.fromARGB(55, 14, 43, 80)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 14, 43, 80),
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
                      onPressed: _isButtonDisabled ? null : (){},
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
                        "Next",
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
    );
  }

  Future<void> _checkFormValidity() async {
    final String userName = _userNameController.text.trim();
    final bool isValid = await isUserName(userName);

    setState(() {
      _isButtonDisabled = !isValid;
    });
  }

  Future<bool> isUserName(String userName) async {
    if (userName.length < 3|| userName.contains(' ') || !_isValidUserName(userName)) {
      return false;
    }

    return await sendPostRequest(userName);
  }

  bool _isValidUserName(String userName) {
    // Regular expression to allow only letters, numbers, and underscores
    RegExp regex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    return regex.hasMatch(userName);
  }

  Future<bool> sendPostRequest(String userName) async {
    // Define the URL of the API endpoint
    await dotenv.load(fileName: ".env");
    String? url = dotenv.env['API_URL'];
    String? apiKey = dotenv.env['API_KEY'];

    try {
      // Send the POST request
      http.Response response = await http.post(
        Uri.parse('${url!}/checkUsername'),
        body: {
          'username': userName,
          'api_key': apiKey!,
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = json.decode(response.body);
        if (data['message'] == 'True'){
          return true;
        }else{
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      return false;
    }
  }
}
