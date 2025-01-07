// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:meepay_app/models/response/dictionary_response.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';

class BankDialog extends StatelessWidget {
  const BankDialog({super.key, required this.banks});

  final List<DictionaryResponse> banks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorMP.ColorBackground,
        appBar: AppBar(
          backgroundColor: ColorMP.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('Chọn ngân hàng'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            margin: const EdgeInsets.all(8.0),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: banks.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(banks[index]);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, boxShadow: [boxShadow()]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: Image(
                                image: AssetImage('assets/img/vietinbank.png'),
                                width: 60,
                                height: 40,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      banks[index].shortName!.trim(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      banks[index].name!.trim(),
                                      softWrap: true,
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                  );
                })));
  }
}
