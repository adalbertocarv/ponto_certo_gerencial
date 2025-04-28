import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/widgets/call_to_action/call_to_action.dart';
import 'package:ponto_certo_gerencial/widgets/centered_view/centered_view.dart';
import 'package:ponto_certo_gerencial/widgets/course_details/course_details.dart';
import '../../widgets/navigation_bar/navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            NavigatorBar(),
            Expanded(
                child: Row(
              children: <Widget>[
                CourseDetails(),
                Expanded(child: Center(child: CallToAction('Paradas de Ônibus'),))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
