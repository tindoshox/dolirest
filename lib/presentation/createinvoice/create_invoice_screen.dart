import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/products_model.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/utils/utils.dart';

import 'controllers/create_invoice_controller.dart';

class CreateinvoiceScreen extends GetView<CreateinvoiceController> {
  const CreateinvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create invoice'),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              isThreeLine: true,
              title: Obx(() => Text(
                  controller.customer.value.name ?? 'No Customer Selected')),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(controller.customer.value.address ?? '')),
                  Obx(() => Text(controller.customer.value.town ?? '')),
                ],
              ),
            ),
          ),
          Expanded(
            child: Form(
                key: controller.createInvoiceKey,
                child: Obx(
                  () => Card(
                    child: ListView(children: [
                      /*---*/
                      if (controller.fromHomeScreen)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownSearch<ThirdPartyModel>(
                            onChanged: (customer) {
                              controller.fetchCustomerById(customer!.id!);
                            },
                            validator: (value) =>
                                value == null ? 'Customer is required' : null,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Customer',
                                icon: Icon(Icons.person_outline),
                                border: UnderlineInputBorder(),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            itemAsString: (ThirdPartyModel? customer) =>
                                customer!.name!,
                            popupProps: PopupProps.modalBottomSheet(
                                searchFieldProps: const TextFieldProps(
                                    textCapitalization:
                                        TextCapitalization.characters),
                                modalBottomSheetProps: ModalBottomSheetProps(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder()),
                                title: const Text('Search Customer',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                isFilterOnline: true,
                                itemBuilder: (context,
                                    ThirdPartyModel? customer, isSelected) {
                                  return ListTile(
                                    title: Text(
                                      customer!.name!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        '${customer.address} ${customer.town}'
                                            .trim()),
                                  );
                                },
                                emptyBuilder: (context, searchEntry) =>
                                    const Center(
                                      child: Text(
                                        'Customer Not Found',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                showSearchBox: true),
                            asyncItems: (String searchString) async {
                              List<ThirdPartyModel> customers = await controller
                                  .searchCustomer(searchString: searchString);
                              return customers;
                            },
                          ),
                        ),
                      /*---*/
                      /*---*/
                      /*--Invoice Date--*/
                      CustomFormField(
                        name: 'invoice_date',
                        prefixIcon: const Icon(Icons.date_range),
                        validator: (invoicDate) =>
                            controller.invoiceDate.value.isAfter(DateTime.now())
                                ? 'Date cannot be in the future'
                                : null,
                        controller: controller.invoiceDateController,
                        labelText: 'Payment Date',
                        suffix: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => controller.setInvoiceDate()),
                      ),

                      ///
                      ///
                      /// Due Date
                      CustomFormField(
                        name: 'due_date',
                        prefixIcon: const Icon(Icons.date_range),
                        validator: (dueDate) => controller.dueDate.value
                                .isBefore(DateTime(DateTime.now().day + 7))
                            ? 'Invalid Due Date'
                            : null,
                        controller: controller.dueDateController,
                        labelText: 'Next Pay Date',
                        suffix: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => controller.setDueDate()),
                      ),
                      /*--Delivery Note--*/
                      CustomFormField(
                        name: 'receipt_number',
                        prefixIcon: const Icon(Icons.numbers),
                        keyboardType: TextInputType.number,
                        validator: (deliveryNote) =>
                            GetUtils.isLengthLessThan(deliveryNote, 4)
                                ? 'Invalid delivery note'
                                : null,
                        controller: controller.refController,
                        labelText: 'Delivery Note',
                      ),

                      ///
                      ///
                      /// Stock Type
                      const ListTile(
                        title: Text('Product Type'),
                        leading: Icon(Icons.delivery_dining),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: Radio(
                                  value: '1',
                                  groupValue: controller.stockType.value,
                                  onChanged: (value) {
                                    controller.setStockType(value.toString());
                                  }),
                              title: const Text('Free Text'),
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: Radio(
                                  value: '0',
                                  groupValue: controller.stockType.value,
                                  onChanged: (value) {
                                    controller.setStockType(value.toString());
                                  }),
                              title: const Text('Predefined'),
                            ),
                          ),
                        ],
                      ),

                      /*--Free text--*/
                      controller.stockType.value == '1'
                          ? CustomFormField(
                              name: 'free_text',
                              prefixIcon: const Icon(Icons.inventory_sharp),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              validator: (freeText) => GetUtils
                                      .isLengthLessThan(freeText, 3)
                                  ? 'Product name must be at least 3 characters'
                                  : null,
                              controller: controller.freetextController,
                              labelText: 'Product',
                            )

                          ///
                          ///
                          /// Product List
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FormBuilderSearchableDropdown<Product>(
                                name: 'product',
                                compareFn: (item1, item2) => item1 == item2,
                                onChanged: (product) {
                                  controller.selectedProduct.value = product!;
                                  controller.priceController.text =
                                      amounts('${product.price}');
                                },
                                validator: (value) => value == null
                                    ? 'Product is required'
                                    : null,
                                decoration: const InputDecoration(
                                  labelText: 'Product',
                                  icon: Icon(Icons.inventory_sharp),
                                  border: UnderlineInputBorder(),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                itemAsString: (Product product) =>
                                    '${product.label}',
                                popupProps: PopupProps.modalBottomSheet(
                                    modalBottomSheetProps:
                                        ModalBottomSheetProps(
                                            shape:
                                                const RoundedRectangleBorder(),
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                    title: const Text(
                                      'Search Product',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isFilterOnline: true,
                                    itemBuilder:
                                        (context, Product product, isSelected) {
                                      return ListTile(
                                        title: Text('${product.label}'),
                                        subtitle:
                                            Text(amounts('${product.price}')),
                                      );
                                    },
                                    emptyBuilder: (context, searchEntry) =>
                                        const Center(
                                            child: Text('Product Not Found')),
                                    showSearchBox: true),
                                asyncItems: (String searchString) async {
                                  List<Product> products = await controller
                                      .fetchProducts(searchString);
                                  return products;
                                },
                              ),
                            ),

                      /*---*/
                      /*---*/
                      /*--Product Price--*/
                      CustomFormField(
                        name: 'product_price',
                        prefixIcon: const Icon(Icons.currency_exchange),
                        keyboardType: TextInputType.number,
                        validator: (amount) {
                          if (amount!.isEmpty) {
                            return 'Price is required';
                          }
                          if (amount.startsWith('0')) {
                            return 'Invalid amount';
                          }
                          return null;
                        },
                        controller: controller.priceController,
                        textInputAction: TextInputAction.done,
                        labelText: 'Price',
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    controller.validateInputs();
                                  }),
                              CustomActionButton(
                                  controller: controller,
                                  buttonText: 'Cancel',
                                  buttonColor: Colors.red,
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    Get.back();
                                  }),
                            ]),
                      ),
                    ]),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
