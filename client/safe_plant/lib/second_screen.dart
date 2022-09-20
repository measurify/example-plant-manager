import 'package:safe_plant/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LuminosityInfo extends StatelessWidget {
  const LuminosityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 136, 219, 136),
      appBar: AppBar(
        title: const Text(
          "Luminosity Info",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
            letterSpacing: 7,
          ),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: const MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.grey.shade200,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.lightGreen.shade50)),
      child: DataTable(
        columnSpacing: 30,
        headingRowHeight: 60,
        dataRowHeight: 65,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              '%',
              style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Range(lux)',
              style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Lighting Cond.',
              style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('10%')),
              DataCell(Text('0-10')),
              DataCell(Text('Pitch Black')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('20%')),
              DataCell(Text('11-50')),
              DataCell(Text('Very Dark')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('30%')),
              DataCell(Text('51-200')),
              DataCell(Text('Dark Indoors')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('40%')),
              DataCell(Text('201-400')),
              DataCell(Text('Dim Indoors')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('50%')),
              DataCell(Text('401-1000')),
              DataCell(Text('Normal Indoors')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('60%')),
              DataCell(Text('1001-5000')),
              DataCell(Text('Bright Indoors')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('70%')),
              DataCell(Text('5001-10,000')),
              DataCell(Text('Dim Outdoors')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('80%')),
              DataCell(Text('10,001-30,000')),
              DataCell(Text('Cloudy Outdoors')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('90%')),
              DataCell(Text('30,001-40,000')),
              DataCell(Text('Direct Sunlight')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('100%')),
              DataCell(Text('40,001-100,000')),
              DataCell(Text('Intense Direct Light')),
            ],
          ),
        ],
      ),
    ));
  }
}
