import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
        actions: [Obx(() => getStatusIcon())],
      ),
      body: Form(
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
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: 'Report',
                        prefixIcon: Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Colors.brown,
                        ),
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
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
                        itemBuilder: (context, report, isSelected, l) {
                          return ListTile(
                            title: Text(report.displayName),
                          );
                        },
                        emptyBuilder: (context, searchEntry) =>
                            const Center(child: Text('Report Not Found')),
                        showSearchBox: true),
                    items: (searchString, l) => controller.reportList,
                    compareFn: (item1, item2) =>
                        item1.reportid == item2.reportid,
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
                        if (group != null) {
                          controller.selectedGroup.value = group;
                        } else {
                          controller.clearGroup();
                        }
                      },
                      compareFn: (item1, item2) => item1.id == item2.id,
                      suffixProps: const DropdownSuffixProps(
                          clearButtonProps: ClearButtonProps(isVisible: true)),
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
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
                          itemBuilder: (context, group, isSelected, l) {
                            return ListTile(
                              title: Text('${group.name}'),
                            );
                          },
                          emptyBuilder: (context, searchEntry) =>
                              const Center(child: Text('Group Not Found')),
                          showSearchBox: true),
                      items: (String searchString, l) async {
                        List<GroupModel> groups =
                            await controller.getGroups(search: searchString);
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
