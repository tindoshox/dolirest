import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/utils/utils.dart';

import 'controllers/create_invoice_controller.dart';

class CreateinvoiceScreen extends GetView<CreateinvoiceController> {
  const CreateinvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Create Invoice'),
      actions: [Obx(() => getStatusIcon())],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildCustomerCard(),
        Expanded(child: _buildForm(context)),
      ],
    );
  }

  Widget _buildCustomerCard() {
    return Card(
      child: Obx(() => ListTile(
            title:
                Text(controller.customer.value.name ?? 'No Customer Selected'),
            subtitle: Text(controller.customer.value.town == null
                ? ''
                : '${controller.customer.value.town}: ${controller.customer.value.address}'),
          )),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.createInvoiceKey,
      child: Obx(
        () => Card(
          child: ListView(
            children: [
              _customerDropdown(context),
              _invoiceDateField(),
              _dueDateField(),
              _deliveryNoteField(),
              _productTypeSection(),
              if (controller.stockType.value == '1')
                _freeTextField()
              else
                _productListDropdown(context),
              _productPriceField(),
              _submitButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customerDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownSearch<CustomerModel>(
        onChanged: (customer) {
          if (customer != null) {
            controller.fetchCustomerById(customer.id!);
          } else {
            controller.clearCustomer();
          }
        },
        validator: (value) => value == null ? 'Customer is required' : null,
        decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: 'Customer',
            icon: Icon(Icons.person_outline),
            border: UnderlineInputBorder(),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
        itemAsString: (CustomerModel? customer) => customer!.name!,
        suffixProps: const DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(isVisible: true)),
        popupProps: PopupProps.modalBottomSheet(
          searchFieldProps: const TextFieldProps(
              textCapitalization: TextCapitalization.characters),
          modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(),
          ),
          title: const Text('Search Customer',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          itemBuilder: (context, customer, isSelected, l) {
            return ListTile(
              title: Text(
                customer.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${customer.town}: ${customer.address}'.trim()),
            );
          },
          emptyBuilder: (context, searchEntry) => const Center(
            child: Text(
              'Customer Not Found',
              textAlign: TextAlign.center,
            ),
          ),
          showSearchBox: true,
        ),
        items: (String searchString, l) async {
          List<CustomerModel> customers =
              await controller.searchCustomer(searchString: searchString);
          return customers;
        },
        compareFn: (item1, item2) => item1.id == item2.id,
      ),
    );
  }

  Widget _invoiceDateField() {
    return CustomFormField(
      name: 'invoice_date',
      prefixIcon: const Icon(Icons.date_range),
      validator: (invoiceDate) =>
          controller.invoiceDate.value.isAfter(DateTime.now())
              ? 'Date cannot be in the future'
              : null,
      controller: controller.invoiceDateController,
      labelText: 'Payment Date',
      suffix: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => controller.setInvoiceDate()),
    );
  }

  Widget _dueDateField() {
    return CustomFormField(
      name: 'due_date',
      prefixIcon: const Icon(Icons.date_range),
      validator: (dueDate) => controller.dueDate.value.isBefore(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day + 7))
          ? 'Invalid Due Date'
          : null,
      controller: controller.dueDateController,
      labelText: 'Next Pay Date',
      suffix: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => controller.setDueDate()),
    );
  }

  Widget _deliveryNoteField() {
    return CustomFormField(
      name: 'receipt_number',
      prefixIcon: const Icon(Icons.numbers),
      keyboardType: TextInputType.number,
      validator: (deliveryNote) => GetUtils.isLengthLessThan(deliveryNote, 4)
          ? 'Invalid delivery note'
          : null,
      controller: controller.refController,
      labelText: 'Delivery Note',
    );
  }

  Widget _productTypeSection() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _freeTextField() {
    return CustomFormField(
      name: 'free_text',
      prefixIcon: const Icon(Icons.inventory_sharp),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      validator: (freeText) => GetUtils.isLengthLessThan(freeText, 3)
          ? 'Product name must be at least 3 characters'
          : null,
      controller: controller.freetextController,
      labelText: 'Product',
    );
  }

  Widget _productListDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownSearch<ProductModel>(
        compareFn: (item1, item2) => item1 == item2,
        onChanged: (product) {
          if (product != null) {
            controller.selectedProduct.value = product;
            controller.priceController.text = Utils.amounts('${product.price}');
          } else {
            controller.clearProduct();
          }
        },
        validator: (value) => value == null ? 'Product is required' : null,
        itemAsString: (ProductModel product) => '${product.label}',
        suffixProps: const DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(isVisible: true)),
        popupProps: PopupProps.modalBottomSheet(
          searchFieldProps: const TextFieldProps(
              textCapitalization: TextCapitalization.characters),
          modalBottomSheetProps: ModalBottomSheetProps(
            shape: const RoundedRectangleBorder(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          title: const Text(
            'Search Product',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          itemBuilder: (context, product, isSelected, l) {
            return ListTile(
              title: Text('${product.label}'),
              subtitle: Text(Utils.amounts('${product.price}')),
            );
          },
          emptyBuilder: (context, searchEntry) =>
              const Center(child: Text('Product Not Found')),
          showSearchBox: true,
        ),
        items: (String searchString, l) async {
          List<ProductModel> products = controller.storageController
              .getProductList()
              .where((product) => product.description!.contains(searchString))
              .toList();
          products.sort((a, b) => a.description!.compareTo(b.description!));
          return products;
        },
      ),
    );
  }

  Widget _productPriceField() {
    return CustomFormField(
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
    );
  }

  Widget _submitButtons(BuildContext context) {
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
                controller.validateInputs();
              }),
          CustomActionButton(
              controller: controller,
              buttonText: 'Cancel',
              buttonColor: Colors.red,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              }),
        ],
      ),
    );
  }
}
