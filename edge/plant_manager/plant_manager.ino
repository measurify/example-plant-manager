#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_TSL2561_U.h>
#include <time.h>
#include <vector>
#include <string>
#include <EdgeEngine_library.h>

using std::vector;
using std::string;

//-----Define feature
sample* light_moisture_Sample = NULL;
vector<sample*> samplesVect;

//-----Define ssid and password for WiFi connection
// const char* ssidWifi = "iPhoneHanna";
// const char* passWifi = "arduino22";

const char* ssidWifi = "TP-Link_4E65";
const char* passWifi = "0000";

//-----Initialize sensors
const int airValue = 700;
const int waterValue = 310;
float soilMoistureValue = 0;
int soilMoiusturePercent = 0;
float lightValue = 0;
const int rele = 2;
const int ledFailure = 5;
Adafruit_TSL2561_Unified lightSensor = Adafruit_TSL2561_Unified(TSL2561_ADDR_FLOAT, 12345);  //12345 port

//-----Define variables for Edge Engine
edgine* Edge;
connection* Connection;  //Wrapper for the wifi connection
string testToken = "";   //TEST TOKEN

void configureSensor(void) {
  lightSensor.enableAutoRange(true);
  lightSensor.setIntegrationTime(TSL2561_INTEGRATIONTIME_402MS); // prima era TSL2561_INTEGRATIONTIME_13MS
}

//void(* resetFunc) (void) = 0;  // declare reset fuction at address 0

void setup() {
  Serial.begin(9600);
  delay(2000);

  pinMode(ledFailure, OUTPUT);
  digitalWrite(ledFailure, LOW);
  //-----Luminosity
  if (!lightSensor.begin()) {
    digitalWrite(ledFailure, HIGH);
    Serial.println("Ooops, no TSL2561 detected.. Check your wiring or I2C ADDR!");
    while (!lightSensor.begin()) {
      delay(5000);
      Serial.println("Try again!");
    }
  }
  digitalWrite(ledFailure, LOW);
  configureSensor();

  //-----Water relè
  digitalWrite(rele, HIGH);
  pinMode(rele, OUTPUT);

  //-----Setup connection
  Connection = connection::getInstance();
  Connection->setupConnection(ssidWifi, passWifi);  //bug connessione

  options opts;
  //-----Login
  opts.username = "plant-manager-user-username";
  opts.password = "plant-manager-user-password";
  opts.tenant = "plant-manager-tenant";

  //-----Route
  opts.url = "https://students.measurify.org";
  opts.ver = "v1";
  opts.login = "login";
  opts.devs = "devices";
  opts.scps = "scripts";
  opts.measurements = "measurements";
  opts.info = "info";
  opts.issues = "issues";

  //-----Edgine identifiers
  opts.thing = "plant B";
  opts.device = "plant-monitor";
  opts.id = "plant-monitor";

  //-----Initialize Edge engine
  Edge = edgine::getInstance();
  Edge->init(opts);

  //-----Token
  testToken = Edge->getToken(); // da togliere
  Serial.println("______________________________________________TOKEN______________________________________________");
  Serial.println(testToken.c_str());
  Serial.println("");
  Serial.println("");
  Serial.println("");
  Serial.println("");
  Serial.println("");
}

void loop() {
  //-----Soil moisture sensor
  soilMoistureValue = analogRead(A1);
  Serial.print(soilMoistureValue); Serial.print("-------> Percent:");
  soilMoiusturePercent = map(soilMoistureValue, airValue, waterValue, 0, 100);
  if (soilMoiusturePercent >= 100) {
    Serial.println("100%");
  } else if (soilMoiusturePercent <= 0) {
    Serial.println("0%");
  } else if (soilMoiusturePercent > 0 && soilMoiusturePercent < 100) {
    Serial.print(soilMoiusturePercent);
    Serial.println("%");
  }
  delay(1000);  //for stability

  //-----Luminosity sensor
  sensors_event_t event;
  lightSensor.getEvent(&event);
  lightValue = event.light;
  if (lightValue < 40000) {
    Serial.print(lightValue);
    Serial.println(" lux");
    digitalWrite(ledFailure, LOW);
  } else {
    Serial.println("Sensor overload");
    digitalWrite(ledFailure, HIGH);
  }

  //-----Water sensor
  if (soilMoistureValue > 400) {  // se la percentuale di acqua va sotto al 75% (500) bagna
    digitalWrite(rele, LOW);
    delay(2500);
    digitalWrite(rele, HIGH);
    delay(8000);
  } else {
    delay(10000);
  }

  //-----Send data to Measurify
  light_moisture_Sample = new sample("light_moisture_Sample");
  light_moisture_Sample->startDate = Edge->Api->getActualDate();
  light_moisture_Sample->endDate = light_moisture_Sample->startDate;
  light_moisture_Sample->sizeOfSamples = Edge->getItems();
  light_moisture_Sample->myArray.assign(light_moisture_Sample->sizeOfSamples, 0);
  //-----other values
  light_moisture_Sample->url = "https://students.measurify.org/v1/measurements";
  light_moisture_Sample->thing = "plant B";
  light_moisture_Sample->feature = "plant-state";
  light_moisture_Sample->device = "plant-monitor";
  light_moisture_Sample->scriptId = "-1";
  light_moisture_Sample->myArray[0] = lightValue;
  light_moisture_Sample->myArray[1] = soilMoistureValue;
  delay(100);

  sample myObject = sample(*light_moisture_Sample);  // Cast pointer to object
  Serial.println(light_moisture_Sample->ArrayToString(myObject.myArray).c_str());
  Edge->Api->POSTMeasurement(myObject, Edge->getToken());
  // samplesVect.push_back(light_moisture_Sample);
  // Edge->evaluate(samplesVect);
  samplesVect.clear();  // after evaluated all samples delete them

  delete light_moisture_Sample;
  light_moisture_Sample = NULL;
  Serial.println("_________________Dato caricato su Measurify_______________________________");

 delay (20UL * 60UL * 1000UL); //20 minutes delay
 //resetFunc(); //call reset 
 //delay(10000);

}