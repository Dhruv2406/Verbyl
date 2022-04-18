import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

Future<String> getUserData(http.Client client, String email) async {
  final response = await http.post(
      Uri.parse(
        'https://verbyl24.000webhostapp.com/getUser.php',
      ),
      body: {"email": email});
  if (response.statusCode == 200) {
    var user = jsonDecode(response.body);
    if(response.body == "[]"){
      return "User with email: " + email + " not found";
    }
    else {
      return user[0]["Name"];
    }
  } else {
    return "Error";
  }
}

class MockClient extends Mock implements http.Client {
  MockClient(Future Function(dynamic request) param0);
}

main() {
  group('getUserData() : ', () {
    test(' 1. Returns user name if user found', () async {
      final mockHTTPClient = MockClient((request) async {
        final response = {
          {
            "UId": "1",
            "Name": "Divyam Mistry",
            "Email": "divsmistry30@gmail.com"
          }
        };
        return Response(jsonEncode(response), 200);
      });
      expect(await getUserData(mockHTTPClient, "divsmistry30@gmail.com"), 'Divyam Mistry');
      print("Expected output : Divyam Mistry");
      print("Generated output  : " + await getUserData(mockHTTPClient, "divsmistry30@gmail.com"));
    });

    test('2. Returns error message if user not found', () async {
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 200);
      });
      expect(await getUserData(mockHTTPClient, "random@gmail.com"), "User with email: random@gmail.com not found");
      print("Expected output : User with email: random@gmail.com not found");
      print("Generated output  : " + await getUserData(mockHTTPClient, "random@gmail.com"));
    });
  });
}
