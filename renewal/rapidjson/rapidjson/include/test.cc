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
    freopen("stdout.txt","a",stdout);
    freopen("stderr.txt","a",stderr);
    //clock_t fc=0,jc=0,lc=0,oc=0;
    string word_input = "/home/chinbat/bunseki/o50_json.txt";
    FILE * log = fopen("log.txt","a");
    ifstream w(word_input);
    stringstream word_buffer;
    word_buffer << w.rdbuf()<<endl;
    Document wd;
    wd.Parse<0>(word_buffer.str().c_str());
    Value& wds = wd["words"];
    assert(wds.IsArray());
    string gois[24334];
    for(SizeType k = 0;k<wds.Size();k++){
      Value& goi  = wds[k];
      assert(goi.IsArray());
      SizeType id = 0;
      Value& goi1 = goi[id];
      gois[k] = goi1.GetString();
    }
 
  for(int id = 24000; id < 24334; id++){
    //int all=0,cr=0;
    string key = gois[id];
    string base = "gois/";
    FILE * udon;
    udon = fopen((base+key).c_str(),"w");
    //long int cnt=0;
    //long int cnt_all=0;
    //string key="うどん";
    unordered_map<string,int> word;

    for(int j = 0; j< 50; j++){
    //clock_t t1 = clock();
    stringstream js;
    js << j;
    string filename = "/home/chinbat/analysis/clean_files/short_json/twout"+js.str()+".json";
    ifstream t(filename);
    stringstream buffer;

    buffer << t.rdbuf()<<endl;
    //clock_t t2 = clock();
    //fc += t2-t1;
    Document d;
    d.Parse<0>(buffer.str().c_str());
    Value& a = d["tweets"];
    assert(a.IsArray());
    //clock_t t3=clock();
    //jc += t3-t2;
    for(SizeType i = 0; i < a.Size(); i++){
        //cnt_all++;        
        Value& tweet = a[i];
        assert(tweet.IsObject());
        string coordinate = tweet["coordinates"].GetString();
        const Value& words = tweet["words"];
        assert(words.IsArray());
        for(SizeType k = 0; k < words.Size(); k++){
          if (key == words[k].GetString()){
                //all++;
         	auto got = word.find(coordinate);
		if ( got == word.end()){
	    		word[coordinate]=1;
		}else{
	    		got->second += 1;
		}
        	//cnt++;
                break;
          }
        }
    }// end of i-for
    //clock_t t4 = clock();
    //lc += t4-t3;
    }// end of j-for
    //clock_t t5=clock();
    for(auto it = word.begin();it!=word.end();++it){
        string tmp = it->first;
        int num = it->second;
        fprintf(udon,"%s,%d\n",tmp.c_str(),num);
    }
    fprintf(log,"%d,%s\n",id,key.c_str());
  }
    //clock_t t6 = clock();
    //oc += t6-t5;
    //cout<<"File: "<<(double)fc/CLOCKS_PER_SEC<<endl;
    //cout<<"JSON: "<<(double)jc/CLOCKS_PER_SEC<<endl;
    //cout<<"Loops: "<<(double)lc/CLOCKS_PER_SEC<<endl;
    //cout<<"Output: "<<(double)oc/CLOCKS_PER_SEC<<endl<<endl;
    //cout<<"all tweets: "<<cnt_all<<endl;
    //cout<<"udon tweets: "<<cnt<<endl;
    //cout<<"different coordinates: "<<word.size()<<endl;
    fclose(stdout);
    fclose(stderr);
    return 0;
}
