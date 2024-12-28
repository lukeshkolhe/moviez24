class PaginationDetails {
  int totalPages;
  int total;
  int lastPage;
  int currentPage;
  int perPage;

  PaginationDetails(
      {required this.totalPages,
      required this.total,
      required this.lastPage,
      required this.currentPage,
      required this.perPage});

  factory PaginationDetails.fromJson(Map<String, dynamic> json) =>
      PaginationDetails(
        totalPages: json['total_pages'],
        total: json['total_results'],
        lastPage: json['total_pages'],
        currentPage: json['page'],
        perPage: json['total_results'] ~/ json['total_pages'],
      );

  Map<String, dynamic> get json => {
        'page': currentPage,
      };
}
