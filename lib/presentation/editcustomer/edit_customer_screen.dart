import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'controllers/editcustomer_controller.dart';

class EditcustomerScreen extends GetView<EditcustomerController> {
  const EditcustomerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: Center(
        child: controller.isLoading.value
            ? const CircularProgressIndicator()
            : FormBuilder(
                key: controller.customerFormKey,
                child: Card(
                  child: ListView(children: [
                    CustomFormField(
                      name: 'customer_name',
                      textCapitalization: TextCapitalization.characters,
                      prefixIcon: const Icon(Icons.person_add),
                      controller: controller.nameController,
                      validator: (name) => GetUtils.isLengthEqualTo(name, 0)
                          ? 'Customer Name is required'
                          : null,
                      labelText: 'Customer Name',
                    ),
                    CustomFormField(
                      name: 'customer_address',
                      textCapitalization: TextCapitalization.characters,
                      prefixIcon: const Icon(Icons.location_pin),
                      controller: controller.addressController,
                      validator: (address) =>
                          GetUtils.isLengthEqualTo(address, 0)
                              ? 'Address is required'
                              : null,
                      labelText: 'Address',
                    ),
                    CustomFormField(
                      name: 'customer_city',
                      textCapitalization: TextCapitalization.characters,
                      prefixIcon: const Icon(Icons.location_city),
                      controller: controller.townController,
                      labelText: 'City',
                      validator: (city) => GetUtils.isLengthEqualTo(city, 0)
                          ? 'Customer Name is required'
                          : null,
                    ),
                    if (controller.customerId.isEmpty)

                      /// Group List
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownSearch<GroupModel>(
                          onChanged: (group) {
                            controller.selectedGroup.value = group!;
                          },
                          validator: (value) =>
                              value == null ? 'Group is required' : null,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Group',
                              icon: Icon(Icons.group_outlined),
                              border: UnderlineInputBorder(),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          itemAsString: (GroupModel group) => '${group.name}',
                          popupProps: PopupProps.modalBottomSheet(
                              modalBottomSheetProps: ModalBottomSheetProps(
                                  shape: const RoundedRectangleBorder(),
                                  backgroundColor: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              title: const Text('Search Group',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              isFilterOnline: true,
                              itemBuilder:
                                  (context, GroupModel group, isSelected) {
                                return ListTile(
                                  title: Text('${group.name}'),
                                );
                              },
                              emptyBuilder: (context, searchEntry) =>
                                  const Center(child: Text('Group Not Found')),
                              showSearchBox: true),
                          asyncItems: (String searchString) async {
                            List<GroupModel> groups =
                                await controller.fetchGroups(searchString);
                            return groups;
                          },
                        ),
                      ),
                    CustomFormField(
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
                        }),
                    CustomFormField(
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
                        }),
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
      ),
    );
  }
}
