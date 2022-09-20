class ApiConstants {
  static String baseUrl = 'https://students.measurify.org';
  static String loginEndpoint = '/v1/login';
  static String measurementsEndpoint = '/v1/measurements';

  static String getMeasurementFilterEndPoint(
      String plant, int limit, int page, String startDate, String endDate) {
    String filter = "";
    if (plant == "A" || plant == "B" || plant == "C") {
      filter =
          '?filter={"thing":"plant $plant","startDate":{"\$gte":"$startDate"},"endDate":{"\$lt":"$endDate"}}&limit=' +
              limit.toString() +
              '&page=' +
              page.toString();
    }

    String measurementsFilterEndpoint = measurementsEndpoint + filter;
    return measurementsFilterEndpoint;
  }
}
