import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

class Viagem extends StatefulWidget {
  const Viagem({super.key});

  @override
  ViagemState createState() => ViagemState();
}

class ViagemState extends State<Viagem> {
  late MapBoxNavigation _directions;
  late MapBoxOptions _options;
  String _currentDestination = "Mercado X";
  String _distanceRemaining = "Distância: 0 KM";

  @override
  void initState() {
    super.initState();
    _directions = MapBoxNavigation();
    _options = MapBoxOptions(
      initialLatitude: -23.5505,
      initialLongitude: -46.6333,
      zoom: 14.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      units: VoiceUnits.metric,
    );

    // Registrar listener para eventos de rota
    _directions.registerRouteEventListener(_onEmbeddedRouteEvent);
  }

  void _onEmbeddedRouteEvent(RouteEvent e) {
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentLegDistanceRemaining != null) {
          setState(() {
            _distanceRemaining =
                "Distância: ${(progressEvent.currentLegDistanceRemaining! / 1000).toStringAsFixed(2)} KM";
            _currentDestination = progressEvent.currentStepInstruction ?? _currentDestination;
          });
        }
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _currentDestination = "Navegação Finalizada";
          _distanceRemaining = "Distância: 0 KM";
        });
        break;
      default:
        break;
    }
  }

  void _startNavigation() async {
    var wayPoints = <WayPoint>[
      WayPoint(
        name: "Você",
        latitude: -23.5505,
        longitude: -46.6333,
      ),
      WayPoint(
        name: "Mercado X",
        latitude: -23.5595,
        longitude: -46.6353,
      ),
    ];

    await _directions.startNavigation(
      wayPoints: wayPoints,
      options: _options,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapbox Viagem')),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'Mapa aqui',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: const Color(0xFF28456F),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Transform.translate(
                            offset: const Offset(0, 8),
                          ),
                          const Text(
                            'Você',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          height: 2.0,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            _currentDestination,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFa5b1c3),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        _distanceRemaining,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25.0,
                            color: Color(0xFFDF541E),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _directions.finishNavigation();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFFDF541E),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          elevation: 10,
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'Finalizar',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _startNavigation,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFFAECC55),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          elevation: 10,
                          shadowColor: Colors.black,
                        ),
                        child: const Text(
                          'Navegação',
                          style: TextStyle(fontSize: 20.0),
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
    );
  }
}