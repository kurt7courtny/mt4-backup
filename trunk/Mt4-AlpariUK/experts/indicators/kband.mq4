//+------------------------------------------------------------------+
//|                                                        kband.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#include <tz.mqh>

#define D1 86400
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
extern int kperiod=13;           // atr period
extern int days=20;              // recent

int lastct=0;

int init()
  {
//---- indicators
//----
   IndicatorDigits(4);
   IndicatorShortName("kband");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete( "hu");
   ObjectDelete( "hd");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   double yjpy=0, yeur=0, yusd=0, tjpy=0, teur=0, tusd=0;
   for(int i=1;i<=kperiod;i++)
   {
      yjpy += itzPrice( Symbol(), 0, 1, 0, i) - itzPrice( Symbol(), 0, 2, 0, i);   
      yeur += itzPrice( Symbol(), 1, 1, 0, i) - itzPrice( Symbol(), 1, 2, 0, i);
      yusd += itzPrice( Symbol(), 2, 1, 0, i) - itzPrice( Symbol(), 2, 2, 0, i);
   }
   yjpy /= kperiod;
   yeur /= kperiod;
   yusd /= kperiod;
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
//----
   return(0);
  }
//+------------------------------------------------------------------+

