import 'package:moviez24/app/shared_widgets/pagination/models/pagination_details.dart';

class GetMoviesRequest {
  final PaginationDetails paginationDetails;

  GetMoviesRequest({required this.paginationDetails});

  Map<String, dynamic> get json => {}..addAll(paginationDetails.json);
}
