import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_generator/rdsa/dtos.dart';

class Rdsa {
  static Future<Uint8List> generateRDSA(ReportDto dto) async {
    final pdf = pw.Document();

    final frontPageBG = pw.MemoryImage(
      (await rootBundle.load(
        'packages/pdf_generator/assets/rdsa_front.png',
      )).buffer.asUint8List(),
    );
    final backPageBG = pw.MemoryImage(
      (await rootBundle.load(
        'packages/pdf_generator/assets/rdsa_back.png',
      )).buffer.asUint8List(),
    );

    final visits = dto.visits;
    final info = dto.info;

    final positions = {
      'userName': const FieldPosition(90, 538),
      'cityName': const FieldPosition(30, 86),
      'areaName': const FieldPosition(200, 86),
      'areaCategory': const FieldPosition(420, 86),
      'areaZone': const FieldPosition(504, 86),
      'areaType': const FieldPosition(690, 86),
      'formCompleted': const FieldPosition(763, 86),
      'activityDate': const FieldPosition(30, 126),
      'activityCycle': const FieldPosition(224, 126),
      'activityCode': const FieldPosition(328, 126),
    };

    final boldTextStyle = pw.TextStyle(
      fontSize: 6,
      fontWeight: pw.FontWeight.bold,
    );
    final headerStyle = pw.TextStyle(fontSize: 10);

    for (var i = 0; i < (visits.length / 18).ceil(); i++) {
      final slice = visits.skip(i * 18).take(18).toList();
      final summaryData = getSummaryData(slice);

      final fields = <pw.Widget>[];
      final bpFields = <pw.Widget>[];

      // add static fields

      fields.addAll([
        //first row of header
        drawField(
          containedText(
            info.cityName,
            width: 158,
            height: 20,
            style: headerStyle,
          ),
          positions['cityName']!,
        ),
        drawField(
          containedText(
            info.areaName,
            width: 210,
            height: 20,
            style: headerStyle,
          ),
          positions['areaName']!,
        ),
        drawField(
          containedText(
            info.areaCategory,
            width: 74,
            height: 20,
            style: headerStyle,
          ),
          positions['areaCategory']!,
        ),
        drawField(
          containedText(
            info.areaZone,
            width: 172,
            height: 20,
            style: headerStyle,
          ),
          positions['areaZone']!,
        ),
        drawField(
          containedText(
            info.areaType,
            width: 24,
            height: 20,
            style: headerStyle,
          ),
          positions['areaType']!,
        ),
        drawField(
          containedText(
            info.formCompleted,
            width: 24,
            height: 20,
            style: headerStyle,
          ),
          positions['formCompleted']!,
        ),
        //second row of header
        drawField(
          containedText(
            info.activityDate,
            width: 158,
            height: 20,
            style: headerStyle,
          ),
          positions['activityDate']!,
        ),
        drawField(
          containedText(
            info.activityCycle,
            width: 66,
            height: 20,
            style: headerStyle,
          ),
          positions['activityCycle']!,
        ),
        drawField(
          containedText(
            info.activityCode,
            width: 28,
            height: 24,
            style: headerStyle,
          ),
          positions['activityCode']!,
        ),
        //agent name
        drawField(
          containedText(
            info.userName,
            width: 176,
            height: 20,
            style: headerStyle,
            alignment: pw.Alignment.centerLeft,
          ),
          positions['userName']!,
        ),
      ]);

      // add table
      for (var i = 0; i < slice.length; i++) {
        final double y = 235.5 + i * 14.5 + i * 0.7;
        final visit = slice[i];

        fields.add(
          drawField(
            containedText(
              visit.block.toString(),
              width: 14,
              height: 14.5,
              style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
            ),
            FieldPosition(28.5, y),
          ),
        );
        fields.add(
          drawField(
            containedText(
              visit.street.toString(),
              width: 168,
              height: 14.5,
              style: pw.TextStyle(fontSize: 8),
              alignment: pw.Alignment.centerLeft,
            ),
            FieldPosition(74, y),
          ),
        );
        fields.add(
          drawField(
            containedText(
              visit.sus.toString().split('.')[0],
              width: 16,
              height: 14.5,
              style: boldTextStyle,
            ),
            FieldPosition(244, y),
          ),
        );

        // sus sequence if exists
        if (visit.sus.toString().split('.').length > 1) {
          fields.add(
            drawField(
              containedText(
                visit.sus.toString().split('.')[1],
                width: 16,
                height: 14.5,
                style: boldTextStyle,
              ),
              FieldPosition(261, y),
            ),
          );
        }

        fields.add(
          drawField(
            containedText(
              visit.propertyType.toString(),
              width: 16,
              height: 14.5,
              style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold),
            ),
            FieldPosition(294.2, y),
          ),
        );

        if (visit.status == 'finished' || visit.status == 'recovered') {
          fields.add(
            drawField(
              containedText(
                getStatusAbbr(visit.status),
                width: 19,
                height: 14.5,
                style: boldTextStyle,
              ),
              FieldPosition(329, y),
            ),
          );
        } else {
          fields.add(
            drawField(
              containedText(
                getStatusAbbr(visit.status),
                width: 18,
                height: 14.5,
                style: boldTextStyle,
              ),
              FieldPosition(348, y),
            ),
          );
        }

        if (visit.treatmentData != null) {
          final data = visit.treatmentData;

          fields.add(
            drawField(
              containedText(
                data!.eliminatedDeposits.toString(),
                width: 19,
                height: 14.5,
              ),
              FieldPosition(575, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.treated == true ? 'X' : '',
                width: 16,
                height: 14.5,
                style: boldTextStyle,
              ),
              FieldPosition(595, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                'BTI',
                width: 17.5,
                height: 14.5,
                style: boldTextStyle,
              ),
              FieldPosition(612, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.usedLarvicideAmount.toStringAsFixed(2),
                width: 24,
                height: 14.5,
              ),
              FieldPosition(632, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.treatedDeposits.toString(),
                width: 30,
                height: 14.5,
              ),
              FieldPosition(657, y),
            ),
          );
        }

        if (visit.liraaData != null) {
          final data = visit.liraaData!;

          fields.add(
            drawField(
              containedText(
                data.a1 > 0 ? data.a1.toString() : '',
                width: 17,
                height: 14.5,
              ),
              FieldPosition(366, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.a2 > 0 ? data.a2.toString() : '',
                width: 15,
                height: 14.5,
              ),
              FieldPosition(383.5, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.b > 0 ? data.b.toString() : '',
                width: 17,
                height: 14.5,
              ),
              FieldPosition(399, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.c > 0 ? data.c.toString() : '',
                width: 16,
                height: 14.5,
              ),
              FieldPosition(417, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.d1 > 0 ? data.d1.toString() : '',
                width: 17,
                height: 14.5,
              ),
              FieldPosition(433, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.d2 > 0 ? data.d2.toString() : '',
                width: 17,
                height: 14.5,
              ),
              FieldPosition(450, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.e > 0 ? data.e.toString() : '',
                width: 17,
                height: 14.5,
              ),
              FieldPosition(469, y),
            ),
          );
          fields.add(
            drawField(
              containedText('X', width: 16, height: 14.5, style: boldTextStyle),
              FieldPosition(487, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.sampleStart?.toString() ?? '',
                width: 24,
                height: 14.5,
              ),
              FieldPosition(504, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.sampleEnd?.toString() ?? '',
                width: 24,
                height: 14.5,
              ),
              FieldPosition(526, y),
            ),
          );
          fields.add(
            drawField(
              containedText(
                data.vialsCount?.toString() ?? '',
                width: 24,
                height: 14.5,
              ),
              FieldPosition(550.5, y),
            ),
          );
        }
      }

      final frontPage = pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.zero,
        build: (_) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Image(frontPageBG, fit: pw.BoxFit.fill),
              ),
              ...fields,
            ],
          );
        },
      );

      pdf.addPage(frontPage);

      bpFields.add(
        drawField(
          containedText(summaryData.r.toString(), width: 45, height: 16),
          FieldPosition(28, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.c.toString(), width: 50, height: 16),
          FieldPosition(74, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.tb.toString(), width: 20, height: 16),
          FieldPosition(125, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.pe.toString(), width: 20, height: 16),
          FieldPosition(146.5, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.o.toString(), width: 24, height: 16),
          FieldPosition(168, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(
            (summaryData.finished + summaryData.recovered).toString(),
            width: 24,
            height: 16,
          ),
          FieldPosition(193, 85),
        ),
      );

      bpFields.add(
        drawField(
          containedText(
            summaryData.recovered.toString(),
            width: 34,
            height: 16,
          ),
          FieldPosition(356, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.denied.toString(), width: 36, height: 16),
          FieldPosition(468, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.closed.toString(), width: 36, height: 16),
          FieldPosition(505, 85),
        ),
      );

      bpFields.add(
        drawField(
          containedText(
            summaryData.treatment.treated.toString(),
            width: 28,
            height: 16,
          ),
          FieldPosition(249, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(
            summaryData.treatment.eliminatedDeposits.toString(),
            width: 43,
            height: 17,
          ),
          FieldPosition(28, 188),
        ),
      );
      bpFields.add(
        drawField(
          containedText('BTI', width: 30, height: 17),
          FieldPosition(72.5, 188),
        ),
      );
      bpFields.add(
        drawField(
          containedText(
            summaryData.treatment.usedLarvicideAmount.toStringAsFixed(2),
            width: 43,
            height: 17,
          ),
          FieldPosition(104, 188),
        ),
      );
      bpFields.add(
        drawField(
          containedText(
            summaryData.treatment.treatedDeposits.toString(),
            width: 43,
            height: 17,
          ),
          FieldPosition(148, 188),
        ),
      );

      bpFields.add(
        drawField(
          containedText(
            (summaryData.finished + summaryData.recovered).toString(),
            width: 38,
            height: 16,
          ),
          FieldPosition(316, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(
            summaryData.liraa.vialsCount.toString(),
            width: 42,
            height: 16,
          ),
          FieldPosition(405, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.liraa.a1.toString(), width: 32, height: 16),
          FieldPosition(562, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.liraa.a2.toString(), width: 32, height: 16),
          FieldPosition(594, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.liraa.b.toString(), width: 32, height: 16),
          FieldPosition(624, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.liraa.c.toString(), width: 32, height: 16),
          FieldPosition(656, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.liraa.d1.toString(), width: 32, height: 16),
          FieldPosition(686.5, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.liraa.d2.toString(), width: 32, height: 16),
          FieldPosition(718, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(summaryData.liraa.e.toString(), width: 32, height: 16),
          FieldPosition(750, 85),
        ),
      );
      bpFields.add(
        drawField(
          containedText(
            (summaryData.liraa.a1 +
                    summaryData.liraa.a2 +
                    summaryData.liraa.b +
                    summaryData.liraa.c +
                    summaryData.liraa.d1 +
                    summaryData.liraa.d2 +
                    summaryData.liraa.e)
                .toString(),
            width: 32,
            height: 16,
          ),
          FieldPosition(782, 85),
        ),
      );

      final backPage = pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.zero,
        build: (_) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Image(backPageBG, fit: pw.BoxFit.fill),
              ),
              ...bpFields,
            ],
          );
        },
      );

      pdf.addPage(backPage);
    }

    return await pdf.save();
  }
}

pw.Widget containedText(
  String data, {
  required double width,
  required double height,
  pw.Alignment alignment = pw.Alignment.center,
  pw.TextStyle style = const pw.TextStyle(fontSize: 6),
}) {
  return pw.Container(
    // color: PdfColors.blue,
    alignment: alignment,
    width: width,
    height: height,
    child: pw.Text(data, style: style),
  );
}

String getStatusAbbr(String? status) {
  switch (status) {
    case "pending":
      return "P";
    case "finished":
      return "N";
    case "closed":
      return "F";
    case "denied":
      return "R";
    case "recovered":
      return "R";
    default:
      return " ";
  }
}

SummaryData getSummaryData(List<VisitDto> visits) {
  final summaryData = SummaryData();

  for (var visit in visits) {
    switch (visit.propertyType) {
      case 'R':
        summaryData.r += 1;
        break;
      case 'C':
        summaryData.c += 1;
        break;
      case 'TB':
        summaryData.tb += 1;
        break;
      case 'O':
        summaryData.o += 1;
        break;
      case 'PE':
        summaryData.pe += 1;
        break;
      default:
    }
    switch (visit.status) {
      case 'pending':
        summaryData.pending += 1;
        break;
      case 'finished':
        summaryData.finished += 1;
        break;
      case 'closed':
        summaryData.closed += 1;
        break;
      case 'denied':
        summaryData.denied += 1;
        break;
      case 'recovered':
        summaryData.recovered += 1;
        break;
      default:
    }

    final treatmentData = visit.treatmentData;

    if (treatmentData != null) {
      if (treatmentData.treated == true) {
        summaryData.treatment.treated += 1;
      }

      summaryData.treatment.eliminatedDeposits +=
          treatmentData.eliminatedDeposits;

      summaryData.treatment.treatedDeposits += treatmentData.treatedDeposits;

      summaryData.treatment.usedLarvicideAmount +=
          treatmentData.usedLarvicideAmount;
    }

    final liraaData = visit.liraaData;

    if (liraaData != null) {
      summaryData.liraa.a1 += liraaData.a1;
      summaryData.liraa.a2 += liraaData.a2;
      summaryData.liraa.b += liraaData.b;
      summaryData.liraa.c += liraaData.c;
      summaryData.liraa.d1 += liraaData.d1;
      summaryData.liraa.d2 += liraaData.d2;
      summaryData.liraa.e += liraaData.e;

      if (liraaData.vialsCount != null) {
        summaryData.liraa.vialsCount += liraaData.vialsCount!;
      }
    }
  }

  return summaryData;
}

class SummaryData {
  int r;
  int c;
  int o;
  int tb;
  int pe;

  int pending;
  int finished;
  int closed;
  int denied;
  int recovered;

  TreatmentSummary treatment;
  LiraaSummary liraa;

  SummaryData({
    this.r = 0,
    this.c = 0,
    this.o = 0,
    this.tb = 0,
    this.pe = 0,
    this.pending = 0,
    this.finished = 0,
    this.closed = 0,
    this.denied = 0,
    this.recovered = 0,
    TreatmentSummary? treatment,
    LiraaSummary? liraa,
  }) : treatment = treatment ?? TreatmentSummary(),
       liraa = liraa ?? LiraaSummary();
}

class TreatmentSummary {
  int eliminatedDeposits;
  int treated;
  int treatedDeposits;
  double usedLarvicideAmount;

  TreatmentSummary({
    this.eliminatedDeposits = 0,
    this.treated = 0,
    this.treatedDeposits = 0,
    this.usedLarvicideAmount = 0,
  });
}

class LiraaSummary {
  int a1;
  int a2;
  int b;
  int c;
  int d1;
  int d2;
  int e;

  int vialsCount;

  LiraaSummary({
    this.a1 = 0,
    this.a2 = 0,
    this.b = 0,
    this.c = 0,
    this.d1 = 0,
    this.d2 = 0,
    this.e = 0,
    this.vialsCount = 0,
  });
}

class FieldPosition {
  final double x;
  final double y;

  const FieldPosition(this.x, this.y);
}

pw.Widget drawField(pw.Widget? data, FieldPosition pos) {
  if (data == null) return pw.SizedBox();

  return pw.Positioned(left: pos.x, top: pos.y, child: data);
}
