# Design and development of a plant health monitor system

This thesis aims to design and build an embedded system for remote monitoring of the health and environmental conditions of a plant. This system also allows the maintenance of the well-being of the plant. The design is based on the Arduino MKR WiFi 1010 board which manages a TSL2561 brightness sensor, a capacitive soil moisture sensor and a submersible pump that allows irrigation of the plant. The communication is based on the Wi-Fi connection, the board takes care of the data acquisition and the sending of these to the cloud, through the APIs released by the Measurify framework, where they are controlled and stored, but also the irrigation of the plant if necessary. Measurify plays the role of interface between the Arduino measurement system and the smartphone application. The latter allows the user to access the stored data and view them by day, week or month.

## Quick start
To setup the embedded system, the following steps need to be followed:

1. Install Arduino IDE.

2. Inside the IDE settings, add your board.

3. Install the following libraries:
-WiFiNINA-1.8.13
-Adafruit_TSL2561
-Adafruit_Unified_Sensor

4. Put the "EdgeEngine_library" inside the "libraries" folder.
Now the sketch is ready to be compiled and executed by the board.

To setup the mobile device, the following steps need to be followed:

- Install Visual Studio Code.
- Install the Flutter plugin.
- Open the safe_plant (inside the folder client in this repository).
- Now the client application is ready to be debugged on a device.
