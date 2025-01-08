import 'package:flutter/material.dart';
import 'package:meepay_app/models/response/account_search_response.dart';
import 'package:meepay_app/utils/common.dart';

bottomSheet(BuildContext context, List<AccountSearchResponse> models) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (context, scrollController) => Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text("Chọn tài khoản"),
                    ),
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: models.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              AccountSearchResponse e = models[index];
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        textLabel("Chủ tài khoản: "),
                                        Text(
                                          e.name!.trim(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        textLabel("Số tài khoản: "),
                                        Text(
                                          e.accoumtNumber!.trim(),
                                          softWrap: true,
                                        ),
                                      ],
                                    )
                                  ]);
                            })),
                  ],
                ),
              ));
    },
  );
}
