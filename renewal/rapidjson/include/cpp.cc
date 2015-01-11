#include "rapidjson/document.h"
#include "rapidjson/prettywriter.h"
#include "rapidjson/filestream.h"
#include <cstdio>
#include <string>
#include <fstream>
#include <streambuf>
#include <sstream>
#include <limits.h>
#include <iostream>
#include <ctime>
#include <unordered_map>
#include <stdio.h>

using namespace rapidjson;
using namespace std;

int main() {

    clock_t t1 = clock();
    FILE * udon;
    udon = fopen("udon.csv","w");
    long int cnt=0;
    string filename = "twout0_edited.json";
    ifstream t(filename);
    stringstream buffer;
    buffer << t.rdbuf()<<endl;
    clock_t t2 = clock();
    cout<<"Read file: "<<(double)(t2-t1)/CLOCKS_PER_SEC<<endl;

    rapidjson::Document d;
    d.Parse<0>(buffer.str().c_str());
    const Value& a = d["tweets"];
    assert(a.IsArray());
    clock_t t3 = clock();
    cout<<"JSON parses: "<<(double)(t3-t2)/CLOCKS_PER_SEC<<endl;

    for(SizeType i = 0; i < a.Size(); i++){
        cnt++;
        const Value& tweet = a[i];
        assert(tweet.IsObject());
        string coordinate = tweet["coordinates"].GetString();
    }
    clock_t t4 = clock();
    cout << "Loops: "<<(double)(t4-t3)/CLOCKS_PER_SEC<<endl;
    return 0;
}
