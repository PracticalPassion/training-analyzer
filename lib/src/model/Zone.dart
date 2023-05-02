enum ZoneType { noZone, zone1, zone2, zone3, zone4, zone5 }

class Zone {
  ZoneType zone;
  int from;
  int to;

  Zone({
    required this.zone,
    required this.from,
    required this.to,
  });
}

final List<Zone> zonen = [
  Zone(zone: ZoneType.zone1, from: 100, to: 135),
  Zone(zone: ZoneType.zone2, from: 136, to: 155),
  Zone(zone: ZoneType.zone3, from: 156, to: 162),
  Zone(zone: ZoneType.zone4, from: 163, to: 175),
  Zone(zone: ZoneType.zone5, from: 176, to: 250)
];

extension ZoneTypeExtention on ZoneType {
  static ZoneType getVal(int averageHeartRate) {
    if (averageHeartRate.isBetween(zonen[0].from, zonen[0].to)) return ZoneType.zone1;
    if (averageHeartRate.isBetween(zonen[1].from, zonen[1].to)) return ZoneType.zone2;
    if (averageHeartRate.isBetween(zonen[2].from, zonen[2].to)) return ZoneType.zone3;
    if (averageHeartRate.isBetween(zonen[3].from, zonen[3].to)) return ZoneType.zone4;
    if (averageHeartRate.isBetween(zonen[4].from, zonen[4].to)) return ZoneType.zone5;
    return ZoneType.noZone;
  }

  static String getStringFromList(int num) {
    switch (num) {
      case 0:
        return "Zone 1";
      case 1:
        return "Zone 2";
      case 2:
        return "Zone 3";
      case 3:
        return "Zone 4";
      case 4:
        return "Zone 5";
      default:
        return "NO ZONE";
    }
  }

  static ZoneType getValueFromList(int num) {
    switch (num) {
      case 0:
        return ZoneType.zone1;
      case 1:
        return ZoneType.zone2;
      case 2:
        return ZoneType.zone3;
      case 3:
        return ZoneType.zone4;
      case 4:
        return ZoneType.zone5;
      default:
        return ZoneType.noZone;
    }
  }
}

extension Range on num {
  bool isBetween(num from, num to) {
    return from <= this && this <= to;
  }
}
