import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_bimestral/theme/app_colors.dart';
import 'package:projeto_bimestral/theme/app_text_styles.dart';
import 'package:projeto_bimestral/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background_onboarding.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withAlpha((0.8 * 255).toInt()),
                  AppColors.primary.withAlpha((0.3 * 255).toInt()),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 100,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bem-vindo ao Nosso App',
                      style: AppTextStyles.headline2.copyWith(
                        color: AppColors.textLight,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Projeto realizado pelos alunos Jonas Ribeiro da Rosa e Vinícius Pereira Costa,\ndo Curso de Análise e Desenvolvimento de Sistemas (IFSP – Campus Bragança Paulista),\ncomo requisito parcial da disciplina Desenvolvimento para Dispositivo Móvel,\nsob orientação do Prof. Luiz Gustavo Diniz de Oliveira Veras.',
                      style: AppTextStyles.bodyText1.copyWith(
                        color: AppColors.textLight.withOpacity(0.9),
                        height: 1.4,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Digite seu nome',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          Navigator.pushNamed(
                            context,
                            Routes.shell,
                            arguments: name,
                          );
                        },
                        child: const Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
