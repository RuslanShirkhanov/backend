import 'package:dio/dio.dart';

import 'result.dart';

abstract class UON {
  const UON();

  static final _dio = Dio();

  static Uri _makeUri(
    String unencodedPath,
    Map<String, Object> queryParams,
  ) =>
      Uri.https(
        'api.u-on.ru',
        '8UaTGoR27f8lOcwcM8961613461210/$unencodedPath',
        queryParams.map<String, Object>(
          (key, dynamic value) => MapEntry(key, value.toString()),
        ),
      );

  static Future<String> createLead({
    required String note,
  }) async {
    final uri = _makeUri('lead/create.json', {});
    try {
      await _dio.post<Map<String, String>>(
        uri.toString(),
        data: {'note': note},
      );
      return true.success.show;
    } catch (error) {
      return false.failure.show;
    }
  }
}
