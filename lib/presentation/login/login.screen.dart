import 'package:dolirest/presentation/widgets/app_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';

import 'controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(children: [
        Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset(
                AppImageUrl.logo,
                height: 50,
                width: 50,
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'Doli',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'REST',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Form(
            key: controller.serverFormKey,
            child: Column(
              children: [
                _buildUrlField(),
                const SizedBox(height: 5),
                _buildKeyField(),
                const SizedBox(height: 10),
                _bulidLoginButton(),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Padding _buildUrlField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomFormField(
        prefixText: 'https://',
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
    );
  }

  Padding _buildKeyField() {
    return Padding(
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
        validator: (apiKey) =>
            GetUtils.isLengthEqualTo(apiKey, 0) ? 'API Key is required' : null,
      ),
    );
  }

  Padding _bulidLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
    );
  }
}
