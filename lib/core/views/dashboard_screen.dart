import 'package:flutter/material.dart';
import 'package:votopia/core/ui/styles/app_colors.dart';
import 'package:votopia/core/ui/styles/app_text_styles.dart';

class DashboardScreen extends StatefulWidget {
  final String organizationName;
  const DashboardScreen({super.key, required this.organizationName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _menuItems = [
    "Dashboard",
    "Membri",
    "Eventi",
    "Comunicazione",
    "Statistiche",
    "Impostazioni",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 240,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Image.asset('assets/images/icon.png', height: 60),
                const SizedBox(height: 12),
                Text(
                  widget.organizationName,
                  style: AppTextStyles.heading.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final selected = index == _selectedIndex;
                      final icons = [
                        Icons.dashboard_outlined,
                        Icons.people_alt_outlined,
                        Icons.event_outlined,
                        Icons.campaign_outlined,
                        Icons.bar_chart_outlined,
                        Icons.settings_outlined
                      ];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: InkWell(
                          onTap: () => setState(() => _selectedIndex = index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: selected ? Colors.white.withOpacity(0.15) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(icons[index], color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  _menuItems[index],
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.white,
                                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
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
                const Divider(color: Colors.white24),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Amministratore",
                        style: AppTextStyles.body.copyWith(color: Colors.white70, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                // TOPBAR
                Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            _menuItems[_selectedIndex],
                            style: AppTextStyles.heading.copyWith(fontSize: 22, color: Colors.black87),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 220,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F3F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Cerca...",
                                prefixIcon: Icon(Icons.search, size: 20),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.black12,
                            child: Icon(Icons.person, color: Colors.black54, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // BODY
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistiche generali
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatCard("Membri attivi", "42", Icons.people, Colors.blueAccent),
                            _buildStatCard("Eventi programmati", "5", Icons.event, Colors.orangeAccent),
                            _buildStatCard("Moduli attivi", "8", Icons.extension, Colors.green),
                            _buildStatCard("Piano", "Premium", Icons.workspace_premium, Colors.purple),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Moduli attivi
                        Text("Moduli attivi", style: AppTextStyles.heading.copyWith(fontSize: 20)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _moduleTile(Icons.people_alt, "Gestione Membri"),
                            _moduleTile(Icons.event_available, "Eventi e Tornei"),
                            _moduleTile(Icons.campaign, "Comunicazione e Social"),
                            _moduleTile(Icons.bar_chart, "Statistiche e Sondaggi"),
                            _moduleTile(Icons.shopping_bag, "Merch di Istituto"),
                            _moduleTile(Icons.discount, "Carte Sconto"),
                            _moduleTile(Icons.brush, "Moodboard AI"),
                            _moduleTile(Icons.psychology_alt, "AI Speech Trainer"),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Grafico + Attività
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: const Center(
                                  child: Text(
                                    "📈 Grafico popolarità e interazioni (fl_chart qui)",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Attività recenti", style: AppTextStyles.heading.copyWith(fontSize: 18)),
                                    const SizedBox(height: 12),
                                    _activity("Nuovo evento: Assemblea di Istituto", "3h fa"),
                                    _activity("Utente aggiunto: Sara P.", "7h fa"),
                                    _activity("AI Graphic generata: Post Instagram", "1g fa"),
                                  ],
                                ),
                              ),
                            ),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: AppTextStyles.heading.copyWith(fontSize: 26)),
            const SizedBox(height: 4),
            Text(title, style: AppTextStyles.body.copyWith(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _moduleTile(IconData icon, String label) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _activity(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: AppTextStyles.body)),
          Text(time, style: AppTextStyles.body.copyWith(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}