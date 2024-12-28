import 'package:moviez24/utils/network/api_handler.dart';

class BaseRemoteService {
  final ApiHandler apiHandler = ApiHandler();

  Future<Map<String, dynamic>> get headers async {
    //Todo: get this token from secure storage.
    final String? accessToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNjkxMTRjMzc3ZGJkOGUzNzQ0MTMzMTMxNzUzNTgyMCIsIm5iZiI6MTczNTM2MDQ1NS4wMTUsInN1YiI6IjY3NmY3ZmM3YmYxMGZmMTk4NDYxOGY1ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.aX6luDrY-FNwx5T3n50FACzOnQbAB3uH8brdSjxDhKA';
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
  }
}
