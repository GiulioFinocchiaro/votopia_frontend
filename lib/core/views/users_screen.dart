import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:votopia/core/providers/user_provider.dart';
import 'package:votopia/core/ui/styles/app_colors.dart';

import '../models/user_model.dart';

class UsersScreen extends StatefulWidget {
  final String organizationName;
  const UsersScreen({super.key, required this.organizationName});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int _selectedIndex = 1; // Utenti è il secondo item
  int? _selectedUserIndex;
  String _searchQuery = '';
  String _selectedRole = 'all-roles';
  String _selectedList = 'all-lists';

  List<Map<String, dynamic>> _users = [];

  final List<String> _menuItems = [
    "Dashboard",
    "Utenti",
    "Eventi",
    "Impostazioni",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers(); // qui carichi gli utenti nel tuo _users
    });
  }

  Future<void> _loadUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await userProvider.getUsersMyOrganization();
      if (response['status'] == true) {
        setState(() {
          _users = userProvider.usersMyOrganization.map((u) => {
            'name': u.name,
            'email': u.email,
            'roles': u.roles != null && u.roles.isNotEmpty
                ? u.roles.map((r) => r.name).join(', ')
                : 'Nessun ruolo',
            'lists': u.lists != null && u.lists.isNotEmpty
                ? u.lists.map((l) => l.name).join(', ')
                : 'Nessuna lista',
            'initials': _getInitials(u.name),
          }).toList();
        });
      } else {
        debugPrint('Errore caricamento utenti: ${response['message']}');
      }
    } catch (e) {
      debugPrint('Eccezione durante il fetch degli utenti: $e');
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildStatsCards(),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Colonna sinistra: filtri + lista utenti
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildFilters(),
                                  const SizedBox(height: 16),
                                  _buildUsersList(),
                                  const SizedBox(width: 24),
                                  // Colonna destra: profilo utente selezionato
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),

                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  // 🔹 Profilo utente (occupa solo lo spazio necessario)
                                  _buildUserProfileCard(),
                                  const SizedBox(height: 24),

                                  // 🔹 Pulsanti azione (stanno sotto, senza Expanded)
                                  _buildActionButtons(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            const Color(0xFF0F2557),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.organizationName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Menu items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                final icons = [
                  LucideIcons.layoutDashboard,
                  LucideIcons.users,
                  LucideIcons.calendar,
                  LucideIcons.settings,
                ];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      if (index == 0) {
                        Navigator.pop(context);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ] : [],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            icons[index],
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            _menuItems[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Utenti',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              Container(
                width: 280,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cerca',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: Icon(LucideIcons.search, size: 20, color: Colors.grey.shade600),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(LucideIcons.bell, size: 24),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.secondary,
                child: const Text(
                  'GF',
                  style: TextStyle(
                    color: Color(0xFF285300),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '128',
            'Utenti totali',
            LucideIcons.users,
            Colors.white,
            Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            '10',
            'Ruoli disponibili',
            LucideIcons.userCheck,
            AppColors.secondary,
            const Color(0xFF285300),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            '32',
            'Liste totali',
            LucideIcons.usersRound,
            Colors.white,
            Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: bgColor == Colors.white ? Colors.grey.shade600 : textColor.withOpacity(0.9),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor == Colors.white
                  ? Colors.grey.shade100
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 32,
              color: bgColor == Colors.white ? Colors.grey.shade600 : textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cerca per nome, email ...',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  prefixIcon: Icon(LucideIcons.search, size: 18, color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown('Tutti i ruoli', _selectedRole, (value) {
              setState(() => _selectedRole = value!);
            }),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown('Tutte le liste', _selectedList, (value) {
              setState(() => _selectedList = value!);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, String value, Function(String?) onChanged) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(LucideIcons.chevronDown, size: 18, color: Colors.grey.shade600),
          style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
          onChanged: onChanged,
          items: [
            DropdownMenuItem(value: value, child: Text(hint)),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((u) =>
      (u['name'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (u['email'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Widget _buildUsersList() {
    final users = _filteredUsers;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Utenti registrati',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          users.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Center(
                    child: Text(
                      'Nessun utente trovato',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade200,
                    height: 1,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) => _buildUserItem(users[index], index),
                ),
        ],
      ),
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user, int index) {
    return InkWell(
      onTap: () => setState(() => _selectedUserIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['email'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user['roles'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: Icon(Icons.edit, size: 18),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF336900),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(LucideIcons.trash2, size: 18),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildButton(
                'Esporta elenco utenti',
                LucideIcons.download,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildButton(
                'Modifica utenti multipli',
                Icons.edit,
                AppColors.secondary,
                textColor: const Color(0xFF285300),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildButton(
                'Registra nuovo utente',
                LucideIcons.userPlus,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildButton(
                'Registra utenti multipli',
                LucideIcons.usersRound,
                AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildButton(
                'Elimina utenti multipli',
                LucideIcons.trash2,
                const Color(0xFF9C0000),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildButton(String text, IconData icon, Color color, {Color? textColor}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildUserProfileCard() {
    if (_users.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: const Center(
          child: Text(
            'Nessun utente selezionato',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    final selectedUser = _selectedUserIndex != null
        ? _users[_selectedUserIndex!]
        : _users.first;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.secondary,
            child: Text(
              selectedUser['initials'],
              style: const TextStyle(
                color: Color(0xFF336900),
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            selectedUser['name'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            selectedUser['roles'],
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),
          _buildInfoRow('E-mail', selectedUser['email']),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),
          _buildInfoRow('Liste', selectedUser['lists']),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Modifica utente', style: TextStyle(fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: const Color(0xFF285300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Reimposta password', style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
