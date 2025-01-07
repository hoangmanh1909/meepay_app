import 'package:flutter/material.dart';
import 'package:meepay_app/models/response/dictionary_response.dart';
import 'package:meepay_app/utils/color_mp.dart';

class BankDialog extends StatelessWidget {
  const BankDialog({super.key, required this.banks});

  final List<DictionaryResponse> banks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: banks.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(banks[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              "${banks[index].code!.trim()} - ${banks[index].name!.trim()}",
                            ),
                          ),
                          const Divider(
                            height: 10,
                          )
                        ],
                      ));
                })));
  }
}
