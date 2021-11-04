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

  static U<int> Function(String) parseUInt = int.parse.then(U.of);

  static List<U<int>> parseUIntList(String value) =>
      value.split(',').map(parseUInt).toList();
}

abstract class Routes {
  const Routes();

  static Future getNotFound(HttpRequest req, HttpResponse res) async {
    res.statusCode = 404;
    return {'message': 'not found'};
  }

  static Future getRoot(HttpRequest req, HttpResponse res) async =>
      SLT.getFeedback(hotelId: const U(98625));

  static Future getDepartCities(HttpRequest req, HttpResponse res) async =>
      SLT.getDepartCities();

  static Future getCountries(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'town_from_id': Utils.parseUInt,
    });

    try {
      Utils.checkParameters(required);
      return SLT.getCountries(
        townFromId: required['town_from_id']!.fst! as U<int>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getCities(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'country_id': Utils.parseUInt,
    });

    try {
      Utils.checkParameters(required);
      return SLT.getCities(
        countryId: required['country_id']!.fst! as U<int>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getHotels(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'country_id': Utils.parseUInt,
      'towns': Utils.parseUIntList,
      'stars': Utils.parseUIntList,
    });

    try {
      Utils.checkParameters(required);
      return SLT.getHotels(
        countryId: required['country_id']!.fst! as U<int>,
        towns: required['towns']!.fst! as List<U<int>>,
        stars: required['stars']!.fst! as List<U<int>>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getTourDates(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'depart_city_id': Utils.parseUInt,
      'country_id': Utils.parseUInt,
    });

    try {
      Utils.checkParameters(required);
      return SLT.getTourDates(
        departCityId: required['depart_city_id']!.fst! as U<int>,
        countryId: required['country_id']!.fst! as U<int>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getHotTours(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'city_from_id': Utils.parseUInt,
      'country_id': Utils.parseUInt,
      'stars': Utils.parseUIntList,
    });

    try {
      Utils.checkParameters(required);
      return SLT.getHotTours(
        cityFromId: required['city_from_id']!.fst! as U<int>,
        countryId: required['country_id']!.fst! as U<int>,
        stars: required['stars']!.fst! as List<U<int>>,
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getSeasonTours(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'city_from_id': Utils.parseUInt,
      'country_id': Utils.parseUInt,
      'adults': Utils.parseUInt,
      'kids': Utils.parseUInt,
      'kids_ages': Utils.parseUIntList,
      'nights_min': Utils.parseUInt,
      'nights_max': Utils.parseUInt,
    });

    final optional = req.getParameters({
      'stars': Utils.parseUIntList,
      'cities': Utils.parseUIntList,
      'hotels': Utils.parseUIntList,
      'meals': Utils.parseUIntList,
    });

    try {
      Utils.checkParameters(required);
      return SLT.getSeasonTours(
        GetSeasonToursArguments(
          cityFromId: required['city_from_id']!.fst! as U<int>,
          countryId: required['country_id']!.fst! as U<int>,
          adults: required['adults']!.fst! as U<int>,
          kids: required['kids']!.fst! as U<int>,
          kidsAges: optional['kids_ages']!.fst as List<U<int>>,
          nightsMin: required['nights_min']!.fst! as U<int>,
          nightsMax: required['nights_max']!.fst! as U<int>,
          stars: optional['stars']!.fst as List<U<int>>?,
          cities: optional['cities']!.fst as List<U<int>>?,
          hotels: optional['hotels']!.fst as List<U<int>>?,
          meals: optional['meals']!.fst as List<U<int>>?,
        ),
      );
    } catch (error) {
      return error.toString();
    }
  }

  static Future getCreateLead(HttpRequest req, HttpResponse res) async {
    final required = req.getParameters({
      'note': (x) => x,
    });

    try {
      Utils.checkParameters(required);
      return UON.createLead(
        note: required['note']!.fst! as String,
      );
    } catch (error) {
      return error.toString();
    }
  }
}

Future<void> main() async {
  final app = Alfred(onNotFound: Routes.getNotFound)
    ..get('/', Routes.getRoot)
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
