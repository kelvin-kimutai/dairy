import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/theme_colors.dart';
import '../../logic/view_models/register_viewModel.dart';
import '../../services/sevice_locator.dart';
import '../widgets/button.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterViewModel model = serviceLocator<RegisterViewModel>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var phoneNumberController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var title = 'Student';

  @override
  void initState() {
    model.scaffoldKey = scaffoldKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: ThemeColors.colorAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  imagePicker(),
                  inputField(firstNameController, 'First name',
                      TextInputType.text, false),
                  inputField(lastNameController, 'Last name',
                      TextInputType.text, false),
                  SizedBox(height: 15),
                  Button(
                    label: 'Create an Account',
                    color: ThemeColors.colorAccent,
                    onPressed: () async {
                      await model.registerUser(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          context: context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(TextEditingController controller, String hintText,
      TextInputType textInputType, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(hintText: hintText, labelText: hintText),
        obscureText: obscureText,
      ),
    );
  }

  Widget imagePicker() {
    return ChangeNotifierProvider(
      create: (context) => model,
      child: GestureDetector(
        onTap: () {
          showImagePicker(context);
        },
        child: Consumer<RegisterViewModel>(
          builder: (context, model, child) {
            return CircleAvatar(
              backgroundColor: ThemeColors.colorAccent,
              radius: 55,
              child: model.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        model.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  showImagePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      model.pickImageFromDevice(ImageSource.gallery, context);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    model.pickImageFromDevice(ImageSource.camera, context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
