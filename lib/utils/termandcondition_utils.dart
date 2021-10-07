import 'package:url_launcher/url_launcher.dart';
class Terms{

  static void lunchTermsAndCondition()async{
    var url="https://lookwhatwemadeyou.com/audiohopper/agreement/";
    if (!url.contains('http')) url = 'https://$url';
    var encoded = Uri.encodeFull(url);
    if (await canLaunch(encoded)) {
    await launch(encoded);
    } else {
    throw 'Could not launch $encoded';
    }
  }

  static void lunchPrivacyPolicy()async{
    var url="https://lookwhatwemadeyou.com/audiohopper/privacy-policy-2/";
    if (!url.contains('http')) url = 'https://$url';
    var encoded = Uri.encodeFull(url);
    if (await canLaunch(encoded)) {
      await launch(encoded);
    } else {
      throw 'Could not launch $encoded';
    }
  }

  static void lunchReadAlong(String url)async{

    if (!url.contains('http')) url = 'https://$url';
    var encoded = Uri.encodeFull(url);
    if (await canLaunch(encoded)) {
      await launch(encoded);
    } else {
      throw 'Could not launch $encoded';
    }
    /*var encoded = Uri.encodeFull(url);
    await launch(encoded);*/

  }

}