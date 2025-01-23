import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/userModels/customer.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/helpers/userHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/select_form.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManageCustomerPage extends StatefulWidget {
  final CustomerModel? customer;
  final String customer_type;
  const ManageCustomerPage({
    super.key,
    this.customer,
    required this.customer_type,
  });

  @override
  State<ManageCustomerPage> createState() => _ManageCustomerPageState();
}

class _ManageCustomerPageState extends State<ManageCustomerPage> {
  final TextEditingController fullname_controller = TextEditingController();
  final TextEditingController nickname_controller = TextEditingController();
  final TextEditingController phone_controller = TextEditingController();
  final TextEditingController address_controller = TextEditingController();
  final TextEditingController birthday_controller = TextEditingController();

  List<String> customer_type_list = [];

  StaffModel? auth_staff;

  String gender = '';
  String customer_type = '';

  bool edit = false;
  bool new_cat = true;

  void get_values() {
    if (widget.customer == null) {
      customer_type = widget.customer_type;
      new_cat = true;
      edit = true;
    } else {
      fullname_controller.text = widget.customer!.fullname;
      nickname_controller.text = widget.customer!.nickName;
      phone_controller.text = widget.customer!.contactPhone;
      address_controller.text = widget.customer!.address;
      birthday_controller.text = widget.customer!.birthday;
      gender = widget.customer!.gender;
      customer_type = widget.customer!.customerType;

      new_cat = false;
      edit = false;
    }
  }

  @override
  void initState() {
    get_values();
    super.initState();
  }

  @override
  void dispose() {
    fullname_controller.dispose();
    nickname_controller.dispose();
    phone_controller.dispose();
    address_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    auth_staff = Provider.of<AppData>(context).active_staff;

    customer_type_list = auth_staff!.role == 'Terminal'
        ? ['Terminal']
        : auth_staff!.role == 'Sales'
            ? ['Store', 'Online']
            : ['Store', 'Online', 'Terminal'];

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 450,
        child: Column(
          children: [
            // top bar
            top_bar(),
            // content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? AppColors.dark_dialogBackground_1
                      : AppColors.light_dialogBackground_1,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              // details
                              if (widget.customer != null) details(),

                              SizedBox(height: 20),

                              formBox(),

                              // SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // submit
                    if (edit) submit_button(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar() {
    var auth_staff = Provider.of<AppData>(context).active_staff;

    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.primaryForegroundColor,
      child: Stack(
        children: [
          // action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // close button
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.secondaryWhiteIconColor,
                  size: 22,
                ),
              ),

              Expanded(child: Container()),

              // edit button
              if (!new_cat &&
                  (auth_staff!.fullaccess ||
                      auth_staff.role == 'Sales' ||
                      auth_staff.role == 'Admin' ||
                      auth_staff.role == 'Terminal'))
                InkWell(
                  onTap: () {
                    edit = !edit;

                    if (!edit) get_values();
                    setState(() {});
                  },
                  child: Icon(
                    edit ? Icons.check_circle : Icons.edit,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 20,
                  ),
                ),

              SizedBox(width: 10),

              // delete button
              if (edit && !new_cat && auth_staff!.fullaccess)
                InkWell(
                  onTap: () async {
                    bool? res = await UniversalHelpers.showConfirmBox(
                      context,
                      title: 'Delete Customer',
                      subtitle:
                          'This would permanently remove this customer from the database!\Would you like to proceed?',
                    );

                    if (res != null && res) {
                      bool done = await UserHelpers.delete_customer(
                          context, widget.customer!.key!);

                      if (done) Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.delete,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 20,
                  ),
                ),
            ],
          ),

          // title
          Center(
            child: Text(
              new_cat
                  ? 'New Customer'
                  : edit
                      ? 'Edit Customer'
                      : 'Manage Customer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // details
  Widget details() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle labelStyle = TextStyle(
      fontSize: 12,
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
    );
    TextStyle mainStyle = TextStyle(
      fontSize: 16,
      color: isDarkTheme
          ? AppColors.dark_primaryTextColor
          : AppColors.light_primaryTextColor,
      fontWeight: FontWeight.bold,
    );

    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nickname', style: labelStyle),
              Text(widget.customer!.nickName, style: mainStyle),
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Customer Type', style: labelStyle),
              Text(widget.customer!.customerType, style: mainStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget formBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // customer type
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Select_form(
              label: 'Customer Type',
              edit: edit,
              options: customer_type_list,
              text_value: customer_type,
              setval: (val) {
                customer_type = val;
                setState(() {});
              },
            ),
          ),

          // nickname
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: nickname_controller,
              label: 'Nickname',
              edit: !edit,
            ),
          ),

          // fullname
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: fullname_controller,
              label: 'Customer Fullname',
              edit: !edit,
            ),
          ),

          // gender
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Select_form(
              label: 'Gender',
              edit: edit,
              options: ['Male', 'Female'],
              text_value: gender,
              setval: (val) {
                gender = val;
                setState(() {});
              },
            ),
          ),

          // phone
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: phone_controller,
              label: 'Phone No.',
              edit: !edit,
              format: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),

          // address
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: address_controller,
              label: 'Address',
              edit: !edit,
              maxLine: 2,
            ),
          ),

          // birthday
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: birthday_controller,
              label: 'Birthday',
              edit: true,
              icon: (edit)
                  ? IconButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          birthday_controller.text =
                              DateFormat('MM/yyyy').format(picked);
                          setState(() {});
                        } else {
                          birthday_controller.text = '';
                        }
                      },
                      icon: Icon(Icons.date_range))
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // submit button
  Widget submit_button() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          if (customer_type.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Select Customer Type',
              icon: Icons.error,
            );
            return;
          }

          if (nickname_controller.text.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Enter Nickname',
              icon: Icons.error,
            );
            return;
          }

          Map map = CustomerModel(
            key: widget.customer?.key,
            fullname: fullname_controller.text.trim(),
            nickName: nickname_controller.text.trim(),
            contactPhone: phone_controller.text.trim(),
            address: address_controller.text.trim(),
            birthday: birthday_controller.text.trim(),
            customerType: customer_type,
            gender: gender,
          ).toJson();

          bool? res = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Save Customer',
            subtitle:
                'This would save this customer to the database!\Would you like to proceed?',
          );

          if (res != null && res) {
            bool done = await UserHelpers.add_update_customer(context, map);

            if (done) Navigator.pop(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.orange_1,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: AppColors.secondaryWhiteIconColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}
