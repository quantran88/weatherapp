import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'condition.dart';

part 'day.g.dart';

@JsonSerializable()
class Day {
  @JsonKey(name: 'maxtemp_c')
  double? maxtempC;
  @JsonKey(name: 'maxtemp_f')
  double? maxtempF;
  @JsonKey(name: 'mintemp_c')
  double? mintempC;
  @JsonKey(name: 'mintemp_f')
  int? mintempF;
  @JsonKey(name: 'avgtemp_c')
  double? avgtempC;
  @JsonKey(name: 'avgtemp_f')
  double? avgtempF;
  @JsonKey(name: 'maxwind_mph')
  double? maxwindMph;
  @JsonKey(name: 'maxwind_kph')
  double? maxwindKph;
  @JsonKey(name: 'totalprecip_mm')
  double? totalprecipMm;
  @JsonKey(name: 'totalprecip_in')
  double? totalprecipIn;
  @JsonKey(name: 'totalsnow_cm')
  int? totalsnowCm;
  @JsonKey(name: 'avgvis_km')
  int? avgvisKm;
  @JsonKey(name: 'avgvis_miles')
  int? avgvisMiles;
  int? avghumidity;
  @JsonKey(name: 'daily_will_it_rain')
  int? dailyWillItRain;
  @JsonKey(name: 'daily_chance_of_rain')
  int? dailyChanceOfRain;
  @JsonKey(name: 'daily_will_it_snow')
  int? dailyWillItSnow;
  @JsonKey(name: 'daily_chance_of_snow')
  
  int? dailyChanceOfSnow;
  Condition? condition;
  double? uv;


  Day({
    this.maxtempC,
    this.maxtempF,
    this.mintempC,
    this.mintempF,
    this.avgtempC,
    this.avgtempF,
    this.maxwindMph,
    this.maxwindKph,
    this.totalprecipMm,
    this.totalprecipIn,
    this.totalsnowCm,
    this.avgvisKm,
    this.avgvisMiles,
    this.avghumidity,
    this.dailyWillItRain,
    this.dailyChanceOfRain,
    this.dailyWillItSnow,
    this.dailyChanceOfSnow,
    this.condition,
    this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Day) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      maxtempC.hashCode ^
      maxtempF.hashCode ^
      mintempC.hashCode ^
      mintempF.hashCode ^
      avgtempC.hashCode ^
      avgtempF.hashCode ^
      maxwindMph.hashCode ^
      maxwindKph.hashCode ^
      totalprecipMm.hashCode ^
      totalprecipIn.hashCode ^
      totalsnowCm.hashCode ^
      avgvisKm.hashCode ^
      avgvisMiles.hashCode ^
      avghumidity.hashCode ^
      dailyWillItRain.hashCode ^
      dailyChanceOfRain.hashCode ^
      dailyWillItSnow.hashCode ^
      dailyChanceOfSnow.hashCode ^
      condition.hashCode ^
      uv.hashCode;
}
