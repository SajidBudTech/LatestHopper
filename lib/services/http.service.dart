import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/api.dart';
import 'package:flutter_hopper/constants/strings/prefrence_key.string.dart';


class HttpService {
  String host = Api.baseUrl;
  BaseOptions baseOptions;
  Dio dio;

  Future<Map<String, String>> getHeaders() async {
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${await getAuthBearerToken()}",
    };
  }

  HttpService() {
    baseOptions = new BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = new Dio(baseOptions);
    dio.interceptors.add(DioCacheManager(
      CacheConfig(
        baseUrl: host,
        defaultMaxAge: Duration(hours: 1),
      ),
    ).interceptor);
  }

  //Get the access token of the logged in user
  Future<String> getAuthBearerToken() async {
    //final currentUser = await appDatabase.userDao.findCurrent();
    String token=await AuthBloc.prefs.getString(PreferenceString.UserToken);
    return token;//await AuthBloc.prefs.getString(PreferenceString.UserToken);

  }

  //for get api calls
  Future<Response> get(
    String url, {
    Map<String, dynamic> queryParameters,
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio.get(
      uri,
      options: mOptions,
      queryParameters: queryParameters,
    );
  }

  //for post api calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio.post(
      uri,
      data: body,
      options: mOptions,
    );
  }

  //for post api calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    var response = Response();

    try {
      response = await dio.post(
        uri,
        data: FormData.fromMap(body),
        options: mOptions,
      );
    } catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, dynamic> body) async {
    String uri = "$host$url";
    return dio.patch(
      uri,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    String uri = "$host$url";
    return dio.delete(
      uri,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  Response formatDioExecption(ex) {
    var response = Response();
    response.statusCode = 400;
    try {
      if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
        response.data = {
          "message":
              "Connection timeout. Please check your internet connection and try again",
        };
      } else {
        response.data = {
          "message": ex.message ??
              "Please check your internet connection and try again",
        };
      }
    } catch (error) {
      final response = Response();
      response.statusCode = 400;
      response.data = {
        "message": error.message ??
            "Please check your internet connection and try again",
      };
    }

    return response;
  }
}
