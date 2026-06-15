import 'package:flutter/services.dart';

class RDSAReportDTO {
  final InfoDto info;
  final List<VisitDto> visits;

  final Uint8List frontPageBytes;
  final Uint8List backPageBytes;

  RDSAReportDTO({
    required this.info,
    required this.visits,
    required this.frontPageBytes,
    required this.backPageBytes,
  });

  factory RDSAReportDTO.fromJson(Map<String, dynamic> json) {
    return RDSAReportDTO(
      info: InfoDto.fromJson(json['info']),
      visits: (json['visits'] as List)
          .map((e) => VisitDto.fromJson(e))
          .toList(),
      frontPageBytes: json['frontPageBytes'],
      backPageBytes: json['backPageBytes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'info': info.toJson(),
    'visits': visits.map((e) => e.toJson()).toList(),
  };
}

class InfoDto {
  final String userName;
  final String cityName;
  final String areaName;
  final String areaCategory;
  final String areaZone;
  final String areaType;
  final String formCompleted;
  final String activityDate;
  final String activityCycle;
  final String activityCode;

  InfoDto({
    required this.userName,
    required this.cityName,
    required this.areaName,
    required this.areaCategory,
    required this.areaZone,
    required this.areaType,
    required this.formCompleted,
    required this.activityDate,
    required this.activityCycle,
    required this.activityCode,
  });

  factory InfoDto.fromJson(Map<String, dynamic> json) {
    return InfoDto(
      userName: json['userName'],
      cityName: json['cityName'],
      areaName: json['areaName'],
      areaCategory: json['areaCategory'],
      areaZone: json['areaZone'],
      areaType: json['areaType'],
      formCompleted: json['formCompleted'],
      activityDate: json['activityDate'],
      activityCycle: json['activityCycle'],
      activityCode: json['activityCode'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'cityName': cityName,
    'areaName': areaName,
    'areaCategory': areaCategory,
    'areaZone': areaZone,
    'areaType': areaType,
    'formCompleted': formCompleted,
    'activityDate': activityDate,
    'activityCycle': activityCycle,
    'activityCode': activityCode,
  };
}

class VisitDto {
  final int block;
  final String sus;
  final String street;
  final String propertyType;
  final String status;
  final TreatmentDataDto? treatmentData;
  final LiraaDataDto? liraaData;
  final bool inspected;

  VisitDto({
    required this.block,
    required this.sus,
    required this.street,
    required this.propertyType,
    required this.status,
    required this.treatmentData,
    required this.liraaData,
    required this.inspected,
  });

  factory VisitDto.fromJson(Map<String, dynamic> json) {
    return VisitDto(
      block: json['block'],
      sus: json['sus'],
      street: json['street'],
      propertyType: json['property_type'],
      status: json['status'],
      treatmentData: TreatmentDataDto.fromJson(json['treatmentData']),
      liraaData: LiraaDataDto.fromJson(json['liraaData']),
      inspected: json['inspected'],
    );
  }

  Map<String, dynamic> toJson() => {
    'block': block,
    'sus': sus,
    'street': street,
    'property_type': propertyType,
    'status': status,
    'treatmentData': treatmentData?.toJson(),
    'liraaData': liraaData?.toJson(),
    'inspected': inspected,
  };
}

class TreatmentDataDto {
  final int eliminatedDeposits;
  final bool treated;
  final int treatedDeposits;
  final double usedLarvicideAmount;

  TreatmentDataDto({
    required this.eliminatedDeposits,
    required this.treated,
    required this.treatedDeposits,
    required this.usedLarvicideAmount,
  });

  factory TreatmentDataDto.fromJson(Map<String, dynamic> json) {
    return TreatmentDataDto(
      eliminatedDeposits: json['eliminated_deposits'],
      treated: json['treated'],
      treatedDeposits: json['treated_deposits'],
      usedLarvicideAmount: (json['used_larvicide_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'eliminated_deposits': eliminatedDeposits,
    'treated': treated,
    'treated_deposits': treatedDeposits,
    'used_larvicide_amount': usedLarvicideAmount,
  };
}

class LiraaDataDto {
  final int a1;
  final int a2;
  final int b;
  final int c;
  final int d1;
  final int d2;
  final int e;
  final int? sampleStart;
  final int? sampleEnd;
  final int? vialsCount;

  LiraaDataDto({
    required this.a1,
    required this.a2,
    required this.b,
    required this.c,
    required this.d1,
    required this.d2,
    required this.e,
    required this.sampleStart,
    required this.sampleEnd,
    required this.vialsCount,
  });

  factory LiraaDataDto.fromJson(Map<String, dynamic> json) {
    return LiraaDataDto(
      a1: json['A1'],
      a2: json['A2'],
      b: json['B'],
      c: json['C'],
      d1: json['D1'],
      d2: json['D2'],
      e: json['E'],
      sampleStart: json['sample_start'],
      sampleEnd: json['sample_end'],
      vialsCount: json['vials_count'],
    );
  }

  Map<String, dynamic> toJson() => {
    'A1': a1,
    'A2': a2,
    'B': b,
    'C': c,
    'D1': d1,
    'D2': d2,
    'E': e,
    'sample_start': sampleStart,
    'sample_end': sampleEnd,
    'vials_count': vialsCount,
  };
}
