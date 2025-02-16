import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRequest {
  final String url;
  final Map<String, dynamic>? data;
  final FormData? formData;
  final storage = const FlutterSecureStorage();

  ApiRequest({
    required this.url,
    this.data,
    this.formData,
  });

  Future<Dio> _dio() async {
    String? token = await storage.read(key: 'accessToken');
    return Dio(
      BaseOptions(
        headers: {
          'authorization': 'Bearer $token',
        },
      ),
    );
  }

  ayncGet({count = 0}) async {
    try {
      var dio = await _dio();
      Response response = await dio.get(url, queryParameters: data);
      return {
        "success": true,
        "data": response.data,
      };
    } on DioException catch (e) {
      if (count < 3) {
        var data =
            "{ path : ${e.requestOptions.path} , title : ${e.response.toString()}}";

        //에러 로그 기록
        // await ErrorLogProvider().writeErrorLog(data);
        await Future.delayed(const Duration(seconds: 5));
        return ayncGet(count: count += 1);
      }

      print(e);

      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  ayncPost() async {
    try {
      var dio = await _dio();
      Response response =
          await dio.post(url, data: data, queryParameters: data);
      return {"success": true, "data": response.data};
    } catch (e) {
      print(e);
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        errorMsg = e.response?.data["message"] ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  ayncPut() async {
    try {
      var dio = await _dio();
      Response response = await dio.put(url, data: data, queryParameters: data);
      return {"success": true, "data": response.data};
    } catch (e) {
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        errorMsg = e.response?.data["message"] ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  ayncDelete() async {
    try {
      var dio = await _dio();
      Response response = await dio.delete(url, data: data);
      return {
        "success": true,
        "data": response.data,
      };
    } catch (e) {
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        errorMsg = e.response?.data["message"] ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }

  formPost() async {
    try {
      var dio = await _dio();
      Response response = await dio.post(url,
          data: FormData.fromMap(data ?? {}),
          options: Options(headers: {
            'Content-type': 'multipart/form-data',
            'Accept': 'application/json',
          }));

      return {"success": true, "data": response.data};
    } catch (e) {
      String errorMsg = "오류발생 내용을 다시 확인해 주세요.";
      if (e is DioException) {
        print(e);
        errorMsg =
            e.response?.data["message"].toString() ?? "오류발생 내용을 다시 확인해 주세요.";
      }
      return {"success": false, "msg": errorMsg};
    } finally {
      EasyLoading.dismiss();
    }
  }
}
