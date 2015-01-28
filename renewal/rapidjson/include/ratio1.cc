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
#include <math.h>
#include <float.h>
#include <vector>
#include <algorithm>

using namespace rapidjson;
using namespace std;

double deg2rad(double deg){
  return deg * M_PI / 180;  
}

double distance(double lat1, double lon1, double lat2, double lon2){
  double R = 6371;
  double dlat = deg2rad(lat2-lat1);
  double dlon = deg2rad(lon2-lon1);
  double a = sin(dlat/2) * sin(dlat/2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dlon/2) * sin(dlon/2);
  double c = 2 * atan2(sqrt(a),sqrt(1-a));
  double d = R * c;
  return d;
}
bool pairCompare(const pair<string,double>& a,const pair<string,double>& b){
  return a.second > b.second;
}

int main(){
  //freopen("../../../../data/estimator_stdout.log","a",stdout);
  //freopen("../../../../data/estimator_error.log","a",stderr);
  //cout << distance(34.6939,135.5022,35.6895,139.6917)<<endl;
/*
  template <typename T1, typename T2>
  struct less_second{
    typedef pair<T1,T2> type;
    //typedef pair<string,int> type;
    bool operator()(type const& a, type const& b) const{
      return a.second < b.second;
    }
  };
*/
/*
  unordered_map<string,int> test= {{"b",2},{"a",1},{"c",4},{"d",3}};  
  for(auto it=test.begin();it!=test.end();++it){
    cout<<it->first<<endl;
  }
  vector<pair<string,double>> mapcopy(test.begin(),test.end());
  sort(mapcopy.begin(),mapcopy.end(),pairCompare);
  for(auto it=mapcopy.begin();it!=mapcopy.end();++it){
    cout<<it->first<<","<<it->second<<endl;
  }

  return 0;
*/
  FILE * log = fopen("../../../../data/ratio.txt","a");  
  string users[11177];
  string line;
  ifstream myfile ("../../../../data/new_valid_user");
  if (myfile.is_open()){
    int n = 0; 
    while (getline(myfile, line)){
      users[n] = line;
      n++;
    }
    myfile.close();
  }
  
  int uc = 0;
  string word_input = "../../../../data/ratio_10.goi";
  //string word_input = "../../../../data/tokucho1.goi";
  ifstream w(word_input);
  stringstream word_buffer;
  word_buffer << w.rdbuf()<<endl;
  Document wd;
  wd.Parse<0>(word_buffer.str().c_str());
  Value& wds = wd["words"];
  assert(wds.IsArray());
  unordered_map<string,int> gois;
  for(SizeType k = 0; k < wds.Size(); k++){
    Value& goi = wds[k];
    assert(goi.IsArray());
    SizeType i0 = 0;
    SizeType i1 = 1;
    Value& goi1 = goi[i0];
    Value& num = goi[i1];
    int cnt = num.GetInt();
    gois[goi1.GetString()] = cnt;
  }
  //cout << gois["twitter"]<<endl;
  //int corpus = 7862333;
  //int corpus = 7866266;
  int corpus = 18704373;
  //cout<<INT_MAX<<endl;
  //cout<<corpus<<endl;return 0;
  for(int i=0; i<1000; i++){
  //for(int i=0; i<1; i++){
  //cout<<INT_MAX<<endl;return 0;
    clock_t t1 = clock();
    unordered_map<string,double> coordinates;
    string user = users[i];
    //cout<<user<<endl;
    //return 0;
    uc++;
    stringstream js;
    js << user;
    FILE * res = fopen(("../../../../data/res_ratio/"+js.str()+".json").c_str(),"w");
    string user_file = "../../../../data/word_user/" + js.str() + ".json";
    ifstream u(user_file);
    stringstream user_buffer;
    user_buffer << u.rdbuf()<<endl;
    Document ud;
    ud.Parse<0>(user_buffer.str().c_str());
    Value& rloc = ud["user"]["rloc"];
    //assert(rloc.IsObject());
    stringstream ss(rloc.GetString());
    double coor[2];
    string token;
    int cnt = 0; 
    while(getline(ss,token,',')){
      coor[cnt] = stod(token);
      cnt++;
    }
    double rlat = coor[0];
    double rlon = coor[1];
    Value& uwords = ud["words"];
    int u_corpus=0;
    for(Value::ConstMemberIterator itr=uwords.MemberBegin();itr!=uwords.MemberEnd();++itr){
      string key = itr->name.GetString();
      stringstream key_s;
      key_s << key;
      int value = itr->value.GetInt();
/*
      string goi_file = "../../../../data/gois/"+key_s.str();
      FILE * p = fopen(goi_file.c_str(),"r");
      if(p){
        fclose(p);
        u_corpus += value;
      }
*/
      for(SizeType k = 0; k < wds.Size(); k++){
        Value& goi = wds[k];
        assert(goi.IsArray());
        SizeType i0 = 0;
        SizeType i1 = 1;
        Value& goi1 = goi[i0];
        Value& num = goi[i1];
        if (key==goi1.GetString()){
          u_corpus += value;
          break;
        }
      }
    }
    //cout<<"test"<<endl;
    //assert(uwords.IsArray());
    //unordered_map<string,int> uwords;
    for(Value::ConstMemberIterator itr=uwords.MemberBegin();itr!=uwords.MemberEnd();++itr){
      string key = itr->name.GetString();
      stringstream key_s;
      key_s << key;
      int value = itr->value.GetInt();
      bool flag=false;
      for(SizeType k = 0; k < wds.Size(); k++){
        Value& goi = wds[k];
        assert(goi.IsArray());
        SizeType i0 = 0;
        SizeType i1 = 1;
        Value& goi1 = goi[i0];
        Value& num = goi[i1];
        if (key==goi1.GetString()){
          flag=true;
          break;
        }
      }
      string goi_file = "../../../../data/gois/"+key_s.str();
      //FILE * p = fopen(goi_file.c_str(),"r");
      if(flag){
        //fclose(p);
        string line;
        ifstream gfile (goi_file);
        if (gfile.is_open()){
          int n = 0; 
          while (getline(gfile, line)){
            stringstream cc(line);
            string coor[3];
            string token;
            int cnt = 0; 
            while(getline(cc,token,',')){
              coor[cnt] = token;
              cnt++;
            }
            string lat = coor[0];
            string lon = coor[1];
            double n = stod(coor[2]);
            //ostringstream oslat,oslon;
            //oslat << lat;
            //oslon << lon;
            //string coordinate = oslat.str() + ',' + oslon.str();
            string coordinate = lat + "," + lon;
            auto got = coordinates.find(coordinate);
            if (got == coordinates.end()){
              coordinates[coordinate] = 0;
            }
            coordinates[coordinate] += (double)(value * n);
            //coordinates[coordinate] += value * ((double)n / gois[key]) * ((double)value/u_corpus);
            //fprintf(log,"%s,%s,%f\n",key.c_str(),coordinate.c_str(),value * ((double)n / gois[key]) * ((double)value/ u_corpus));
          }
        }       
      }
    }
    //sort coordinates
    vector<pair<string,double>> mapcopy(coordinates.begin(),coordinates.end());
    sort(mapcopy.begin(),mapcopy.end(),pairCompare);
    if (mapcopy.size()<11){
      //cout<<"no word"<<endl;
      continue;
    }
    /*
    for(auto it=mapcopy.begin();it!=mapcopy.end();++it){
      //cout<<it->first<<","<<it->second<<endl;
    }
    cout<<mapcopy.begin()->second<<endl;
    return 0;*/

    int size = 31366;
    int cr_cnt = 0;
    int num = size;
    int first_num =size;
    int first_num_10 = size;
    bool flag = true;
    bool flag_10 = true;
    double all_prob = 0;
    double all_dist = 0;
    double all_dist2 = 0;
    for(auto it=mapcopy.begin();it!=mapcopy.end();++it){      
      all_prob += it->second;
      cr_cnt++;
      if (it->first == rloc.GetString()){
        num = cr_cnt;
      }
      string line;
      line = it->first;
      stringstream cc(line);
      double coor[2];
      string token;
      int cnt = 0; 
      while(getline(cc,token,',')){
        coor[cnt] = stod(token);
        cnt++;
      }
      double lat = coor[0];
      double lon = coor[1];
      double dist = distance(rlat,rlon,lat,lon);
      //fprintf(log,"%s,%f,%f\n",it->first.c_str(),it->second,dist);
      if (cr_cnt <= 10){
        all_dist += dist;
        all_dist2 += dist * dist;
      }
      if (flag && dist<=160){
        first_num = cr_cnt;
        flag = false;
      }
      if (flag_10 && dist <= 10){
        first_num_10 = cr_cnt;
        flag_10 = false;
      }
      fprintf(res,"%s,%f\n",it->first.c_str(),it->second);
    }
    fclose(res);
    clock_t t2 = clock();
    fprintf(log,"%d,%s,%s,%d,%d,%d,%d,%f,%f,%f,%f,%f\n",uc,user.c_str(),rloc.GetString(),first_num,first_num_10,num,coordinates.size(),mapcopy.begin()->second,all_prob,all_dist/10,sqrt(all_dist2/10-all_dist*all_dist/100),(double)(t2-t1)/CLOCKS_PER_SEC);
    fclose(log);
    log = fopen("../../../../data/ratio.txt","a");  
  }
return 0;
}
