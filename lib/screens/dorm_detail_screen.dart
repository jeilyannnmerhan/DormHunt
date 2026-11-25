import 'package:flutter/material.dart';
import '../models/dorm.dart';
import '../theme.dart';

class DormDetailScreen extends StatelessWidget {
  final Dorm dorm;
  const DormDetailScreen({super.key, required this.dorm});

  Widget _placeholder() => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.apartment, size: 48, color: Colors.grey),
      );

  Widget _chip(IconData icon, String text, double s) => Container(
        padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 8 * s),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          border: Border.all(color: AppColors.darkBlue),
          borderRadius: BorderRadius.circular(20 * s),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 18 * s, color: AppColors.darkBlue),
          SizedBox(width: 6 * s),
          Text(text,
              style: TextStyle(fontSize: 14 * s, color: AppColors.darkBlue)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final s = scaleOf(context);
    final wide = isWide(context);

    final photo = ClipRRect(
      borderRadius: BorderRadius.circular(16 * s),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: dorm.image == null
            ? _placeholder()
            : Image.asset(dorm.image!,
                fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder()),
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(dorm.name,
            style: TextStyle(
                fontSize: 30 * s,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBlue)),
        SizedBox(height: 12 * s),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.location_on, size: 22 * s, color: AppColors.darkBlue),
          SizedBox(width: 8 * s),
          Expanded(
            child: Text(dorm.address,
                style: TextStyle(
                    fontSize: 16 * s, height: 1.3, color: AppColors.darkBlue)),
          ),
        ]),
        SizedBox(height: 18 * s),
        Wrap(spacing: 10 * s, runSpacing: 10 * s, children: [
          _chip(Icons.bed_outlined, dorm.roomType, s),
        ]),
        SizedBox(height: 28 * s),
        Text('₱${dorm.price}/mo',
            style: TextStyle(
                fontSize: 30 * s,
                fontWeight: FontWeight.w800,
                color: AppColors.ink)),
        SizedBox(height: 24 * s),
        SizedBox(
          width: double.infinity,
          height: 52 * s,
          child: ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Messaging is coming soon.')),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30 * s)),
            ),
            child: Text('Contact owner',
                style: TextStyle(fontSize: 16 * s, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        title: Text(dorm.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24 * s),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: photo),
                      const SizedBox(width: 40),
                      Expanded(flex: 4, child: info),
                    ],
                  )
                : Column(children: [
                    photo,
                    SizedBox(height: 20 * s),
                    info,
                  ]),
          ),
        ),
      ),
    );
  }
}