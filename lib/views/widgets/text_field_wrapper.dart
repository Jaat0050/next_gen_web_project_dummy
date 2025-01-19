import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';


class TextFieldWrapper {
  final _controller = TextEditingController().obs;

  TextEditingController get controller => this._controller.value;

  set controller(TextEditingController value) => this._controller.value = value;

  final RxString _errorText = RxString("");

  String get errorText => this._errorText.value;

  set errorText(String value) => this._errorText.value = value;

  TextFieldWrapper() {
    controller = TextEditingController();
  }

  factory TextFieldWrapper.withValue({
    TextEditingController? controller,
    String? errorText,
  }) {
    final wrap = TextFieldWrapper();
    wrap.controller = controller ?? TextEditingController();
    wrap.errorText = errorText ?? "";
    return wrap;
  }
}