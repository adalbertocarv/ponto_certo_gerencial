import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  /// Largura máxima que o conteúdo pode atingir.
  ///
  /// • Passe `double.infinity` se não quiser limite.  
  /// • Deixe null para usar o valor padrão de 1200 px.
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Widget child;

  const CenteredView({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 70, vertical: 60),
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // se maxWidth == null → usa 1200 (padrão)
          maxWidth: maxWidth ?? 1200,
        ),
        child: child,
      ),
    );
  }
}
