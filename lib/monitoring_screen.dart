import 'package:flutter/material.dart';
import 'bt_chart.dart';
import 'sp_chart.dart';
import 'ws_chart.dart';
import 'wt_chart.dart';
import 'report_screen.dart';

class MonitoringScreen extends StatefulWidget {
  final String idPerangkat;
  final String jenisPerangkat;
  const MonitoringScreen({
    Key? key,
    required this.jenisPerangkat,
    required this.idPerangkat,
  }) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    String jenisPerangkat = widget.jenisPerangkat;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (jenisPerangkat == 'PLTB')
              WtChart(idWt: widget.idPerangkat)
            else if (jenisPerangkat == 'PLTS')
              SpChart(idSp: widget.idPerangkat)
            else if (jenisPerangkat == 'Diesel')
              // WsChart(idWs: widget.idPerangkat)
              const ReportScreen()
            else if (jenisPerangkat == 'Baterai')
              BtChart(idBt: widget.idPerangkat)
            else if (jenisPerangkat == 'Weather Station')
              WsChart(idWs: widget.idPerangkat)
            else if (jenisPerangkat == 'Rumah Energi')
              // WsChart(idWs: widget.idPerangkat),
              const ReportScreen()
          ],
        ),
      ),
    );
  }
}
