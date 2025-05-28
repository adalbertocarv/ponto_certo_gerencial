import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  /// Largura máxima que o conteúdo pode atingir.
  ///
  /// • Passe `double.infinity` se não quiser limite.
  /// • Deixe null para usar o valor padrão de 1200 px.
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final Widget child;

  const CenteredView({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;
    final isMobile = screenWidth < 600;

    // Padding responsivo baseado no tamanho da tela
    EdgeInsetsGeometry responsivePadding =
        padding ?? _getDefaultPadding(screenWidth);

    // Largura máxima responsiva
    double responsiveMaxWidth = maxWidth ?? _getDefaultMaxWidth(screenWidth);

    return Container(
      padding: responsivePadding,
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: responsiveMaxWidth,
        ),
        child: child,
      ),
    );
  }

  /// Retorna padding padrão baseado na largura da tela
  EdgeInsetsGeometry _getDefaultPadding(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile: padding menor para aproveitar mais a tela
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
    } else if (screenWidth < 900) {
      // Tablet pequeno
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 40);
    } else if (screenWidth < 1200) {
      // Tablet grande
      return const EdgeInsets.symmetric(horizontal: 50, vertical: 50);
    } else {
      // Desktop: padding original
      return const EdgeInsets.symmetric(horizontal: 70, vertical: 60);
    }
  }

  /// Retorna largura máxima baseada na largura da tela
  double _getDefaultMaxWidth(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile: usa quase toda a largura disponível
      return screenWidth * 0.95;
    } else if (screenWidth < 900) {
      // Tablet pequeno: usa 90% da largura
      return screenWidth * 0.9;
    } else if (screenWidth < 1200) {
      // Tablet grande: usa 85% da largura até 1000px
      return (screenWidth * 0.85).clamp(0, 1000);
    } else {
      // Desktop: largura máxima de 1200px (padrão original)
      return 1200;
    }
  }
}

// Extensão para facilitar breakpoints em outros widgets
extension ResponsiveBreakpoints on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 600 &&
      MediaQuery.of(this).size.width < 1024;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1024;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
