import 'package:flutter/material.dart';

class HomeDashboard extends StatefulWidget {
  final String token;
  final String email;
  final VoidCallback onLogout;

  const HomeDashboard({
    super.key,
    required this.token,
    required this.email,
    required this.onLogout,
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

  void _openChat() {
    // We will connect this to the existing ChatScreen next.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat is ready — connecting Gideon next.'),
      ),
    );
  }

  void _selectAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action is ready.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcome(),
                    const SizedBox(height: 28),
                    _buildAskGideon(),
                    const SizedBox(height: 28),
                    _buildQuickActions(),
                    const SizedBox(height: 32),
                    _buildRecentMissions(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4D7CFE),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'GIDEON',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.2,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon.'),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 2),
          CircleAvatar(
            radius: 19,
            backgroundColor: const Color(0xFF151D30),
            child: Text(
              _displayName.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good to see you, $_displayName.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'What are we working on today?',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildAskGideon() {
    return GestureDetector(
      onTap: _openChat,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF101827),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFF26344E),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 25,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ask Gideon anything...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Ideas, writing, coding, research and more.',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4D7CFE),
                    Color(0xFF8B5CF6),
                  ],
                ),
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK START',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.7,
          ),
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              child: _actionCard(
                icon: Icons.lightbulb_outline_rounded,
                title: 'Ideas',
                subtitle: 'Brainstorm',
                onTap: () => _selectAction('Ideas'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _actionCard(
                icon: Icons.edit_outlined,
                title: 'Write',
                subtitle: 'Create content',
                onTap: () => _selectAction('Write'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _actionCard(
                icon: Icons.code_rounded,
                title: 'Code',
                subtitle: 'Build & debug',
                onTap: () => _selectAction('Code'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _actionCard(
                icon: Icons.search_rounded,
                title: 'Research',
                subtitle: 'Explore topics',
                onTap: () => _selectAction('Research'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0E1523),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFF202C42),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color(0xFF8BA8FF),
              size: 23,
            ),
            const SizedBox(height: 17),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMissions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'RECENT MISSIONS',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.7,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  color: Color(0xFF8BA8FF),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF0B111D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF1C273A),
            ),
          ),
          child: Column(
            children: const [
              Icon(
                Icons.auto_awesome_outlined,
                color: Colors.white24,
                size: 28,
              ),
              SizedBox(height: 12),
              Text(
                'No recent missions',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Start a conversation with Gideon to begin.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white30,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: const BoxDecoration(
        color: Color(0xFF080C15),
        border: Border(
          top: BorderSide(
            color: Color(0xFF151E2D),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
          ),
          _navItem(
            icon: Icons.layers_outlined,
            label: 'Missions',
            index: 1,
          ),
          _navItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
            index: 2,
          ),
          _navItem(
            icon: Icons.workspace_premium_outlined,
            label: 'Pro',
            index: 3,
          ),
          _navItem(
            icon: Icons.person_outline_rounded,
            label: 'Account',
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });

        if (index == 2) {
          _openChat();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF17233A)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? const Color(0xFF8BA8FF)
                  : Colors.white38,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white38,
                fontSize: 10,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}