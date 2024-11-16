import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';


import 'forecastday.dart';

part 'forecast.g.dart';

@JsonSerializable()
class Forecast {
  List<Forecastday>? forecastday;
  Forecast({this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return _$ForecastFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ForecastToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Forecast) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => forecastday.hashCode;
}
