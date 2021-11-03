import 'package:alfred/alfred.dart';

import 'compose.dart';
import 'result.dart';
import 'slt.dart';
import 'uon.dart';
import 'u.dart';

extension Parameters on HttpRequest {
  Result<T, String> getParameter<T>(
    String key,
    T Function(String) transform,
  ) {
    final value = uri.queryParameters[key];
    if (value == null || value.isEmpty) {
      return Result.failure('$key is empty');
    }
    return Result.success(transform(value));
  }

  Map<String, Result<Object, String>> getParameters(
    Map<String, Object Function(String)> xs,
  ) =>
      xs.map((key, value) => MapEntry(key, getParameter(key, value)));
}

abstract class Utils {
  const Utils();

  static void checkParameters(Map<String, Result<Object, String>> xs) {
    if (!xs.values.every((x) => x.isSuccess)) {
      throw xs.values.firstWhere((x) => x.isFailure);
    }
  }
}

abstract class Routes {
  const Routes();

  static Future getNotFound(HttpRequest req, HttpResponse res) async {
    res.statusCode = 404;
    return {'message': 'not found'};
  }

  static Future getDepartCities(HttpRequest req, HttpResponse res) async =>
      SLT.getDepartCities();

  static Future getCountries(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'town_from_id': int.parse.then(U.of),
    });

    try {
      Utils.checkParameters(required);
      return SLT.getCountries(
        townFromId: required['town_from_id']!.asSuccess as U<int>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getCities(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'country_id': int.parse.then(U.of),
    });

    try {
      Utils.checkParameters(required);
      return SLT.getCities(
        countryId: required['country_id']!.asSuccess as U<int>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getHotels(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'country_id': int.parse.then(U.of),
      'towns': (towns) => towns.split(',').map(int.parse).map(U.of).toList(),
      'stars': (stars) => stars.split(',').map(int.parse).map(U.of).toList(),
    });

    try {
      Utils.checkParameters(required);
      return SLT.getHotels(
        countryId: required['country_id']!.asSuccess as U<int>,
        towns: required['towns']!.asSuccess as List<U<int>>,
        stars: required['stars']!.asSuccess as List<U<int>>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getTourDates(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'depart_city_id': int.parse.then(U.of),
      'country_id': int.parse.then(U.of),
    });

    try {
      Utils.checkParameters(required);
      return SLT.getTourDates(
        departCityId: required['depart_city_id']!.asSuccess as U<int>,
        countryId: required['country_id']!.asSuccess as U<int>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getHotTours(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'city_from_id': int.parse.then(U.of),
      'country_id': int.parse.then(U.of),
      'stars': (stars) => stars.split(',').map(int.parse).map(U.of).toList(),
    });

    try {
      Utils.checkParameters(required);
      return SLT.getHotTours(
        cityFromId: required['city_from_id']!.asSuccess as U<int>,
        countryId: required['country_id']!.asSuccess as U<int>,
        stars: required['stars']!.asSuccess as List<U<int>>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  // todo
  static Future getSeasonTours(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'city_from_id': int.parse.then(U.of),
      'country_id': int.parse.then(U.of),
    });

    final _cities = req.uri.queryParameters['cities'];
    if (_cities?.isEmpty == null) {
      return '"cities" is empty'.failure.toString();
    }
    final _meals = req.uri.queryParameters['meals'];
    if (_meals?.isEmpty == null) {
      return '"meals" is empty'.failure.toString();
    }
    final _stars = req.uri.queryParameters['stars'];
    if (_stars?.isEmpty == null) {
      return '"stars" is empty'.failure.toString();
    }
    final _hotels = req.uri.queryParameters['hotels'];
    if (_hotels?.isEmpty == null) {
      return '"hotels" is empty'.failure.toString();
    }
    final _adults = req.uri.queryParameters['adults'];
    if (_adults?.isEmpty == null) {
      return '"adults" is empty'.failure.toString();
    }
    final _kids = req.uri.queryParameters['kids'];
    if (_kids?.isEmpty == null) {
      return '"kids" is empty'.failure.toString();
    }
    var _kidsAges = req.uri.queryParameters['kids_ages'];
    final _nightsMin = req.uri.queryParameters['nights_min'];
    if (_nightsMin?.isEmpty == null) {
      return '"nights_min" is empty'.failure.toString();
    }
    final _nightsMax = req.uri.queryParameters['nights_max'];
    if (_nightsMax?.isEmpty == null) {
      return '"nights_max" is empty'.failure.toString();
    }

    final cities = _cities!.split(',').map(int.parse).map(U.of).toList();
    final meals = _meals!.split(',').map(int.parse).map(U.of).toList();
    final stars = _stars!.split(',').map(int.parse).map(U.of).toList();
    final hotels = _hotels!.split(',').map(int.parse).map(U.of).toList();
    final adults = U<int>(int.parse(_adults!));
    final kids = U<int>(int.parse(_kids!));
    final kidsAges = _kidsAges?.split(',').map(int.parse).map(U.of).toList();
    final nightsMin = U<int>(int.parse(_nightsMin!));
    final nightsMax = U<int>(int.parse(_nightsMax!));

    try {
      Utils.checkParameters(required);
      return SLT.getSeasonTours(
        GetSeasonToursArguments(
          cityFromId: required['city_from_id']!.asSuccess as U<int>,
          countryId: required['country_id']!.asSuccess as U<int>,
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
    } catch (error) {
      return error.toString();
    }
  }

  static Future getCreateLead(HttpRequest req, HttpResponse res) async {
    final _note = req.uri.queryParameters['note'];
    if (_note?.isEmpty == null) {
      return '"_note" is empty'.failure.toString();
    }

    final note = _note!;

    return UON.createLead(note: note);
  }
}

Future<void> main() async {
  final app = Alfred(onNotFound: Routes.getNotFound)
    ..get('/', (req, res) async => null)
    ..get('/depart_cities', Routes.getDepartCities)
    ..get('/countries', Routes.getCountries)
    ..get('/cities', Routes.getCities)
    ..get('/hotels', Routes.getHotels)
    ..get('/tour_dates', Routes.getTourDates)
    ..get('/hot_tours', Routes.getHotTours)
    ..get('/season_tours', Routes.getSeasonTours)
    ..get('/create_lead', Routes.getCreateLead);

  await app.listen(3800);
}
