import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:alfred/alfred.dart';

class U<T extends num> {
  final T value;

  const U(this.value) : assert(value >= 0);

  static U<T> of<T extends num>(T value) => U<T>(value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(covariant U<T> that) => value == that.value;

  bool eq(T value) => this.value == value;

  bool operator <(U<T> that) => value < that.value;

  bool lt(T value) => this.value < value;

  bool operator <=(U<T> that) => value <= that.value;

  bool lte(T value) => this.value <= value;

  bool operator >(U<T> that) => value > that.value;

  bool gt(T value) => this.value > value;

  bool operator >=(U<T> that) => value >= that.value;

  bool gte(T value) => this.value >= value;

  U<T> operator +(U<T> that) => U<T>((value + that.value).abs() as T);

  U<T> operator -(U<T> that) => U<T>((value - that.value).abs() as T);

  U<T> operator *(U<T> that) => U<T>((value * that.value).abs() as T);

  U<num> operator /(U<T> that) => U<num>((value / that.value).abs());

  U<num> operator %(U<T> that) => U<num>((value % that.value).abs());

  int toInt() => value.toInt();

  double toDouble() => value.toDouble();

  @override
  String toString() => value.toString();
}

enum ResultKind { ok, err }

String resultKindToString(ResultKind value) {
  switch (value) {
    case ResultKind.ok:
      return 'ok';
    case ResultKind.err:
      return 'err';
  }
}

abstract class Result<O extends Object?, E extends Object?> {
  final O value;
  final E error;
  final ResultKind kind;

  const Result({
    required this.kind,
    required this.value,
    required this.error,
  });

  @override
  String toString() => jsonEncode(<String, dynamic>{
        'kind': resultKindToString(kind),
        'value': value,
        'error': error,
      });
}

class Ok<O extends Object> extends Result<O, Object?> {
  const Ok(O value)
      : super(
          kind: ResultKind.ok,
          value: value,
          error: null,
        );
}

extension ToOk<O extends Object> on O {
  Ok<O> get ok => Ok(this);
}

class Err<E extends Object> extends Result<Object?, E> {
  const Err(E error)
      : super(
          kind: ResultKind.err,
          value: null,
          error: error,
        );
}

extension ToErr<E extends Object> on E {
  Err<E> get err => Err(this);
}

abstract class UON {
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
      return true.ok.toString();
    } catch (error) {
      // ignore: avoid_print
      print(error);
      return false.err.toString();
    }
  }
}

class GetSeasonToursArguments {
  final U<int> cityFromId;
  final U<int> countryId;
  final List<U<int>> cities;
  final List<U<int>> meals;
  final List<U<int>> stars;
  final List<U<int>> hotels;
  final U<int> adults;
  final U<int> kids;
  final List<U<int>> kidsAges;
  final U<int> nightsMin;
  final U<int> nightsMax;

  const GetSeasonToursArguments({
    required this.cityFromId,
    required this.countryId,
    required this.cities,
    required this.meals,
    required this.stars,
    required this.hotels,
    required this.adults,
    required this.kids,
    required this.kidsAges,
    required this.nightsMin,
    required this.nightsMax,
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
        // 'cities': cities.join(','),
        // 'meals': meals.join(','),
        // 'stars': stars.join(','),
        // 'hotels': hotels.join(','),
        // 's_adults': adults,
        // 's_kids': kids,
        // 's_nightsMin': nightsMin,
        // 's_nightsMax': nightsMax,
        // 'includeDescriptions': U<int>(1),
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

  static Future<String> getDepartCities() async {
    final uri = _makeUri('GetDepartCities', {});
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return (res.data['GetDepartCitiesResult']['Data'] as Object)
          .ok
          .toString();
    }
    return (const <Object>[]).err.toString();
  }

  static Future<String> getCountries({
    required U<int> townFromId,
  }) async {
    final uri = _makeUri('GetCountries', {
      'townFromId': townFromId,
    });
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return (res.data['GetCountriesResult']['Data'] as Object).ok.toString();
    }
    return (const <Object>[]).err.toString();
  }

  static Future<String> getCities({
    required U<int> countryId,
  }) async {
    final uri = _makeUri('GetCities', {
      'countryId': countryId,
    });
    final res = await _dio.get<Object>(uri.toString());

    if (res.statusCode == 200) {
      return (res.data['GetCitiesResult']['Data'] as Object).ok.toString();
    }
    return (const <Object>[]).err.toString();
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
      return (res.data['GetHotelsResult']['Data'] as Object).ok.toString();
    }
    return (const <Object>[]).err.toString();
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
      return (res.data['GetTourDatesResult']['Data']['dates'] as Object)
          .ok
          .toString();
    }
    return (const <Object>[]).err.toString();
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
      return (res.data['GetToursResult']['Data']['aaData'] as Object)
          .ok
          .toString();
    }
    return (const <Object>[]).err.toString();
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
        res.data['GetToursResult']['Data']['requestId'] as int,
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
      return (res.data['GetLoadStateResult']['Data'] as List<dynamic>)
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
      return (res.data['GetToursResult']['Data']['aaData'] as Object)
          .ok
          .toString();
    }

    return (const <Object>[]).err.toString();
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
        : (const <Object>[]).err.toString();

    return result;
  }
}

Future missingHandler(HttpRequest req, HttpResponse res) async {
  res.statusCode = 404;
  return {'message': 'not found'};
}

Future<void> main() async {
  final app = Alfred(onNotFound: missingHandler)
    ..get('/', (req, res) async => null)
    ..get('/depart_cities', (req, res) async => SLT.getDepartCities())
    ..get('/countries', (req, res) async {
      final _townFromId = req.uri.queryParameters['town_from_id'];
      if (_townFromId?.isEmpty == null) {
        return '"town_from_id" is empty'.err.toString();
      }

      final townFromId = U<int>(int.parse(_townFromId!));

      return SLT.getCountries(townFromId: townFromId);
    })
    ..get('/cities', (req, res) async {
      final _countryId = req.uri.queryParameters['country_id'];
      if (_countryId?.isEmpty == null) {
        return '"country_id" is empty'.err.toString();
      }

      final countryId = U<int>(int.parse(_countryId!));

      return SLT.getCities(countryId: countryId);
    })
    ..get('/hotels', (req, res) async {
      final _countryId = req.uri.queryParameters['country_id'];
      if (_countryId?.isEmpty == null) {
        return '"country_id" is empty'.err.toString();
      }
      final _towns = req.uri.queryParameters['towns'];
      if (_towns?.isEmpty == null) {
        return '"towns" is empty'.err.toString();
      }
      final _stars = req.uri.queryParameters['stars'];
      if (_stars?.isEmpty == null) {
        return '"stars" is empty'.err.toString();
      }

      final countryId = U<int>(int.parse(_countryId!));
      final towns = _towns!.split(',').map(int.parse).map(U.of).toList();
      final stars = _stars!.split(',').map(int.parse).map(U.of).toList();

      return SLT.getHotels(
        countryId: countryId,
        towns: towns,
        stars: stars,
      );
    })
    ..get('/tour_dates', (req, res) async {
      final _departCityId = req.uri.queryParameters['depart_city_id'];
      if (_departCityId?.isEmpty == null) {
        return '"depart_city_id" is empty'.err.toString();
      }
      final _countryId = req.uri.queryParameters['country_id'];
      if (_countryId?.isEmpty == null) {
        return '"country_id" is empty'.err.toString();
      }

      final departCityId = U<int>(int.parse(_departCityId!));
      final countryId = U<int>(int.parse(_countryId!));

      return SLT.getTourDates(
        departCityId: departCityId,
        countryId: countryId,
      );
    })
    ..get('/hot_tours', (req, res) async {
      final _cityFromId = req.uri.queryParameters['city_from_id'];
      if (_cityFromId?.isEmpty == null) {
        return '"city_from_id" is empty'.err.toString();
      }
      final _countryId = req.uri.queryParameters['country_id'];
      if (_countryId?.isEmpty == null) {
        return '"country_id" is empty'.err.toString();
      }
      final _stars = req.uri.queryParameters['stars'];
      if (_stars?.isEmpty == null) {
        return '"stars" is empty'.err.toString();
      }

      final cityFromId = U<int>(int.parse(_cityFromId!));
      final countryId = U<int>(int.parse(_countryId!));
      final stars = _stars!.split(',').map(int.parse).map(U.of).toList();

      return SLT.getHotTours(
        cityFromId: cityFromId,
        countryId: countryId,
        stars: stars,
      );
    })
    ..get('/season_tours', (req, res) async {
      final _cityFromId = req.uri.queryParameters['city_from_id'];
      if (_cityFromId?.isEmpty == null) {
        return '"city_from_id" is empty'.err.toString();
      }
      final _countryId = req.uri.queryParameters['country_id'];
      if (_countryId?.isEmpty == null) {
        return '"country_id" is empty'.err.toString();
      }
      final _cities = req.uri.queryParameters['cities'];
      if (_cities?.isEmpty == null) {
        return '"cities" is empty'.err.toString();
      }
      final _meals = req.uri.queryParameters['meals'];
      if (_meals?.isEmpty == null) {
        return '"meals" is empty'.err.toString();
      }
      final _stars = req.uri.queryParameters['stars'];
      if (_stars?.isEmpty == null) {
        return '"stars" is empty'.err.toString();
      }
      final _hotels = req.uri.queryParameters['hotels'];
      if (_hotels?.isEmpty == null) {
        return '"hotels" is empty'.err.toString();
      }
      final _adults = req.uri.queryParameters['adults'];
      if (_adults?.isEmpty == null) {
        return '"adults" is empty'.err.toString();
      }
      final _kids = req.uri.queryParameters['kids'];
      if (_kids?.isEmpty == null) {
        return '"kids" is empty'.err.toString();
      }
      var _kidsAges = req.uri.queryParameters['kids_ages'];
      final _nightsMin = req.uri.queryParameters['nights_min'];
      if (_nightsMin?.isEmpty == null) {
        return '"nights_min" is empty'.err.toString();
      }
      final _nightsMax = req.uri.queryParameters['nights_max'];
      if (_nightsMax?.isEmpty == null) {
        return '"nights_max" is empty'.err.toString();
      }

      final cityFromId = U<int>(int.parse(_cityFromId!));
      final countryId = U<int>(int.parse(_countryId!));
      final cities = _cities!.split(',').map(int.parse).map(U.of).toList();
      final meals = _meals!.split(',').map(int.parse).map(U.of).toList();
      final stars = _stars!.split(',').map(int.parse).map(U.of).toList();
      final hotels = _hotels!.split(',').map(int.parse).map(U.of).toList();
      final adults = U<int>(int.parse(_adults!));
      final kids = U<int>(int.parse(_kids!));
      final kidsAges = _kidsAges?.split(',').map(int.parse).map(U.of).toList();
      final nightsMin = U<int>(int.parse(_nightsMin!));
      final nightsMax = U<int>(int.parse(_nightsMax!));

      return SLT.getSeasonTours(
        GetSeasonToursArguments(
          cityFromId: cityFromId,
          countryId: countryId,
          cities: cities,
          meals: meals,
          stars: stars,
          hotels: hotels,
          adults: adults,
          kids: kids,
          kidsAges: kidsAges ?? [],
          nightsMin: nightsMin,
          nightsMax: nightsMax,
        ),
      );
    })
    ..get('/create_lead', (req, res) async {
      final _note = req.uri.queryParameters['note'];
      if (_note?.isEmpty == null) {
        return '"_note" is empty'.err.toString();
      }

      final note = _note!;

      return UON.createLead(note: note);
    });

  await app.listen(3800);
}
