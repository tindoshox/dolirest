import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';

import 'controllers/settings.controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsScreen'),
        centerTitle: true,
      ),
      body: ListView(children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              textAlign: TextAlign.justify,
              'About API Keys \n\n'
              'The API key is your private secret and should never be made public. This API key is used to connect this app without a usernamer or password.',
            ),
          ),
        ),
        Card(
          child: FormBuilder(
            key: controller.serverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomFormField(
                    name: 'server_url',
                    labelText: 'Server Url',
                    textCapitalization: TextCapitalization.none,
                    controller: controller.urlController,
                    autocorrect: false,
                    enableSuggestions: true,
                    enableInteractiveSelection: true,

                    /// Returns an error message if the URL is empty or not a valid URL.
                    validator: (url) {
                      if (url!.isEmpty) {
                        return 'URL is required';
                      }
                      if (!GetUtils.isURL(url)) {
                        return 'Invalid URL';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomFormField(
                    suffix: IconButton(
                        onPressed: () => controller.getClipboardText(),
                        icon: const Icon(Icons.paste_outlined)),
                    name: 'api_key',
                    labelText: 'API Key',
                    controller: controller.apiController,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.done,
                    minLines: 3,
                    maxLines: 5,
                    enableInteractiveSelection: true,
                    keyboardType: TextInputType.multiline,

                    /// Returns an error message if the API key is empty.
                    validator: (apiKey) => GetUtils.isLengthEqualTo(apiKey, 0)
                        ? 'API Key is required'
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomActionButton(
                        controller: controller,
                        buttonText: 'Save',

                        /// Calls the controller's `validate` method when the button is tapped.
                        onTap: () {
                          controller.validate();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
