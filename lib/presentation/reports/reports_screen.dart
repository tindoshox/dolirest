import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/reportid_model.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';

import 'controllers/reports_controller.dart';

class ReportsScreen extends GetView<ReportsController> {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        CustomActionButton(
          buttonText: 'Submit',
          onTap: () => controller.validate(),
        )
      ],
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: FormBuilder(
        key: controller.reportFormKey,
        child: Obx(
          () => Card(
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                //
                // Select Report
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownSearch<ReportIdModel>(
                    onChanged: (report) {
                      controller.selectedReport.value = report!;
                    },
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Report',
                        icon: Icon(Icons.picture_as_pdf_outlined),
                        border: UnderlineInputBorder(),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    itemAsString: (ReportIdModel report) => report.displayName,
                    popupProps: PopupProps.modalBottomSheet(
                        modalBottomSheetProps: ModalBottomSheetProps(
                            padding: const EdgeInsets.only(top: 20),
                            shape: const RoundedRectangleBorder(),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor),
                        title: const Text(
                          'Search Report',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        isFilterOnline: true,
                        itemBuilder:
                            (context, ReportIdModel report, isSelected) {
                          return ListTile(
                            title: Text(report.displayName),
                          );
                        },
                        emptyBuilder: (context, searchEntry) =>
                            const Center(child: Text('Report Not Found')),
                        showSearchBox: true),
                    items: controller.reportList,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                ///
                ///
                /// From Date
                if (controller.selectedReport.value.hasFromDateParameter)
                  CustomFormField(
                    textInputAction: TextInputAction.next,
                    name: 'from_date',
                    prefixIcon: const Icon(Icons.date_range),
                    controller: controller.fromDateController,
                    labelText: 'From Date',
                    suffix: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => controller.setFromDate()),
                  ),

                ///
                ///
                /// To Date
                if (controller.selectedReport.value.hasToDateParameter)
                  CustomFormField(
                    name: 'to_date',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.date_range),
                    controller: controller.toDateController,
                    labelText: 'To Date',
                    suffix: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => controller.setToDate()),
                  ),

                /// Group List
                if (controller.selectedReport.value.hasGroupParameter)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownSearch<GroupModel>(
                      onChanged: (group) {
                        controller.selectedGroup.value = group!;
                      },
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
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor),
                          title: const Text('Search Group',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          isFilterOnline: true,
                          itemBuilder: (context, GroupModel group, isSelected) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
