// import 'package:farstore/constants/error_handeling.dart';
// import 'package:farstore/constants/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class RatingServices {
//   void rateProduct({
//     required BuildContext context,
//     required Product product,
//     required double rating,
//   }) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     try {
//       http.Response res = await http.post(
//         Uri.parse('$uri/api/rate-product'),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': userProvider.user.token,
//         },
//         body: jsonEncode({
//           'id': product.id!,
//           'rating': rating,
//         }),
//       );

//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () {},
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

// }