import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/crypto_entity.dart';

class CryptoDetailBottomSheet extends StatelessWidget {
  final CryptoEntity crypto;

  const CryptoDetailBottomSheet({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.change >= 0;
    final themeColor = isPositive ? Colors.greenAccent : Colors.redAccent;

    final List<FlSpot> chartSpots = [];
    for (int i = 0; i < crypto.sparkline.length; i++) {
      chartSpots.add(FlSpot(i.toDouble(), crypto.sparkline[i]));
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: crypto.iconUrl.toLowerCase().endsWith('.svg')
                        ? SvgPicture.network(crypto.iconUrl)
                        : Image.network(crypto.iconUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        crypto.symbol,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${crypto.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${isPositive ? '+' : ''}${crypto.change.toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 16, color: themeColor, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 40),

          const Text(
            'Price History (24h)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: chartSpots.isEmpty
                ? const Center(child: Text('Grafik verisi bulunamadı.'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false), 
                      titlesData: FlTitlesData(show: false), 
                      borderData: FlBorderData(show: false), 
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartSpots,
                          isCurved: true, 
                          color: themeColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false), 
                          belowBarData: BarAreaData(
                            show: true,
                            color: themeColor.withOpacity(0.15), 
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}