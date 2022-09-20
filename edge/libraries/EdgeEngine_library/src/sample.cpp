/*
  sample.cpp - Class for model sample.
  Created by Francesco Tornatore, February 24, 2020.
  Released into the public domain.
*/

#include "sample.h"
#include <sstream>
#include <array>
#include <vector>
using std::array;
using std::string;
using std::stringstream;
using std::vector;






sample::sample(string feature){
  this->feature=feature;
}
//copy constructor
sample::sample(const sample &sam){

  
  
  this->startDate=sam.startDate;
  this->endDate=sam.endDate;
  this->url=sam.url;
  this->thing=sam.thing;
  this->feature=sam.feature;
  this->device=sam.device;
  this->scriptId=sam.scriptId;
  this->sizeOfSamples = sam.sizeOfSamples;
  this->myArray = sam.myArray;
  
}

//methods
string sample::ArrayToString(vector<float> myArray){
  
  stringstream sstream;
  if(myArray.size() == 1){
    sstream << myArray[0];
  }else{
    sstream << "[ ";
    for(int i=0; i < myArray.size(); i++ ){
      sstream << myArray[i];
      if(i < (myArray.size()-1)){
          sstream << ", ";
        }
    }
    sstream << " ]";
  }
  return sstream.str();
}
