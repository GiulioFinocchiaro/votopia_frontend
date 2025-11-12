import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:votopia/core/ui/styles/app_colors.dart';
import 'package:votopia/core/ui/widgets/app_sidebar.dart';
import 'package:votopia/core/ui/widgets/app_top_bar.dart';
import 'package:votopia/core/views/users_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String organizationName;
  const DashboardScreen({super.key, required this.organizationName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onMenuItemTap(int index) {
    if (index == 1) {
      // Naviga a Utenti
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UsersScreen(
            organizationName: widget.organizationName,
          ),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Row(
        children: [
          AppSidebar(
            organizationName: widget.organizationName,
            selectedIndex: _selectedIndex,
            onMenuItemTap: _onMenuItemTap,
          ),
          Expanded(
            child: Column(
              children: [
                const AppTopBar(title: 'Dashboard'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsCards(),
                        const SizedBox(height: 32),
                        _buildModulesSection(),
                        const SizedBox(height: 32),
                        _buildActivitySection(),
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

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '42',
            'Membri attivi',
            LucideIcons.users,
            Colors.white,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            '5',
            'Eventi programmati',
            LucideIcons.calendar,
            AppColors.secondary,
            const Color(0xFF285300),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            '8',
            'Moduli attivi',
            LucideIcons.package,
            Colors.white,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            'Premium',
            'Piano attivo',
            LucideIcons.crown,
            const Color(0xFFFFD700),
            const Color(0xFF8B6914),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: bgColor == Colors.white
                            ? Colors.grey.shade600
                            : textColor.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        height: 1,
                        letterSpacing: -1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bgColor == Colors.white
                      ? Colors.grey.shade100
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: bgColor == Colors.white
                      ? Colors.grey.shade600
                      : textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Moduli attivi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('Aggiungi modulo'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildModuleCard(
              'Gestione Membri',
              LucideIcons.users,
              AppColors.primary,
            ),
            _buildModuleCard(
              'Eventi e Tornei',
              LucideIcons.calendar,
              const Color(0xFFFF6B6B),
            ),
            _buildModuleCard(
              'Comunicazione',
              LucideIcons.messageSquare,
              const Color(0xFF4ECDC4),
            ),
            _buildModuleCard(
              'Statistiche',
              LucideIcons.chartBar,
              AppColors.secondary,
            ),
            _buildModuleCard(
              'Merch Store',
              LucideIcons.shoppingBag,
              const Color(0xFF9B59B6),
            ),
            _buildModuleCard(
              'Carte Sconto',
              LucideIcons.creditCard,
              const Color(0xFFE67E22),
            ),
            _buildModuleCard(
              'Moodboard AI',
              LucideIcons.palette,
              const Color(0xFFF39C12),
            ),
            _buildModuleCard(
              'AI Speech Trainer',
              LucideIcons.mic,
              const Color(0xFF3498DB),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModuleCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Panoramica attività',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ultimi 7 giorni',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 250,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.trendingUp,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Grafico attività',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dati di esempio - Integrare con fl_chart',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attività recenti',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                _buildActivityItem(
                  'Nuovo evento creato',
                  'Assemblea di Istituto',
                  '3h fa',
                  LucideIcons.calendar,
                  const Color(0xFF4ECDC4),
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  'Utente aggiunto',
                  'Sara Pellegrino',
                  '7h fa',
                  LucideIcons.userPlus,
                  AppColors.secondary,
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  'Post pubblicato',
                  'Nuova grafica Instagram',
                  '1g fa',
                  LucideIcons.image,
                  const Color(0xFFE67E22),
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  'Sondaggio creato',
                  'Preferenze eventi',
                  '2g fa',
                  LucideIcons.chartBar,
                  AppColors.primary,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Vedi tutte'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      String title,
      String subtitle,
      String time,
      IconData icon,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
