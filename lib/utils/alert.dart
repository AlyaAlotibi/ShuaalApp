import 'package:flutter/material.dart';
import 'package:shuaal/utils/colors.dart';
import 'package:shuaal/utils/text.dart';

class Alert {
  show(BuildContext context, title) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    text(text: title, size: 16.0),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          onPressed: () => Navigator.pop(context),
                          color: primary,
                          child: text(
                              text: 'حسنا',
                              size: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ));
  }
}
