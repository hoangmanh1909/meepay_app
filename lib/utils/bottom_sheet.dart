import 'package:flutter/material.dart';
import 'package:meepay_app/models/response/account_search_response.dart';

bottomSheet(BuildContext context, List<AccountSearchResponse> models) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: models.map((e) {
              return Text("data");
            }).toList(),
          ),
        ),
      );
    },
  );
}
