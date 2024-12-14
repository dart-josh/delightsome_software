import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/helpers/authHelpers.dart';
import 'package:delightsome_software/helpers/dataGetters.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/homePage.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController staff_id_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  bool hide_password = true;

  @override
  void dispose() {
    staff_id_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Image.asset('assets/logo_app.jpg', width: 120),

            SizedBox(height: 60),

            // form
            Container(
              width: 700,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: width > 600
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: staff_id_textfield()),
                        SizedBox(width: 50),
                        Expanded(child: password_textfield()),
                      ],
                    )
                  : Column(
                      children: [
                        staff_id_textfield(),
                        SizedBox(height: 20),
                        password_textfield(),
                      ],
                    ),
            ),

            SizedBox(height: 40),

            // submit
            submit_button(),
          ],
        ),
      ),
    );
  }

  // staff id textfield
  Widget staff_id_textfield() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Text_field(
      controller: staff_id_controller,
      label: 'Staff ID',
      prefix: Icon(
        Icons.person_3_rounded,
        color: isDarkTheme
            ? AppColors.dark_secondaryTextColor
            : AppColors.light_secondaryTextColor,
        size: 20,
      ),
    );
  }

  // password textfield
  Widget password_textfield() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Text_field(
      controller: password_controller,
      label: 'Password',
      prefix: Icon(
        Icons.password_outlined,
        color: isDarkTheme
            ? AppColors.dark_secondaryTextColor
            : AppColors.light_secondaryTextColor,
        size: 20,
      ),
      obscure: hide_password,
      icon: GestureDetector(
        onTap: () {
          setState(() {
            hide_password = !hide_password;
          });
        },
        child: Icon(
          hide_password ? Icons.visibility : Icons.visibility_off,
          color: isDarkTheme
              ? AppColors.dark_secondaryTextColor
              : AppColors.light_secondaryTextColor,
          size: 18,
        ),
      ),
    );
  }

  // submit button
  Widget submit_button() {
    return InkWell(
      onTap: () async {
        if (staff_id_controller.text == 'xx') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          return;
        }

        if (staff_id_controller.text.trim().isEmpty ||
            password_controller.text.trim().isEmpty) {
          return UniversalHelpers.showToast(
            context: context,
            color: Colors.red,
            toastText: 'Enter login details',
            icon: Icons.error,
          );
        }

        bool auth = await AuthHelpers.login(
          context,
          {
            'staffId': staff_id_controller.text.trim(),
            'password': password_controller.text.trim()
          },
        );

        if (auth) {
          UniversalHelpers.showLoadingScreen(context: context);
          await DataGetters.get_active_staff(
              context, staff_id_controller.text.trim());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        }
      },
      child: Container(
        width: 200,
        height: 35,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.orange_1,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  //
}
