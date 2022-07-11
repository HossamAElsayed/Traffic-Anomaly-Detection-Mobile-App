import 'package:adtracker/UI/shared/constants.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

// const String host = 'http://40.77.47.208/';

class DataBaseRepo {
  var url = Uri.parse('http://${mainEndPoint}/insert_data.php');

  Future<bool> sendData(
    String id,
    String speed,
    String lati,
    String long,
    XFile img,
    String dt,
  ) async {
    var url = Uri.parse('http://${mainEndPoint}/insert_data.php');
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['rid'] = id;
      request.fields['speed'] = speed;
      request.fields['lati'] = lati;
      request.fields['long'] = long;
      request.fields['date_time'] = dt;
      request.fields['name'] = img.path.split('/').last;
      var pic = await http.MultipartFile.fromPath('image', img.path);
      request.files.add(pic);
      var response = await request.send();
      print("Response status: ${response.statusCode} ");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<String>> syncData(String uid) async {
    var url = Uri.parse('http://${mainEndPoint}/sync.php');
    var response = await http.post(url, body: {'uid': uid});
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    List<String> res = response.body.trim().split('\n');
    return res;
  }
  // Future<void> insertData(String? speed, String? long, String? lati) async {
  //   final response = await http.post(url, body: {
  //     "speed": speed,
  //     "lati": lati,
  //     "long": long,
  //   });
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  // }

  // Future<void> uploadFile(String fileName, String base64Image) async {
  //   var url = Uri.parse('${host}upload_file.php');
  //   http.post(url, body: {
  //     "image": base64Image,
  //     "name": fileName,
  //   }).then((response) {
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }).catchError((error) {
  //     print('Response status: $error');
  //   });
  // }
  //   Future<void> uploadFile(String fileName, String base64Image) async {
  //   var url = Uri.parse('http://$mainEndPoint/upload_file.php');
  //   http.post(url, body: {
  //     "image": base64Image,
  //     "name": fileName,
  //   }).then((response) {
  //     debugPrint('Response status: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');
  //     showASnackBar(context, '${response.statusCode} \n ${response.body}');
  //   }).catchError((error) {
  //     debugPrint('Response error: $error');
  //   });
  // }

  // Future<void> upload(XFile img) async {
  //   final uri = Uri.parse('http://$mainEndPoint/test.php');
  //   var request = http.MultipartRequest('POST', uri);
  //   request.fields['name'] = img.path.split('/').last;
  //   var pic = await http.MultipartFile.fromPath('image', img.path);
  //   request.files.add(pic);
  //   var response = await request.send();
  //   debugPrint(
  //       "response.statusCode: ${response.statusCode} ${response.request}");
  // }

}
