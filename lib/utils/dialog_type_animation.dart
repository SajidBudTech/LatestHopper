import 'package:flutter_hopper/models/dialog_data.dart';

class DialogTypeAnimation {
  static String getType(DialogType dialogType) {
    String assetName = 'assets/animations/lottie/loading.json';

    if (dialogType == DialogType.loading) {
      assetName = 'assets/animations/lottie/loading.json';
    } else if (dialogType == DialogType.success ||
        dialogType == DialogType.successThenClosePage) {
      assetName = 'assets/animations/lottie/success.json';
    } else if (dialogType == DialogType.warning) {
      assetName = 'assets/animations/lottie/caution.json';
    } else if (dialogType == DialogType.payment) {
      assetName = 'assets/animations/lottie/payment.json';
    } else {
      assetName = 'assets/animations/lottie/other.json';
    }

    return assetName;
  }
}
