import 'package:flutter/material.dart';
import 'package:fox_link_app/modules/auth/presentation/pages/login_page.dart';
import 'package:fox_link_app/core/navigation/app_routes.dart';

class AppleOnboardingPage extends StatefulWidget {
  const AppleOnboardingPage({super.key});

  @override
  State<AppleOnboardingPage> createState() =>
      _AppleOnboardingPageState();
}

class _AppleOnboardingPageState
    extends State<AppleOnboardingPage> {
  final PageController _controller =
  PageController();

  int currentIndex = 0;

  final pages = [
    {
      "title": "Organize seu salão",
      "subtitle":
      "Controle profissionais, serviços e clientes em um só lugar."
    },
    {
      "title": "Plano inteligente",
      "subtitle":
      "Cresça no seu ritmo com planos flexíveis."
    },
    {
      "title": "Simples e poderoso",
      "subtitle":
      "Experiência fluida, rápida e elegante."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          pages[index]["title"]!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          pages[index]["subtitle"]!,
                          style: const TextStyle(
                            fontSize: 18,
                            color:
                            Color(0xFF6E6E73),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Indicadores
            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (index) => AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 300),
                  margin:
                  const EdgeInsets.symmetric(
                      horizontal: 4),
                  width: currentIndex == index
                      ? 20
                      : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.black
                        : Colors.grey.shade400,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding:
              const EdgeInsets.symmetric(
                  horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF1D1D1F),
                    padding:
                    const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      AppRoutes.fadeRoute(
                          const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Começar",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}