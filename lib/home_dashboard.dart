import 'package:flutter/material.dart';

class HomeDashboard extends StatefulWidget {
  final String token;
  final String email;
  final VoidCallback onLogout;
  final void Function([String? mode]) onOpenChat;

  const HomeDashboard({
    super.key,
    required this.token,
    required this.email,
    required this.onLogout,
    required this.onOpenChat,
  });

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  String get _displayName {
    final name = widget.email.split('@').first.trim();
    if (name.isEmpty) return 'there';
    return name[0].toUpperCase() + name.substring(1);
  }

  void _openChat() => widget.onOpenChat();

void _openMode(String mode) {
  widget.onOpenChat(mode);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A10),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 850;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 48 : 20,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHero(),
                          const SizedBox(height: 28),
                          _buildSearchCard(),
                          const SizedBox(height: 34),
                          const Text(
                            'Explore with Gideon',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildModes(wide),
                          const SizedBox(height: 34),
                          _buildRecent(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF171D28))),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              gradient: const LinearGradient(
                colors: [Color(0xFF5B7CFF), Color(0xFF8B5CF6)],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          const Text(
            'GIDEON',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Account',
            onPressed: widget.onLogout,
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good to see you, $_displayName.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 9),
        const Text(
          'Ask anything. Research deeply. Get things done.',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return InkWell(
      onTap: _openChat,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 19, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF10151F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF293346)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.search_rounded, color: Colors.white38, size: 21),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ask Gideon anything...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _miniAction(
                  Icons.public_rounded,
                  'Research',
                  () => _openMode('Research'),
                ),
                const SizedBox(width: 8),
                _miniAction(
                  Icons.auto_awesome_rounded,
                  'Deep Think',
                  () => _openMode('Deep Think'),
                ),
                const SizedBox(width: 8),
                _miniAction(
                  Icons.attach_file_rounded,
                  'Attach',
                  _openChat,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniAction(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF171D28),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.white60),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModes(bool wide) {
    final cards = [
      _modeCard(
        Icons.public_rounded,
        'Research',
        'Search, analyze and synthesize information.',
        () => _openMode('Research'),
      ),
      _modeCard(
        Icons.edit_outlined,
        'Write',
        'Draft, rewrite and improve your content.',
        () => _openMode('Write'),
      ),
      _modeCard(
        Icons.code_rounded,
        'Code',
        'Build, explain and debug code with Gideon.',
        () => _openMode('Code'),
      ),
      _modeCard(
        Icons.lightbulb_outline_rounded,
        'Ideas',
        'Brainstorm concepts and explore possibilities.',
        () => _openMode('Ideas'),
      ),
    ];

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            Expanded(child: cards[i]),
            if (i != cards.length - 1) const SizedBox(width: 12),
          ],
        ],
      );
    }

    return Column(
      children: [
        Row(children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 12),
          Expanded(child: cards[1]),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: cards[2]),
          const SizedBox(width: 12),
          Expanded(child: cards[3]),
        ]),
      ],
    );
  }

  Widget _modeCard(
  IconData icon,
  String title,
  String subtitle,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 145,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF0E131C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF202938),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF91A8FF),
            size: 23,
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildRecent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1018),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B2432)),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, color: Colors.white30, size: 24),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent conversations',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your conversations will appear here.',
                  style: TextStyle(color: Colors.white30, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _openChat,
            child: const Text(
              'Open Chat',
              style: TextStyle(color: Color(0xFF91A8FF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 11),
      decoration: const BoxDecoration(
        color: Color(0xFF080C13),
        border: Border(top: BorderSide(color: Color(0xFF171D28))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, 'Home', 0, () {}),
          _navItem(
            Icons.public_rounded,
            'Research',
            1,
            () => _openMode('Research'),
          ),
          _navItem(
            Icons.chat_bubble_outline_rounded,
            'Chat',
            2,
            _openChat,
          ),
          _navItem(
            Icons.person_outline_rounded,
            'Account',
            3,
            widget.onLogout,
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    int index,
    VoidCallback onTap,
  ) {
    final selected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
        onTap();
      },
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? const Color(0xFF91A8FF) : Colors.white38,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white38,
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
