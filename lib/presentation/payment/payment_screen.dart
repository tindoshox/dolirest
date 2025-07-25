import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Rx<InvoiceEntity> invoice = controller.invoice;
    Rx<CustomerEntity> customer = controller.customer;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() => getStatusIcon(connected: controller.connected.value))
        ],
        title: const Text('Record Payment'),
      ),
      body: Center(
        child: Column(
          children: [
            _buildInvoiceInfo(customer, invoice, context),
            _buidForm(context, invoice, customer),
          ],
        ),
      ),
    );
  }

  Expanded _buidForm(BuildContext context, Rx<InvoiceEntity> invoice,
      Rx<CustomerEntity> customer) {
    return Expanded(
      child: Form(
        key: controller.paymentFormKey,
        child: Card(
          child: ListView(
            children: [
              if (controller.invoice.value.documentId.isEmpty)
                _buildSearchField(context),
              _buildPayDateField(),
              _buildDueDateField(),
              _buildReceiptNumberField(),
              _buildAmountField(invoice),
              _buildSaveButton(customer),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildSaveButton(Rx<CustomerEntity> customer) {
    return Padding(
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
                if (controller.paymentFormKey.currentState!.validate()) {
                  Get.defaultDialog(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    title: 'Record Payment',
                    middleText:
                        'Do you confirm payment of R${controller.amount} for ${customer.value.name}?',
                    barrierDismissible: false,
                    confirm: CustomActionButton(
                        onTap: () {
                          Get.back();
                          controller.validateAndSave();
                        },
                        buttonText: 'Yes'),
                    cancel: CustomActionButton(
                      isCancel: true,
                      buttonText: 'No',
                      onTap: () => Get.back(),
                    ),
                  );
                }
              }),
          CustomActionButton(
              controller: controller,
              buttonText: 'Cancel',
              isCancel: true,
              onTap: () {
                Get.back();
              }),
        ],
      ),
    );
  }

  CustomFormField _buildAmountField(Rx<InvoiceEntity>? invoice) {
    return CustomFormField(
      name: 'amount',
      onChanged: (value) => controller.amount.value = value!,
      prefixIcon: const Icon(
        Icons.currency_exchange,
        color: Colors.greenAccent,
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      validator: (amount) {
        if (invoice?.value.documentId == null) {
          return 'Please select an invoice first';
        }
        if (amount!.isEmpty) {
          return 'Amount is required';
        }
        if (GetUtils.isGreaterThan(
            int.parse(amount), int.parse(invoice!.value.remaintopay))) {
          return 'Amount cannot be greater than balance';
        }
        return null;
      },
      controller: controller.amountController,
      labelText: 'Amount',
    );
  }

  CustomFormField _buildReceiptNumberField() {
    return CustomFormField(
      name: 'receipt',
      onChanged: (value) => controller.receipt.value = value!,
      prefixIcon: const Icon(
        Icons.numbers,
        color: Colors.purpleAccent,
      ),
      keyboardType: TextInputType.number,
      validator: (receipt) {
        if (receipt!.isEmpty) {
          return 'Amount is required';
        }
        if (receipt.length < 4) {
          return 'Invalid receipt number';
        }
        // ignore: invalid_use_of_protected_member
        if (controller.receiptNumbers.value.contains(receipt)) {
          return 'Receipt number already used for this invoice';
        }
        return null;
      },
      controller: controller.receiptController,
      labelText: 'Receipt No',
    );
  }

  Obx _buildDueDateField() {
    return Obx(() => CustomFormField(
          name: 'due_date',
          hintText: Utils.dateTimeToDMY(controller.payDate.value),
          prefixIcon: const Icon(
            Icons.date_range,
            color: Colors.redAccent,
          ),
          validator: (dueDate) => controller.dueDate.value.isBefore(
                  controller.payDate.value.add(const Duration(days: 7)))
              ? 'Invalid Due Date'
              : null,
          controller: controller.dueDateController,
          labelText: 'Next Pay Date',
          suffix: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.redAccent,
              ),
              onPressed: () => controller.setDueDate()),
        ));
  }

  Obx _buildPayDateField() {
    return Obx(() => CustomFormField(
          name: 'pay_date',
          hintText: Utils.dateTimeToDMY(controller.payDate.value),
          prefixIcon: const Icon(
            Icons.date_range,
            color: Colors.orangeAccent,
          ),
          validator: (payDate) {
            if (controller.payDate.value.isAfter(DateTime.now())) {
              return 'Pay date cannot be in the future';
            }

            if (controller.paymentDates.contains(payDate)) {
              return 'Payment date already used for this invoice';
            }

            return null;
          },
          controller: controller.payDateController,
          labelText: 'Pay Date', //'Payment Date',
          suffix: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.orangeAccent,
              ),
              onPressed: () => controller.setPayDate()),
        ));
  }

  Padding _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownSearch<InvoiceEntity>(
        key: controller.dropdownKey,
        compareFn: (item1, item2) => item1.name == item2.name,
        onChanged: (invoice) {
          if (invoice != null) {
            controller.fetchData(invoice);
          } else {
            controller.clearInvoice();
          }
        },
        validator: (value) => value == null ? 'Invoice is required' : null,
        itemAsString: (InvoiceEntity invoice) => invoice.ref,
        decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: 'Invoice',
            prefixIcon: Icon(
              Icons.person_outline,
              color: Colors.blueAccent,
            ),
          ),
        ),
        suffixProps: const DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(isVisible: true)),
        popupProps: PopupProps.modalBottomSheet(
            searchFieldProps: const TextFieldProps(
                textCapitalization: TextCapitalization.characters),
            modalBottomSheetProps: ModalBottomSheetProps(
                shape: const UnderlineInputBorder(),
                constraints: const BoxConstraints(minHeight: 600),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor),
            listViewProps:
                const ListViewProps(padding: EdgeInsets.only(bottom: 12)),
            title: const Text('Search Invoice',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            itemBuilder: (context, invoice, isSelected, l) {
              return invoiceListTile(
                context: context,
                customer: controller.customers
                    .firstWhere((c) => c.customerId == invoice.socid),
                invoice: invoice,
              );
            },
            emptyBuilder: ((context, searchEntry) =>
                const Center(child: Text('Invoice not found'))),
            showSearchBox: true),
        items: (filter, loadProps) async {
          return controller.fetchInvoices();
        },
        filterFn: (invoice, filter) =>
            invoice.name.contains(filter) || invoice.ref.contains(filter),
      ),
    );
  }

  Card _buildInvoiceInfo(Rx<CustomerEntity> customer, Rx<InvoiceEntity> invoice,
      BuildContext context) {
    return Card(
      child: Obx(() => ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    customer.value.name.isEmpty
                        ? 'No Invoice Selected'
                        : customer.value.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(invoice.value.ref,
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    controller.customer.value.customerId.isEmpty
                        ? ''
                        : '${customer.value.town}: ${customer.value.address}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  controller.customer.value.customerId.isEmpty
                      ? ''
                      : 'BALANCE: ${invoice.value.remaintopay}',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )),
    );
  }
}
