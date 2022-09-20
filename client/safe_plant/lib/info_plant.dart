import 'package:safe_plant/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoistureInfo extends StatelessWidget {
  const MoistureInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 136, 219, 136),
      appBar: AppBar(
        title: const Text(
          "Plant Care Tips",
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
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 136, 219, 136),
        body: SingleChildScrollView(
            child: Center(
          child: Column(children: <Widget>[
            Card(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.grey.shade200,
                margin: EdgeInsets.all(10),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.white)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10)),
                    Center(
                      child: Card(
                        child: Image.asset(
                          'assets/images/plants1.jpg',
                          width: 370,
                          height: 150,
                          alignment: Alignment.centerRight,
                          fit: BoxFit.cover,
                        ),
                        elevation: 2,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.transparent)),
                        clipBehavior: Clip.antiAlias,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 25),
                      child: Text(
                        "1. Choose plants based on your light",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Text(
                        "The first rule is to determine the amount of natural light your space receives and to choose your plant accordingly. If you're unsure just by looking, start by figuring out which direction your windows face. "
                        "South-facing windows give bright light, east & west-facing windows give moderate light, and north-facing windows give low light. "
                        "If something outside your window —for example, a large tree or building— could obstruct sunlight, consider that, too. "
                        "Most houseplants prefer bright, indirect sunlight, but many can tolerate lower light levels (like low light tolerant snake plants and ZZ plants). "
                        "If the sun is intense through your windows, you may want to add a sheer curtain to diffuse the light. "
                        "Cacti and some succulents like aloe can handle brighter, direct sunlight. You don't want to overexpose or underexpose any plant, so keep an eye on them if they're in very bright or low light. ",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 25),
                      child: Text(
                        "2. Always keep temperatures stable",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Text(
                        "Keep your plant's home environment as stable as possible. Extreme changes can stress plants out. "
                        "Keep the temperature between 65 and 85 degrees F, and avoid placing your plants near radiators, A/C units, and forced-air vents, which can create hot or cold drafts.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 25),
                      child: Text(
                        "3. Know when to skip the fertilizer",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Text(
                        "Be mindful when using fertilizer on your houseplants. Too much fertilizer can do more harm than good. Houseplants tend not to need fertilizer as often as outdoor plants do. "
                        "If you choose to fertilize your plant, it's best to do so during the growing season (early spring to early fall) and follow the general rule of thumb: 'less is more. "
                        "Most store-bought fertilizers should be diluted with water before use. If you have had your plant for at least a year, you can fertilize it for the first time. "
                        "We suggest using an all-purpose fertilizer. Always follow the instructions. If you've just changed the soil, skip the fertilizer! Fresh soil has enough new nutrients. "
                        "Moreover, prune your plant's dead leaves. That will focus the plants' vital energy on the healthier leaves and stop wasting resources on old ones.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 25),
                      child: Text(
                        "4. How to recognize the types of deficiencies",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Card(
                                  child: Image.asset(
                                    'assets/images/leaf1.png',
                                    width: 130,
                                    height: 100,
                                    alignment: Alignment.centerRight,
                                    fit: BoxFit.cover,
                                  ),
                                  elevation: 0,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  clipBehavior: Clip.antiAlias,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                ),
                                Container(
                                  width: 200,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "NITROGEN",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "SIGNS:",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "Yellow or pale green leaves, stunted growth. ",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              margin: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              height: 1,
                              width: 300,
                            ),
                            Row(
                              children: [
                                Card(
                                  child: Image.asset(
                                    'assets/images/leaf2.png',
                                    width: 130,
                                    height: 100,
                                    alignment: Alignment.centerRight,
                                    fit: BoxFit.cover,
                                  ),
                                  elevation: 0,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  clipBehavior: Clip.antiAlias,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                ),
                                Container(
                                  width: 200,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "PHOSPHOROUS",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "SIGNS:",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "Darkening around edges of leaves, small or absent flowers, stunted growth.",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              margin: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              height: 1,
                              width: 300,
                            ),
                            Row(
                              children: [
                                Card(
                                  child: Image.asset(
                                    'assets/images/leaf3.png',
                                    width: 130,
                                    height: 100,
                                    alignment: Alignment.centerRight,
                                    fit: BoxFit.cover,
                                  ),
                                  elevation: 0,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  clipBehavior: Clip.antiAlias,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                ),
                                Container(
                                  width: 200,
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "POTASSIUM",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "SIGNS:",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "Leaves with brown spots, brown or yellow veins or yellow edges. This deficiency is more susceptible to disease and drought.",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              margin: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              height: 1,
                              width: 300,
                            ),
                            Row(
                              children: [
                                Card(
                                  child: Image.asset(
                                    'assets/images/leaf4.png',
                                    width: 130,
                                    height: 100,
                                    alignment: Alignment.centerRight,
                                    fit: BoxFit.cover,
                                  ),
                                  elevation: 0,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  clipBehavior: Clip.antiAlias,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                ),
                                Container(
                                  width: 200,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "MAGNESIUM",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "SIGNS:",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "Yellowing of veins and edges of leaves. Can sometimes have a marbled appearance.",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              margin: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              height: 1,
                              width: 300,
                            ),
                            Row(
                              children: [
                                Card(
                                  child: Image.asset(
                                    'assets/images/leaf5.png',
                                    width: 130,
                                    height: 100,
                                    alignment: Alignment.centerRight,
                                    fit: BoxFit.cover,
                                  ),
                                  elevation: 0,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  clipBehavior: Clip.antiAlias,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                ),
                                Container(
                                  width: 200,
                                  height: 115,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CALCIUM",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "SIGNS:",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        "Yellow spots between leaf veins, blossom end rot, stunted growth, weak or dying stems.",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                    Card(
                      child: Image.asset(
                        'assets/images/terra.png',
                        alignment: Alignment.centerRight,
                        fit: BoxFit.cover,
                      ),
                      elevation: 2,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)),
                      clipBehavior: Clip.antiAlias,
                    ),
                  ],
                ))
          ]),
        )));
  }
}
