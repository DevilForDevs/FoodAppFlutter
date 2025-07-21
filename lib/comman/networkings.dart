import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';


// Shared domain variable
const String domain = 'https://jalebi.shop';

/// Sends a login POST request and returns the raw JSON string response (or null on failure)
Future<String> login(String email, String password) async {
  final url = Uri.parse('$domain/api/login');

  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({'email': email, 'password': password});

  final response = await http.post(url, headers: headers, body: body);
  return response.body;
}

Future<bool> checkConnectivity() async {
  final ConnectivityResult result = await Connectivity().checkConnectivity();

  switch (result) {
    case ConnectivityResult.mobile:
    case ConnectivityResult.wifi:
    case ConnectivityResult.ethernet:
      return true;

    case ConnectivityResult.none:
    default:
      return false;
  }
}

Future<String> signup({
  required String name,
  required String email,
  required String password,
  required String accountType,
}) async {
  final url = Uri.parse('https://jalebi.shop/api/signup'); // Replace with your actual API URL

  try {
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'account_type': accountType,
      }),
    );
    return response.body;
  } catch (e) {
    return jsonEncode({
      "message":e.toString()
    });
  }
}


Future<Map<String, dynamic>> sendOtp(String userEmail, String userType) async {
  final url = Uri.parse('$domain/api/sendOtp');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': userEmail, 'user_type': userType}),
    );
    return jsonDecode(response.body);
  } catch (e) {
    return {'error message': e.toString()};
  }
}

Future<String> changePassword(String email, String newPassword) async {
  final String url = '$domain/api/changePassword';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'new_password': newPassword}),
    );

    return response.body;
  } catch (e) {
    return 'error message: ${e.toString()}';
  }
}

Future<Map<String, dynamic>> getAddress(String userId, String token) async {
  final url = Uri.parse('$domain/api/getAddress');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'error': 'Server responded with status: ${response.statusCode}',
        'body': jsonDecode(response.body),
      };
    }
  } catch (e) {
    return {'error message': e.toString()};
  }
}

Future<String> updateAvatar(
  String avatarUrl,
  String token,
) async {
  final url = Uri.parse('$domain/api/updateAvatar');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'avatar_url': avatarUrl}),
    );
    return response.body;
  } catch (e) {
    return jsonEncode({"error message": e.toString()});
  }
}

Future<String> addAddress(
    String longAddress,
    String city,
    String pinCode,
    String village,
    String addressType,
    String token,
    ) async {
  final url = Uri.parse('$domain/api/addAddress');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'longAddress': longAddress,
        "city": city,
        "village": village,
        "pincode": pinCode,
        "addressType": addressType,
      }),
    );
    return response.body;
  } catch (e) {
    return jsonEncode({"error message": e.toString()});
  }
}

Future<String> updateAddress(
  String addressId,
  String longAddress,
  String city,
  String pinCode,
  String village,
  String addressType,
  String token,
) async {
  final url = Uri.parse('$domain/api/updateAddress');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'address_id': addressId,
        'longAddress': longAddress,
        "city": city,
        "village": village,
        "pincode": pinCode,
        "addressType": addressType,
      }),
    );
    return response.body;
  } catch (e) {
    return jsonEncode({"error message": e.toString()});
  }
}

Future<Object> getRestrictedItems(String token) async {
  final url = Uri.parse('$domain/api/getRestrictedItems');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({

      }),
    );

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded; // List of items
    } else if (decoded is Map) {
      return decoded; // Possibly an error or object
    } else {
      return {'error_message': 'Unexpected response type'};
    }
  } catch (e) {
    return {'error_message': e.toString()};
  }
}

Future<Object> getAllItems(String token) async {
  final url = Uri.parse('$domain/api/getItems');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },

    );
    return jsonDecode(response.body);


  } catch (e) {
    return {'error_message': e.toString()};
  }
}


Future<String> addOrder(
    String token,
    String userId,
    String addressId,
    String itemId,
    String contact,
    int quantity,
    int price,
    String method,
    {String status = "confirmed"} // default status
    ) async {
  final url = Uri.parse('$domain/api/addOrder');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_id': userId,
        'address': addressId,
        'item': itemId,
        'contact': contact,
        'quantity': quantity,
        'price': price,
        'method': method,
        'status': status,
      }),
    );
    return response.body;

  } catch (e) {
   return('error message: $e');
  }
}

Future<Object> getOrders(String token) async {
  final url = Uri.parse('$domain/api/getOrders');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({

      }),
    );

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded; // List of items
    } else if (decoded is Map) {
      return decoded; // Possibly an error or object
    } else {
      return {'error_message': 'Unexpected response type'};
    }
  } catch (e) {
    return {'error_message': e.toString()};
  }
}

Future<Object> syncMessages({
  required int chatWithId,
  String? newMessage,
  List<int> seenIds = const [],
  required String bearerToken,
}) async {
  try {
    final url = Uri.parse('$domain/api/messageSync');

    final headers = {
      'Authorization': 'Bearer $bearerToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json', // ✅ very important
    };

    final body = jsonEncode({ // ✅ encode entire body to JSON string
      'chat_with': chatWithId,
      'message': newMessage,
      'seen_ids': seenIds, // ✅ this will become a proper JSON array
    });

    final response = await http.post(url, headers: headers, body: body);

    return response.body;
  } catch (e) {
    return jsonEncode({
      "error": e.toString(),
    });
  }
}
Future<String> updateProfileName(String newName, String authToken) async {
  final url = Uri.parse('$domain/api/updateProfileName');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // if you're using Laravel Sanctum or Passport
      },
      body: json.encode({
        'newName': newName,
      }),
    );
    return response.body;


  } catch (e) {
    return jsonEncode({
      "error message": e.toString(),
    });
  }
}

Future<String> updateProfileEmail(String newEmail, String authToken) async {
  final url = Uri.parse('$domain/api/updateEmail');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // if you're using Laravel Sanctum or Passport
      },
      body: json.encode({
        'new_email':newEmail,
      }),
    );
    return response.body;


  } catch (e) {
    return jsonEncode({
      "error message": e.toString(),
    });
  }
}

Future<String> deleteAccount(String authToken) async {
  final url = Uri.parse('$domain/api/deleteAccount');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // if you're using Laravel Sanctum or Passport
      },
      body: json.encode({

      }),
    );
    return response.body;

  } catch (e) {
    return jsonEncode({
      "error message": e.toString(),
    });
  }
}

Future<void> avatarUpload({
  required File file,
  required String accessToken,
  required int userId,
  required void Function(int progress, String message) listener,
}) async {
  final dio = Dio();
  final fileName = path.basename(file.path);
  final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

  try {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ),
      'metadata': jsonEncode({
        'userId': userId,
        'description': 'A nice picture',
      })
    });

    final response = await dio.post(
      '$domain/api/uploadImage',
      data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken', // <-- Add token here
            'Content-Type': 'multipart/form-data',  // Optional, but recommended
          },
        ),
      onSendProgress: (int sent, int total) {
        final progress = ((sent / total) * 100).toInt();
        listener(progress, 'Uploading');
      },

    );
    if(response.statusCode==402){
      print("Unauthorized");
    }

    if (response.statusCode == 200 && response.data is Map) {
      final fileUrl = response.data['file_url'] ?? 'Upload failed';
      listener(100, fileUrl);
    } else {
      listener(-1, 'Failed To Upload');
    }
  } catch (e) {
    listener(-1, 'Failed To Upload');
    print(e);
  }
}

Future<String?> downloadFile(
    String url, {
      required String savePath,
      Function(int percent)? onProgress,
    }) async {
  try {
    final uri = Uri.parse(url);
    final request = http.Request('GET', uri);
    final response = await http.Client().send(request);

    if (response.statusCode != 200) {
      print("Failed to download file: ${response.statusCode}");
      return null;
    }

    final contentLength = response.contentLength ?? 0;
    final file = File(savePath);
    final sink = file.openWrite();

    int downloaded = 0;
    await for (var chunk in response.stream) {
      downloaded += chunk.length;
      sink.add(chunk);

      if (contentLength != 0 && onProgress != null) {
        final percent = ((downloaded / contentLength) * 100).toInt();
        onProgress(percent);
      }
    }

    await sink.flush();
    await sink.close();

    return savePath;
  } catch (e) {
    print("Download error: $e");
    return null;
  }
}

Future<Object> searchItems(String token,String query) async {
  final url = Uri.parse('$domain/api/search');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "query":query

      }),
    );

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded; // List of items
    } else if (decoded is Map) {
      return decoded; // Possibly an error or object
    } else {
      return {'error_message': 'Unexpected response type'};
    }
  } catch (e) {
    return {'error_message': e.toString()};
  }
}

Future<String> cancelOrder(String authToken,int orderId) async {
  final url = Uri.parse('$domain/api/cancelOrder');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // if you're using Laravel Sanctum or Passport
      },
      body: json.encode({
        "order_id":orderId
      }),
    );
    return response.body;

  } catch (e) {
    return jsonEncode({
      "error message": e.toString(),
    });
  }
}
/*qrlLogin*/

Future<String> qrLogin(int userId,String name) async {
  final url = Uri.parse('$domain/api/qrlLogin');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "userId":userId,
        "name":name
      }),
    );
    return response.body;

  } catch (e) {
    return jsonEncode({
      "error message": e.toString(),
    });
  }
}







