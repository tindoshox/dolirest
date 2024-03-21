import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
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
            controller.customerId.isEmpty ? 'New Customer' : 'Edit Customer'),
      ),
      body: Center(
        child: controller.isLoading.value
            ? const LoadingIndicator(message: Text('Loading...'))
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
            if (controller.customerId.isEmpty) _buildGroupDropdown(context),
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
      prefixIcon: const Icon(Icons.person_add),
      controller: controller.nameController,
      validator: (name) => GetUtils.isLengthEqualTo(name, 0)
          ? 'Customer Name is required'
          : null,
      labelText: 'Customer Name',
      autofocus: true,
    );
  }

  Widget _buildCityAutocomplete() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return controller.towns;
        }
        return controller.towns
            .where((String town) => town.startsWith(textEditingValue.text));
      },
      onSelected: (town) {
        controller.townController.text = town.trim();
        controller.getAddressSuggestions(town: town.trim());
      },
      fieldViewBuilder: (context, townController, focusNode, onFieldSubmitted) {
        return CustomFormField(
          prefixIcon: const Icon(Icons.location_city),
          onFieldSubmitted: (town) {
            controller.getAddressSuggestions(town: town!.trim());
          },
          onChanged: (town) {
            controller.getAddressSuggestions(town: town!.trim());
            controller.townController.text = town.trim();
          },
          name: 'customer_city',
          controller: controller.customerId == ''
              ? townController
              : controller.townController,
          focusNode: focusNode,
          validator: (city) =>
              GetUtils.isLengthLessThan(city, 3) ? 'City is required' : null,
          labelText: 'City',
        );
      },
    );
  }

  Widget _buildAddressAutocomplete() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return controller.addresses;
        }
        return controller.addresses
            .where((String address) => address.contains(textEditingValue.text));
      },
      onSelected: (address) {
        controller.addressController.text = address.trim();
      },
      fieldViewBuilder: (BuildContext context, addressController, focusNode,
          onFieldSubmitted) {
        return CustomFormField(
          prefixIcon: const Icon(Icons.location_pin),
          onChanged: (address) =>
              controller.addressController.text = address!.trim(),
          name: 'customer_address',
          controller: controller.customerId == ''
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
  }

  Widget _buildGroupDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownSearch<GroupModel>(
        onChanged: (group) {
          controller.selectedGroup.value = group!;
        },
        validator: (value) => value == null ? 'Group is required' : null,
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: 'Group',
            icon: Icon(Icons.group_outlined),
            border: UnderlineInputBorder(),
            errorBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
        itemAsString: (GroupModel group) => group.name,
        popupProps: PopupProps.modalBottomSheet(
          modalBottomSheetProps: ModalBottomSheetProps(
            shape: const RoundedRectangleBorder(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          title: const Text('Search Group',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          isFilterOnline: true,
          itemBuilder: (context, GroupModel group, isSelected) {
            return ListTile(
              title: Text(group.name),
            );
          },
          emptyBuilder: (context, searchEntry) =>
              const Center(child: Text('Group Not Found')),
          showSearchBox: true,
        ),
        asyncItems: (String searchString) async {
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
      prefixIcon: const Icon(Icons.phone_callback),
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
      prefixIcon: const Icon(Icons.phone_enabled),
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
            buttonColor: Colors.red,
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
