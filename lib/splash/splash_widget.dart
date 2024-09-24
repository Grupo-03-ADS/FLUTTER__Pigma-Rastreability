import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'splash_model.dart';
export 'splash_model.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  late SplashModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashModel());
    
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {

      await Future.delayed(const Duration(seconds: 1), () {
        context.pushReplacementNamed('codigoAcesso'); 
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // added
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/image_4.png',
                  width: 300.0,
                  height: 185.0,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(flex: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/pigma_(1)_1.png',
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(),
              const Text(
                "v2.0.1", // Version Code
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,)
                ), 
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
