//+------------------------------------------------------------------+
//|                                                        KTest.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#define C_JPY 0
#define C_EUR 1
#define C_USD 2

#define T_High    0
#define T_Open    1
#define T_Close   2
#define T_Low     3
#define T_Volume  4

int H1 = 3600;
int D1 = 86400;

double itzPrice(string sb, int ctype, int tprice,int jpystart, int days) 
{
   double resp = 0;
   jpystart = MathMod( MathMod( jpystart, 24) + 24, 24);
   int tstart = Time[0] / D1 * D1 - days * D1 +  jpystart * H1, icount=-1;
   bool done = false;
   for( int i = tstart; i < Time[0] && !done ; i += H1)
   {
      // Print("sb:" + sb, " ctype:" + ctype + " tprice:" + tprice + " time:" + TimeToStr(i) + " ibas:" + iBarShift( sb, PERIOD_H1, i));
      icount++;
      switch (ctype)
      {
         case C_JPY:
            if( icount < 7+jpystart)
            {
               //Print("icount:" + icount);
               switch(tprice)
               {
                  case T_Open:
                     resp = iOpen( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i));
                     done = true;
                     break;
                  case T_Close:
                     resp = iClose( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)); 
                     break;
                  case T_High:
                     resp = MathMax( resp , iHigh( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)));
                     break;
                  case T_Low:
                     if( icount == 0)
                        resp = 100000;
                     resp = MathMin( resp , iLow( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)));
                     break;
               }
            }
            else
            {
               done = true;   
               // Print("get jpy price finished");
            }
            break;
         case C_EUR:
            if( icount < 15+jpystart)
            {
               if( icount < 7 + jpystart)
                  break;
               //Print("icount e:" + icount);
               switch(tprice)
               {
                  case T_Open:
                     resp = iOpen( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i));
                     done = true;
                     break;
                  case T_Close:
                     resp = iClose( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)); 
                     break;
                  case T_High:
                     resp = MathMax( resp , iHigh( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)));
                     break;
                  case T_Low:
                     if( icount == 7+jpystart)
                        resp = 100000;
                     resp = MathMin( resp , iLow( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)));
                     break;
               }
            }
            else 
               done = true;
            break;
         case C_USD:
            if( icount < 24+jpystart)
            {
               if( icount < 15 + jpystart)
                  break;
               //Print("icount u:" + icount);
               switch(tprice)
               {
                  case T_Open:
                     resp = iOpen( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i));
                     done = true;
                     break;
                  case T_Close:
                     resp = iClose( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)); 
                     break;
                  case T_High:
                     resp = MathMax( resp , iHigh( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)));
                     break;
                  case T_Low:
                     if( icount == 15+jpystart)
                        resp = 100000;
                     resp = MathMin( resp , iLow( sb, PERIOD_H1, iBarShift( sb, PERIOD_H1, i)));
                     break;
               }
            }
            else 
               done = true;
            break;
         default:
            return (resp);
 
      }
   }
   return (resp);
}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
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
   int    counted_bars=IndicatorCounted();
//----
   Print("yestoday u jpyh:" + itzPrice(Symbol(), 2,0,0,1) + " jpyo:"  + itzPrice(Symbol(), 2,1,0,1)  + " jpyc:"  + itzPrice(Symbol(), 2,2,0,1) + " jpyl:"  + itzPrice(Symbol(), 2,3,0,1));
//----
   return(0);
  }
//+------------------------------------------------------------------+