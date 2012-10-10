//+------------------------------------------------------------------+
//|                                                       kAlert.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
int m10=600;
string CurrencyPairs[] = { "EURUSD", "GBPUSD", "AUDUSD", "USDCAD", "USDCHF", "NZDUSD",
                           "EURGBP", "EURAUD", "EURCAD", "EURCHF", "EURNZD", 
                           "GBPAUD", "GBPCAD", "GBPCHF",
                           "AUDCAD", "AUDCHF", "AUDNZD",
                           "CADCHF", "NZDCAD",
                           "NZDCHF",
                           "USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "CADJPY", "CHFJPY",
                           "XAUUSD", "XAGUSD"
                           };
                           
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
extern bool	EmailAlert1	= true;

extern int malevel1=33;
extern int malevel2=9;

extern int MAS=0;
extern int MAE=100;
extern int MAM=0;
extern int MAP=0;
extern int MAL=30;

int lt=0, cpn=0;

int init()
  {
//---- indicators
//----
   IndicatorShortName("kmacr");
   cpn = ArraySize(CurrencyPairs);
   string sTitle;
   sTitle = "Æô¶¯¼à¿Ø±¨¾¯:kmacr";
   if( EmailAlert1)
      SendMail( sTitle, "");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(lt!=Time[0]&&MathMod(Time[0],900)==m10)
   {
      string sTitle="ma break", sMessage="";
      for(int i=0;i<cpn;i++)
      {
         double ma0,ma1,ma2,ma3;
         int c0=0,c1=0,c2=0,c3=0;
         for( int j=MAS; j<MAE; j++)
         {
            ma0=iMA(CurrencyPairs[i],PERIOD_M15,j,0,MAM,MAP,0);
            ma1=iMA(CurrencyPairs[i],PERIOD_M15,j,0,MAM,MAP,1);
            ma2=iMA(CurrencyPairs[i],PERIOD_M15,j,0,MAM,MAP,2);
            ma3=iMA(CurrencyPairs[i],PERIOD_M15,j,0,MAM,MAP,3);
            if(iLow(CurrencyPairs[i],PERIOD_M15,0)<ma0&&iHigh(CurrencyPairs[i],PERIOD_M15,0)>ma0)
               c0+=1;
            if(iLow(CurrencyPairs[i],PERIOD_M15,1)<ma1&&iHigh(CurrencyPairs[i],PERIOD_M15,1)>ma1)
               c1+=1;
            if(iLow(CurrencyPairs[i],PERIOD_M15,2)<ma2&&iHigh(CurrencyPairs[i],PERIOD_M15,2)>ma2)
               c2+=1;
            if(iLow(CurrencyPairs[i],PERIOD_M15,3)<ma3&&iHigh(CurrencyPairs[i],PERIOD_M15,3)>ma3)
               c3+=1;
         }
         //Print(CurrencyPairs[i]+",c0:"+c0+",c1:"+c1+",c2:"+c2+",c3:"+c3);
         if(c0<malevel2 && (c1>malevel1 || c2>malevel1 || c3>malevel1))
         {
            sMessage=sMessage+CurrencyPairs[i]+",";
         }
      }
      if( EmailAlert1 && StringLen(sMessage)>0)
         SendMail( sTitle, sMessage);
      lt=Time[0];
   }
 
//----
   
//----
   return(0);
  }