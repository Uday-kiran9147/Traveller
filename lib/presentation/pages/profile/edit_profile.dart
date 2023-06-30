import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/domain/repositories/database.dart';
import 'package:traveler/presentation/providers/user_provider.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String? profileUrl;
  String? bio;
  String? tag;
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information Form'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'tag'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an tag';
                  }
                  // You can add email format validation if needed.
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    tag = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'bio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a boi';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    bio = value;
                  });
                },
              ),
              // Add more text fields for other user information here.

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Save the user information to your database or use it as needed.
                    var response = await db.editPtofile(username, bio!, tag!);
                    if (response) {
                      await Provider.of<UserProvider>(context,listen: false)
                          .getuser();
                      Navigator.pop(context);
                      customSnackbarMessage("success!", context, Colors.black);
                    } else {
                      customSnackbarMessage(
                          "Failed to update".toString(), context, Colors.black);
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserInfoForm(),
  ));
}
