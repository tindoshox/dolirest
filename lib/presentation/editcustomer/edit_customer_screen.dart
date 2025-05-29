import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'controllers/editcustomer_controller.dart';

class EditCustomerScreen extends GetView<EditCustomerController> {
  const EditCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            controller.customerId == null ? 'New Customer' : 'Edit Customer'),
        actions: [Obx(() => getStatusIcon())],
      ),
      body: Center(
        child: controller.isLoading.value
            ? const LoadingIndicator(
                message: Text('Loading customer invoices...'))
            : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.customerFormKey,
      child: Card(
        child: ListView(
          children: [
            _buildNameField(),
            _buildCityAutocomplete(),
            _buildAddressAutocomplete(),
            if (controller.customerId == null) _buildGroupDropdown(context),
            _buildPhoneField(),
            _buildFaxField(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomFormField(
      name: 'customer_name',
      textCapitalization: TextCapitalization.characters,
      prefixIcon: const Icon(
        Icons.person_add,
        color: Colors.blueAccent,
      ),
      controller: controller.nameController,
      validator: (name) => GetUtils.isLengthEqualTo(name, 0)
          ? 'Customer Name is required'
          : null,
      labelText: 'Customer Name',
      autofocus: true,
    );
  }

  Widget _buildCityAutocomplete() {
    return Obx(() {
      final addresses =
          controller.addresses.map((a) => a.town.toString().toUpperCase());
      final towns = addresses.toSet().toList();
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return towns;
          }
          return towns.where((String town) => town
              .toString()
              .toUpperCase()
              .startsWith(textEditingValue.text.toUpperCase()));
        },
        onSelected: (town) {
          controller.selectedTown.value = town;
          controller.townController.text = town.trim().toUpperCase();
        },
        fieldViewBuilder:
            (context, townController, focusNode, onFieldSubmitted) {
          return CustomFormField(
            prefixIcon: const Icon(
              Icons.location_city,
              color: Colors.greenAccent,
            ),
            onChanged: (town) {
              if (town != null && town.isNotEmpty) {
                controller.selectedTown.value = town;
                controller.townController.text = town.trim().toUpperCase();
              }
            },
            name: 'customer_city',
            controller: controller.customerId == null
                ? townController
                : controller.townController,
            focusNode: focusNode,
            validator: (city) =>
                GetUtils.isLengthLessThan(city, 3) ? 'City is required' : null,
            labelText: 'City',
          );
        },
      );
    });
  }

  Widget _buildAddressAutocomplete() {
    return Obx(() {
      var list = controller.addresses
          .where((a) => a.town == controller.selectedTown.value)
          .toList();
      var filteredList = list.map((l) => l.address!.toUpperCase()).toList();
      var addresses = filteredList.toSet().toList();

      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return addresses;
          } else {
            return addresses.where(
              (String addr) => addr.startsWith(
                textEditingValue.text.toUpperCase(),
              ),
            );
          }
        },
        onSelected: (address) {
          controller.addressController.text = address.trim().toUpperCase();
        },
        fieldViewBuilder: (BuildContext context, addressController, focusNode,
            onFieldSubmitted) {
          return CustomFormField(
            prefixIcon: const Icon(
              Icons.location_pin,
              color: Colors.orangeAccent,
            ),
            onChanged: (address) => controller.addressController.text =
                address!.trim().toUpperCase(),
            name: 'customer_address',
            controller: controller.customerId == null
                ? addressController
                : controller.addressController,
            focusNode: focusNode,
            validator: (address) => GetUtils.isLengthLessThan(address, 3)
                ? 'Address is required'
                : null,
            labelText: 'Address',
          );
        },
      );
    });
  }

  Widget _buildGroupDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownSearch<GroupModel>(
        onChanged: (group) {
          if (group != null) {
            controller.selectedGroup.value = group;
          } else {
            controller.clearGroup();
          }
        },
        compareFn: (item1, item2) => item1.id == item2.id,
        validator: (value) => value == null ? 'Group is required' : null,
        decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: 'Group',
            prefixIcon: Icon(
              Icons.group_outlined,
              color: Colors.brown,
            ),
          ),
        ),
        itemAsString: (GroupModel group) => group.name!,
        suffixProps: const DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(isVisible: true)),
        popupProps: PopupProps.modalBottomSheet(
          modalBottomSheetProps: ModalBottomSheetProps(
            shape: const OutlineInputBorder(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          title: const Text('Search Group',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          itemBuilder: (context, group, isSelected, l) {
            return ListTile(
              title: Text(group.name!),
            );
          },
          emptyBuilder: (context, searchEntry) =>
              const Center(child: Text('Group Not Found')),
          showSearchBox: true,
        ),
        items: (String searchString, l) async {
          List<GroupModel> groups =
              await controller.getGroups(search: searchString);
          return groups;
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    return CustomFormField(
      name: 'customer_phone',
      prefixIcon: const Icon(
        Icons.phone_callback,
        color: Colors.redAccent,
      ),
      controller: controller.phoneController,
      keyboardType: TextInputType.number,
      labelText: 'Phone 1',
      validator: (phone) {
        if (phone!.isNotEmpty &&
            !(phone.length == 10 && phone.startsWith("0"))) {
          return 'Must be 10 digits and start with "0"';
        }
        return null;
      },
    );
  }

  Widget _buildFaxField() {
    return CustomFormField(
      textInputAction: TextInputAction.done,
      name: 'customer_fax',
      prefixIcon: const Icon(
        Icons.phone_enabled,
        color: Colors.redAccent,
      ),
      controller: controller.faxController,
      keyboardType: TextInputType.number,
      labelText: 'Phone 2',
      validator: (fax) {
        if (fax!.isNotEmpty &&
            !(fax.length == 10 &&
                fax.startsWith("0") &&
                controller.faxController.text !=
                    controller.phoneController.text)) {
          return 'Must be 10 digits and different from phone';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons() {
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
              controller.validateAndSave();
            },
          ),
          CustomActionButton(
            controller: controller,
            buttonText: 'Cancel',
            isCancel: true,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
