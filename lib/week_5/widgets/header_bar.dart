import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAvatarTap;
  final VoidCallback onNotifTap;
  final String userName;
  final String avatarAssetPath;

  const HeaderBar({
    super.key,
    required this.onAvatarTap,
    required this.onNotifTap,
    required this.userName,
    this.avatarAssetPath = 'lib/assets/images/person.jpg',
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1E7F74), // sesuaikan tema
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(avatarAssetPath),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo,',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  '$userName 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onNotifTap,
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              tooltip: 'Notifikasi',
            ),
          ),
        ],
      ),
    );
  }
}
