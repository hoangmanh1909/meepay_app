import 'package:flutter/material.dart';
import 'package:meepay_app/models/response/account_search_response.dart';
import 'package:meepay_app/utils/common.dart';

bottomSheet(BuildContext context, List<AccountSearchResponse> models,
    Function callBack) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 1,
          snap: true,
          expand: false,
          snapSizes: const [
            0.55,
            1,
          ],
          builder: (context, scrollController) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                    child: Text(
                      "Chọn tài khoản",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: models.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            AccountSearchResponse e = models[index];
                            return InkWell(
                                onTap: () {
                                  callBack(e);
                                },
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    ]));
                          })),
                ],
              ),
            );
          });
    },
  );
}
