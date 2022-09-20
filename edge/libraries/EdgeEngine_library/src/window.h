/*
  window.h - Class for perform a calculus on a window of n samples.
  Created by Francesco Tornatore, February 24, 2020.
  Released into the public domain.
*/
#ifndef window_h
#define window_h

#include "myDefines.h"

#ifdef ARDUINO
  #include <Arduino.h>
  #ifndef ESP_WROVER
    #undef min
    #undef max
  #endif
#endif
#include "operation.h"
#include "sample.h"

class window : public operation{
  private:
  //variable
  char function;
  float initial;
  float accumulator;
  float result;
  int windowSize;
  int counter;
  string startDate;

  //methods
  void parseArgument(string,int);
  float calculate(float);
  public:
  //constructors
  window(string,int);
  //destructor
  ~window();
  
  //methods
  sample* execute() ;
};



#endif 
