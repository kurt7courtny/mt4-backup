//+------------------------------------------------------------------+
//|                                                      G7_MACD.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4

//---- input parameters
extern int       MA_fast=4;
extern int       MA_slow=32;
extern int       MA_method=0;
extern int       MA_applied_price=0;
extern double    MACD_Sepa=0.3;
extern string RGB = "R";
extern int WickWidth = 1;
extern int CandleWidth = 4;

color AverageColor = Crimson;
color LighterColor = Tomato;
color DarkerColor = Crimson;
string g_symbol_96 = "";
double g_ibuf_112[];
double g_ibuf_116[];
double g_ibuf_120[];
double g_ibuf_124[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if( RGB == "R") {
      AverageColor = Crimson;
      LighterColor = Tomato;
      DarkerColor = Crimson;
   }
   else if( RGB == "G") {
      AverageColor = ForestGreen;
      LighterColor = Chartreuse;
      DarkerColor = ForestGreen;
   }
   else {
      AverageColor = RoyalBlue;
      LighterColor = LightBlue;
      DarkerColor = RoyalBlue;
   }
   SetIndexLabel(0, "R_CAND_LIGHT");
   SetIndexBuffer(0, g_ibuf_112);
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, CandleWidth, LighterColor);
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexLabel(1, "R_CAND_DARK");
   SetIndexBuffer(1, g_ibuf_116);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, CandleWidth, DarkerColor);
   SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexLabel(2, "R_WICK_LIGHT");
   SetIndexBuffer(2, g_ibuf_120);
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, WickWidth, LighterColor);
   SetIndexEmptyValue(2, EMPTY_VALUE);
   SetIndexLabel(3, "R_WICK_DARK");
   SetIndexBuffer(3, g_ibuf_124);
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, WickWidth, DarkerColor);
   SetIndexEmptyValue(3, EMPTY_VALUE);
    
   IndicatorShortName("G7-MACD-R" + MA_fast + "," + MA_slow + ")");
   IndicatorDigits(4);
//----
   g_symbol_96 = Symbol();
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
   double l_iclose_36;
   double l_iopen_44;
   double l_ihigh_52;
   double l_ilow_60;
   if( Bars < 30) return;
   int counted_bars=IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   double ig;
   for (int i = 0; i < limit ; i++) {
      if( Symbol() == "EURUSD") {
         ig = iG7( "EUR", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "GBPUSD") {
         ig = iG7( "GBP", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "AUDUSD") {
         ig = iG7( "AUD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "USDCAD") {
         ig = iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "CAD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "USDCHF") {
         ig = iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "CHF", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "USDJPY") {
         ig = iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "JPY", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      }
      l_iclose_36 = iClose(g_symbol_96, 0, i);
      l_iopen_44 = iOpen(g_symbol_96, 0, i);
      l_ihigh_52 = iHigh(g_symbol_96, 0, i);
      l_ilow_60 = iLow(g_symbol_96, 0, i);    
      //Print("ig ...", ig, i);
      if( (ig < 0 && MathAbs(ig) > MACD_Sepa && RGB == "R") || ( ig > 0 && MathAbs(ig) > MACD_Sepa && RGB == "G") || ((MathAbs(ig) < MACD_Sepa) && RGB == "B")){
         g_ibuf_112[i] = l_iclose_36;
         g_ibuf_116[i] = l_iopen_44;
         if (l_iclose_36 >= l_iopen_44) {
            g_ibuf_120[i] = l_ihigh_52;
            g_ibuf_124[i] = l_ilow_60;
         } else {
            g_ibuf_124[i] = l_ihigh_52;
            g_ibuf_120[i] = l_ilow_60;
         }
      }
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

double iG7(string sb, int timeframe, int g7_fast, int g7_slow, int ma_method, int applied_price, int shift) {
   double resp=0;
   double mas[6], imaf[6], imas[6];
   string ac = AccountCompany();
   
   ma_method=ma_method%4;
   applied_price=applied_price%7;
   
   if( g7_fast < 1) g7_fast=1;
   if( g7_slow < 1) g7_slow=1;
   if( timeframe != NULL && 
       timeframe != PERIOD_M1 && timeframe != PERIOD_M5 && timeframe != PERIOD_M15 && 
       timeframe != PERIOD_M30 && timeframe != PERIOD_H1 && timeframe != PERIOD_H4 && 
       timeframe != PERIOD_D1 && timeframe != PERIOD_W1 && timeframe != PERIOD_MN1) {
      Print("Invalid timeframe");
      return (-1);
   }
       
   if( StringFind( ac, "Alpari", 0) == 0) {
      imaf[0] = iMA("EURUSD", 0, g7_fast, 0, ma_method, applied_price, shift);
      imas[0] = iMA("EURUSD", 0, g7_slow, 0, ma_method, applied_price, shift);
      imaf[1] = iMA("GBPUSD", 0, g7_fast, 0, ma_method, applied_price, shift);
      imas[1] = iMA("GBPUSD", 0, g7_slow, 0, ma_method, applied_price, shift);
      imaf[2] = iMA("AUDUSD", 0, g7_fast, 0, ma_method, applied_price, shift);
      imas[2] = iMA("AUDUSD", 0, g7_slow, 0, ma_method, applied_price, shift);
      imaf[3] = iMA("USDCAD", 0, g7_fast, 0, ma_method, applied_price, shift);
      imas[3] = iMA("USDCAD", 0, g7_slow, 0, ma_method, applied_price, shift);
      imaf[4] = iMA("USDCHF", 0, g7_fast, 0, ma_method, applied_price, shift);
      imas[4] = iMA("USDCHF", 0, g7_slow, 0, ma_method, applied_price, shift);
      imaf[5] = iMA("USDJPY", 0, g7_fast, 0, ma_method, applied_price, shift);
      imas[5] = iMA("USDJPY", 0, g7_slow, 0, ma_method, applied_price, shift);
      if( imaf[0] * imas[0] * imaf[1] * imas[1] * imaf[2] * imas[2] * imaf[3] * imas[3] * imaf[4] * imas[4] * imaf[5] * imas[5] == 0)
         return;
      mas[0] = imaf[0] / imas[0];
      mas[1] = imaf[1] / imas[1];
      mas[2] = imaf[2] / imas[2];
      mas[3] = imas[3] / imaf[3];
      mas[4] = imas[4] / imaf[4];
      mas[5] = imas[5] / imaf[5];
      if( sb == "EUR") {
         return ( mas[0] * (100 / mas[1] + 100.0 + 100 / mas[2] + 100 / mas[3] + 100 / mas[4] + 100 / mas[5]) - 600.0);
      } else if( sb == "GBP") {
         return ( mas[1] * (100 / mas[0] + 100.0 + 100 / mas[2] + 100 / mas[3] + 100 / mas[4] + 100 / mas[5]) - 600.0);
      } else if( sb == "AUD") {
         return ( mas[2] * (100 / mas[0] + 100.0 + 100 / mas[1] + 100 / mas[3] + 100 / mas[4] + 100 / mas[5]) - 600.0);
      } else if( sb == "CAD") {
         return ( mas[3] * (100 / mas[0] + 100.0 + 100 / mas[1] + 100 / mas[2] + 100 / mas[4] + 100 / mas[5]) - 600.0);
      } else if( sb == "CHF") {
         return ( mas[4] * (100 / mas[0] + 100.0 + 100 / mas[1] + 100 / mas[2] + 100 / mas[3] + 100 / mas[5]) - 600.0);
      } else if( sb == "JPY") {
         return ( mas[5] * (100 / mas[0] + 100.0 + 100 / mas[1] + 100 / mas[2] + 100 / mas[3] + 100 / mas[4]) - 600.0);
      } else if( sb == "USD") {
         return ( 100 / mas[0] + 100 / mas[1] + 100 / mas[2] + 100 / mas[3] + 100 / mas[4] + 100 / mas[5] - 600.0);
      } else {
         Print("Can not find Symbol Config");
         return (-2);
      }
   }
   else {
      Print("Can not find Company Config");
      return (-3);
   }
   return (resp);  
}