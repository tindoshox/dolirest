import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/utils/utils.dart';

import 'controllers/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var invoice = controller.invoice;
    var customer = controller.customer;

    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: const [],
      appBar: AppBar(
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
                            compareFn: (item1, item2) => item1 == item2,
                            clearButtonProps:
                                const ClearButtonProps(isVisible: true),
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
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Invoice',
                                icon: Icon(Icons.person_outline),
                                border: UnderlineInputBorder(),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
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
                                isFilterOnline: true,
                                itemBuilder: (context, InvoiceModel? invoice,
                                    isSelected) {
                                  return ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            invoice!.ref!,
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
                                                intToDateString(
                                                    invoice.dateLimReglement!),
                                                style: overDueStyle(
                                                    invoice.dateLimReglement!),
                                              ),
                                            ],
                                          ),
                                          Text(invoice.lines![0].productLabel ??
                                              invoice.lines![0].description)
                                        ],
                                      ));
                                },
                                emptyBuilder: ((context, searchEntry) =>
                                    const Center(
                                        child: Text('Invoice not found'))),
                                showSearchBox: true),
                            asyncItems: (String searchString) async {
                              List<InvoiceModel> invoices = await controller
                                  .fetchInvoices(searchString: searchString);
                              return invoices;
                            },
                          ),
                        ),
                      /*---*/
                      /*---*/
                      /*--Payment Date--*/
                      Obx(() => CustomFormField(
                            name: 'pay_date',
                            hintText:
                                dateTimeToString(controller.payDate.value),
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
                            hintText:
                                dateTimeToString(controller.payDate.value),
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
                        validator: (receipt) =>
                            GetUtils.isLengthLessThan(receipt, 4)
                                ? 'Invalid receipt number'
                                : null,
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
                                  controller.validateAndSave();
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
