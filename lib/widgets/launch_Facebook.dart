import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchFacebook {
  static void showFacebookChoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("إختر صفحة للتواصل معنا"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.facebook, color: Colors.blue),
                title:  Text("دار الإمام ابن عرفة للنشر - تونس",style: TextStyle(fontSize: MediaQuery.of(context).size.width *  0.05 > 18
                                    ? MediaQuery.of(context).size.width * 0.05
                                    : 18,),),
                onTap: () {
                  launchFacebookPage("https://www.facebook.com/dar.ibnou.arafa/");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.facebook, color: Colors.blue),
                title: Text("معهد الإمام المارغني للقراءات",style: TextStyle(fontSize: MediaQuery.of(context).size.width *  0.05 > 18
                                    ? MediaQuery.of(context).size.width * 0.05
                                    : 18,),),
                onTap: () {
                  launchFacebookPage("https://www.facebook.com/Mereghni.Qeraat/");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void launchFacebookPage(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Impossible d\'ouvrir la page Facebook';
    }
  }
}
