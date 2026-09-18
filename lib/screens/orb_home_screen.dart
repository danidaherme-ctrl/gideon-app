import 'dart:math' as math;

import 'package:flutter/material.dart';

// ============================================================
// ORB HOME SCREEN
// ============================================================

class OrbHomeScreen extends StatefulWidget {
  const OrbHomeScreen({
    super.key,
    this.onOpenMenu,
  });

  final VoidCallback? onOpenMenu;

  @override
  State<OrbHomeScreen> createState() => _OrbHomeScreenState();
}

// ============================================================
// HOME STATE
// ============================================================

class _OrbHomeScreenState extends State<OrbHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ==========================================================
  // NAVIGATION
  // ==========================================================

  void _selectPage(int index) {
    // Chat is handled by the parent.
    if (index == 2) {
      widget.onOpenMenu?.call();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _currentPage() {
    switch (_selectedIndex) {
      case 0:
        return _HomeContent(
          onOpenChat: widget.onOpenMenu,
          controller: _controller,
        );

      case 1:
        return const _AccountPage();

      case 3:
        return const _ProPage();

      case 4:
        return const _MissionsPage();

      default:
        return _HomeContent(
          onOpenChat: widget.onOpenMenu,
          controller: _controller,
        );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF070B14),

        body: SafeArea(
          child: _currentPage(),
        ),

        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            height: 88,
            decoration: const BoxDecoration(
              color: Color(0xFF080D17),
              border: Border(
                top: BorderSide(
                  color: Color(0xFF1B2535),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ACCOUNT
                _BottomNavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Account',
                  active: _selectedIndex == 1,
                  onTap: () => _selectPage(1),
                ),

                // PRO
                _BottomNavItem(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Pro',
                  active: _selectedIndex == 3,
                  onTap: () => _selectPage(3),
                ),

                // CHAT
                _BottomNavItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chat',
                  active: false,
                  onTap: () => _selectPage(2),
                ),

                // MISSIONS
                _BottomNavItem(
                  icon: Icons.layers_outlined,
                  label: 'Missions',
                  active: _selectedIndex == 4,
                  onTap: () => _selectPage(4),
                ),

                // HOME
                _BottomNavItem(
                  icon: Icons.home_filled,
                  label: 'Home',
                  active: _selectedIndex == 0,
                  onTap: () => _selectPage(0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME CONTENT
// ============================================================

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.onOpenChat,
    required this.controller,
  });

  // Nullable on purpose because the parent may not provide it.
  final VoidCallback? onOpenChat;

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(
        30,
        35,
        30,
        30,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // HEADER
          // ======================================================

          Row(
            children: [
              const Text(
                'Gideon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: onOpenChat?.call,
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 45),

          // ======================================================
          // ORB
          // ======================================================

          Center(
            child: GestureDetector(
              onTap: onOpenChat?.call,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(
                      300,
                      300,
                    ),
                    painter: _OrbPainter(
                      progress: controller.value,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 35),

          // ======================================================
          // TITLE
          // ======================================================

          const Center(
            child: Text(
              'How can I help?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'Choose an action or start a conversation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF747D8E),
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 35),

          // ======================================================
          // QUICK START
          // ======================================================

          const Text(
            'QUICK START',
            style: TextStyle(
              color: Color(0xFF6F7480),
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // ------------------------------------------------------
          // ROW 1
          // ------------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _QuickStartCard(
                  icon: Icons.search_rounded,
                  title: 'Research',
                  subtitle: 'Explore anything',
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: _QuickStartCard(
                  icon: Icons.code_rounded,
                  title: 'Code',
                  subtitle: 'Build & debug',
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ------------------------------------------------------
          // ROW 2
          // ------------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _QuickStartCard(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Create',
                  subtitle: 'Generate ideas',
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: _QuickStartCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Chat',
                  subtitle: 'Talk with Gideon',
                  onTap: onOpenChat?.call,
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          // ======================================================
          // RECENT MISSIONS
          // ======================================================

          Row(
            children: [
              const Expanded(
                child: Text(
                  'RECENT MISSIONS',
                  style: TextStyle(
                    color: Color(0xFF6F7480),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Color(0xFF83A5FF),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ======================================================
          // EMPTY MISSIONS CARD
          // ======================================================

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFF0D1523),

              borderRadius: BorderRadius.circular(28),

              border: Border.all(
                color: const Color(0xFF263B5D),
                width: 1.1,
              ),
            ),

            child: const Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF586174),
                  size: 42,
                ),

                SizedBox(height: 14),

                Text(
                  'No recent missions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC7CBD4),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Start a conversation with Gideon to begin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6F7685),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

// ============================================================
// QUICK START CARD
// ============================================================

class _QuickStartCard extends StatelessWidget {
  const _QuickStartCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  // Nullable so widget.onOpenMenu can be passed safely.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(24),

      child: Container(
        height: 125,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFF0D1523),

          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: const Color(0xFF1F304A),
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color(0xFF63DFFF),
              size: 28,
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF737D90),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BOTTOM NAV ITEM
// ============================================================

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 25,

              color: active
                  ? const Color(0xFF63DFFF)
                  : const Color(0xFF687286),
            ),

            const SizedBox(height: 6),

            Text(
              label,

              style: TextStyle(
                color: active
                    ? const Color(0xFF63DFFF)
                    : const Color(0xFF687286),

                fontSize: 11,

                fontWeight: active
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ACCOUNT PAGE
// ============================================================

class _AccountPage extends StatelessWidget {
  const _AccountPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Account',

        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ============================================================
// PRO PAGE
// ============================================================

class _ProPage extends StatelessWidget {
  const _ProPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),

        padding: const EdgeInsets.all(30),

        decoration: BoxDecoration(
          color: const Color(0xFF0D1523),

          borderRadius: BorderRadius.circular(28),

          border: Border.all(
            color: const Color(0xFF263B5D),
          ),
        ),

        child: const Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFF63DFFF),
              size: 55,
            ),

            SizedBox(height: 18),

            Text(
              'Gideon Pro',

              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 10),

            Text(
              'Premium features coming soon.',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Color(0xFF7C8698),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MISSIONS PAGE
// ============================================================

class _MissionsPage extends StatelessWidget {
  const _MissionsPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Missions',

        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ============================================================
// ORB PAINTER
// ============================================================

class _OrbPainter extends CustomPainter {
  const _OrbPainter({
    required this.progress,
  });

  final double progress;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width * 0.24;

    // ========================================================
    // PULSE
    // ========================================================

    final pulse =
        1 + math.sin(progress * math.pi * 2) * 0.035;

    final orbRadius = radius * pulse;

    // ========================================================
    // OUTER GLOW
    // ========================================================

    final outerGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00D9FF).withValues(
            alpha: 0.24,
          ),

          const Color(0xFF694BFF).withValues(
            alpha: 0.14,
          ),

          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: orbRadius * 2.8,
        ),
      );

    canvas.drawCircle(
      center,
      orbRadius * 2.8,
      outerGlow,
    );

    // ========================================================
    // MAIN HALO
    // ========================================================

    final haloPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..shader = SweepGradient(
        transform: GradientRotation(
          progress * math.pi * 2,
        ),

        colors: const [
          Color(0xFF00E5FF),
          Color(0xFF477BFF),
          Color(0xFFB14DFF),
          Color(0xFFFF4FD8),
          Color(0xFF00E5FF),
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: orbRadius * 1.45,
        ),
      );

    canvas.drawCircle(
      center,
      orbRadius * 1.45,
      haloPaint,
    );

    // ========================================================
    // SECOND HALO
    // ========================================================

    final secondHaloPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(
        0xFF4D8CFF,
      ).withValues(
        alpha: 0.35,
      );

    canvas.drawCircle(
      center,
      orbRadius * 1.65,
      secondHaloPaint,
    );

    // ========================================================
    // ORB BODY
    // ========================================================

    final orbPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(
          -0.25,
          -0.3,
        ),

        radius: 0.85,

        colors: [
          Color(0xFFB8F7FF),
          Color(0xFF55DFFF),
          Color(0xFF2E8CFF),
          Color(0xFF613BFF),
          Color(0xFF171B4B),
        ],

        stops: [
          0.0,
          0.24,
          0.48,
          0.75,
          1.0,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: orbRadius,
        ),
      );

    canvas.drawCircle(
      center,
      orbRadius,
      orbPaint,
    );

    // ========================================================
    // INNER GLOW
    // ========================================================

    final innerGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(
            alpha: 0.28,
          ),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            center.dx - orbRadius * 0.25,
            center.dy - orbRadius * 0.30,
          ),
          radius: orbRadius * 0.65,
        ),
      );

    canvas.drawCircle(
      Offset(
        center.dx - orbRadius * 0.18,
        center.dy - orbRadius * 0.20,
      ),
      orbRadius * 0.58,
      innerGlow,
    );

    // ========================================================
    // ROTATING PARTICLES
    // ========================================================

    final particlePaint = Paint()
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 18; i++) {
      final angle =
          progress * math.pi * 2 +
          (i * math.pi * 2 / 18);

      final distance =
          orbRadius *
          (1.85 + (i % 3) * 0.18);

      final point = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      particlePaint.color = [
        const Color(0xFF00E5FF),
        const Color(0xFF638CFF),
        const Color(0xFFB15CFF),
      ][i % 3].withValues(
        alpha: 0.55,
      );

      canvas.drawCircle(
        point,
        1.3 + (i % 2) * 0.8,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _OrbPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}