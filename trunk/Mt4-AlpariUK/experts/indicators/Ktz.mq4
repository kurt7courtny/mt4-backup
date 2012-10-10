/*
   Generated by EX4-TO-MQ4 decompiler V4.0.224.1 []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "Copyright ?2005, Nick Bilak"
#property link      "http://metatrader.50webs.com/"

#property indicator_chart_window
#include <tz.mqh>
extern double djpy = 0.5;
extern double deur = 0.5;
extern double dusd = 0.5;

int deinit() {
   ObjectDelete( "hu");
   ObjectDelete( "hd");
   return (0);
}

int init() {
   return (0);
}

int start() {
   double yjpy, yeur, yusd, tjpy, teur, tusd;
   yjpy = (itzPrice( Symbol(), 0, 1, 0, 1) - itzPrice( Symbol(), 0, 2, 0, 1)) * djpy;
   yeur = (itzPrice( Symbol(), 1, 1, 0, 1) - itzPrice( Symbol(), 1, 2, 0, 1)) * deur;
   yusd = (itzPrice( Symbol(), 2, 1, 0, 1) - itzPrice( Symbol(), 2, 2, 0, 1)) * dusd;
   tjpy = itzPrice( Symbol(), 0, 0, 0, 0);
   teur = itzPrice( Symbol(), 1, 0, 0, 0);
   tusd = itzPrice( Symbol(), 2, 0, 0, 0);
   //Print("price " + tjpy + " e " + teur + " u " + tusd);
   ObjectDelete("hu");
   ObjectDelete("hd");
   if( tusd != 0)
   {
      ObjectCreate("hu", OBJ_HLINE, 0, 0, tusd + yusd);
      ObjectCreate("hd", OBJ_HLINE, 0, 0, tusd - yusd);
      //Print("usd open price " + tusd + " range " + yusd);
      return (0);
   }
   
   if( teur != 0)
   {
      ObjectCreate("hu", OBJ_HLINE, 0, 0, teur + yeur);
      ObjectCreate("hd", OBJ_HLINE, 0, 0, teur - yeur);
      //Print("eur open price " + teur + " range " + yeur);
      return (0);
   }
   
   if( tjpy != 0)
   {
      ObjectCreate("hu", OBJ_HLINE, 0, 0, tjpy + yjpy);
      ObjectCreate("hd", OBJ_HLINE, 0, 0, tjpy - yjpy);
      //Print("jpy open price " + tjpy + " range " + yjpy);
      return (0);
   }
   
   return (0);
}