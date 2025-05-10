import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_bimestral/theme/app_colors.dart';
import 'package:projeto_bimestral/theme/app_text_styles.dart';
import 'package:projeto_bimestral/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo com imagem + gradiente
          Image.asset(
            'assets/images/background_onboarding.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Conteúdo central
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 100,
                    ),
                    const SizedBox(height: 24),

                    // Título
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
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.shell);
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
