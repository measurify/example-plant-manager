/*
  APIRest.h - Class for make Edge Engine HTTP requests.
  Created by Francesco Tornatore, February 24, 2020.
  Released into the public domain.
*/
#ifndef APIRest_h
#define APIRest_h
#include "myDefines.h"
#include <Arduino.h>

#ifndef ESP_WROVER
#undef min
#undef max
#endif

#include <stdlib.h>
#include <vector>
using std::vector;
#include <string>
using std::string;

#ifdef ESP_WROVER
#include <HTTPClient.h>
#else
// #include <ArduinoHttpClient.h>
#include <WiFiNINA.h>
#endif

#include <time.h>
//#include <pthread.h>
#include "sample.h"

#define SECOND  1000 // 1000 milliseconds in a second

typedef struct{
  string device;
  string date;
  string message;
  string type;
  string url;
} issue;

// typedef struct{
  // //input
  // sample* sam;
  // string token;
// } taskParameter;

//SINGLETON wrapper
class APIRest{

  private:

  //variables
  int serverPort = 443;
  int httpCode;
  char httpCodeTmp [4];
  string response = "";
  bool success;
  long  startingTime;
  long timeElapsed;
  string timestamp;
  string actualDate ;
  vector<issue> issueBuffer;
  vector<sample> sampleBuffer;
  int issueBufferSize=20;
  int sampleBufferSize=20;
  int decimationPolicyFactor = 2; // size/decimationPolicyFactor; that is half of data will be deleted
  bool reposting;
  
  //taskParameter parameters;
  
  //constructor
  APIRest();
  
  //variables
  static APIRest* instance;
  
  //methods
  bool isHTTPCodeOk(int);
  bool needToBeRePOST(string);
  string parseResponse(string,string,bool = true);
  void deleteSpaces(string);
  void rePOSTMeasurement(string);
  void rePOSTIssue(string);
  void checkIssueBufferSize();
  void checkSampleBufferSize();
  string parseServerName(string);
  string parseURLPath(string);
  int parseHTTPCode(string);
  void printResponseToSerial(string,string);

  public:
  //variables
  
  //methods
  static APIRest* getInstance();
  string POSTLogin(string,string,string,string);
  string GETInfoUpdateDate(string,string);
  string GETDescr(string,string);
  string GETScript(string,string);
  string GETFeatures(string,string);
  bool POSTMeasurement(sample,string);
  bool POSTIssue(string,string,string,string,string="generic",string=APIRest::getInstance()->getActualDate());
  string getActualDate();
  bool TESTING;
  int getSampleBufferSize();
  int getIssueBufferSize();
  void setSampleBufferSize(int);
  void setIssueBufferSize(int);
};


#endif
