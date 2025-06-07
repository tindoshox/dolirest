import 'package:dolirest/infrastructure/dal/models/product/product_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/invoicedetail/components/invoice_detail_widget.dart';
import 'package:dolirest/presentation/invoicedetail/components/payment_list.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/invoice_detail_controller.dart';

class InvoiceDetailScreen extends GetView<InvoiceDetailController> {
  const InvoiceDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: _buildFooterButtons(context),
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingIndicator(
                message: Text('Loading payment history...'),
              )
            : TabBarView(
                controller: controller.tabController,
                children: [
                  invoiceDetailWidget(
                      context: context,
                      onPressed: () {
                        if (Get.find<NetworkController>().connected.value) {
                          controller.setDueDate();
                        }
                      },
                      customer: controller.customer.value,
                      invoice: controller.document.value),
                  controller.document.value.totalpaid == 0
                      ? const ListTile(
                          title: Text(
                            'No payments.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: paymentsList(
                            context,
                            controller.document.value.totalTtc,
                            controller.payments,
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  _buildAppBar() {
    final document = controller.document.value;
    return AppBar(
      title: const Text('Invoice Detail'),
      actions: [
        getStatusIcon(
          onPressed: () => controller.refreshInvoiceData(),
        ),
        if (document.type == DocumentType.invoice &&
            document.paye == PaidStatus.unpaid &&
            document.remaintopay != "0")
          _getMenu()
      ],
      bottom: TabBar(
          controller: controller.tabController, tabs: controller.invoiceTabs),
    );
  }

  _getMenu() {
    return PopupMenuButton(
      onSelected: (item) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Return Item'),
          onTap: () => controller.createCreditNote(productReturned: true),
        ),
        PopupMenuItem(
          child: Text('Write-off Item'),
          onTap: () => controller.createCreditNote(productReturned: false),
        )
      ],
    );
  }

  _buildFooterButtons(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() {
            var connected = Get.find<NetworkController>().connected.value;
            var document = controller.document.value;
            return Row(
              children: [
                //Show Edit Draft Button
                if (document.status == ValidationStatus.draft &&
                    document.lines.isEmpty)
                  CustomActionButton(
                      buttonText: 'Edit', onTap: () => _addProduct(context)),
                //Show button to validate a draft
                if (document.status == ValidationStatus.draft &&
                    document.paye == PaidStatus.unpaid &&
                    document.lines.isNotEmpty)
                  CustomActionButton(
                    buttonText: 'Validate',
                    onTap: () => connected
                        ? controller.validateDocument(
                            id: document.documentId,
                            invoiceValidation:
                                document.type == DocumentType.invoice)
                        : SnackBarHelper.networkSnackbar(),
                  ),
                //Close a credit note
                if (document.status == ValidationStatus.creditAvalable &&
                    document.type == DocumentType.typeCreditNote &&
                    document.paye == PaidStatus.unpaid)
                  CustomActionButton(
                    buttonText: 'Close',
                    onTap: () => controller.closeCreditNote(),
                  ),
                //Show payment button
                if (document.type == DocumentType.invoice &&
                    document.status == ValidationStatus.validated &&
                    document.remaintopay != "0")
                  CustomActionButton(
                    buttonText: 'Payment',
                    onTap: () => connected
                        ? Get.toNamed(
                            Routes.PAYMENT,
                            arguments: {
                              'invoiceId': controller.document.value.documentId,
                              'socid': controller.customer.value.customerId,
                            },
                          )
                        : SnackBarHelper.networkSnackbar(),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (document.status == ValidationStatus.draft &&
                    document.paye == PaidStatus.unpaid)
                  CustomActionButton(
                    isCancel: true,
                    buttonText: 'Delete',
                    onTap: () => connected
                        ? controller.deleteDocument(
                            documentId: document.documentId,
                            entityId: document.id)
                        : SnackBarHelper.networkSnackbar(),
                  ),
                if (document.type == DocumentType.invoice &&
                    document.status == ValidationStatus.validated)
                  CustomActionButton(
                    buttonText: 'Statement',
                    onTap: () => Get.find<NetworkController>().connected.value
                        ? controller.generatePDF()
                        : SnackBarHelper.networkSnackbar(),
                  ),
              ],
            );
          })
        ],
      ),
    ];
  }

  _addProduct(BuildContext context) {
    return Get.defaultDialog(
        title: 'Add Product',
        content: Form(
          key: controller.addProductKey,
          child: Obx(
            () => Column(
              children: [
                _productTypeSection(),
                if (controller.productType.value == '1')
                  _freeTextField()
                else
                  _productListDropdown(context),
                _productPriceField(),
                _submitButtons(context),
              ],
            ),
          ),
        ));
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
                    groupValue: controller.productType.value,
                    onChanged: (value) {
                      controller.setStockType(value.toString());
                    }),
                title: const Text('Free Text'),
              ),
            ),
            if (controller.moduleProductEnabled.value)
              Flexible(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Radio(
                      value: '0',
                      groupValue: controller.productType.value,
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
      prefixIcon: const Icon(
        Icons.inventory_sharp,
        color: Colors.brown,
      ),
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
      child: DropdownSearch<ProductEntity>(
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
        decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: 'Product',
            prefixIcon: Icon(
              Icons.inventory_sharp,
              color: Colors.brown,
            ),
          ),
        ),
        itemAsString: (ProductEntity product) => '${product.label}',
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
          List<ProductEntity> products =
              controller.searchProduct(searchString: searchString);
          return products;
        },
      ),
    );
  }

  Widget _productPriceField() {
    return CustomFormField(
      name: 'product_price',
      prefixIcon: const Icon(
        Icons.currency_exchange,
        color: Colors.greenAccent,
      ),
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
          SizedBox(width: 3),
          CustomActionButton(
              controller: controller,
              buttonText: 'Cancel',
              isCancel: true,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              }),
        ],
      ),
    );
  }
}
