import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_link_app/injection/injection.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';
import 'package:fox_link_app/core/config/plan_config.dart';
import 'package:fox_link_app/modules/professionals/presentation/pages/professionals_page.dart';
import 'package:fox_link_app/modules/services/presentation/pages/services_page.dart';
import 'package:fox_link_app/core/navigation/app_routes.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final _session = getIt<TenantSession>();

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  Widget _metricCard(String title, int used, int max) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6E6E73),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$used / $max",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tenants')
              .doc(_session.tenantId)
              .snapshots(),
          builder: (context, tenantSnapshot) {
            if (!tenantSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final tenant = tenantSnapshot.data!;
            final plan = tenant['plan'];
            final salonName = tenant['name'];

            return FutureBuilder(
              future: Future.wait([
                FirebaseFirestore.instance
                    .collection('professionals')
                    .where('tenantId',
                    isEqualTo: _session.tenantId)
                    .get(),
                FirebaseFirestore.instance
                    .collection('services')
                    .where('tenantId',
                    isEqualTo: _session.tenantId)
                    .get(),
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final professionals =
                snapshot.data![0] as QuerySnapshot;
                final services =
                snapshot.data![1] as QuerySnapshot;

                final professionalsCount =
                    professionals.docs.length;
                final servicesCount =
                    services.docs.length;

                final maxProfessionals =
                PlanConfig.maxProfessionals(plan);
                final maxServices =
                PlanConfig.maxServices(plan);

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 24),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      Text(
                        salonName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Plano ${plan.toUpperCase()}",
                        style: const TextStyle(
                          color:
                          Color(0xFF6E6E73),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// 🍎 ANIMAÇÃO SUAVE
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position:
                          _slideAnimation,
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                _metricCard(
                                  "Profissionais",
                                  professionalsCount,
                                  maxProfessionals,
                                ),
                              ),
                              const SizedBox(
                                  width: 16),
                              Expanded(
                                child:
                                _metricCard(
                                  "Serviços",
                                  servicesCount,
                                  maxServices,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            AppRoutes
                                .slideRoute(
                              const ProfessionalsPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Gerenciar Profissionais",
                          style: TextStyle(
                            fontSize: 17,
                            color:
                            Color(0xFF1D1D1F),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            AppRoutes
                                .slideRoute(
                              const ServicesPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Gerenciar Serviços",
                          style: TextStyle(
                            fontSize: 17,
                            color:
                            Color(0xFF1D1D1F),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}