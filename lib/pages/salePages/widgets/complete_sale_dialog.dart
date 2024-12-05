import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/saleModels/paymentMethod.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CompleteSaleDialog extends StatefulWidget {
  final int total;
  final int amount;
  final bool is_online;
  const CompleteSaleDialog({
    super.key,
    required this.total,
    required this.amount,
    required this.is_online,
  });

  @override
  State<CompleteSaleDialog> createState() => _CompleteSaleDialogState();
}

class _CompleteSaleDialogState extends State<CompleteSaleDialog> {
  TextEditingController note_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  TextEditingController discount_controller = TextEditingController();

  String? payment_method;
  List<PaymentMethodModel> split_payment_methods = [];

  void set_values() {
    final_amount = widget.amount;
  }

  DateTime? date;

  bool split_payment = false;
  bool add_note = false;
  bool apply_discount = false;
  int final_amount = 0;
  int split_amount = 0;

  @override
  void initState() {
    set_values();
    super.initState();
  }

  @override
  void dispose() {
    note_controller.dispose();
    date_controller.dispose();
    discount_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: (activeStaff!.fullaccess || activeStaff!.backDate) ? 450 : 400,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // amount & total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // total
                                  Column(
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          color: isDarkTheme
                                              ? AppColors
                                                  .dark_secondaryTextColor
                                              : AppColors
                                                  .light_secondaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        UniversalHelpers.format_number(
                                            widget.total),
                                        style: TextStyle(
                                          color: isDarkTheme
                                              ? AppColors.dark_primaryTextColor
                                              : AppColors
                                                  .light_primaryTextColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // amount
                                  Column(
                                    children: [
                                      Text(
                                        'Amount',
                                        style: TextStyle(
                                          color: isDarkTheme
                                              ? AppColors
                                                  .dark_secondaryTextColor
                                              : AppColors
                                                  .light_secondaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        UniversalHelpers.format_number(
                                            widget.amount,
                                            currency: true),
                                        style: TextStyle(
                                          color: isDarkTheme
                                              ? AppColors.dark_primaryTextColor
                                              : AppColors
                                                  .light_primaryTextColor,
                                          fontWeight: apply_discount
                                              ? FontWeight.w500
                                              : FontWeight.bold,
                                          fontSize: apply_discount ? 16 : 20,
                                          decoration: apply_discount
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              if (apply_discount) SizedBox(height: 10),

                              // apply discount
                              if (!apply_discount)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        apply_discount = true;
                                      });
                                    },
                                    child: Text('Discount'),
                                  ),
                                )
                              else
                                Column(
                                  children: [
                                    // discount box
                                    discount_box(),

                                    SizedBox(height: 10),

                                    // final amount
                                    Text(
                                      UniversalHelpers.format_number(
                                          final_amount,
                                          currency: true),
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? AppColors.dark_primaryTextColor
                                            : AppColors.light_primaryTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),

                              SizedBox(height: 15),

                              if (widget.is_online)
                                delivery_box()
                              else
                                payment_box(),

                              SizedBox(height: 5),

                              // short note
                              if (!add_note)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      add_note = true;
                                    });
                                  },
                                  child: Text('Add note'),
                                )
                              else
                                Text_field(
                                  controller: note_controller,
                                  label: 'Short note',
                                  icon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        note_controller.text = '';
                                        add_note = false;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: isDarkTheme
                                          ? AppColors.dark_secondaryTextColor
                                          : const Color.fromARGB(
                                              137, 52, 49, 49),
                                    ),
                                  ),
                                ),

                              if (activeStaff!.fullaccess ||
                                  activeStaff!.backDate)
                                SizedBox(height: 15),

                              // date
                              if (activeStaff!.fullaccess ||
                                  activeStaff!.backDate)
                                date_box(),

                              SizedBox(height: 6),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // submit
                    submit_button(),
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
            ],
          ),

          // title
          Center(
            child: Text(
              'Confirm Payment',
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

  // discount box
  Widget discount_box() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_secondaryTextColor
              : AppColors.light_secondaryTextColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      height: 34,
      child: Center(
        child: Row(
          children: [
            // icon
            Text(
              discount_controller.text.trim().isNotEmpty ? '₦' : '',
              style: TextStyle(
                color: isDarkTheme
                    ? AppColors.dark_secondaryTextColor
                    : AppColors.light_secondaryTextColor,
              ),
            ),

            SizedBox(width: 4),

            // text field
            Expanded(
              child: TextField(
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    int discount = int.parse(value);
                    final_amount = widget.amount - discount;
                  } else {
                    final_amount = widget.amount;
                  }

                  if (final_amount < 0) {
                    final_amount = 0;
                    discount_controller.text = widget.amount.toString();
                  }

                  setState(() {});
                },
                controller: discount_controller,
                style: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_primaryTextColor
                      : AppColors.light_primaryTextColor,
                  fontSize: 15,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(2, 2, 2, 1),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  hintText: 'Discount',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkTheme
                        ? AppColors.dark_secondaryTextColor
                        : AppColors.light_secondaryTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            // clear
            InkWell(
              onTap: () {
                apply_discount = false;
                discount_controller.clear();
                final_amount = widget.amount;
                setState(() {});
              },
              child: Icon(
                Icons.clear,
                color: isDarkTheme
                    ? AppColors.dark_secondaryTextColor
                    : AppColors.light_secondaryTextColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // payment box
  Widget payment_box() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    split_amount = final_amount -
        (split_payment_methods.fold(0, (int previousValue, element) {
          return previousValue + element.amount;
        }));

    return Container(
      child: Column(
        children: [
          // payment method label
          Row(
            children: [
              Text(
                'Select Payment Method',
                style: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
                ),
              ),
              Expanded(child: Container()),
              Text(
                UniversalHelpers.format_number(split_amount, currency: true),
                style: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 7),

          // payment method
          if (!split_payment)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Payment Method',
                labelStyle: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
                ),
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 10, 12),
              ),
              dropdownColor: isDarkTheme
                  ? AppColors.dark_primaryBackgroundColor
                  : AppColors.light_dialogBackground_1,
              value: payment_method,
              items: ['Cash', 'Transfer', 'POS']
                  .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  payment_method = val;

                  setState(() {});
                }
              },
            )

          // split payment method
          else
            Column(
              children: split_payment_methods.map(
                (e) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        //  method
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Method',
                              labelStyle: TextStyle(
                                color: isDarkTheme
                                    ? AppColors.dark_secondaryTextColor
                                    : AppColors.light_secondaryTextColor,
                              ),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 12, 10, 12),
                            ),
                            dropdownColor: isDarkTheme
                                ? AppColors.dark_primaryBackgroundColor
                                : AppColors.light_dialogBackground_1,
                            value: e.paymentMethod,
                            items: ['Cash', 'Transfer', 'POS'].map((e) {
                              bool selected = (split_payment_methods
                                  .where((el) => el.paymentMethod == e)
                                  .isNotEmpty);

                              return DropdownMenuItem<String>(
                                  enabled: !selected, value: e, child: Text(e));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                e.paymentMethod = val;

                                setState(() {});
                              }
                            },
                          ),
                        ),

                        SizedBox(width: 15),

                        // amount
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: isDarkTheme
                                  ? AppColors.dark_secondaryTextColor
                                  : AppColors.light_secondaryTextColor,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 40,
                          width: 100,
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  '₦',
                                  style: TextStyle(
                                    color: isDarkTheme
                                        ? AppColors.dark_secondaryTextColor
                                        : AppColors.light_secondaryTextColor,
                                    fontSize: 15,
                                  ),
                                ),

                                SizedBox(width: 2),

                                // text field
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value.trim().isNotEmpty) {
                                        int val = int.parse(value);
                                        e.amount = val;
                                      } else {
                                        e.amount = 0;
                                      }

                                      setState(() {});
                                    },
                                    style: TextStyle(
                                      color: isDarkTheme
                                          ? AppColors.dark_primaryTextColor
                                          : AppColors.light_primaryTextColor,
                                      fontSize: 15,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(2, 3, 2, 1),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 6),

                        // remove
                        InkWell(
                          onTap: () {
                            split_payment_methods.remove(e);
                            setState(() {});
                          },
                          child: Icon(
                            Icons.clear,
                            color: isDarkTheme
                                ? AppColors.dark_secondaryTextColor
                                : AppColors.light_secondaryTextColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),

          SizedBox(height: 5),

          // split payment
          Row(
            children: [
              if (split_payment &&
                  split_payment_methods.length < 3 &&
                  split_amount > 0)
                TextButton(
                  onPressed: () {
                    if (split_payment_methods.length >= 3) return;

                    split_payment_methods.add(
                      PaymentMethodModel(paymentMethod: null, amount: 0),
                    );
                    setState(() {});
                  },
                  child: Text('Add method'),
                ),
              Expanded(child: Container()),
              TextButton(
                onPressed: () {
                  split_payment = !split_payment;

                  if (split_payment) {
                    split_payment_methods.add(
                      PaymentMethodModel(paymentMethod: null, amount: 0),
                    );
                  } else {
                    split_payment_methods.clear();
                  }

                  payment_method = null;

                  setState(() {});
                },
                child:
                    Text(!split_payment ? 'Split Payment' : 'Single Payment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // delivery box
  Widget delivery_box() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      child: Column(
        children: [
          // delivery method label
          Text(
            'Select Delivery Method',
            style: TextStyle(
              color: isDarkTheme
                  ? AppColors.dark_secondaryTextColor
                  : AppColors.light_secondaryTextColor,
            ),
          ),

          SizedBox(height: 7),

          // delivery method
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Delivery Method',
                labelStyle: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
                ),
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(15, 12, 10, 12),
              ),
              dropdownColor: isDarkTheme
                  ? AppColors.dark_primaryBackgroundColor
                  : AppColors.light_dialogBackground_1,
              value: payment_method,
              items: ['Dispatch', 'Pickup']
                  .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  payment_method = val;

                  setState(() {});
                }
              },
            )

        ],
      ),
    );
  }

  // date box
  Widget date_box() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Text_field(
      controller: date_controller,
      icon: InkWell(
        onTap: () async {
          var data = await showDatePicker(
              context: context,
              firstDate:
                  DateTime(DateTime.now().year, DateTime.now().month - 5, 1),
              lastDate: DateTime.now(),
              initialDate:
                  DateTime.tryParse(date_controller.text) ?? DateTime.now());

          if (data != null) {
            date = data;
            date_controller.text = data.toString();
            setState(() {});
          } else {
            date = null;
            date_controller.text = '';
            setState(() {});
          }
        },
        child: Icon(
          Icons.calendar_month,
          color: isDarkTheme
              ? AppColors.dark_secondaryTextColor
              : const Color.fromARGB(137, 52, 49, 49),
        ),
      ),
    );
  }

  // submit button
  Widget submit_button() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          if (split_payment) {
            // empty
            if (split_payment_methods.isEmpty) {
              UniversalHelpers.showToast(
                context: context,
                color: Colors.red,
                toastText: 'Select payment methods',
                icon: Icons.error,
              );
              return;
            }

            if (split_payment_methods.length < 2) {
              UniversalHelpers.showToast(
                context: context,
                color: Colors.red,
                toastText: 'Invalid Split payment',
                icon: Icons.error,
              );
              return;
            }

            if (split_amount != 0) {
              UniversalHelpers.showToast(
                context: context,
                color: Colors.red,
                toastText: 'Invalid Split payment',
                icon: Icons.error,
              );
              return;
            }

            for (var element in split_payment_methods) {
              if (element.paymentMethod == null ||
                  element.paymentMethod!.isEmpty ||
                  element.amount == 0) {
                UniversalHelpers.showToast(
                  context: context,
                  color: Colors.red,
                  toastText: 'Invalid Split payment',
                  icon: Icons.error,
                );
                return;
              }
            }

            List<String> methods = split_payment_methods
                .map((e) => e.paymentMethod ?? '')
                .toList();
            payment_method = methods.join(', ');
          } else {
            if (payment_method == null || payment_method!.isEmpty) {
              UniversalHelpers.showToast(
                context: context,
                color: Colors.red,
                toastText: 'Select Payment method',
                icon: Icons.error,
              );
              return;
            }
          }

          Map response = {
            'final_amount': final_amount,
            'payment_method': payment_method,
            'split_payment':
                split_payment_methods.map((e) => e.toJson()).toList(),
            'note': note_controller.text.trim(),
            'date': date_controller.text.trim().isEmpty
                ? null
                : DateTime.tryParse(date_controller.text.trim()),
          };

          var conf = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Confirm Payment',
            subtitle:
                'Confirm the amount of ${UniversalHelpers.format_number(final_amount, currency: true)} has been paid successfully',
          );

          if (conf != null && conf) Navigator.pop(context, response);
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
