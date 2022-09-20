#include <EdgeEngine_library.h>
#include <time.h>

using std::vector;
using std::string;

bool testTemp = false;
clock_t cycleCounter;
clock_t sleepTime;

sample* temperature = NULL;

edgine* Edge;
connection_windows* Connection;
vector<sample*> samples;

float getTemperature(){
  if(testTemp)
    return 24.0F;
  else
    return 24.5F;
}

void setup() {
    // setup connection
    Connection = connection_windows::getInstance();
    options opts;
    //login
    opts.username = "body-monitor-username";
    opts.password = "body-monitor-password";
    opts.tenant = "body-monitor";
    //route
    opts.url = "https://students.measurify.org";
    opts.ver = "v1";
    opts.login = "login";
    opts.devs = "devices";
    opts.scps = "scripts";
    opts.measurements = "measurements";
    opts.info= "info";
    opts.issues="issues";
    //Edgine identifiers
    opts.thing = "User B";
    opts.device = "distance-monitor-1";
    opts.id = "distance-monitor-1";
    //initialize Edge engine
    Edge = edgine::getInstance();
    Edge->init(opts);
}

void action(int counter) {
  for(int i = 0; i < counter; i++)
  {
    cycleCounter = clock();

    //create a temperature measurement sample
    temperature = new sample("temperature");
    temperature->startDate = Edge->Api->getActualDate();
    temperature->endDate = temperature->startDate;
    testTemp = !testTemp;
    temperature->value = getTemperature();
    samples.push_back(temperature);

    Edge->evaluate(samples);

    samples.clear(); // after evaluated all samples delete them

    delete temperature;
    temperature = NULL;

    cycleCounter=clock()-cycleCounter;// duration of the execution of the cycle

    // subtract te execution time to the Sleep period if result is not negative
    ((float)cycleCounter/CLOCKS_PER_SEC) < Edge->getPeriod() ? sleepTime = (Edge->getPeriod() - (float)cycleCounter/CLOCKS_PER_SEC)*1000 : sleepTime = 0;//delay in milliseconds
  
    sleep(sleepTime);
  }
}

int main() {
    setup();
    action(4);
}





