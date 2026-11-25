import 'package:flutter/material.dart';
import '../models/dorm.dart';
import '../theme.dart';

class DormDetailScreen extends StatelessWidget {
  final Dorm dorm;
  const DormDetailScreen({super.key, required this.dorm});

  void _message(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen(dorm: dorm)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    final s = scaleOf(context);
    return Scaffold(
      backgroundColor: wide ? Colors.white : const Color(0xFF0D0D0D),
      body: SafeArea(
        child: wide ? _wide(context, s) : _narrow(context, s),
      ),
    );
  }

  // ---------- Mobile ----------
  Widget _narrow(BuildContext context, double s) {
    return Padding(
      padding: EdgeInsets.all(10 * s),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28 * s),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Hero(dorm: dorm, s: s),
                      Padding(
                        padding: EdgeInsets.fromLTRB(18 * s, 0, 18 * s, 16 * s),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TitleRow(dorm: dorm, s: s, stacked: true),
                            SizedBox(height: 14 * s),
                            _HostCard(dorm: dorm, s: s),
                            SizedBox(height: 16 * s),
                            _Inclusions(dorm: dorm, s: s),
                            SizedBox(height: 16 * s),
                            _Availability(dorm: dorm, s: s),
                            SizedBox(height: 16 * s),
                            _MapPlaceholder(s: s),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18 * s, 8 * s, 18 * s, 16 * s),
                child: _MessageButton(
                    s: s, maxWidth: 300, onTap: () => _message(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Wide ----------
  Widget _wide(BuildContext context, double s) {
    final t = s * 1.06; // balanced type scale on wide screens
    return Column(
      children: [
        Container(
          color: AppColors.blue,
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 8),
              const Text(
                'Dorm details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              final photoMin = (c.maxHeight * 0.36).clamp(280.0, 420.0);
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: c.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(36, 28, 36, 36),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ROW 1: photo + about  |  title, host, inclusions
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: photoMin + 100),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 11,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: _Hero(
                                                dorm: dorm,
                                                s: t,
                                                wide: true,
                                                fill: true),
                                          ),
                                          if (dorm.description.isNotEmpty) ...[
                                            const SizedBox(height: 20),
                                            _SectionTitle(
                                                'About this dorm', t),
                                            const SizedBox(height: 6),
                                            Text(
                                              dorm.description,
                                              style: TextStyle(
                                                  fontSize: 14 * t,
                                                  height: 1.5,
                                                  color: AppColors.slate),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 44),
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _TitleRow(dorm: dorm, s: t),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.location_on_outlined,
                                                  size: 20,
                                                  color: AppColors.slate),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  dorm.address,
                                                  style: TextStyle(
                                                      fontSize: 14 * t,
                                                      color: AppColors.slate),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          _HostCard(dorm: dorm, s: t),
                                          const SizedBox(height: 22),
                                          _Inclusions(dorm: dorm, s: t),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // ROW 2: location panel  |  availability panel (aligned)
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 11,
                                    child: _LocationPanel(s: t),
                                  ),
                                  const SizedBox(width: 44),
                                  Expanded(
                                    flex: 10,
                                    child: _Availability(dorm: dorm, s: t),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            _MessageButton(
                                s: t,
                                maxWidth: 460,
                                onTap: () => _message(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ================= Pieces =================

BoxDecoration _panel({Color fill = AppColors.fieldFill, double r = 14}) =>
    BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: AppColors.darkBlue, width: 1.5),
    );

class _Hero extends StatelessWidget {
  final Dorm dorm;
  final double s;
  final bool wide;
  final double? height; // fixed height (wide layout)
  final bool fill; // fill the height given by the parent (wide layout)
  const _Hero(
      {required this.dorm,
      required this.s,
      this.wide = false,
      this.height,
      this.fill = false});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.vertical(
      top: Radius.circular(wide ? 20 : 0),
      bottom: Radius.circular(wide ? 20 : 0),
    );
    final pills = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Pill(text: dorm.roomType, filled: true, s: s),
        SizedBox(width: 8 * s),
        _Pill(
          text: dorm.slotsAvailable > 0
              ? '${dorm.slotsAvailable} slots available'
              : 'Fully booked',
          filled: false,
          s: s,
        ),
      ],
    );
    final photo = dorm.image != null
        ? Image.asset(
            dorm.image!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _noPhoto(),
          )
        : _noPhoto();
    if (fill) {
      return Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(borderRadius: radius, child: photo),
          ),
          Positioned(left: 14 * s, bottom: 14, child: pills),
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: wide ? 0 : 16 * s),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: radius,
            child: height != null
                ? SizedBox(
                    height: height, width: double.infinity, child: photo)
                : AspectRatio(aspectRatio: 1.6, child: photo),
          ),
          if (!wide)
            Positioned(
              top: 10 * s,
              right: 10 * s,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all(8 * s),
                    child: Icon(Icons.arrow_back,
                        size: 20 * s, color: AppColors.darkBlue),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 14 * s,
            bottom: wide ? 14 : -14 * s,
            child: pills,
          ),
        ],
      ),
    );
  }

  Widget _noPhoto() => Container(
        color: AppColors.fieldFill,
        child: const Center(
            child: Icon(Icons.home_work_outlined,
                size: 48, color: AppColors.darkBlue)),
      );
}

class _Pill extends StatelessWidget {
  final String text;
  final bool filled;
  final double s;
  const _Pill({required this.text, required this.filled, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 4 * s),
      decoration: BoxDecoration(
        color: filled ? AppColors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blue, width: 1.2),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11 * s,
          fontWeight: FontWeight.w500,
          color: filled ? Colors.white : AppColors.blue,
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final Dorm dorm;
  final double s;
  final bool stacked; // mobile: title on top, price pill below on the right
  const _TitleRow(
      {required this.dorm, required this.s, this.stacked = false});

  @override
  Widget build(BuildContext context) {
    final title = Text(
      dorm.name,
      style: TextStyle(
        fontSize: (stacked ? 24 : 26) * s,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
    );
    final price = Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 7 * s),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBlue, width: 1.5),
      ),
      child: Text(
        '₱${_fmt(dorm.price)} /month',
        style: TextStyle(
          fontSize: 14 * s,
          fontWeight: FontWeight.w700,
          color: AppColors.darkBlue,
        ),
      ),
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          SizedBox(height: 8 * s),
          Align(alignment: Alignment.centerRight, child: price),
        ],
      );
    }
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8 * s,
      spacing: 12 * s,
      children: [title, price],
    );
  }
}

String _fmt(int n) {
  final str = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
    buf.write(str[i]);
  }
  return buf.toString();
}

class _HostCard extends StatelessWidget {
  final Dorm dorm;
  final double s;
  const _HostCard({required this.dorm, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12 * s),
      decoration: _panel(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22 * s,
            backgroundColor: AppColors.blue,
            child: Icon(Icons.person, color: Colors.white, size: 26 * s),
          ),
          SizedBox(width: 14 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 3 * s),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.darkBlue, width: 1)),
                  ),
                  child: Text(
                    dorm.hostName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15 * s,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
                SizedBox(height: 6 * s),
                Text(
                  dorm.isVerifiedHost
                      ? 'Dorm Owner  •  Verified Host'
                      : 'Dorm Owner',
                  style: TextStyle(fontSize: 12 * s, color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final double s;
  const _SectionTitle(this.text, this.s);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 16 * s,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      );
}

class _Inclusions extends StatelessWidget {
  final Dorm dorm;
  final double s;
  const _Inclusions({required this.dorm, required this.s});

  Widget _chip(String item) {
    return Container(
      constraints: BoxConstraints(minHeight: 52 * s),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBlue, width: 1.5),
      ),
      child: Text(
        item,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13 * s,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dorm.inclusions.isEmpty) return const SizedBox.shrink();
    final items = dorm.inclusions;
    final gap = 12 * s;
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final second = i + 1 < items.length ? items[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: gap),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _chip(items[i])),
                SizedBox(width: gap),
                Expanded(
                  child: second != null ? _chip(second) : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Dorm Inclusions', s),
        SizedBox(height: 10 * s),
        ...rows,
      ],
    );
  }
}

class _Availability extends StatelessWidget {
  final Dorm dorm;
  final double s;
  const _Availability({required this.dorm, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12 * s),
      decoration: _panel(r: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4 * s, bottom: 10 * s),
            child: _SectionTitle('Dorm Room Availability', s),
          ),
          if (dorm.rooms.isEmpty)
            Padding(
              padding: EdgeInsets.all(8 * s),
              child: Text('No rooms listed yet.',
                  style: TextStyle(fontSize: 13 * s)),
            ),
          for (final room in dorm.rooms) _RoomRow(room: room, s: s),
        ],
      ),
    );
  }
}

class _RoomRow extends StatelessWidget {
  final Room room;
  final double s;
  const _RoomRow({required this.room, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10 * s),
      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 10 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBlue, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13 * s,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 3 * s),
                Text(
                  '${room.capacityLabel}  |  ₱${_fmt(room.price)} / month',
                  style: TextStyle(fontSize: 11.5 * s, color: AppColors.slate),
                ),
              ],
            ),
          ),
          SizedBox(width: 8 * s),
          _StatusBadge(room: room, s: s),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Room room;
  final double s;
  const _StatusBadge({required this.room, required this.s});

  @override
  Widget build(BuildContext context) {
    final filled =
        room.status == RoomStatus.limited || room.status == RoomStatus.full;
    final color = filled ? AppColors.red : AppColors.blue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 3 * s),
      decoration: BoxDecoration(
        color: filled ? AppColors.red : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Text(
        room.badgeLabel,
        style: TextStyle(
          fontSize: 10.5 * s,
          fontWeight: FontWeight.w500,
          color: filled ? Colors.white : AppColors.blue,
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final double s;
  final double? height;
  const _MapPlaceholder({required this.s, this.height});

  @override
  Widget build(BuildContext context) {
    // TODO(teammates): replace with Google Maps widget.
    return Container(
      width: double.infinity,
      height: height ?? 120 * s,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.darkBlue, width: 1.5),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _CrossPainter())),
          Center(
            child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.symmetric(horizontal: 10 * s, vertical: 4 * s),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined,
                      size: 18 * s, color: AppColors.darkBlue),
                  SizedBox(width: 6 * s),
                  Flexible(
                    child: Text(
                      'Map of the dorm location',
                      style: TextStyle(
                          fontSize: 13 * s, color: AppColors.darkBlue),
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

/// Map placeholder that fills whatever space its parent gives it.
class _MapFill extends StatelessWidget {
  const _MapFill();

  @override
  Widget build(BuildContext context) {
    // TODO(teammates): replace with Google Maps widget.
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.darkBlue, width: 1.5),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _CrossPainter())),
          Center(
            child: Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, size: 22, color: AppColors.darkBlue),
                  SizedBox(width: 8),
                  Text(
                    'Map of the dorm location',
                    style: TextStyle(fontSize: 15, color: AppColors.darkBlue),
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

/// Plain location block (no panel). Its title lines up with the title of the
/// availability panel and the map spans the same height as the panel's content.
class _LocationPanel extends StatelessWidget {
  final double s;
  const _LocationPanel({required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.5 + 12 * s, bottom: 10 * s),
          child: _SectionTitle('Dorm Location', s),
        ),
        const Expanded(child: _MapFill()),
      ],
    );
  }
}

class _CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.darkBlue
      ..strokeWidth = 1;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), p);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _MessageButton extends StatelessWidget {
  final double s;
  final double maxWidth;
  final VoidCallback onTap;
  const _MessageButton(
      {required this.s, required this.onTap, this.maxWidth = 420});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          height: 52 * s,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Message Owner',
              style: TextStyle(fontSize: 17 * s, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= Simple chat placeholder =================

class ChatScreen extends StatefulWidget {
  final Dorm dorm;
  const ChatScreen({super.key, required this.dorm});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ctrl = TextEditingController();
  final List<String> _sent = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sent.add(_ctrl.text.trim()));
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final s = scaleOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        title: Text(widget.dorm.hostName, style: TextStyle(fontSize: 17 * s)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16 * s),
                  children: [
                    Container(
                      padding: EdgeInsets.all(12 * s),
                      decoration: _panel(),
                      child: Text(
                        'Say hi to ${widget.dorm.hostName} about '
                        '${widget.dorm.name}. Messaging will be connected soon.',
                        style: TextStyle(fontSize: 13 * s),
                      ),
                    ),
                    for (final m in _sent)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 10 * s),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14 * s, vertical: 10 * s),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(m,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14 * s)),
                        ),
                      ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12 * s, 6 * s, 12 * s, 10 * s),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ctrl,
                            maxLength: 300,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.fieldFill,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter a message'
                                : null,
                            onFieldSubmitted: (_) => _send(),
                          ),
                        ),
                        SizedBox(width: 8 * s),
                        IconButton.filled(
                          style: IconButton.styleFrom(
                              backgroundColor: AppColors.red),
                          onPressed: _send,
                          icon: const Icon(Icons.send, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
