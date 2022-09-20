/*
  APIRest.cpp - Class for make Edge Engine HTTP requests.
  Created by Francesco Tornatore, February 24, 2020.
  Released into the public domain.
*/
#include "APIRest.h"

APIRest *APIRest::instance = NULL;

APIRest *APIRest::getInstance()
{
  if (instance == NULL)
  {
    instance = new APIRest();
  }
  return instance;
}
// constructor
APIRest::APIRest()
{
  reposting = false;
  TESTING = false;
}

string APIRest::POSTLogin(string url, string username, string password, string tenant)
{
  if (!TESTING)
  {
#ifdef ESP_WROVER
    HTTPClient http;
    http.begin(url.c_str()); //Specify the URL and certificate
    http.addHeader("Content-Type", "application/json");
    httpCode = http.POST(("{\"username\": \"" + username + "\",\"password\": \"" + password + "\",\"tenant\": \"" + tenant + "\"}").c_str()); //this is the body
    itoa(httpCode, httpCodeTmp, 10);
    response = string(httpCodeTmp) + http.getString().c_str();

    if (!isHTTPCodeOk(httpCode))
    { //Check for the returning code
      Serial.print(F("[HTTPS] POST Login... failed,"));
      if (httpCode < 0)
        response = response + " error: " + http.errorToString(httpCode).c_str();
    }
    http.end(); //Free the resources
#else
    WiFiSSLClient client;
    if (client.connect(parseServerName(url).c_str(), serverPort))
    {
      Serial.print("\nConnected to cloud resource ");
      Serial.println(parseServerName(url).c_str());
      string postData = "{\"username\": \"" + username + "\",\"password\": \"" + password + "\",\"tenant\": \"" + tenant + "\"}";
      client.print("POST ");
      client.print(parseURLPath(url).c_str());
      client.println(" HTTP 1.1");
      client.println(("Content-Type: application/json"));
      client.print("Content-Length: ");
      client.println(postData.length());
      client.print("Host: ");
      client.println(parseServerName(url).c_str());
      client.println("Connection: Keep-Alive");
      client.println();
      client.println(postData.c_str());
      bool dataAvailable = false;
      response = "";
      while (!dataAvailable)
      {
        while (client.available())
        {
          dataAvailable = true;
          response += client.read();
        }
      }
    }
    else
    {
      Serial.print(F("[HTTPS] POST Login... failed, client status: "));
      response += client.status();
    }
    client.stop();
#endif
    printResponseToSerial("[POST] Login", response);
    return response;
  }
  else // Mocking for the Unit Test
  {    //example of token response
    if (username == "username" && password == "password")
    {
      return "200{\"token\": \"JWT token\"}";
    }
    else if (username == "username1" && password == "password1")
    {
      return "200{\"token\": \"JWT token1\"}";
    }
    else
    {
      return "none";
    }
  }
}
string APIRest::GETInfoUpdateDate(string url, string token)
{
  if (!TESTING)
  {
#ifdef ESP_WROVER
    HTTPClient http;
    http.begin(url.c_str()); //Specify the URL and certificate
    http.addHeader("Authorization", token.c_str());
    httpCode = http.GET(); //the body is empty
    itoa(httpCode, httpCodeTmp, 10);
    response = string(httpCodeTmp) + http.getString().c_str();
    if (isHTTPCodeOk(httpCode))
    { //Check for the returning code

      startingTime = ((long)clock() / CLOCKS_PER_SEC) * SECOND; //milliseconds
      timestamp = parseResponse(response, "timestamp");
      // example of timestamp in milliseconds: "1580394697254"
    }
    else
    {
      if (httpCode < 0)
        response = response + " error: " + http.errorToString(httpCode).c_str();
      Serial.print(F("[HTTPS] GET Date... failed, "));
    }
    http.end(); //Free the resources
#else
    WiFiSSLClient client;
    if (client.connect(parseServerName(url).c_str(), serverPort))
    {
      client.print("GET ");
      client.print(parseURLPath(url).c_str());
      client.println(" HTTP 1.1");
      client.print("Host: ");
      client.println(parseServerName(url).c_str());
      client.println("Connection: Keep-Alive");
      client.print("Authorization: ");
      client.println(token.c_str());
      client.println();
      bool dataAvailable = false;
      response = "";
      while (!dataAvailable)
      {
        while (client.available())
        {
          dataAvailable = true;
          response += client.read();
        }
      }
      if (isHTTPCodeOk(parseHTTPCode(response)))
      { //Check for the returning code
        startingTime = millis();
        timestamp = parseResponse(response, "timestamp");
        // example of timestamp in milliseconds: "1580394697254"
      }
    }
    else
    {
      Serial.print(F("[HTTPS] GET Date... failed, client status: "));
      response += client.status();
    }
    client.stop();
#endif
    printResponseToSerial("[GET] Info - Update Date", response);
    return response;
  }
  else // Mocking for the Unit Test
  {
    if (token == "JWT token")
    {
      return "200{"
             "\"version\": \"0.2.001\","
             "\"environment\": \"production\","
             "\"token_expiration_time\": \"30m\","
             "\"database\": \"mongodb://localhost:27017/atmosphere-prod\","
             "\"timestamp\": \"1581425017114\""
             "}";
    }
    else if (token == "JWT token1")
    {
      return "200{"
             "\"version\": \"0.2.001\","
             "\"environment\": \"production\","
             "\"token_expiration_time\": \"30h\","
             "\"database\": \"mongodb://localhost:27017/atmosphere-prod\","
             "\"timestamp\": \"1581425017114\""
             "}";
    }
    else
    {
      return "none";
    }
  }
}

string APIRest::GETDescr(string url, string token)
{
  if (!TESTING)
  {
#ifdef ESP_WROVER
    HTTPClient http;
    http.begin(url.c_str()); //Specify the URL and certificate

    http.addHeader("Authorization", token.c_str());
    httpCode = http.GET(); //the body is empty
    itoa(httpCode, httpCodeTmp, 10);
    response = string(httpCodeTmp) + http.getString().c_str();
    if (!isHTTPCodeOk(httpCode))
    { //Check for the returning code
      if (httpCode < 0)
        response = response + " error: " + http.errorToString(httpCode).c_str();
      Serial.print(F("[HTTPS] GET Description... failed, "));
    }
    http.end(); //Free the resources
#else
    WiFiSSLClient client;
    if (client.connect(parseServerName(url).c_str(), serverPort))
    {
      client.print("GET ");
      client.print(parseURLPath(url).c_str());
      client.println(" HTTP 1.1");
      client.print("Host: ");
      client.println(parseServerName(url).c_str());
      client.println("Connection: Keep-Alive");
      client.print("Authorization: ");
      client.println(token.c_str());
      client.println();
      bool dataAvailable = false;
      response = "";
      while (!dataAvailable)
      {
        while (client.available())
        {
          dataAvailable = true;
          response += client.read();
        }
      }
    }
    else
    {
      Serial.print(F("[HTTPS] GET Description... failed, client status: "));
      response += client.status();
    }
    client.stop();
#endif
    printResponseToSerial("[GET] Description", response);
    return response;
  }
  else
  { // Mocking for the Unit Test
    if (token == "JWT token")
    {
      return "200{"
             "\"features\": ["
             " \"temperature\""
             "],"
             "\"tags\": [],"
             "\"scripts\": ["
             "\"average-hourly-temperature\","
             "\"group-temperature\""
             "],"
             "\"visibility\": \"private\","
             "\"period\": \"5s\","
             "\"cycle\": \"10m\","
             "\"retryTime\": \"10s\","
             "\"scriptListMaxSize\": 5,"
             "\"measurementBufferSize\": 20,"
             "\"issueBufferSize\": 20,"
             "\"sendBufferSize\": 20,"
             "\"scriptStatementMaxSize\": 5,"
             "\"statementBufferSize\": 10,"
             "\"measurementBufferPolicy\": \"decimation\","
             "\"_id\": \"temperature-sensor-riccardo-office\","
             "\"owner\": {"
             "\"_id\": \"5dcec66bc67ed54963bc865c\","
             "\"username\": \"riccardo-office-temperature-sensor-username\","
             "\"type\": \"provider\""
             "}"
             "}";
    }
    else if (token == "JWT token1")
    {
      return "200{"
             "\"features\": ["
             " \"temperature\""
             "],"
             "\"tags\": [],"
             "\"scripts\": ["
             "\"average-hourly-temperature\","
             "\"group-temperature\""
             "],"
             "\"visibility\": \"private\","
             "\"period\": \"5a\","
             "\"cycl\": \"10m\","
             "\"retryTime\": \"1d0s\","
             "\"scriptListMaxSize\": 5,"
             "\"measurementBufferSize\": 20,"
             "\"issueBufferSize\": 20,"
             "\"sendBufferSize\": 20,"
             "\"scriptStatementMaxSize\": 5,"
             "\"statementBufferSize\": 10,"
             "\"measurementBufferPolicy\": \"decimation\","
             "\"_id\": \"temperature-sensor-riccardo-office\","
             "\"owner\": {"
             "\"_id\": \"5dcec66bc67ed54963bc865c\","
             "\"username\": \"riccardo-office-temperature-sensor-username\","
             "\"type\": \"provider\""
             "}"
             "}";
    }
    else
    {
      return "none";
    }
  }
}

string APIRest::GETScript(string url, string token)
{
  if (!TESTING)
  {
#ifdef ESP_WROVER
    HTTPClient http;
    http.begin(url.c_str()); //Specify the URL and certificate

    http.addHeader("Authorization", token.c_str());
    httpCode = http.GET(); //the body is empty
    itoa(httpCode, httpCodeTmp, 10);
    response = string(httpCodeTmp) + http.getString().c_str();

    if (!isHTTPCodeOk(httpCode))
    { //Check for the returning code
      if (httpCode < 0)
        response = response + " error: " + http.errorToString(httpCode).c_str();
      Serial.print(F("[HTTPS] GET Script... failed, "));
    }
    http.end(); //Free the resources
#else
    WiFiSSLClient client;
    if (client.connect(parseServerName(url).c_str(), serverPort))
    {
      client.print("GET ");
      client.print(parseURLPath(url).c_str());
      client.println(" HTTP 1.1");
      client.print("Host: ");
      client.println(parseServerName(url).c_str());
      client.println("Connection: Keep-Alive");
      client.print("Authorization: ");
      client.println(token.c_str());
      client.println();
      bool dataAvailable = false;
      response = "";
      while (!dataAvailable)
      {
        while (client.available())
        {
          dataAvailable = true;
          response += client.read();
        }
      }
    }
    else
    {
      Serial.print(F("[HTTPS] GET Script... failed, client status: "));
      Serial.println(client.status());
      response += client.status();
    }
    client.stop();
#endif
    printResponseToSerial("[GET] Script", response);
    return response;
  }

  else
  {

    if (token == "JWT token")
    {
      if (parseResponse(url, "_id") == "group-temperature")
      {
        return "200{\"docs\": ["
               "{"
               "\"visibility\": \"private\","
               "\"tags\": [],"
               "\"_id\": \"group-temperature\","
               "\"code\": \"temperature().send(5)\","
               "\"owner\": {"
               "\"_id\": \"5dcec66bc67ed54963bc865c\","
               "\"username\": \"riccardo-office-temperature-sensor-username\","
               "\"type\": \"provider\"}"
               "}"
               "],"
               "\"totalDocs\": 1, \"limit\": 10, \"hasPrevPage\": false, \"hasNextPage\": false, \"page\": 1, \"totalPages\": 1, \"pagingCounter\": 1, \"prevPage\": null, \"nextPage\": null}";
      }
      else if (parseResponse(url, "_id") == "average-hourly-temperature")
      {
        return "200{\"docs\": ["
               "{"
               "\"visibility\": \"private\","
               "\"tags\": [],"
               "\"_id\": \"average-hourly-temperature\","
               "\"code\": \"temperature(60).window(+, 0, 10).map(a/100).send()\","
               "\"owner\": {"
               "\"_id\": \"5dcec66bc67ed54963bc865c\","
               "\"username\": \"riccardo-office-temperature-sensor-username\","
               "\"type\": \"provider\"}"
               "}"
               "],"
               "\"totalDocs\": 1, \"limit\": 10, \"hasPrevPage\": false, \"hasNextPage\": false, \"page\": 1, \"totalPages\": 1, \"pagingCounter\": 1, \"prevPage\": null, \"nextPage\": null}";
      }
    }
    if (token == "JWT token1")
    {
      if (parseResponse(url, "_id") == "group-temperature")
      {
        return "200{\"docs\": ["
               "{"
               "\"visibility\": \"private\","
               "\"tags\": [],"
               "\"_id\": \"group-temperature\","
               "\"code\": \"temperature().send(5)\","
               "\"owner\": {"
               "\"_id\": \"5dcec66bc67ed54963bc865c\","
               "\"username\": \"riccardo-office-temperature-sensor-username\","
               "\"type\": \"provider\"}"
               "}"
               "],"
               "\"totalDocs\": 1, \"limit\": 10, \"hasPrevPage\": false, \"hasNextPage\": false, \"page\": 1, \"totalPages\": 1, \"pagingCounter\": 1, \"prevPage\": null, \"nextPage\": null}";
      }
      else if (parseResponse(url, "_id") == "average-hourly-temperature")
      {

        return "200{\"docs\": ["
               "{"
               "\"visibility\": \"private\","
               "\"tags\": [],"
               "\"_id\": \"average-hourly-temperature\","
               "\"code\": \"temperature(60).window(+, 0, 10).map(a/100).send()\","
               "\"owner\": {"
               "\"_id\": \"5dcec66bc67ed54963bc865c\","
               "\"username\": \"riccardo-office-temperature-sensor-username\","
               "\"type\": \"provider\"}"
               "}"
               "],"
               "\"totalDocs\": 1, \"limit\": 10, \"hasPrevPage\": false, \"hasNextPage\": false, \"page\": 1, \"totalPages\": 1, \"pagingCounter\": 1, \"prevPage\": null, \"nextPage\": null}";
      }
      else
      {
        return "none";
      }
    }
    else
    {
      return "none";
    }
  }
}

string APIRest::GETFeatures(string url, string token)
{
  if (!TESTING)
  {
#ifdef ESP_WROVER
    HTTPClient http;
    http.begin(url.c_str()); //Specify the URL and certificate

    http.addHeader("Authorization", token.c_str());
    httpCode = http.GET(); //the body is empty
    itoa(httpCode, httpCodeTmp, 10);
    response = string(httpCodeTmp) + http.getString().c_str();
    if (!isHTTPCodeOk(httpCode))
    { //Check for the returning code
      if (httpCode < 0)
        response = response + " error: " + http.errorToString(httpCode).c_str();
      Serial.print(F("[HTTPS] GET Features... failed, "));
    }
    http.end(); //Free the resources
#else
    WiFiSSLClient client;
    if (client.connect(parseServerName(url).c_str(), serverPort))
    {
      client.print("GET ");
      client.print(parseURLPath(url).c_str());
      client.println(" HTTP 1.1");
      client.print("Host: ");
      client.println(parseServerName(url).c_str());
      client.println("Connection: Keep-Alive");
      client.print("Authorization: ");
      client.println(token.c_str());
      client.println();
      bool dataAvailable = false;
      response = "";
      while (!dataAvailable)
      {
        while (client.available())
        {
          dataAvailable = true;
          response += client.read();
        }
      }
    }
    else
    {
      Serial.print(F("[HTTPS] GET Features... failed, client status: "));
      response += client.status();
    }
    client.stop();
#endif
    printResponseToSerial("[GET] Features", response);
    return response;
  }

}

bool APIRest::POSTMeasurement(sample sam, string token)
{
  if (!TESTING)
  {
#ifdef ESP_WROVER
    HTTPClient http;
    http.begin(sam.url.c_str()); //Specify the URL and certificate
    http.addHeader("Content-Type", "application/json");
    http.addHeader("Authorization", token.c_str());
    // [TBD] Arduino does not support std::to_string(float) so I used here String(float).c_str()
    httpCode = http.POST(("{\"thing\": \"" + sam.thing + "\", \"feature\": \"" + sam.feature + "\", \"device\": \"" + sam.device + "\", \"script\": \"" + sam.scriptId + "\", \"samples\": {\"values\":" + sam.ArrayToString(sam.myArray).c_str() + "}, \"startDate\": \"" + sam.startDate + "\", \"endDate\": \"" + sam.endDate + "\"}").c_str()); //this is the body

    itoa(httpCode, httpCodeTmp, 10);
    response = string(httpCodeTmp) + http.getString().c_str();

    if (isHTTPCodeOk(httpCode))
    { //Check for the returning code
      success = true;
    }
    else
    { // something has gone wrong in the POST
      // if the post has encoutered an error, we want to save datum that will be resent as soon as possible
      if (httpCode < 0)
        response = response + " error: " + http.errorToString(httpCode).c_str();
      if (needToBeRePOST(response))
      {
        checkSampleBufferSize();     //if there is not space, make it
        sampleBuffer.push_back(sam); // save the datum in a local sampleBuffer
        Serial.print(F("[HTTPS] POST NewMeas... failed"));
        Serial.print(", value: ");
        Serial.print(sam.ArrayToString(sam.myArray).c_str());
        Serial.print(", script: ");
        Serial.println(sam.scriptId.c_str());
        success = false;
      }
      else
      {
        success = true; // if don't need to be resent
        Serial.println(F("Measurement aleady POSTed"));
      }
      http.end(); //Free the resources
    }
#else
    WiFiSSLClient client;
    if (client.connect(parseServerName(sam.url).c_str(), serverPort))
    {
      //patch
      string postData = "";
      if(sam.scriptId=="-1"){
        postData = "{\"thing\": \"" + sam.thing + "\", \"feature\": \"" + sam.feature + "\", \"device\": \"" + sam.device + "\", \"samples\": {\"values\":" + sam.ArrayToString(sam.myArray).c_str() + "}, \"startDate\": \"" + sam.startDate + "\", \"endDate\": \"" + sam.endDate + "\"}";
      }
      else{
        postData = "{\"thing\": \"" + sam.thing + "\", \"feature\": \"" + sam.feature + "\", \"device\": \"" + sam.device + "\", \"script\": \"" + sam.scriptId + "\", \"samples\": {\"values\":" + sam.ArrayToString(sam.myArray).c_str() + "}, \"startDate\": \"" + sam.startDate + "\", \"endDate\": \"" + sam.endDate + "\"}";
      }
      client.print("POST ");
      client.print(parseURLPath(sam.url).c_str());
      client.println(" HTTP 1.1");
      client.println(("Content-Type: application/json"));
      client.print("Content-Length: ");
      client.println(postData.length());
      client.print("Host: ");
      client.println(parseServerName(sam.url).c_str());
      client.println("Connection: Keep-Alive");
      client.print("Authorization: ");
      client.println(token.c_str());
      client.println();
      client.println(postData.c_str());
      bool dataAvailable = false;
      response = "";
      while (!dataAvailable)
      {
        while (client.available())
        {
          dataAvailable = true;
          response += client.read();
        }
      }
      httpCode = parseHTTPCode(response);
      itoa(httpCode, httpCodeTmp, 10);
      if (isHTTPCodeOk(httpCode))
      { //Check for the returning code
        success = true;
      }
      else
      { // something has gone wrong in the POST
        // if the post has encoutered an error, we want to save datum that will be resent as soon as possible
        if (httpCode < 0)
          response = response + " error: " + httpCodeTmp;
        if (needToBeRePOST(response))
        {
          checkSampleBufferSize();     //if there is not space, make it
          sampleBuffer.push_back(sam); // save the datum in a local sampleBuffer
          Serial.print(F("[HTTPS] POST NewMeas... failed"));
          Serial.print(", value: ");
          Serial.print(sam.ArrayToString(sam.myArray).c_str());
          Serial.print(", script: ");
          Serial.println(sam.scriptId.c_str());
          success = false;
        }
        else
        {
          success = true; // if don't need to be resent
          Serial.println(F("Measurement aleady POSTed"));
        }
      }
    }
    else
    {
      Serial.print(F("[HTTPS] POST NewMeas... failed, client status: "));
      response += client.status();
    }
    client.stop();
#endif
    printResponseToSerial("[POST] Measurement", response);
    if (!reposting)
    {
      reposting = true;
      rePOSTMeasurement(token); // every time we post a new measurement retry to post all the failed ones
    }
    if (!reposting)
    {
      reposting = true;
      rePOSTIssue(token); // every time we post a new measurement retry to post all the failed alerts
    }
    return success;
  }
  else
  { //////////////////// TESTING ////////////////////
    if (token == "JWT token")
    {
      success = true;
    }
    else
    {
      // if the post has encoutered an error, we want to save datum that will be resent as soon as possible
      checkSampleBufferSize();     //if there is not space, make it
      sampleBuffer.push_back(sam); // save the datum in a local sampleBuffer
      success = false;
    }
    if (!reposting)
    {
      reposting = true;
      rePOSTMeasurement(token); // every time we post a new measurement retry to post all the failed ones
    }
    if (!reposting)
    {
      reposting = true;
      rePOSTIssue(token); // every time we post a new measurement retry to post all the failed alerts
    }

    return success;
  }
}

void APIRest::rePOSTMeasurement(string token)
{
  // j is useful to count the number of iteration equal to sampleBuffer size;
  // since after repost the first element we erase it, the next one shift to the first position so access sampleBuffer[0] till end
  int size = sampleBuffer.size();
  for (int j = 0; j < size; j++)
  {
    APIRest::POSTMeasurement(sampleBuffer[0], token);
    sampleBuffer.erase(sampleBuffer.begin());
  }
  vector<sample>(sampleBuffer).swap(sampleBuffer); // this create a new sampleBuffer with capacity equal to the size

  reposting = false;
}

bool APIRest::POSTIssue(string url, string token, string device, string message, string type, string date)
{
  if (!TESTING)
  {
#ifdef ESP_WROVER
    HTTPClient http;
    http.begin(url.c_str()); //Specify the URL and certificate
    http.addHeader("Content-Type", "application/json");
    http.addHeader("Authorization", token.c_str());
    httpCode = http.POST(("{\"device\": \"" + device + "\",  \"date\": \"" + date + "\", \"message\": \"" + message + "\",\"type\": \"" + type + "\"}").c_str()); //this is the body
    itoa(httpCode, httpCodeTmp, 10);
    response = string(httpCodeTmp) + http.getString().c_str();

    if (isHTTPCodeOk(httpCode))
    { //Check for the returning code
      success = true;
    }
    else
    { // something has gone wrong in the POST
      if (httpCode < 0)
        response = response + " error: " + http.errorToString(httpCode).c_str();

      if (needToBeRePOST(response))
      {
        issue al;
        al.date = date;
        al.device = device;
        al.message = message;
        al.type = type;
        al.url = url;

        checkIssueBufferSize(); //if there is not space, make it
        // if the post has encoutered an error, we want to save datum that will be resent as soon as possible
        issueBuffer.push_back(al); // save the datum in a local sampleBuffer

        Serial.println(F("[HTTPS] POST Issue... failed"));

        success = false;
      }
      else
      {
        Serial.println(F("Issue aleady POSTed"));
        success = true; // if don't need to be resent
      }
    }
    http.end(); //Free the resources
#else
    WiFiSSLClient client;
    if (client.connect(parseServerName(url).c_str(), serverPort))
    {
      string postData = "{\"device\": \"" + device + "\",  \"date\": \"" + date + "\", \"message\": \"" + message + "\",\"type\": \"" + type + "\"}";
      client.print("POST ");
      client.print(parseURLPath(url).c_str());
      client.println(" HTTP 1.1");
      client.println(("Content-Type: application/json"));
      client.print("Content-Length: ");
      client.println(postData.length());
      client.print("Host: ");
      client.println(parseServerName(url).c_str());
      client.println("Connection: Keep-Alive");
      client.print("Authorization: ");
      client.println(token.c_str());
      client.println();
      client.println(postData.c_str());
      bool dataAvailable = false;
      response = "";
      while (!dataAvailable)
      {
        while (client.available())
        {
          dataAvailable = true;
          response += client.read();
        }
      }
      httpCode = parseHTTPCode(response);
      itoa(httpCode, httpCodeTmp, 10);
      if (isHTTPCodeOk(httpCode))
      { //Check for the returning code
        success = true;
      }
      else
      { // something has gone wrong in the POST
        if (httpCode < 0)
          response = response + " error: " + httpCodeTmp;

        if (needToBeRePOST(response))
        {
          issue al;
          al.date = date;
          al.device = device;
          al.message = message;
          al.type = type;
          al.url = url;

          checkIssueBufferSize(); //if there is not space, make it
          // if the post has encoutered an error, we want to save datum that will be resent as soon as possible
          issueBuffer.push_back(al); // save the datum in a local sampleBuffer

          Serial.println(F("[HTTPS] POST Issue... failed"));

          success = false;
        }
        else
        {
          Serial.println(F("Issue aleady POSTed"));
          success = true; // if don't need to be resent
        }
      }
    }
    else
    {
      Serial.print(F("[HTTPS] POST Issue... failed, client status: "));
      response += client.status();
    }
    client.stop();
#endif
    printResponseToSerial("[POST] Issue", response);
    return success;
  }

  else
  {
    if (token == "JWT token")
    {
      success = true;
    }
    else
    {
      issue al;
      al.date = date;
      al.device = device;
      al.message = message;
      al.type = type;
      al.url = url;

      checkIssueBufferSize(); //if there is not space, make it
      // if the post has encoutered an error, we want to save datum that will be resent as soon as possible
      issueBuffer.push_back(al); // save the datum in a local Buffer
      success = false;
    }

    return success;
  }
}
void APIRest::rePOSTIssue(string token)
{
  // j is useful to count the number of iteration equal to Buffer size;
  // since after repost the first element we erase it, the next one shift to the first position so access issueBuffer[0] till end
  int size = issueBuffer.size();
  for (int j = 0; j < size; j++)
  {
    APIRest::POSTIssue(issueBuffer[0].url, token, issueBuffer[0].device, issueBuffer[0].message, issueBuffer[0].type, issueBuffer[0].date);
    issueBuffer.erase(issueBuffer.begin()); // don't need to deallocate every issue individually because we passed the struct and not the pointer
  }
  vector<issue>(issueBuffer).swap(issueBuffer); // this create a new Buffer with capacity equal to the size, that frees memory
  reposting = false;
}

bool APIRest::isHTTPCodeOk(int code)
{
  return code >= 200 && code <= 308;
}

bool APIRest::needToBeRePOST(string response)
{
  if (parseResponse(response, "value", false) == "6")
  { // "value"= 6 means that the resource was not created for some problem(usually because it already exists), so do not try create it again
    return false;
  }
  return true;
}

string APIRest::getActualDate()
{
  #ifdef ESP_WROVER
  timeElapsed = ((long)clock() / CLOCKS_PER_SEC) * SECOND - startingTime; //in milliseconds
  #else
  timeElapsed = millis() - startingTime;
  #endif
  // [TBD] Arduino does not support std::to_string('float') so I used here string( String('float').c_str() )
  return string(String(atof(timestamp.c_str()) + timeElapsed).c_str());
}

string APIRest::parseResponse(string response, string fieldName, bool quotedField)
{
  deleteSpaces(response);
  if (response.find(fieldName) == -1)
  {
    Serial.print(fieldName.c_str());
    Serial.println(" field is not present!");
    return "";
  }
  int beginOfValue = response.find(":", response.find(fieldName)) + 1; //find starting index of field value
  int endOfValue;
  string fieldValue;

  if (quotedField)
  {                                                     // example "fieldName": "fieldValue"
    endOfValue = response.find('\"', beginOfValue + 1); // start looking for the last delimiter from the next value
    fieldValue = response.substr(beginOfValue + 1, endOfValue - (beginOfValue + 1));
  }
  else
  {                                                // example "fieldName": fieldValue
    endOfValue = response.find(',', beginOfValue); // start looking for the last delimiter from the next value
    if (response.at(endOfValue - 1) == '}' || response.at(endOfValue - 1) == ']')
    { // if the field is the last of the a JSON objects({...}) or JSON array([...])
      endOfValue -= 1;
    }
    else if (endOfValue == -1)
    { //if the object is the last of response
      endOfValue = response.find('}', beginOfValue);

      if (endOfValue == -1)
      { //if the array is the last of response
        endOfValue = response.find(']', beginOfValue);
      }
    }
    fieldValue = response.substr(beginOfValue, endOfValue - beginOfValue);
  }

  return fieldValue;
}
void APIRest::deleteSpaces(string str)
{
  int pos = 0;
  while ((pos = str.find(" ")) != -1)
  {
    str.erase(pos, 1); //delete whitespace
  }
}

int APIRest::getSampleBufferSize()
{
  return sampleBuffer.size();
}
int APIRest::getIssueBufferSize()
{
  return issueBuffer.size();
}

void APIRest::setSampleBufferSize(int size)
{
  // if(size<sampleBuffer.size()){ [TBD]
  //Call the correct policy
  // }
  if (size < sampleBuffer.size())
  {
    sampleBuffer.erase(sampleBuffer.begin(), sampleBuffer.begin() + (sampleBuffer.size() - size));
    vector<sample>(sampleBuffer).swap(sampleBuffer); // this create a new Buffer with capacity equal to the size, that frees memory allocated with the erased issue
  }
  sampleBufferSize = size;
  sampleBuffer.reserve(size); //useful if (size>sampleBuffer.size()) in other cases it does nothing, no need of "if clause"
}

void APIRest::setIssueBufferSize(int size)
{
  if (size < issueBuffer.size())
  {
    issueBuffer.erase(issueBuffer.begin(), issueBuffer.begin() + (issueBuffer.size() - size)); // don't need to delete every issue individually because we passed the struct and not the pointer
    vector<issue>(issueBuffer).swap(issueBuffer);                                              // this create a new Buffer with capacity equal to the size, that frees memory allocated with the erased issue
  }
  issueBufferSize = size;
  issueBuffer.reserve(size); //useful if (size>issueBuffer.size()) in other cases it does nothing, no need of "if clause"
}

void APIRest::checkIssueBufferSize()
{
  if (issueBufferSize <= issueBuffer.size() - (reposting ? 1 : 0))
  { //if the rePOSTing of an issue fails, when this check is done the issue is already at the begin of issueBuffer,
    // so do not take into account its presence (so issueBuffer.size()-1), beacuse the issue will be deleted from the begin of the queue and added back to the end.
    // don't need to deallocate every issue individually because we passed the struct and not the pointer
    issueBuffer.erase(issueBuffer.begin(), issueBuffer.begin() + issueBufferSize / decimationPolicyFactor); //delete issueBufferSize/decimationPolicyFactor issue
    vector<issue>(issueBuffer).swap(issueBuffer);                                                           // this create a new Buffer with capacity equal to the size, that frees memory allocated with the erased issues
  }
}
void APIRest::checkSampleBufferSize()
{
  if (sampleBufferSize <= sampleBuffer.size() - (reposting ? 1 : 0))
  { //if the rePOSTing of a sample fails, when this check is done the sample is already at the begin of sampleBuffer,
    // so do not take into account its presence (so sampleBuffer.size()-1), beacuse the sample will be deleted from the begin of the queue and added back to the end.
    // [TBD]
    // don't need to deallocate every sample individually because we passed the struct and not the pointer
    sampleBuffer.erase(sampleBuffer.begin(), sampleBuffer.begin() + sampleBufferSize / decimationPolicyFactor); //delete sampleBufferSize/decimationPolicyFactor sample
    vector<sample>(sampleBuffer).swap(sampleBuffer);                                                            // this create a new Buffer with capacity equal to the size, that frees memory allocated with the erased samples
  }
}

// https://students.atmosphere.tools ->
string APIRest::parseServerName(string url)
{
  string sName = url.substr(url.find("//") + 2);
  sName = sName.substr(0, sName.find("/"));
  return sName;
}

string APIRest::parseURLPath(string url)
{
  string uPath = url.substr(url.find("//") + 2);
  if (uPath.find("/") != -1)
  {
    uPath = uPath.substr(uPath.find("/"));
    return uPath;
  }
  else
    return uPath;
}

int APIRest::parseHTTPCode(string response)
{
  string code = response.substr(response.find("HTTP/") + 9);
  code = code.substr(0, 3);
  return atoi(code.c_str());
}

void APIRest::printResponseToSerial(string request, string response)
{
  Serial.println("\n===================================================================================");
  Serial.print("Request: ");
  Serial.println(request.c_str());
  Serial.println("Response: ");
  Serial.println(response.c_str());
  Serial.println("===================================================================================");
}

