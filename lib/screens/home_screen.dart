import 'package:flutter/material.dart';
import '../models/dorm.dart';
import '../theme.dart';
import 'dorm_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  String _query = '';
  String _price = 'Price Range';
  String _room = 'Room Type';

  static const _prices = [
    'Price Range',
    'Under ₱3,000',
    '₱3,000 - ₱4,000',
    'Above ₱4,000'
  ];
  static const _rooms = ['Room Type', 'Single', 'Shared', 'Bedspace'];

  bool _matchesPrice(Dorm d) {
    switch (_price) {
      case 'Under ₱3,000':
        return d.price < 3000;
      case '₱3,000 - ₱4,000':
        return d.price >= 3000 && d.price <= 4000;
      case 'Above ₱4,000':
        return d.price > 4000;
      default:
        return true;
    }
  }

  List<Dorm> get _results {
    final q = _query.trim().toLowerCase();
    return sampleDorms.where((d) {
      final text = '${d.name} ${d.address}'.toLowerCase();
      return (q.isEmpty || text.contains(q)) &&
          _matchesPrice(d) &&
          (_room == 'Room Type' || d.roomType == _room);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = scaleOf(context);
    final wide = isWide(context);
    final content = _tab == 0 ? _explore(s, wide) : _messages();

    return Scaffold(
      backgroundColor: Colors.white,
      body: wide
          ? Row(children: [
              _rail(s),
              const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
              Expanded(child: content),
            ])
          : content,
      bottomNavigationBar: wide ? null : _bottomNav(s),
    );
  }

  // ---------------------------------------------------------------- explore

    Widget _explore(double s, bool wide) {
    final results = _results;
    final pad = wide ? 32.0 : 16 * s;

    return Column(
      children: [
        _header(s, wide),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text('No dorms match your search.',
                      style: TextStyle(fontSize: 16 * s)))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    const gap = 36.0;
                    final avail = constraints.maxWidth - pad * 2;
                    final cols = (avail / 400).floor().clamp(1, 5);
                    final cardW = ((avail - gap * (cols - 1)) / cols)
                        .clamp(0.0, 400.0)
                        .toDouble();
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(pad),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle(results.length, s),
                            SizedBox(height: 28 * s),
                            Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              alignment: WrapAlignment.start,
                              children: [
                                for (final d in results)
                                  SizedBox(
                                      width: cardW,
                                      child: _DormCard(dorm: d, s: s)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _sectionTitle(int count, double s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count dorm${count == 1 ? '' : 's'} available',
            style: TextStyle(
                fontSize: 24 * s,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBlue),
          ),
          SizedBox(height: 6 * s),
          Container(
            width: 56 * s,
            height: 4 * s,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      );

  Widget _greeting(double s) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Your location',
              style: TextStyle(color: Colors.white, fontSize: 12 * s)),
          SizedBox(height: 2 * s),
          Text('Hi,  Jeily Ann',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * s,
                  fontWeight: FontWeight.w700)),
        ],
      );

  Widget _searchBar(double s) => Container(
        height: 42 * s,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24 * s),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _query = v),
          style: TextStyle(fontSize: 14 * s),
          decoration: InputDecoration(
            hintText: 'Search Street, Dorm Name...',
            hintStyle:
                TextStyle(fontSize: 13 * s, fontStyle: FontStyle.italic),
            prefixIcon: Icon(Icons.search, size: 22 * s, color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 11 * s),
          ),
        ),
      );

  Widget _header(double s, bool wide) {
    final menu = IconButton(
      onPressed: () {},
      icon: Icon(Icons.menu, color: Colors.white, size: 26 * s),
    );

    final Widget body;
    if (wide) {
      // One compact row: greeting | search | filters | menu
      body = Row(
        children: [
          _greeting(s),
          const SizedBox(width: 32),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: _searchBar(s),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
              width: 190 * s,
              child:
                  _dropdown(_price, _prices, (v) => setState(() => _price = v), s)),
          const SizedBox(width: 12),
          SizedBox(
              width: 170 * s,
              child:
                  _dropdown(_room, _rooms, (v) => setState(() => _room = v), s)),
          const SizedBox(width: 8),
          menu,
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: _greeting(s)), menu],
          ),
          SizedBox(height: 14 * s),
          Padding(
              padding: EdgeInsets.only(right: 8 * s), child: _searchBar(s)),
          SizedBox(height: 14 * s),
          Row(children: [
            Expanded(
                child: _dropdown(
                    _price, _prices, (v) => setState(() => _price = v), s)),
            SizedBox(width: 12 * s),
            Expanded(
                child: _dropdown(
                    _room, _rooms, (v) => setState(() => _room = v), s)),
            SizedBox(width: 8 * s),
          ]),
        ],
      );
    }

    return Container(
      width: double.infinity,
      color: AppColors.blue,
      padding: EdgeInsets.fromLTRB(
          wide ? 28 : 20 * s, 14 * s, wide ? 20 : 12 * s, 16 * s),
      child: SafeArea(bottom: false, child: body),
    );
  }

  Widget _dropdown(String value, List<String> items,
      ValueChanged<String> onChanged, double s) {
    return Container(
      height: 36 * s,
      padding: EdgeInsets.only(left: 16 * s, right: 8 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * s),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 22 * s),
          style: TextStyle(
              fontSize: 13.5 * s,
              fontWeight: FontWeight.w600,
              color: AppColors.ink),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  Widget _messages() => const SafeArea(
        child: Center(child: Text('No messages yet.')),
      );

  // ------------------------------------------------------------- navigation

  Widget _navItem(int index, IconData icon, String label, double s) {
    final selected = _tab == index;
    return InkWell(
      onTap: () => setState(() => _tab = index),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12 * s, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 26 * s,
                color: selected ? AppColors.blue : AppColors.darkBlue),
            SizedBox(height: 3 * s),
            Text(label,
                style: TextStyle(
                    fontSize: 12.5 * s,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.ink)),
          ],
        ),
      ),
    );
  }

  /// Side navigation for wide screens.
  Widget _rail(double s) {
    return SizedBox(
      width: 112,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.home_rounded, size: 38, color: AppColors.slate),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: _navItem(0, Icons.grid_view_rounded, 'Explore', s)),
            SizedBox(
                width: double.infinity,
                child:
                    _navItem(1, Icons.chat_bubble_outline, 'Messages', s)),
          ],
        ),
      ),
    );
  }

  /// Bottom navigation for phones.
  Widget _bottomNav(double s) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        top: false,
        child: Row(children: [
          Expanded(child: _navItem(0, Icons.grid_view_rounded, 'Explore', s)),
          Expanded(
              child: _navItem(1, Icons.chat_bubble_outline, 'Messages', s)),
        ]),
      ),
    );
  }
}

class _DormCard extends StatelessWidget {
  final Dorm dorm;
  final double s;
  const _DormCard({required this.dorm, required this.s});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16 * s);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        border: Border.all(color: AppColors.darkBlue, width: 1.5),
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0A2A66),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DormDetailScreen(dorm: dorm)),
          ),
          child: Padding(
            padding: EdgeInsets.all(12 * s),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10 * s),
                  child: AspectRatio(
                    aspectRatio: 2.0,
                    child: dorm.image == null
                        ? _placeholder()
                        : Image.asset(dorm.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder()),
                  ),
                ),
                SizedBox(height: 14 * s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4 * s),
                  child: Text(dorm.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18 * s,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBlue)),
                ),
                SizedBox(height: 8 * s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4 * s),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          size: 18 * s, color: AppColors.darkBlue),
                      SizedBox(width: 6 * s),
                      Expanded(
                        child: Text(dorm.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.5 * s,
                                height: 1.3,
                                color: AppColors.darkBlue)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16 * s),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 18 * s, vertical: 7 * s),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      border:
                          Border.all(color: AppColors.darkBlue, width: 1.5),
                      borderRadius: BorderRadius.circular(24 * s),
                    ),
                    child: Text('₱${dorm.price}/mo',
                        style: TextStyle(
                            fontSize: 15 * s,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.apartment, color: Colors.grey),
      );
}