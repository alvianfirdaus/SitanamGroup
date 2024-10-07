import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sitanamalvian/widgets/SensorDataPanelWidget.dart'; // Import the new widget

class LingkunganScreen extends StatefulWidget {
  @override
  _LingkunganScreenState createState() => _LingkunganScreenState();
}

class _LingkunganScreenState extends State<LingkunganScreen> {
  String selectedPlot = "Plot 01"; // State to track selected plot
  Map<String, dynamic> plotData = {}; // State to store plot data

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // Listen for real-time updates for the selected plot data
  void listenToPlotData(String plot) {
    databaseReference.child(plot.toLowerCase()).onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          plotData = Map<String, dynamic>.from(event.snapshot.value as Map);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listenToPlotData("plot1"); // Start listening to plot1 changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Gambar Header
              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/headerlingkungan.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
          Positioned(
            top: 130,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kotak Kotak seperti gambar
                Container(
                  height: 90,
                  child: Center(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: PlotBox(
                            plotName: "Plot 01",
                            isSelected: selectedPlot == "Plot 01",
                            onTap: () {
                              setState(() {
                                selectedPlot = "Plot 01";
                                listenToPlotData("plot1"); // Switch to plot1 listener
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: PlotBox(
                            plotName: "Plot 02",
                            isSelected: selectedPlot == "Plot 02",
                            onTap: () {
                              setState(() {
                                selectedPlot = "Plot 02";
                                listenToPlotData("plot2"); // Switch to plot2 listener
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Use the SensorDataPanelWidget
                SensorDataPanelWidget(
                  selectedPlot: selectedPlot,
                  plotData: plotData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlotBox extends StatelessWidget {
  final bool isSelected;
  final String plotName;
  final VoidCallback onTap;

  const PlotBox({
    required this.isSelected,
    required this.plotName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.local_florist,
                color: isSelected ? Colors.white : Color.fromARGB(255, 21, 109, 15),
                size: 30,
              ),
            ),
            SizedBox(height: 8),
            Text(
              plotName,
              style: TextStyle(
                color: isSelected ? Color.fromARGB(255, 255, 183, 0) : Colors.green[900],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
