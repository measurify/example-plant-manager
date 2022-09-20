/*
  sample.h - Class for model sample.
  Created by Francesco Tornatore, February 24, 2020.
  Released into the public domain.
*/

#ifndef sample_h
#define sample_h
#include <array>
#include <string>
#include <iostream>
#include <vector>



using std::array;
using std::string;
using std::stringstream;
using std::vector;



class sample{
  private:
  //variables
  
  //methods
  
  public:
  //variables
  
  vector<float> myArray;
  string startDate;
  string endDate;
  string url;
  string thing;
  string feature;
  string device;
  string scriptId;
  int sizeOfSamples;
 
  
  
  //methods 
  string ArrayToString(vector<float> myArray);
 
  
  //constructors
  sample(string);
  sample(const sample&);
  
};

#endif 
