import 'dart:convert';

MeasurementsResponse measurementsResponseFromJson(String str) =>
    MeasurementsResponse.fromJson(json.decode(str));

String measurementsResponseToJson(MeasurementsResponse data) =>
    json.encode(data.toJson());

class MeasurementsResponse {
  MeasurementsResponse({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.prevPage,
    required this.nextPage,
  });

  List<Doc> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  factory MeasurementsResponse.fromJson(Map<String, dynamic> json) =>
      MeasurementsResponse(
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class Doc {
  Doc({
    required this.visibility,
    required this.tags,
    required this.id,
    required this.thing,
    required this.feature,
    required this.device,
    required this.samples,
    required this.startDate,
    required this.endDate,
  });

  Visibility? visibility;
  List<dynamic> tags;
  String id;
  Thing? thing;
  Feature? feature;
  Device? device;
  List<Sample> samples;
  DateTime startDate;
  DateTime endDate;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        visibility: visibilityValues.map[json["visibility"]],
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        id: json["_id"],
        thing: thingValues.map[json["thing"]],
        feature: featureValues.map[json["feature"]],
        device: deviceValues.map[json["device"]],
        samples:
            List<Sample>.from(json["samples"].map((x) => Sample.fromJson(x))),
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "visibility": visibilityValues.reverse![visibility],
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "_id": id,
        "thing": thingValues.reverse![thing],
        "feature": featureValues.reverse![feature],
        "device": deviceValues.reverse![device],
        "samples": List<dynamic>.from(samples.map((x) => x.toJson())),
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };
}

enum Device { PLANT_MONITOR }

final deviceValues = EnumValues({"plant-monitor": Device.PLANT_MONITOR});

enum Feature { PLANT_STATE }

final featureValues = EnumValues({"plant-state": Feature.PLANT_STATE});

class Sample {
  Sample({
    required this.values,
  });

  List<int> values;

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
        values: List<int>.from(json["values"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "values": List<dynamic>.from(values.map((x) => x)),
      };
}

enum Thing { PLANT_B, PLANT_C, PLANT_A }

final thingValues = EnumValues({
  "plant A": Thing.PLANT_A,
  "plant B": Thing.PLANT_B,
  "plant C": Thing.PLANT_C
});

enum Visibility { PRIVATE }

final visibilityValues = EnumValues({"private": Visibility.PRIVATE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
