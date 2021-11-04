// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart';

import 'result.dart';
import 'u.dart';

class GetSeasonToursArguments {
  final U<int> cityFromId;
  final U<int> countryId;
  final U<int> adults;
  final U<int> kids;
  final List<U<int>> kidsAges;
  final U<int> nightsMin;
  final U<int> nightsMax;
  final List<U<int>>? stars;
  final List<U<int>>? cities;
  final List<U<int>>? hotels;
  final List<U<int>>? meals;

  const GetSeasonToursArguments({
    required this.cityFromId,
    required this.countryId,
    required this.adults,
    required this.kids,
    required this.kidsAges,
    required this.nightsMin,
    required this.nightsMax,
    required this.stars,
    required this.cities,
    required this.hotels,
    required this.meals,
  });

  Map<String, dynamic> toQueryParameters({
    required String login,
    required String password,
    U<int>? requestId,
  }) =>
      <String, dynamic>{
        'login': login,
        'password': password,
        'cityFromId': cityFromId,
        'countryId': countryId,
        if (requestId != null) 'requestId': requestId,
        if (requestId != null) 'updateResult': const U(1),
        'pageSize': const U(1000),
        'pageNumber': const U(1),
        'includeDescriptions': const U(1),
        's_adults': adults,
        's_kids': kids,
        's_nightsMin': nightsMin,
        's_nightsMax': nightsMax,
        if (stars != null) 'stars': stars!.join(','),
        if (cities != null) 'cities': cities!.join(','),
        if (hotels != null) 'hotels': hotels!.join(','),
        if (meals != null) 'meals': meals!.join(','),
      };
}

class LoadState {
  final U<int> id;
  final bool isProcessed;

  const LoadState({
    required this.id,
    required this.isProcessed,
  });

  static LoadState serialize(Map<String, dynamic> data) => LoadState(
        id: U<int>(data['Id'] as int),
        isProcessed: data['IsProcessed'] as bool,
      );

  static Map<String, dynamic> deserialize(LoadState data) => <String, dynamic>{
        'Id': data.id,
        'IsProcessed': data.isProcessed,
      };
}

abstract class SLT {
  const SLT();

  static final _dio = Dio();

  static const _login = 'ra-koncept@yandex.ru';
  static const _password = '4FFYfEOwfi';

  static Uri _makeUri(
    String unencodedPath,
    Map<String, Object> queryParams,
  ) =>
      Uri.https(
        'module.sletat.ru',
        '/Main.svc/$unencodedPath',
        queryParams.map<String, Object>(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

  // todo
  static Future<String> getFeedback({
    required U<int> hotelId,
  }) async {
    final res = await _dio.post<Object>(
      'https://module.sletat.ru/XmlGate.svc?singleWSDL',
      data: '''
            <x:Envelope xmlns:x="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:SletatRu:Contracts:Soap11Gate:v1" xmlns:urn1="urn:SletatRu:DataTypes:AuthData:v1">
            <x:Header>
              <urn1:AuthInfo>
                <urn1:Login>ra-koncept@yandex.ru</urn1:Login>
                <urn1:Password>4FFYfEOwfi</urn1:Password>
              </urn1:AuthInfo>
            </x:Header>
              <x:Body>
                <urn:GetHotelComments>
                  <urn:hotelId>$hotelId</urn:hotelId>
                </urn:GetHotelComments>
              </x:Body>
            </x:Envelope>
            ''',
      options: Options(
        headers: <String, String>{
          'Content-Type': 'text/xml;charset=UTF-8',
          'SOAPAction':
              'urn:SletatRu:Contracts:Soap11Gate:v1/Soap11Gate/GetHotelComments'
        },
      ),
    );
    return res.data.toString();
  }

  static Future<String> getDepartCities() async {
    final uri = _makeUri('GetDepartCities', {});
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetDepartCitiesResult']
              ['Data'] as Object)
          .success
          .toString();
    }
    return (const <Object>[]).failure.toString();
  }

  static Future<String> getCountries({
    required U<int> townFromId,
  }) async {
    final uri = _makeUri('GetCountries', {
      'townFromId': townFromId,
    });
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetCountriesResult']['Data']
              as Object)
          .success
          .toString();
    }
    return (const <Object>[]).failure.toString();
  }

  static Future<String> getCities({
    required U<int> countryId,
  }) async {
    final uri = _makeUri('GetCities', {
      'countryId': countryId,
    });
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetCitiesResult']['Data']
              as Object)
          .success
          .toString();
    }
    return (const <Object>[]).failure.toString();
  }

  static Future<String> getHotels({
    required U<int> countryId,
    List<U<int>> towns = const [],
    List<U<int>> stars = const [],
  }) async {
    final uri = _makeUri('GetHotels', {
      'countryId': countryId,
      'towns': towns.join(','),
      'stars': stars.join(','),
      'filter': '',
      'all': -1,
    });
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetHotelsResult']['Data']
              as Object)
          .success
          .toString();
    }
    return (const <Object>[]).failure.toString();
  }

  static Future<String> getTourDates({
    required U<int> departCityId,
    required U<int> countryId,
    List<U<int>> resorts = const [],
  }) async {
    final uri = _makeUri('GetTourDates', {
      'dptCityId': departCityId,
      'countryId': countryId,
      if (resorts.isNotEmpty) 'resorts': resorts.join(','),
    });
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetTourDatesResult']['Data']
              ['dates'] as Object)
          .success
          .toString();
    }
    return (const <Object>[]).failure.toString();
  }

  static Future<String> getHotTours({
    required U<int> cityFromId,
    required U<int> countryId,
    required List<U<int>> stars,
  }) async {
    final uri = _makeUri('GetTours', {
      'login': _login,
      'password': _password,
      'cityFromId': cityFromId,
      'countryId': countryId,
      'stars': stars.join(','),
      's_showcase': true,
      'pageSize': const U(1000),
      'pageNumber': const U(1),
      'includeDescriptions': const U(1),
    });
    final res = await _dio.get<Object>(
      uri.toString(),
      options: Options(headers: const <String, String>{
        'Referer': 'https://module.sletat.ru',
      }),
    );

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetToursResult']['Data']
              ['aaData'] as Object)
          .success
          .toString();
    }
    return (const <Object>[]).failure.toString();
  }

  static bool _checkLoadStates(List<LoadState> loadStates) =>
      loadStates.every((state) => state.isProcessed);

  static Future<U<int>?> getSeasonToursRequest(
    GetSeasonToursArguments arguments,
  ) async {
    final uri = _makeUri(
      '/GetTours',
      arguments.toQueryParameters(
        login: SLT._login,
        password: SLT._password,
      ) as Map<String, Object>,
    );
    final res = await _dio.get<Object>(
      uri.toString(),
      options: Options(headers: const <String, String>{
        'Referer': 'https://module.sletat.ru',
      }),
    );

    if (res.statusCode == 200) {
      return U(
        (res.data as Map<String, dynamic>)['GetToursResult']['Data']
            ['requestId'] as int,
      );
    }
    return null;
  }

  static Future<List<LoadState>> getLoadStates({
    required U<int> requestId,
  }) async {
    final uri = _makeUri('/GetLoadState', {
      'requestId': requestId,
    });
    final res = await _dio.get<Object>(
      uri.toString(),
      options: Options(headers: const <String, String>{
        'Referer': 'https://module.sletat.ru',
      }),
    );

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetLoadStateResult']['Data']
              as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(LoadState.serialize)
          .toList()
          .cast<LoadState>();
    }
    return const [];
  }

  static Future<String> getSeasonToursData(
    GetSeasonToursArguments arguments, {
    required U<int> requestId,
  }) async {
    final uri = _makeUri(
      '/GetTours',
      arguments.toQueryParameters(
        login: SLT._login,
        password: SLT._password,
        requestId: requestId,
      ) as Map<String, Object>,
    );
    final res = await _dio.get<Object>(
      uri.toString(),
      options: Options(headers: const <String, String>{
        'Referer': 'https://module.sletat.ru',
      }),
    );

    if (res.statusCode == 200) {
      return ((res.data as Map<String, dynamic>)['GetToursResult']['Data']
              ['aaData'] as Object)
          .success
          .toString();
    }

    return (const <Object>[]).failure.toString();
  }

  static Future<String> getSeasonTours(
    GetSeasonToursArguments arguments,
  ) async {
    final _requestId = await SLT.getSeasonToursRequest(arguments);
    assert(_requestId != null);
    final requestId = _requestId!;

    var loadStates = await SLT.getLoadStates(requestId: requestId);
    var status = false;
    var iteration = 0;
    while (!status) {
      if (iteration == 80) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 1500), () {});
      loadStates = await SLT.getLoadStates(requestId: requestId);
      status = SLT._checkLoadStates(loadStates);
      iteration = iteration + 1;
    }

    final result = status
        ? await SLT.getSeasonToursData(
            arguments,
            requestId: requestId,
          )
        : (const <Object>[]).failure.toString();

    return result;
  }
}
