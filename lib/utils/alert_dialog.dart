import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MapAlertDialog {
  static void showAlertDialog(
      {required String dialogName, required BuildContext context}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  icon: const Icon(Icons.cancel))
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/alert_icon.png',
                height: 24,
                width: 24,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                dialogName,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
        );
      },
    );
  }
}
