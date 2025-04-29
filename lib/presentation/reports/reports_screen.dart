import 'package:dolirest/presentation/widgets/period_dropdown.dart';
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
                    validator: (value) =>
                        value == null ? 'Please select a report' : null,
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
                if (controller.selectedReport.value.hasStartDateParam)
                  CustomFormField(
                    textInputAction: TextInputAction.next,
                    name: 'startdate',
                    prefixIcon: const Icon(Icons.date_range),
                    controller: controller.endDateController,
                    labelText: 'From Date',
                    suffix: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => controller.setStartDate()),
                  ),

                ///
                ///
                /// To Date
                if (controller.selectedReport.value.hasEndDateParam)
                  CustomFormField(
                    name: 'enddate',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.date_range),
                    controller: controller.toEndController,
                    labelText: 'To Date',
                    suffix: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => controller.setEndDate()),
                  ),

                /// Group List
                if (controller.selectedReport.value.hasGroupParam)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownSearch<GroupModel>(
                      validator: (value) {
                        if (controller.selectedReport.value.groupIsRequired &&
                            value == null) {
                          return 'Group is required';
                        } else {
                          return null;
                        }
                      },
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

                //Start Receipt
                if (controller.selectedReport.value.hasStartReceiptParam)
                  CustomFormField(
                    name: 'startreceipt',
                    controller: controller.startReceiptController,
                    validator: (receipt) =>
                        GetUtils.isLengthLessThan(receipt, 3)
                            ? 'Receipt number is required'
                            : null,
                    keyboardType: TextInputType.number,
                    labelText: 'Start Receipt',
                    prefixIcon: const Icon(Icons.receipt_long),
                    autofocus: true,
                  ),

                //End Receipt
                if (controller.selectedReport.value.hasEndReceiptParam)
                  CustomFormField(
                    name: 'endreceipt',
                    controller: controller.endReceiptController,
                    validator: (receipt) =>
                        GetUtils.isLengthLessThan(receipt, 3)
                            ? 'Receipt number is required'
                            : null,
                    keyboardType: TextInputType.number,
                    labelText: 'End Receipt',
                    prefixIcon: const Icon(Icons.receipt_long),
                  ),
                if (controller.selectedReport.value.hasStartPeriodParam)
                  Obx(() => PeriodDropdown(
                        value: controller.startPeriod.value.isEmpty
                            ? null
                            : controller.startPeriod.value,
                        onChanged: (val) =>
                            controller.startPeriod.value = val ?? '',
                        labelText: 'Start Period',
                        hintText: 'Select Start Period',
                        validator: (val) => val == null || val.isEmpty
                            ? 'Start period is required'
                            : null,
                      )),
                SizedBox(height: 16),
                if (controller.selectedReport.value.hasEndPeriodParam)
                  Obx(() => PeriodDropdown(
                        value: controller.endPeriod.value.isEmpty
                            ? null
                            : controller.endPeriod.value,
                        onChanged: (val) =>
                            controller.endPeriod.value = val ?? '',
                        labelText: 'End Period',
                        hintText: 'Select End Period',
                        validator: (val) => val == null || val.isEmpty
                            ? 'End period is required'
                            : null,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
