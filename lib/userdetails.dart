import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'image_module.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> with WidgetsBindingObserver{
  File? _imageFile;
  final ImageModel _model = ImageModel();
  bool _detectPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userAboutController = TextEditingController();

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _detectPermission &&
        (_model.imageSection == ImageSection.noStoragePermissionPermanent)) {
      _detectPermission = false;
      _model.requestFilePermission();
    } else if (state == AppLifecycleState.paused &&
        _model.imageSection == ImageSection.noStoragePermissionPermanent) {
      _detectPermission = true;
    }
  }

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
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                              child: _imageFile == null ? const Icon(Icons.person, size: 150) : null,
                            ),
                          ) ,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 1.0,
                      right: 25.0,
                      child: FloatingActionButton(
                        onPressed: () async {
                          _checkPermissionsAndPick();
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                )
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
                    maxLength: 64,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Name',
                      hintText: 'Name',
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
              const SizedBox(height: 30.0),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: TextFormField(
                    controller: _userAboutController,
                    style: const TextStyle(fontSize: 16.0),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.text,
                    maxLength: 200,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'About',
                      hintText: 'About',
                      labelStyle:
                      TextStyle(color: Color.fromARGB(255, 14, 43, 80)),
                      hintStyle:
                      TextStyle(color: Color.fromARGB(55, 14, 43, 80)),
                      prefixIcon: Icon(
                        Icons.edit,
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
                      onPressed: (){},
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
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
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String? filePath = pickedFile?.path;

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(filePath!);
      });
    }
  }

  Future<void> _checkPermissionsAndPick() async {
    final hasFilePermission = await _model.requestFilePermission();
    print(hasFilePermission);
    if (hasFilePermission) {
      try {
        await _pickImage(ImageSource.gallery);
      } on Exception catch (e) {
        debugPrint('Error when picking a file: $e');
        // Show an error to the user if the pick file failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred when picking a file'),
          ),
        );
      }
    }
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

// class UserPic extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
//
// }

