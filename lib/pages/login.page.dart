import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/userModels/auth.model.dart';
import 'package:delightsome_software/helpers/authHelpers.dart';
import 'package:delightsome_software/helpers/dataGetters.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/homePage.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/utils/localStorage.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  final int? initial_page;
  const LoginPage({super.key, this.initial_page});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController staff_id_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController password_2_controller = TextEditingController();
  TextEditingController pin_controller = TextEditingController();

  FocusNode pin_node = FocusNode();

  bool hide_password = true;

  bool isLoading = false;

  List<AuthModel> saved_accounts = [];
  AuthModel? saved_active_account;

  int pin_1_confirmation = 0;
  String? pin_1;

  @override
  void initState() {
    validate_login();
    super.initState();
  }

  @override
  void dispose() {
    staff_id_controller.dispose();
    password_controller.dispose();
    password_2_controller.dispose();
    pin_controller.dispose();
    pin_node.dispose();
    super.dispose();
  }

  int prev_page = 0;
  int page_index = 6;
  // 0-login 1-password 2-select_account 3-pin 4-create_password 5-create-pin

  // login
  validate_login() async {
    saved_accounts = await Localstorage.get_accounts();
    saved_active_account = await Localstorage.get_active_account();

    // direct login
    if (widget.initial_page == null) {
      // active
      if (saved_active_account != null) {
        prev_page = 2;
        validate_account(saved_active_account!, prev: 0, from_active: true);
      } else if (saved_accounts.isNotEmpty) {
        // GOTO ACCOUNTS
        setState(() {
          page_index = 2;
        });
      } else {
        // GOTO LOGIN
        setState(() {
          page_index = 0;
        });
      }
    }

    // from logout
    else {
      // switch account & logout
      if (widget.initial_page == 2 || widget.initial_page == 0) {
      }

      // lock
      else {
        if (saved_active_account != null) {
          staff_id_controller.text = saved_active_account?.staff_id ?? '';
          password_controller.text = saved_active_account?.password ?? '';
          prev_page = 2;
        }
      }

      setState(() {
        page_index = widget.initial_page!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkTheme
          ? AppColors.dark_primaryBackgroundColor
          : AppColors.light_dialogBackground_3,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo_area(),
            SizedBox(height: (!isLoading) ? 30 : 60),
            if (!isLoading)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  page_index == 6
                      ? landing_page()
                      : page_index == 2
                          ? accounts_page()
                          : page_index == 3 || page_index == 5
                              ? pin_page(page_index)
                              : login_page(page_index),
                ],
              )
            else
              Center(
                  child: CircularProgressIndicator(
                color: AppColors.orange_1,
              )),
          ],
        ),
      ),
    );
  }

  // PAGES

  // landing page
  Widget landing_page() {
    return Container();
  }

  // logo
  Widget logo_area() {
    return Image.asset('assets/logo_app.png', width: 120);
  }

  // login page
  Widget login_page(int page) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    // double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30),

        if (page != 0) user_tile(staff_id_controller.text),

        // form
        Container(
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: page == 0
              ? staff_id_textfield()
              : page == 1
                  ? password_textfield()
                  : page == 4
                      ? Column(
                          children: [
                            password_textfield(),

                            SizedBox(height: 15),

                            // password 2
                            password_2_textfield(),
                          ],
                        )
                      : Container(),
        ),

        SizedBox(height: 20),

        // submit
        login_button(page),

        // back button
        if (page != 0)
          back_button(
            'Go back',
            function: () {
              password_controller.clear();
              password_2_controller.clear();
              setState(() {
                page_index = prev_page;
              });
            },
          ),

        if (page == 0) SizedBox(height: 10),
        // select account
        if (page == 0)
          TextButton(
            onPressed: () {
              setState(() {
                page_index = 2;
              });
            },
            child: Text(
              'Select account to login',
              style: TextStyle(
                color: isDarkTheme
                    ? AppColors.dark_secondaryTextColor
                    : AppColors.light_secondaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: isDarkTheme
                    ? AppColors.dark_secondaryTextColor
                    : AppColors.light_secondaryTextColor,
              ),
            ),
          ),
      ],
    );
  }

  // select account
  Widget accounts_page() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // accounts box
        Container(
          width: width > 450 ? 400 : double.infinity,
          height: saved_accounts.isEmpty
              ? 250
              : height > 550
                  ? 400
                  : 300,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color.fromRGBO(167, 106, 53, .8),
                Color.fromRGBO(142, 70, 7, .7),
                Color.fromRGBO(159, 115, 47, .8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                spreadRadius: 2,
                blurRadius: 5,
                color: Colors.white24,
              ),
            ],
          ),
          child: Column(
            children: [
              // header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select account to login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  SizedBox(width: 3),

                  // remove accounts
                  if (saved_accounts.isNotEmpty)
                    TextButton(
                      onPressed: () async {
                        var conf = await UniversalHelpers.showConfirmBox(
                          context,
                          title: 'Remove Accounts',
                          subtitle:
                              'Would you like to remove all saved accounts from this device? This cannot be undone.',
                        );

                        if (conf != null && conf) {
                          await Localstorage.remove_accounts();
                          await Localstorage.remove_active_account();

                          setState(() {
                            staff_id_controller.clear();
                            password_controller.clear();
                            password_2_controller.clear();
                            pin_controller.clear();
                            saved_active_account = null;
                            saved_accounts.clear();
                            page_index = 0;
                          });
                        }
                      },
                      child: Text(
                        'Remove all',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),

              if (saved_accounts.isEmpty)
                SizedBox(height: 30)
              else
                SizedBox(height: 10),

              // list
              saved_accounts.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          AuthModel staff = saved_accounts[index];
                          return saved_account_tile(staff);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: saved_accounts.length,
                      ),
                    )
                  : saved_account_tile(null),

              // login button
              TextButton(
                onPressed: () {
                  setState(() {
                    staff_id_controller.clear();
                    password_controller.clear();
                    password_2_controller.clear();
                    page_index = 0;
                  });
                },
                child: Text(
                  saved_accounts.isNotEmpty
                      ? 'Login with another account'
                      : 'Go back',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }

  // pin page
  Widget pin_page(int _page_index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          user_tile(staff_id_controller.text),
          SizedBox(height: 1),
          Text(
            page_index == 5
                ? pin_1_confirmation == 0
                    ? 'Create 4 digit pin'
                    : 'Confrim 4 digit pin'
                : 'Enter 4 digit pin to login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 10),
          buildPinPut(_page_index),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                pin_controller.clear();
                if (page_index == 5 && pin_1_confirmation == 1) {
                  pin_1_confirmation = 0;
                  pin_1 = null;
                } else {
                  // logout
                  AuthHelpers.logout(context);

                  page_index = 2;
                  password_controller.clear();
                  password_2_controller.clear();
                }
                setState(() {});
              },
              child: Text((_page_index == 5 && pin_1_confirmation == 1)
                  ? 'Go back'
                  : 'Switch account'),
            ),
          ),
        ],
      ),
    );
  }

  // pin put
  Widget buildPinPut(int page_index) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(16, 88, 150, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_borderColor
              : AppColors.light_borderColor,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(238, 114, 114, 1)),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
        controller: pin_controller,
        focusNode: pin_node,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        errorPinTheme: errorPinTheme,
        submittedPinTheme: submittedPinTheme,
        obscureText: true,
        validator: (s) {
          if (page_index == 5) {
            if (pin_1_confirmation == 1) {
              if (s != null && s.isNotEmpty && pin_1 != s) {
                return 'Pin do not match';
              }
            }
            return null;
          }

          return null;
        },
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        onCompleted: (_pin) {
          check_pin(staff_id_controller.text, _pin);
        });
  }

  //? WIDGETS

  // user tile
  Widget user_tile(String staff_id) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      width: 260,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_dimTextColor
              : AppColors.light_dimTextColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // user image
          Container(
            decoration: BoxDecoration(
              color: isDarkTheme
                  ? AppColors.dark_dimTextColor
                  : AppColors.light_dimTextColor,
              shape: BoxShape.circle,
            ),
            width: 35,
            height: 35,
            child: Center(
              child: Icon(
                Icons.person_2_rounded,
                size: 25,
                color: isDarkTheme
                    ? AppColors.dark_secondaryTextColor
                    : AppColors.light_secondaryTextColor,
              ),
            ),
          ),

          SizedBox(width: 8),

          // details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // id
                Text(
                  staff_id,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      hintText: 'Staff ID',
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
      hintText: '••••••••••••••••',
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

  // password_2 textfield
  Widget password_2_textfield() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Text_field(
      controller: password_2_controller,
      label: 'Confirm Password',
      hintText: '••••••••••••••••',
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

  // saved account tile
  Widget saved_account_tile(AuthModel? staff) {
    // add account
    if (staff == null)
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              staff_id_controller.clear();
              password_controller.clear();
              password_2_controller.clear();
              page_index = 0;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                // stops: [0.0, 0.5, 1.0],
                colors: [
                  Color.fromRGBO(167, 106, 53, 1),
                  Color.fromRGBO(142, 70, 7, 1),
                  Color.fromRGBO(159, 115, 47, 1),
                ],
              ),
            ),
            child: Row(
              children: [
                // icon
                Icon(
                  Icons.add,
                  size: 35,
                  color: Colors.white70,
                ),

                SizedBox(width: 10),

                // details
                Expanded(
                  child: Text(
                    'Add Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

    // account tile
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          prev_page = 2;
          validate_account(staff, prev: 2);
        },
        onLongPress: () async {
          var conf = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Remove Account',
            subtitle:
                'Would you like to remove this account from this device? This cannot be undone.',
          );

          if (conf != null && conf) {
            int staff_index = saved_accounts.indexOf(staff);
            saved_accounts.removeAt(staff_index);
            await Localstorage.save_accounts(saved_accounts);

            if (saved_active_account != null &&
                (saved_active_account!.staff_id == staff.staff_id)) {
              await Localstorage.remove_active_account();
              saved_active_account = null;
            }

            setState(() {});
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              // stops: [0.0, 0.5, 1.0],
              colors: [
                Color.fromRGBO(167, 106, 53, 1),
                Color.fromRGBO(142, 70, 7, 1),
                Color.fromRGBO(159, 115, 47, 1),
              ],
            ),
          ),
          child: Row(
            children: [
              // user image
              Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  shape: BoxShape.circle,
                ),
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.person_2_rounded,
                    size: 30,
                    color: Colors.white70,
                  ),
                ),
              ),

              SizedBox(width: 8),

              // details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // id
                    Text(
                      staff.staff_id,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),

                    // role
                    Text(
                      staff.role,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // submit button
  Widget login_button(int page) {
    return InkWell(
      onTap: () async {
        String role = '';

        prev_page = 0;

        // check staff id
        if (page == 0) {
          if (staff_id_controller.text.trim().isEmpty) {
            return UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Enter Staff ID',
              icon: Icons.error,
            );
          }

          await check_staff_id(staff_id_controller.text.trim());
        }

        // check password
        else if (page == 1) {
          if (password_controller.text.trim().isEmpty) {
            return UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Enter password',
              icon: Icons.error,
            );
          }

          role = await check_password(
              staff_id_controller.text.trim(), password_controller.text);

          if (role.isNotEmpty) {
            setState(() {
              saved_active_account = AuthModel(
                staff_id: staff_id_controller.text.trim(),
                password: password_controller.text,
                role: role,
              );
              page_index = 3;
            });
          }
        }

        // create password
        else if (page == 4) {
          if (password_controller.text.trim().isEmpty) {
            return UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Enter password',
              icon: Icons.error,
            );
          }

          if (password_2_controller.text.isEmpty ||
              (password_controller.text != password_2_controller.text)) {
            return UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Passwords do not match',
              icon: Icons.error,
            );
          }

          role = await create_password(
              staff_id_controller.text.trim(), password_controller.text);

          if (role.isNotEmpty) {
            setState(() {
              saved_active_account = AuthModel(
                staff_id: staff_id_controller.text.trim(),
                password: password_controller.text,
                role: role,
              );
              page_index = 3;
            });
          }
        }

        if (page == 0) return;

        if (role.isNotEmpty) {
          // save login
          await save_login(
              staff_id_controller.text.trim(), password_controller.text, role);
        }

        //
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
            page == 0
                ? 'Continue'
                : page == 1
                    ? 'Login'
                    : page == 4
                        ? 'Create Password'
                        : '',
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

  // back button
  Widget back_button(String title, {required VoidCallback function}) {
    return InkWell(
      onTap: function,
      child: Container(
        width: 200,
        height: 35,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.orange_1,
            width: .5,
          ),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.orange_1,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  //? FUNCTIONS
  // check staff id
  Future<bool?> check_staff_id(String staff_id, {bool check = false}) async {
    var response = await AuthHelpers.check_staff_id(
      context,
      {'staffId': staff_id},
      showLoading: !check,
    );

    if (response == null) return null;

    // create password
    if (response['mode'] == 1) {
      setState(() {
        page_index = 4;
      });
      return null;
    }

    // continue
    else if (response['mode'] == 0) {
      if (check) {
        return true;
      } else {
        setState(() {
          page_index = 1;
        });
        return null;
      }
    }

    // invalid
    else {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'Invalid Action',
        icon: Icons.warning,
      );
      return null;
    }
  }

  // check password
  Future<String> check_password(
    String staff_id,
    String password, {
    bool check = false,
  }) async {
    String role = '';
    var response = await AuthHelpers.check_password(
      context,
      {
        'staffId': staff_id,
        'password': password,
      },
      showLoading: !check,
    );

    if (response == null) return '';

    // create password
    if (response['mode'] == 1) {
      setState(() {
        page_index = 4;
      });
      return '';
    }

    // continue
    else if (response['mode'] == 0) {
      if (check) {
        return 'true';
      } else {
        role = response['role'];
        return role;
      }
    }

    // invalid
    else {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'Invalid Action',
        icon: Icons.warning,
      );
      return '';
    }
  }

  // create password
  Future<String> create_password(String staff_id, String password) async {
    String role = '';
    var response = await AuthHelpers.create_password(
      context,
      {
        'staffId': staff_id,
        'password': password,
      },
      showLoading: true,
    );

    if (response == null)
      return '';

    // continue
    else if (response['mode'] == 0) {
      role = response['role'];
    }

    // invalid
    else {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'Invalid Action',
        icon: Icons.warning,
      );
    }

    return role;
  }

  // create pin
  Future<String> create_pin(String staff_id, String pin) async {
    var response = await AuthHelpers.create_pin(
      context,
      {
        'staffId': staff_id,
        'pin': pin,
      },
    );

    if (response == null)
      return '';

    // continue
    else if (response['mode'] == 0) {
      return pin;
    }

    // invalid
    else {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'Invalid Action',
        icon: Icons.warning,
      );
      return '';
    }
  }

  // check pin
  check_pin(String staff_id, String _pin) async {
    // create pin
    if (page_index == 5) {
      if (pin_1_confirmation == 0) {
        pin_1 = _pin;
        pin_1_confirmation = 1;
        pin_controller.clear();
        setState(() {});
      } else {
        // CREATE PIN
        if (pin_1 == _pin) {
          isLoading = true;
          setState(() {});

          // create pin
          var res = await create_pin(staff_id_controller.text, _pin);

          if (res.isNotEmpty) {
            login();
          } else {
            isLoading = false;
            setState(() {});
          }
        }
      }
    }

    // check pin
    else {
      isLoading = true;
      setState(() {});

      var response = await AuthHelpers.check_pin(
        context,
        {
          'staffId': staff_id,
          'pin': _pin,
        },
      );

      isLoading = false;
      setState(() {});

      if (response == null) return '';

      // create pin
      if (response['mode'] == 1) {
        pin_controller.clear();
        setState(() {
          page_index = 5;
        });
        return '';
      }

      // continue
      else if (response['mode'] == 0) {
        login();
      }

      // invalid
      else {
        UniversalHelpers.showToast(
          context: context,
          color: Colors.red,
          toastText: 'Invalid Action',
          icon: Icons.warning,
        );
        return '';
      }
    }
  }

  // validate account
  validate_account(AuthModel staff,
      {required int prev, bool from_active = false}) async {
    isLoading = true;
    setState(() {});

    staff_id_controller.text = staff.staff_id;

    bool? staff_id_cr = await check_staff_id(staff.staff_id, check: true);

    if (staff_id_cr == null || !staff_id_cr) {
      isLoading = false;
      if (from_active) {
        page_index = 2;
      }
      setState(() {});
      return;
    }

    if (staff.password.isEmpty) {
      setState(() {
        isLoading = false;

        page_index = 1;
      });
      return;
    }

    String password_cr =
        await check_password(staff.staff_id, staff.password, check: true);

    if (password_cr == '') {
      isLoading = false;
      setState(() {});
      return;
    }

    setState(() {
      isLoading = false;
      saved_active_account = staff;
      page_index = 3;
    });
  }

  // login
  login() async {
    isLoading = true;
    page_index = 5;
    setState(() {});

    await DataGetters.get_active_staff(
        context, staff_id_controller.text.trim());

    await Localstorage.save_active_account(saved_active_account);

    isLoading = false;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
  }

  // save login
  Future save_login(String staff_id, String password, String role) async {
    var chk = saved_accounts.indexWhere((act) => act.staff_id == staff_id);

    if (chk == -1) {
      saved_accounts.add(AuthModel(
        staff_id: staff_id,
        password: password,
        role: role,
      ));
    } else {
      saved_accounts[chk] = AuthModel(
        staff_id: staff_id,
        password: password,
        role: role,
      );
    }

    await Localstorage.save_accounts(saved_accounts);
  }

  //
}
