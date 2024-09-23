import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/utils/utils.dart';

import 'controllers/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Rx<InvoiceModel> invoice = controller.invoice;
    Rx<CustomerModel> customer = controller.customer;

    return Scaffold(
      appBar: AppBar(
        actions: [Obx(() => getStatusIcon())],
        title: const Text('Record Payment'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: Obx(() => ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            customer.value.name ?? 'No Invoice Selected',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(invoice.value.ref ?? ''),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            controller.customer.value.ref == null
                                ? ''
                                : '${customer.value.town}: ${customer.value.address}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          controller.customer.value.ref == null
                              ? ''
                              : 'Balance Due: ${invoice.value.remaintopay ?? '0'}',
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  )),
            ),
            Expanded(
              child: Form(
                key: controller.paymentFormKey,
                child: Card(
                  child: ListView(
                    children: [
                      if (controller.fromHomeScreen)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownSearch<InvoiceModel>(
                            key: controller.dropdownKey,
                            compareFn: (item1, item2) => item1.id == item2.id,
                            onChanged: (invoice) {
                              if (invoice != null) {
                                controller.fetchData(
                                    invoice.socid!, invoice.id!);
                              } else {
                                controller.clearInvoice();
                              }
                            },
                            validator: (value) =>
                                value == null ? 'Invoice is required' : null,
                            itemAsString: (InvoiceModel? invoice) =>
                                invoice!.ref!,
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: 'Invoice',
                                icon: Icon(Icons.person_outline),
                                border: UnderlineInputBorder(),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            suffixProps: const DropdownSuffixProps(
                                clearButtonProps:
                                    ClearButtonProps(isVisible: true)),
                            popupProps: PopupProps.modalBottomSheet(
                                searchFieldProps: const TextFieldProps(
                                    textCapitalization:
                                        TextCapitalization.characters),
                                modalBottomSheetProps: ModalBottomSheetProps(
                                    shape: const UnderlineInputBorder(),
                                    constraints:
                                        const BoxConstraints(minHeight: 600),
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                listViewProps: const ListViewProps(
                                    padding: EdgeInsets.only(bottom: 12)),
                                title: const Text('Search Invoice',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                itemBuilder: (context, invoice, isSelected, l) {
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          invoice.ref,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'BALANCE: ${invoice.remaintopay}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(invoice.nom!),
                                            ),
                                            Text(
                                              Utils.intToDMY(
                                                  invoice.dateLimReglement!),
                                              style: Utils.overDueStyle(
                                                  invoice.dateLimReglement!),
                                            ),
                                          ],
                                        ),
                                        Text(invoice.lines![0].productLabel ??
                                            invoice.lines![0].description)
                                      ],
                                    ),
                                  );
                                },
                                emptyBuilder: ((context, searchEntry) =>
                                    const Center(
                                        child: Text('Invoice not found'))),
                                showSearchBox: true),
                            items: (filter, loadProps) async {
                              return await controller.fetchInvoices();
                            },
                            filterFn: (item, filter) =>
                                item.nom.contains(filter) ||
                                item.ref.contains(filter),
                          ),
                        ),
                      /*---*/
                      /*---*/
                      /*--Payment Date--*/
                      Obx(() => CustomFormField(
                            name: 'pay_date',
                            hintText: Utils.dateTimeToString(
                                controller.payDate.value),
                            prefixIcon: const Icon(Icons.date_range),
                            validator: (payDate) =>
                                controller.payDate.value.isAfter(DateTime.now())
                                    ? 'Date cannot be in the future'
                                    : null,
                            controller: controller.payDateController,
                            labelText: 'Pay Date', //'Payment Date',
                            suffix: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => controller.setPayDate()),
                          )),

                      ///
                      ///
                      /// Next Pay Date
                      Obx(() => CustomFormField(
                            name: 'due_date',
                            hintText: Utils.dateTimeToString(
                                controller.payDate.value),
                            prefixIcon: const Icon(Icons.date_range),
                            validator: (dueDate) => controller.dueDate.value
                                    .isBefore(controller.payDate.value
                                        .add(const Duration(days: 7)))
                                ? 'Invalid Due Date'
                                : null,
                            controller: controller.dueDateController,
                            labelText: 'Next Pay Date',
                            suffix: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => controller.setDueDate()),
                          )),
                      /*--Receipt Number--*/
                      CustomFormField(
                        name: 'receipt',
                        onChanged: (value) => controller.receipt.value = value!,
                        prefixIcon: const Icon(Icons.numbers),
                        keyboardType: TextInputType.number,
                        validator: (receipt) {
                          if (receipt!.isEmpty) {
                            return 'Amount is required';
                          }
                          if (receipt.length < 4) {
                            return 'Invalid receipt number';
                          }
                          // ignore: invalid_use_of_protected_member
                          if (controller.receiptNumbers.value
                              .contains(receipt)) {
                            return 'Receipt number already used for this customer';
                          }
                          return null;
                        },
                        controller: controller.receiptController,
                        labelText: 'Receipt No',
                      ),
                      /*---*/
                      /*---*/
                      /*--Payment Amount--*/
                      CustomFormField(
                        name: 'amount',
                        onChanged: (value) => controller.amount.value = value!,
                        prefixIcon: const Icon(Icons.currency_exchange),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: (amount) {
                          if (amount!.isEmpty) {
                            return 'Amount is required';
                          }
                          if (GetUtils.isGreaterThan(int.parse(amount),
                              int.parse(invoice.value.remaintopay!))) {
                            return 'Amount cannot be greater than balance';
                          }
                          return null;
                        },
                        controller: controller.amountController,
                        labelText: 'Amount',
                      ),
                      /*---*/
                      /*---*/
                      /*--Submit--*/
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomActionButton(
                                controller: controller,
                                buttonText: 'Save',
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  //controller.validateAndSave();
                                  if (controller.paymentFormKey.currentState!
                                      .validate()) {
                                    Get.defaultDialog(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 8),
                                      title: 'Record Payment',
                                      middleText:
                                          'Do you confirm payment of R${controller.amount} for ${customer.value.name}?',
                                      barrierDismissible: false,
                                      confirm: DialogActionButton(
                                          onPressed: () {
                                            Get.back();
                                            controller.validateAndSave();
                                          },
                                          buttonText: 'Yes'),
                                      cancel: DialogActionButton(
                                        buttonColor: Colors.red,
                                        buttonText: 'No',
                                        onPressed: () => Get.back(),
                                      ),
                                    );
                                  }
                                }),
                            CustomActionButton(
                                controller: controller,
                                buttonText: 'Cancel',
                                buttonColor: Colors.red,
                                onTap: () {
                                  Get.back();
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogActionButton extends StatelessWidget {
  const DialogActionButton(
      {super.key, this.onPressed, required this.buttonText, this.buttonColor});
  final void Function()? onPressed;
  final String buttonText;
  final Color? buttonColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        maximumSize: const Size(100, 40),
        minimumSize: const Size(100, 40),
        side: BorderSide(
          width: 1,
          color: buttonColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      child: Text(buttonText),
    );
  }
}
