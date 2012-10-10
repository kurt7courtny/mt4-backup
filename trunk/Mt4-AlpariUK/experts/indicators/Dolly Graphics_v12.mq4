//+------------------------------------------------------------------+
//|                                 Dolly Graphics_v12-GMT-Email.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//+------------------------------------------------------------------+
//|                                         Dolly (the famous sheep) |
//|               original indicator is called valasholic13 v2.5.mq4 |
//|                                                                  |
//|                  and the original author is valasholic@yahoo.com |
//|                                                                  |         
//|                        mods and stuff by Linuxser for Forex-TSD  |
//|                      (there is a lot of usefull code inside here)|
//|Credits: hulahula (traslation from original indonesian language)  |
//|ign... in collaboration with Linuxser (with mods and improvments  |
//+------------------------------------------------------------------+

/*
Thanks to the above coders for all their work on the original Dolly 

Dolly Graphics 4: by cja
   - Comments restored to original figures but different layout, kept simple thanks to FxNorth for advise
   - Graphics code cleaned up now can be run on any colour background
   - Pivot points altered to short LINES and Labels can be shifted and LINES extended
   - Pivot M Levels added and Labels can be shifted and LINES extended
   - Dolly Sell Buy Target Labels can be shifted
   - Daily Average Range added above & below Dolly Levels and DAR Labels can be shifted 
Dolly Graphics 5   
   - Dolly coloured panels & Daily Average Range can now be either panels or lines or a combo of both 
   - Daily Average Panels can now be turned on/off  
   - Dolly trading Comments reset to original layout with larger type & can now be turned on/off
   - Pivot points and M pivot levels can now be selected individually
   - Added in Back TEST simply set to # of days and scroll back to the 1st graphic in the line
Dolly Graphics 6
   - Central Pivot Point and Main Pivots now automatically show in BackTEST if Pivots on.
Dolly Graphics 8
   - Fib Levels added with option to take data back to previous days, Fib Levels on/off & TEXT on/off, 
   - move Fib TEXT & Extend line length if required.
   - Revised code and removed excess objects to increase speed. 
   - Fib Display able to be Short (Cover only the Graphics) or long extend to previous Day or more.
   - Adjustment of Dolly & Daily Average colours in inputs
   - Adjustment of BUY/SELL Levels in inputs 
   - Daily Average labels delete when Daily Graphics are removed.
Dolly Graphics 9
   - Extra Fib levels added to extend range if previous day was Range Bound.
   - Target 2 BUY & SELL have altered the code for the take profit so the Graphics now match the Text 
   - & when the level figure is altered the Text now alters to reflect the change, the old code was target 1 plus 
   - or minus 10. 
Dolly Graphics 10
   - NONE of the ORIGINAL CODE is now being used
   - Rewrote the original Dolly Code as I think that was where the REFRESH UPDATE issue problem existed
   - Rewrote the Pivots & M Pivot levels to speed up the indicator.
   - All Pivots now Backtest if Pivots & M Pivots turned on
   - Added a daily High/Low that is turned off by default - when on this feature will Backtest. 
   - Added Daily OPEN line Default is off, useful for the days that price starts above or below the Targets
   - can be used as a dynamic Pivot.         
Dolly Graphics #10 - by hymns
   - Add Daily Change Value
   - Tweak for using Open Graphics   
Fixed TimeShift - by FiFtHeLeMeNt
   - Fixed Pivots and added GMTshift , but backtest can not be used anymore , I think accurate data for today trade is more important than having backtest feature   
   - Fixed FiboLines and Graphics to be compatible with GMTshift
   - Fixed some bugs causing errors
Dolly Graphics #11 - by cja & thanks to FiFtHeLeMeNt for the GMT shift code
   - Added a pop up window alert when price approaches the Dolly levels 
   - Added an Auto Signals feature which removes the Comments and replaces them with an Auto signal system
   - Added email alert for trading levels and for sending all trading levels for new trading day at user selected LOCAL TIME.
Dolly Graphics #12 - updates to code by cja.
   - Cleaned up TEXT DELETE Functions code to stop interference with other indicators and refreshes issues. 
   - Altered the Fib code so that the 100% 0.00% levels switch depending on the previous day OPEN / CLOSE.
   - Changed the OBJECT DELETE setup for the graphics. 
   - Updated Comment TEXT to be on TOP so the text is not lost behind price candles.
   - Altered "Change" code so it does not display above H4 or below M5 for correct result plus minus numbers. 
   - Daily Average code updated.
   - Added Basic Shift functions for COMMENT Text & Change Display.
   - Resolved email not sending DATA for all currencies, rewrote email Frequency Function & split it into separate time functions. 
   - for email DATA/ALERTS & POP UP Window ALERTS, email DATA has 1 min frequency - POP UP ALERTS have 1 min - email ALERTS have
   - 5 min frequency to avoid too many email Alerts filling your inbox but updating often enough to be valid.
   - The DATA Email is now set for your LOCAL time not the BROKER time.
   - Show_Dolly_Instructions - This feature when set to "true" shows a basic method of trading Dolly, all the graphics are 
   - removed to assist in making the comments easier to read, set the Foreground tab under properties on your chart to WHITE
   - to make reading easier if using a dark background or BLACK if using a light background.     
       
*/
#property copyright ""
#property link      " Dolly Graphics cja"
#property indicator_chart_window


#define IND_NAME "Dolly Graphics #12"//GMT Email
extern int Show_Dolly_Instructions = false;
extern string IIIIIIIIIIIIIIIIIIIIIII= "<<<< If Broker GMT+2 enter 2 >>>>>>";
extern int GMTshift=0;
extern string IIIIIIIIIIIIIIIIIIIIIIII = "<<<< true=Open false=Pivot >>>>>>>>>"; 
extern bool Using_OpenGraphics = true;
extern string IIIIIIIIIIIIIIIIIIIIIIIII = "<<<< Comments & Alerts >>>>>>>>>>>>>>>>>>>>>>";
extern bool Alert_ON = false;
extern bool Auto_Signals = false;//New Auto Comments
extern bool Show_DollyCOMMENTS = true;//Standard Dolly comments
extern int  Shift_DollyCOMMENTS_UP_DN = 0;
extern int  Shift_DollyCOMMENTS_SIDEWAYS = 0;
extern string IIIIIIIIIIIIIIIIIIIIII="<<<< Emails Level Alerts >>>>>>>>>>>>>>>>>>>>>>>>";
extern bool EmailON = false;// sends email if price approaches Dolly level
extern string IIIIIIIIIIIIIIIIIII = "<<<< Emails All Daily Levels >>>>>>>>>>>>>>>>>>>>>";
extern bool Email_DATA = false;//sends email of all trading levels at start of new day
extern string IIIIIIIIIIIIIIIIIIII = "<<<< Email Time = Local >>>>>>>>>>>>>>>>>"; 
extern string DATA_EmailTime = "10:30";//sets email Data delivery time

extern string IIIIIIIIIIIIIIIIIIIIIIIIII = "<<<< Dolly Settings >>>>>>>>>>>>>>>>>>>>>>>>";
extern bool Dolly_GRAPHICS = true;
extern color BUY_Color_2 = C'0,0,150';
extern color BUY_Color_1 = C'0,0,100';
extern color SELL_Color_1 = C'120,0,0';
extern color SELL_Color_2 = C'180,0,0';
extern int BUY_Target_2 =50;
extern int BUY_Target_1 =40;
extern int BUY_Area =20;
extern int SELL_Area =20;
extern int SELL_Target_1 =40;
extern int SELL_Target_2 =50;
extern int SHIFT_DollyText = 0;

extern string IIIIIIIIIIIIIIIIIIIIIIIIIII = "<<<< Daily Average Settings >>>>>>>>>>>>>>>>>>>"; 
extern bool Show_DailyAverageGRAPHICS = true;
extern bool Daily_AverageGRAPHICS = true;
extern color DAILY_Av_UP_Color_150 = C'0,110,255';
extern color DAILY_Av_UP_Color_125 = C'0,70,255';
extern color DAILY_Av_UP_Color_100 = C'20,20,255';
extern color DAILY_Av_UP_Color_75 = C'0,0,210';
extern color DAILY_Av_DN_Color_75 = C'220,0,0';
extern color DAILY_Av_DN_Color_100 = C'255,0,10';
extern color DAILY_Av_DN_Color_125 = C'255,70,0';
extern color DAILY_Av_DN_Color_150 = C'255,110,0';
extern int SHIFT_DailyAverageText = 28;
extern string IIIIIIIIIIIIIIIIIIIIIIIIIIII = "<<<< Pivot Level Settings >>>>>>>>>>>>>>>>>>>>>>";
extern bool Show_PivotLines = false;
extern bool Show_M_PivotLines = false;
extern int SHIFT_PivotPointText = 0;
extern int PivotPoint_ExtendLINE = 0;
extern string IIIIIIIIIIIIIIIIIIIIIIIIIIIII = "<<<< Fib Level Settings >>>>>>>>>>>>>>>>>>>";
extern bool Show_FibLines = false;
extern bool Show_EXTRAFibLines = false;
extern int SHIFT_FibText = 65;
extern int FIB_ExtendDISPLAY = 1;
extern string IIIIIIIIIIIIIIIIIIIIIIIIIIIIII = "<<<< High & Low Settings >>>>>>>>>>>>>>>>>>>>>";
extern bool Show_Daily_HI_LOW = false;
extern int SHIFT_HI_LOW_TEXT = 50;
extern string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII = "<<<< Daily Open Settings >>>>>>>>>>>>>>>>>>>>";
extern bool Show_Daily_OPEN = false;
extern int SHIFT_Daily_OPEN_TEXT = 0;
extern string IIIIIIIIIIIIIIIIIIIII = "<<<< Change Display Settings >>>>>>>>>>>>>>>>>>>>";
extern bool Show_ChangeDISPLAY = true;
extern int  Shift_Change_UP_DN = 0;
extern int  Shift_Change_SIDEWAYS= 850;

//Daily OPEN
#define DO "DO"


//Daily HI/LOW
#define DHI "DHI"
#define DLO "DLO"
#define DDHI "DDHI"
#define DDLO "DDLO"

//Dolly Levels
#define DollyBUY3 "DollyBUY3"
#define DollyBUY2 "DollyBUY2"
#define DollyBUY1 "DollyBUY1"
#define DollySELL1 "DollySELL1"
#define DollySELL2 "DollySELL2"
#define DollySELL3 "DollySELL3"

//Daily Average Levels
#define AvBUY150 "AvBUY150"
#define AvBUY125 "AvBUY125"
#define AvBUY100 "AvBUY100"
#define AvBUY75 "AvBUY75"
#define AvSELL75 "AvSELL75"
#define AvSELL100 "AvSELL100"
#define AvSELL125 "AvSELL125"
#define AvSELL150 "AvSELL150"

//Pivot Levels
#define P1 "P1"

#define PP1 "PP1"
#define RR3 "RR3"
#define RR2 "RR2"
#define RR1 "RR1"
#define SS1 "SS1"
#define SS2 "SS2"
#define SS3 "SS3"

#define MM1 "MM1"
#define MM2 "MM2"
#define MM3 "MM3"
#define MM4 "MM4"
#define MM5 "MM5"
#define MM0 "MM0"

#define PPP1 "PPP1"
#define RRR3 "RRR3"
#define RRR2 "RRR2"
#define RRR1 "RRR1"
#define SSS1 "SSS1"
#define SSS2 "SSS2"
#define SSS3 "SSS3"

//FIB Levels
#define FibP100 "FibP100"
#define FibP618 "FibP618"
#define FibP50 "FibP50"
#define FibP382 "FibP382"
#define Fib100 "Fib100"
#define Fib764 "Fib764"
#define Fib618 "Fib618"
#define Fib50 "Fib50"
#define Fib382 "Fib382"
#define Fib236 "Fib236"
#define Fib0 "Fib0"
#define FibM100 "FibM100"
#define FibM618 "FibM618"
#define FibM50 "FibM50"
#define FibM382 "FibM382"

#define FibP236 "FibP236"
#define FibP764 "FibP764"
#define FibM236 "FibM236"
#define FibM764 "FibM764"
#define FibM150 "FibM150"
#define FibP150 "FibP150"
#define FibM200 "FibM200"
#define FibP200 "FibP200"
#define FibM250 "FibM250"
#define FibP250 "FibP250"
#define FibM300 "FibM300"
#define FibP300 "FibP300"


double P, S1, B1, S2, B2, S3, B3,x;

double day_high;
double day_low;
double yesterday_open;
double today_open;
double cur_day;
double prev_day;

double yesterday_high=0;
double yesterday_low=0;
double yesterday_close=0;
double tmp=0;

int nDigits,Precision,nDigitsMINUS;

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   GlobalVariableDel("AlertTime"+Symbol()+Period());
   GlobalVariableDel("SignalType"+Symbol()+Period());
   
  
   ObjectDelete("Pivot");
   ObjectDelete("Open");
     
   ObjectDelete("Dolly");
   ObjectDelete("Dolly1"); ObjectDelete("Dolly2"); ObjectDelete("Dolly3"); ObjectDelete("Dolly4");
   ObjectDelete("Dolly5"); ObjectDelete("Dolly6"); ObjectDelete("Dolly7"); ObjectDelete("Dolly8");
   ObjectDelete("Dolly9"); ObjectDelete("Dolly10"); ObjectDelete("Dolly11"); ObjectDelete("Dolly12");
   ObjectDelete("Dolly13"); ObjectDelete("Dolly14"); ObjectDelete("Dolly15"); ObjectDelete("Dolly16");
   ObjectDelete("Dolly17"); ObjectDelete("Dolly18"); ObjectDelete("Dolly19"); ObjectDelete("Dolly20");
   ObjectDelete("Dolly21"); ObjectDelete("Dolly22"); ObjectDelete("Dolly23"); ObjectDelete("Dolly24");
   ObjectDelete("Dolly25"); ObjectDelete("Dolly26"); ObjectDelete("Dolly27"); ObjectDelete("Dolly28");
   ObjectDelete("Dolly29"); ObjectDelete("Dolly30"); ObjectDelete("Dolly31"); ObjectDelete("Dolly32");
   ObjectDelete("Dolly33"); ObjectDelete("Dolly34"); ObjectDelete("Dolly35"); ObjectDelete("Dolly36");
   ObjectDelete("Dolly37"); ObjectDelete("Dolly38"); ObjectDelete("Dolly39"); ObjectDelete("Dolly40");
   ObjectDelete("Dolly41"); ObjectDelete("Dolly42"); ObjectDelete("Dolly43"); ObjectDelete("Dolly44");
   ObjectDelete("Dolly45"); ObjectDelete("Dolly46"); ObjectDelete("Dolly47"); ObjectDelete("Dolly48");
   ObjectDelete("Dolly49"); ObjectDelete("Dolly50"); ObjectDelete("Dolly51");
 
   ObjectDelete("Signal");ObjectDelete("Signal1");ObjectDelete("Signal2");
   
   ObjectDelete("TOP/AV150");ObjectDelete("TOP/AV125");ObjectDelete("TOP/AV100");
   ObjectDelete("TOP/AV75");ObjectDelete("TOP/AV50");ObjectDelete("TOP/AV25");
   ObjectDelete("LOW/AV150");ObjectDelete("LOW/AV125");ObjectDelete("LOW/AV100");
   ObjectDelete("LOW/AV75");ObjectDelete("LOW/AV50");ObjectDelete("LOW/AV25");
   
   ObjectDelete("B1");ObjectDelete("B2");ObjectDelete("B3");
   ObjectDelete("S1");ObjectDelete("S2");ObjectDelete("S3");
   ObjectDelete("C/PIVOT");
   ObjectDelete("R1");ObjectDelete("R2");ObjectDelete("R3");
   ObjectDelete("PS1");ObjectDelete("PS2");ObjectDelete("PS3");
   
   ObjectDelete("M0");ObjectDelete("M1");ObjectDelete("M2");
   ObjectDelete("M3");ObjectDelete("M4");ObjectDelete("M5");
   
   ObjectDelete("FIB");ObjectDelete("FIB2");ObjectDelete("FIB3");ObjectDelete("FIB4");
   ObjectDelete("FIB5");ObjectDelete("FIB6");ObjectDelete("FIB7");ObjectDelete("FIB8");
   ObjectDelete("FIB9");ObjectDelete("FIB10");ObjectDelete("FIB11");ObjectDelete("FIB12");
   ObjectDelete("FIB13");ObjectDelete("FIB14");ObjectDelete("FIB15");ObjectDelete("FIB16");
   ObjectDelete("FIB17");ObjectDelete("FIB18");ObjectDelete("FIB19");ObjectDelete("FIB20");
   ObjectDelete("FIB21");ObjectDelete("FIB22");ObjectDelete("FIB23");ObjectDelete("FIB24");
   ObjectDelete("FIB25");ObjectDelete("FIB26");ObjectDelete("FIB27");
   
   ObjectDelete("DHIGH");ObjectDelete("DLOW");
   
    DeleteCreatePivots1();
    DeleteCreatePivots(); 
    DeleteDollyGraphics();
    DeleteAvGraphics();
    DeleteCreateFibs(); 
    Comment("");
	//----
	return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{

   	//---- name for DataWindow and indicator subwindow label
	IndicatorShortName(IND_NAME);
	return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{ 
  
  if(Show_Dolly_Instructions==true){
    Comment("\n General Trading instructions for Dolly Graphics v12"
           +"\n -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
           +"\n Dolly is BreakOut trading system which uses either the DAILY OPEN or DAILY CENTRAL PIVOT as the Central starting point."
           +"\n" 
           +"\n Dolly gives the Trading Setups in the COMMENTS on the left side of the chart" 
           +"\n These COMMENTS can be either STATIC or DYNAMIC by selecting the Auto_Signals or Show_DollyCOMMENTS inputs "
           +"\n NOTE : Both types of COMMENTS STATIC & DYNAMIC can be moved to anywhere or you chart by using the Shift inputs "
           +"\n"
           +"\n -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
           +"\n TRADING : "
           +"\n NOTE : Breakout Trading is usually best at times such as the LONDON / NEW YORK / ASIAN OPENS"
           +"\n"
           +"\n When PRICE approaches a Dolly ENTRY LEVEL wait for the 5 Minute candle to CLOSE before making a trading decision  "
           +"\n Use your favourite indicators of TREND and STRENGTH of DIRECTION to help with these trades "
           +"\n A combination of H4 MACD & H1 MACD for the general TREND is commonly used with a M1 & M5 MACD & RSI 10 for ENTRIES"
           +"\n NEVER trade against the H1 MACD Trend, Recommended settings for MACD are 8 / 17 / 9 for a quicker response "
           +"\n"
           +"\n If H1 & H4 MACD are both ABOVE the CENTRE LEVEL and pointing UP only take LONG Trades"
           +"\n If H1 & H4 MACD are both BELOW the CENTRE LEVEL and pointing DOWN only take SHORT Trades"
           +"\n If HI is ABOVE the CENTRE LEVEL and pointing UP but the H4 is TURNED DOWN the PRICE may not run very far LONG   "
           +"\n If HI is BELOW the CENTRE LEVEL and pointing DOWN but the H4 is TURNED UP the PRICE may not run very far SHORT"
           +"\n NOTE : Generally if both TREND MACDs are pointing in the same direction the TRADES will go the  "
           +"\n DAILY AVERAGE DISTANCE or more for that day"
           +"\n If the TREND MACDs are against each other go with the H1 direction but expect about 60% of the DAILY AVERAGE DISTANCE"
           +"\n"
           +"\n FOR EXAMPLE : EURUSD H1 / H4 Both UP = Range 80 - 120 pips  -  GBPUSD  =  Range 120 -  200 pips"
           +"\n                          EURUSD H1 UP / H4 DN  or H1 DN / H4 UP  = Range 30  -  60 pips  -  GBPUSD = Range 80  -  100 pips"  
           +"\n ENTRIES : "
           +"\n Wait for the M5 RSI to swing DOWN from ABOVE the 70 Level and the M1 & M5 MACD to turn DOWN from ABOVE the Centre Level to go SHORT"
           +"\n Wait for the M5 RSI to swing UP from BELOW the 30 Level and the M1 & M5 MACD to turn UP from BELOW the Centre Level to go LONG  "
           +"\n Using these entries should give minimal losses if you pick the wrong trade and it goes against you as the MOMETUM for the" 
           +"\n M5 entry is going with you and so should the longer term TREND"
           +"\n"
           +"\n EXITS : "
           +"\n LONG Exit on the Dolly Levels  -   Enter at BUY AREA and exit at either the 1 st or 2nd BUY TARGET"
           +"\n SHORT Exit on the Dolly Levels  -   Enter at SELL AREA and exit at either the 1 st or 2nd SELL TARGET"
           +"\n DAILY AVERAGE EXITS : "
           +"\n The other option is to assess the STRENGTH of the move and use the Dolly AVERAGE ZONES 50% 75% 100% 125% 150% etc" 
           +"\n as an indication of how far the PRICE will move based on the H1 / H4 TREND information previously assessed."   
           +"\n"
           +"\n -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    
    } 
if(Show_Dolly_Instructions==true)return(0);

	int counted_bars = IndicatorCounted(); 
   CreateP();
}

void CreateP()
{
  
   DeleteCreatePivots1();  
   CreateDL();
}

void DeleteCreatePivots1()
{
   ObjectDelete(P1); 
   ObjectDelete(DHI); 
   ObjectDelete(DLO);
   ObjectDelete(DO);
}

void CreateDL()
{
   
   DeleteDollyGraphics();
   CreateAL();
}

void DeleteDollyGraphics()
{
   ObjectDelete(DollyBUY3);
   ObjectDelete(DollyBUY2);
   ObjectDelete(DollyBUY1);
   ObjectDelete(DollySELL1);
   ObjectDelete(DollySELL2);
   ObjectDelete(DollySELL3);
}

void CreateAL()
{
   
   DeleteAvGraphics();
   CreatePP();
}

void DeleteAvGraphics()
{
   ObjectDelete (AvBUY150);  ObjectDelete (AvBUY125);  ObjectDelete (AvBUY100); ObjectDelete (AvBUY75); 
   ObjectDelete (AvSELL75);  ObjectDelete (AvSELL100);  ObjectDelete (AvSELL125);  ObjectDelete (AvSELL150); 
}

void CreatePP()
{
  
   DeleteCreatePivots();
   CreateFIB();
}

void DeleteCreatePivots()
{
   ObjectDelete(PP1); ObjectDelete(RR3); ObjectDelete(RR2); ObjectDelete(RR1);
   ObjectDelete(SS1); ObjectDelete(SS2); ObjectDelete(SS3); ObjectDelete(P1);
    
   ObjectDelete(MM1); ObjectDelete(MM2); ObjectDelete(MM3);
   ObjectDelete(MM4); ObjectDelete(MM5); ObjectDelete(MM0);
   ObjectDelete(DDHI); ObjectDelete(DDLO);
}

void CreatePivots1(string Pivots1, double start, double end,double w, double s,color clr)
{
   ObjectCreate(Pivots1, OBJ_TREND, 0, iTime(NULL,1440,0)+GMTshift*3600, start, Time[0], end);
   ObjectSet(Pivots1, OBJPROP_COLOR, clr);
   ObjectSet(Pivots1,OBJPROP_RAY,false);
   ObjectSet(Pivots1,OBJPROP_BACK,true);
   ObjectSet(Pivots1,OBJPROP_WIDTH,w);
   ObjectSet(Pivots1,OBJPROP_STYLE,s);
}


void CreateDollyGraphics(string Dolly, double start, double end, color clr)
{
   ObjectCreate(Dolly, OBJ_RECTANGLE, 0, iTime(NULL,1440,0)+GMTshift*3600, start, Time[0], end);
   ObjectSet(Dolly, OBJPROP_COLOR, clr);
   ObjectSet(Dolly,OBJPROP_BACK,Dolly_GRAPHICS);
   ObjectSet(Dolly,OBJPROP_WIDTH,2);
   ObjectSet(Dolly,OBJPROP_STYLE,0);
}

void CreateAvGraphics(string DailyAv, double start, double end, color clr)
{
   ObjectCreate(DailyAv, OBJ_RECTANGLE, 0, iTime(NULL,1440,0)+GMTshift*3600, start, Time[0], end);
   ObjectSet(DailyAv, OBJPROP_COLOR, clr);
   ObjectSet(DailyAv,OBJPROP_BACK,Daily_AverageGRAPHICS);
   ObjectSet(DailyAv,OBJPROP_WIDTH,0);
   ObjectSet(DailyAv,OBJPROP_STYLE,0);
}

void CreatePivots(string Pivots, double start, double end,double w, double s,color clr)
{
   ObjectCreate(Pivots, OBJ_TREND, 0, iTime(NULL,1440,PivotPoint_ExtendLINE+0), start, Time[0], end);
   ObjectSet(Pivots, OBJPROP_COLOR, clr);
   ObjectSet(Pivots,OBJPROP_RAY,false);
   ObjectSet(Pivots,OBJPROP_WIDTH,w);
   ObjectSet(Pivots,OBJPROP_STYLE,s);
}

void CreateFibs(string FibLevels, double start, double end,double w, double s,color clr)
{
   ObjectCreate(FibLevels, OBJ_TREND, 0, iTime(NULL,1440,FIB_ExtendDISPLAY), start, Time[0], end);
   ObjectSet(FibLevels, OBJPROP_COLOR, clr);
   ObjectSet(FibLevels,OBJPROP_RAY,false);
   ObjectSet(FibLevels,OBJPROP_WIDTH,w);
   ObjectSet(FibLevels,OBJPROP_STYLE,s);
}

void DeleteCreateFibs()
{
    ObjectDelete(Fib100); ObjectDelete(Fib764); ObjectDelete(Fib618); ObjectDelete(Fib50);  
    ObjectDelete(Fib236); ObjectDelete(Fib0); ObjectDelete(Fib382);
    ObjectDelete(FibP100); ObjectDelete(FibP618); ObjectDelete(FibP50); ObjectDelete(FibP382); 
    ObjectDelete(FibM100); ObjectDelete(FibM618); ObjectDelete(FibM50); ObjectDelete(FibM382);
    ObjectDelete(FibP236); ObjectDelete(FibM236); ObjectDelete(FibP764); ObjectDelete(FibM764); 
    ObjectDelete(FibP150); ObjectDelete(FibM150); ObjectDelete(FibP200); ObjectDelete(FibM200);
    ObjectDelete(FibP250); ObjectDelete(FibM250); ObjectDelete(FibP300); ObjectDelete(FibM300);
} 

void CreateFIB()
{
    DeleteCreateFibs(); 

//---- Get new daily prices & calculate pivots
   double day_high=iHigh(NULL,1440,0);
   double day_low=iLow(NULL,1440,0);
   double yesterday_open=iOpen(NULL,1440,1);
   double today_open=iOpen(NULL,1440,0);
   
   double yesterday_high = iHigh(NULL,1440,1);
   double yesterday_low = iLow(NULL,1440,1);
   double yesterday_close = iClose(NULL,1440,1);
   
   cur_day=0;
   prev_day=0;
   
   int cnt=720;//720

   while (cnt!= 0)
   {
	  if (TimeDayOfWeek(Time[cnt]) == 0)
	  {
        cur_day = prev_day;
	  }
	  else
	  {
        cur_day = TimeDay(Time[cnt]-(GMTshift*3600));
	  }
	
  	  if (prev_day != cur_day)
	  {
		 yesterday_close = Close[cnt+1];
		 today_open = Open[cnt];
		 yesterday_high = iHigh(NULL,1440,1);
		 yesterday_low = iLow(NULL,1440,1);

		 day_high = High[cnt];
		 day_low  = Low[cnt];

		 prev_day = cur_day;
	  }
   
     if (High[cnt]>day_high)
     {
       day_high = High[cnt];
     }
   
     if (Low[cnt]<day_low)
     {
       day_low = Low[cnt];
     }
	
	  cnt--;

  }
  
  double P = (yesterday_high + yesterday_low + yesterday_close)/3;//Pivot
  

    //Pivots & M Pivots
    double r3 = ( 2 * P ) + ( yesterday_high - ( 2 * yesterday_low ));
    double r2 = P + ( yesterday_high - yesterday_low );
    double r1 = ( 2 * P ) - yesterday_low;
    double s1 = ( 2 * P ) - yesterday_high;
    double s2 = P - ( yesterday_high- yesterday_low);
    double s3 = ( 2 * P ) - ( ( 2 * yesterday_high ) - yesterday_low );
         
    double m0 = (s2 + s3)/2;
    double m1 = (s1 + s2)/2;
    double m2 = (P + s1)/2;
    double m3 = (P + r1)/2; 
    double m4 = (r1 + r2)/2;
    double m5 = (r2 + r3)/2; 
          
    double OPEN = today_open; 
    double HI2 = iHigh(NULL,1440,0);
    double LOW2 = iLow(NULL,1440,0); 
    double HI3 = yesterday_high;
    double LOW3 = yesterday_low;
  
  // Daily Average code
    
   int R1=0,R5=0,R10=0,R20=0,RAvg=0;
   
   int i=0;

   R1 =  (iHigh(NULL,1440,1)-iLow(NULL,1440,1))/Point;
   for(i=1;i<=5;i++)
      R5    =    R5  +  (iHigh(NULL,1440,i)-iLow(NULL,1440,i))/Point;
   for(i=1;i<=10;i++)
      R10   =    R10 +  (iHigh(NULL,1440,i)-iLow(NULL,1440,i))/Point;
   for(i=1;i<=20;i++)
      R20   =    R20 +  (iHigh(NULL,1440,i)-iLow(NULL,1440,i))/Point;

   R5 = R5/5;
   R10 = R10/10;
   R20 = R20/20;
   double AV  =  (R1+R5+R10+R20)/4;    
  
    //Add for Open Graphics - hymns
    double DollyOpenGraphics;
        
    if (Using_OpenGraphics == true) { DollyOpenGraphics = OPEN; }
    else { DollyOpenGraphics = P; }
    
    //Tweak for Open Graphics - hymns   
    double AvDN150 = DollyOpenGraphics-AV/2*3*Point;
    double AvUP150 = DollyOpenGraphics+AV/2*3*Point;
    double AvDN125 = DollyOpenGraphics-AV/4*5*Point;
    double AvUP125 = DollyOpenGraphics+AV/4*5*Point;
    double AvDN100 = DollyOpenGraphics-AV*Point; 
    double AvUP100 = DollyOpenGraphics+AV*Point;
    double AvDN75 = DollyOpenGraphics-AV/4*3*Point; 
    double AvUP75 = DollyOpenGraphics+AV/4*3*Point;  
    double AvDN50 = DollyOpenGraphics-AV/2*Point;
    double AvUP50 = DollyOpenGraphics+AV/2*Point;
    double AvDN25 = DollyOpenGraphics-AV/4*Point; 
    double AvUP25 = DollyOpenGraphics+AV/4*Point; 
  
    double CLOSE = iClose(NULL,1440,0); 
   
         
    double F;      
    F = (yesterday_high-yesterday_low);
   
    double FIBP300 =  yesterday_low + F*4.00;
    double FIBP250 =  yesterday_low + F*3.5;
    double FIBP200 =  yesterday_low + F*3.00;
    double FIBP150 =  yesterday_low + F*2.5;
    double FIBP100 =  yesterday_low + F*2.00;
    double FIBP764 = yesterday_low + F*1.764;
    double FIBP618 =  yesterday_low + F*1.618;
    double FIBP50 = yesterday_low + F*1.5;
    double FIBP382 =  yesterday_low + F*1.382;
    double FIBP236 = yesterday_low + F*1.236;
    double FIB100 =  yesterday_high;
    double FIB764 = yesterday_low + F*0.764;
    double FIB618 =  yesterday_low + F*0.618;
    double FIB50 = yesterday_low + F*0.5;
    double FIB382 =  yesterday_low + F*0.382;
    double FIB236 = yesterday_low + F*0.236;
    double FIB0 = yesterday_low + F*0.0;
    double FIBM236 = yesterday_low - F*0.236;
    double FIBM382 =  yesterday_low - F*0.382;
    double FIBM50 = yesterday_low - F*0.5;
    double FIBM618 =  yesterday_low - F*0.618;
    double FIBM764 = yesterday_low  - F*0.764;
    double FIBM100 =  yesterday_low - F*1.00; 
    double FIBM150 =  yesterday_low - F*1.5; 
    double FIBM200 =  yesterday_low - F*2.00; 
    double FIBM250 =  yesterday_low - F*2.5; 
    double FIBM300 =  yesterday_low - F*3.00; 
    
    //Tweak for Open Graphics - hymns  
    double B1 = DollyOpenGraphics + BUY_Area * Point; // Logic to determine Buy Area 
    double S1 = DollyOpenGraphics - SELL_Area * Point; // Logic to determine Sell Area 
    double B2 = DollyOpenGraphics + BUY_Target_1 * Point; // Logic to determine High Break Area 
    double S2 = DollyOpenGraphics - SELL_Target_1 * Point; // Logic to determine Low Break Area )
    double B3 = DollyOpenGraphics + BUY_Target_2 * Point; // Logic to determine High Target Area 
    double S3 = DollyOpenGraphics - SELL_Target_2 * Point; // Logic to determine Low Target Area 
    
    ObjectsRedraw();
    
    
        if (Alert_ON ==true) 
       {
     if(Ask>(B1-2*Point)&&Ask<(B1+2*Point)){if (DataBarChanged()){ Alert(Symbol()," M",Period()," : DOLLY : BUY AREA  @  "+(DoubleToStr (B1,Digits))+"");}}
     if(Bid<(S1+2*Point)&&Bid>(S1-2*Point)){if (DataBarChanged()){ Alert(Symbol()," M",Period()," : DOLLY : SELL AREA  @  "+(DoubleToStr (S1,Digits))+"" );}}
     if(Ask>(B2-2*Point)&&Ask<(B2+2*Point)){if (DataBarChanged()){ Alert(Symbol()," M",Period()," : DOLLY : BUY TARGET #1  @  "+(DoubleToStr (B2,Digits))+"" );}}
     if(Bid<(S2+2*Point)&&Bid>(S2-2*Point)){if (DataBarChanged()){ Alert(Symbol()," M",Period()," : DOLLY : SELL TARGET #1  @  "+(DoubleToStr (S2,Digits))+"" );}}
     if(Ask>(B3-2*Point)&&Ask<(B3+2*Point)){if (DataBarChanged()){ Alert(Symbol()," M",Period()," : DOLLY : BUY TARGET #2  @  "+(DoubleToStr (B3,Digits))+"" );}}
     if(Bid<(S3+2*Point)&&Bid>(S3-2*Point)){if (DataBarChanged()){ Alert(Symbol()," M",Period()," : DOLLY : SELL TARGET #2  @  "+(DoubleToStr (S3,Digits))+"" );}}
     }
     
   if(TimeToStr(TimeLocal(),TIME_MINUTES)==DATA_EmailTime){   if (DataBarChanged())
     {
     if (Email_DATA==true)SendMail("DOLLY Daily Trading Levels : "+Symbol()+"", 
     "DOLLY Daily Trading Levels : "+"\n"+Symbol()+"\n"+"Date = "+TimeToStr(TimeLocal(),TIME_DATE)+"\n"
     +"GMT Shift = "+GMTshift+"\n"
     
     +"---------------------------------------------------------------"+"\n"+"\n"
                   
    
     +"BUY TARGET #2  @  "+DoubleToStr (B3,Digits)+""
                                             +" - TP @ "+DoubleToStr(B3+10*Point,Digits)+""                                                  
                                             +" - SL @ "+DoubleToStr(B3-20*Point,Digits)+"\n" 
     +"BUY TARGET #1  @  "+DoubleToStr (B2,Digits)+""
                                             +" - TP @ "+DoubleToStr(B2+10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(B2-20*Point,Digits)+"\n" 
     +"BUY AREA  @  "+DoubleToStr (B1,Digits)+""
                                             +" - TP @ "+DoubleToStr(B1+20*Point,Digits)+""                  
                                             +" - SL @ "+DoubleToStr(B1-40*Point,Digits)+"\n"
                                             
      +"\n"+"OPEN @  "+DoubleToStr (OPEN,Digits)+"\n"  
      +"\n"+"PIVOT @  "+DoubleToStr (P,Digits)+"\n"                                                                             
                                            
     +"\n"+"SELL AREA  @  "+DoubleToStr (S1,Digits)+""
                                             +" - TP @ "+DoubleToStr(S1-20*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(S1+40*Point,Digits)+"\n"
     +"SELL TARGET #1  @  "+DoubleToStr (S2,Digits)+""
                                             +" - TP @ "+DoubleToStr(S2-10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(S2+20*Point,Digits)+"\n"                                           
     +"SELL TARGET #2  @  "+DoubleToStr (S3,Digits)+""
                                             +" - TP @ "+DoubleToStr(S3-10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(S3+20*Point,Digits)+"\n"
                                             
      +"\n"+"DAILY AVERAGE  @  "+DoubleToStr (AV/Point,0)+"\n" );}}                                          
                                                                                 
                                                
       
      if(Ask>(B1-10*Point)&&Ask<(B1+0*Point)){  if (BarChanged())
    { 
    if (EmailON==true)SendMail("Dolly BUY AREA Alert : "+Symbol()+" M"+Period()+" @  "+DoubleToStr (B1,Digits)+"",
    "Price is approaching : DOLLY : BUY AREA  @  "+DoubleToStr (B1,Digits)+""
                                              +" - TP @ "+DoubleToStr(B1+20*Point,Digits)+""
                                              +" - SL @ "+DoubleToStr(B1-40*Point,Digits)+"");
                                              }}  
     
    if(Ask>(B2-5*Point)&&Ask<(B2+0*Point)){   if (BarChanged())
    {        
    if (EmailON==true)SendMail("Dolly BUY TARGET #1  Alert : "+Symbol()+" M"+Period()+" @  "+DoubleToStr (B2,Digits)+"",
    "Price is approaching : DOLLY : BUY TARGET #1  @  "+DoubleToStr (B2,Digits)+""
                                             +" - TP @ "+DoubleToStr(B2+10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(B2-20*Point,Digits)+"");
                                             }}  
                                             
    if(Ask>(B3-5*Point)&&Ask<(B3+0*Point)){     if (BarChanged())
    {         
    if (EmailON==true)SendMail("Dolly BUY TARGET #2 Alert : "+Symbol()+" M"+Period()+" @  "+DoubleToStr (B3,Digits)+"",
    "Price is approaching : DOLLY : BUY TARGET #2  @  "+DoubleToStr (B3,Digits)+""
                                            +" - TP @ "+DoubleToStr(B3+10*Point,Digits)+""                                                  
                                            +" - SL @ "+DoubleToStr(B3-20*Point,Digits)+"");
                                            }} 
             
        
    if(Bid<(S1+5*Point)&&Bid>(S1-0*Point)){ if (BarChanged())
    { 
    if (EmailON==true)SendMail("Dolly SELL AREA Alert : "+Symbol()+" M"+Period()+" @  "+DoubleToStr (S1,Digits)+"",
    "Price is approaching : DOLLY : SELL AREA  @  "+DoubleToStr (S1,Digits)+""
                                               +" - TP @ "+DoubleToStr(S1-20*Point,Digits)+""
                                               +" - SL @ "+DoubleToStr(S1+40*Point,Digits)+"");
                                               }}
                                                  
    if(Bid<(S2+5*Point)&&Bid>(S2-0*Point)){ if (BarChanged())
    {    
    if (EmailON==true)SendMail("Dolly SELL TARGET #1  Alert : "+Symbol()+" M"+Period()+" @  "+DoubleToStr (S2,Digits)+"",
    "Price is approaching : DOLLY : SELL TARGET #1  @  "+DoubleToStr (S2,Digits)+""
                                              +" - TP @ "+DoubleToStr(S2-10*Point,Digits)+""
                                              +" - SL @ "+DoubleToStr(S2+20*Point,Digits)+"");
                                              }}
                                                
    if(Bid<(S3+5*Point)&&Bid>(S3-0*Point)){ if (BarChanged())
    {             
    if (EmailON==true)SendMail("Dolly SELL TARGET #2 Alert : "+Symbol()+" M"+Period()+" @  "+DoubleToStr (S3,Digits)+"",
    "Price is approaching : DOLLY : SELL TARGET #2  @  "+DoubleToStr (S3,Digits)+""
                                              +" - TP @ "+DoubleToStr(S3-10*Point,Digits)+""
                                              +" - SL @ "+DoubleToStr(S3+20*Point,Digits)+"");
                                              }}        
    
     
     string Signal="",Signal2=""; color Dolly_col,Dolly_col2;
      if ( Show_DollyCOMMENTS == true )
   { 
   if ( Auto_Signals == true )
   {  
   
    if (Using_OpenGraphics == true)
   {
   Signal = "Currently Signals Pending ................................."; Dolly_col =   C'250,250,0';
   if(Ask>(B1-3*Point)&&Ask<(B1+3*Point)){Signal = "OPEN + ["+BUY_Area+"] @ "+DoubleToStr(B1,Digits)+""
                                              +" - TP @ "+DoubleToStr(B1+20*Point,Digits)+""
                                              +" - SL @ "+DoubleToStr(B1-40*Point,Digits)+"";
                                              Dolly_col = C'0,250,250';
                                             }
   if(Ask>(B2-3*Point)&&Ask<(B2+3*Point)){Signal = "BUY Stop : OPEN + ["+BUY_Target_1+"] @ "+DoubleToStr(B2,Digits)+""
                                             +" - TP @ "+DoubleToStr(B2+10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(B2-20*Point,Digits)+"";
                                             Dolly_col =  C'0,250,250';
                                            }
   if(Ask>(B3-3*Point)&&Ask<(B3+3*Point)){Signal = "BUY Stop : OPEN + ["+BUY_Target_2 +"] @ "+DoubleToStr(B3,Digits)+""
                                             +" - TP @ "+DoubleToStr(B3+10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(B3-20*Point,Digits)+"";
                                             Dolly_col =C'0,250,250' ;
                                            }                      
   if(Ask>(AvUP100-3*Point)&&Ask<(AvUP100+3*Point)){Signal = "Caution approaching Daily Average Range @ "+DoubleToStr(AvUP100,Digits)+"";
                                                                                          Dolly_col = YellowGreen;
                                            }   
   if(Bid>(AvDN100+3*Point)&&Bid<(AvDN100-3*Point)){Signal = "Caution approaching Daily Average Range @ "+DoubleToStr(AvDN100,Digits)+"";
                                                                                          Dolly_col = YellowGreen;
                                            }                                                                                                                        
   
   if(Bid<(S1+3*Point)&&Bid>(S1-3*Point)){Signal = "OPEN - ["+SELL_Area+"] @ "+DoubleToStr(S1,Digits)+""
                                              +" - TP @ "+DoubleToStr(S1-20*Point,Digits)+""
                                              +" - SL @ "+DoubleToStr(S1+40*Point,Digits)+"";
                                              Dolly_col =  C'250,150,0';
                                             }
   if(Bid<(S2+3*Point)&&Bid>(S2-3*Point)){Signal = "SELL Stop : OPEN - ["+SELL_Target_1+"] @ "+DoubleToStr(S2,Digits)+""
                                             +" - TP @ "+DoubleToStr(S2-10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(S2+20*Point,Digits)+"";
                                             Dolly_col =  C'250,150,0';
                                            }
   if(Bid<(S3+3*Point)&&Bid>(S3-3*Point)){Signal = "SELL Stop : OPEN - ["+SELL_Target_2+"] @ "+DoubleToStr(S3,Digits)+""
                                             +" - TP @ "+DoubleToStr(S3-10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(S3+20*Point,Digits)+"";
                                             Dolly_col = C'250,150,0';
                                            }                                         
   if(Bid<(P+3*Point)&&Bid>(P-3*Point)){Signal = "Caution possible reversal  PIVOT @ "+DoubleToStr(P,Digits)+"";
                                                                                          Dolly_col = White;
                                                                                          }
   if(Bid<(OPEN+2*Point)&&Bid>(OPEN-2*Point)){Signal = "Caution possible reversal  OPEN @ "+DoubleToStr(OPEN,Digits)+"";
                                                                                          Dolly_col = White;                                                                                       
                                            }  
   if((Bid>S1)&& (Bid<B1)){Signal2 = "Price Currently between BUY & SELL ZONES";  
                                              Dolly_col2 =  C'280,230,0';
                                             }
                                              
   if((Bid<=S1)&& (Bid>S2)){Signal2 = "Price Currently in SELL ZONE #1";  
                                              Dolly_col2 =  C'250,50,0';
                                             }  
                                               
   if((Bid<=S2)&& (Bid>S3)){Signal2 = "Price Currently in SELL ZONE #2";  
                                              Dolly_col2 =  C'250,90,0';
                                             } 
   if((Bid>=B1)&& (Bid<B2)){Signal2 = "Price Currently in BUY ZONE #1";  
                                              Dolly_col2 =  C'0,120,250';
                                             }  
                                               
   if((Bid>=B2)&& (Bid<B3)){Signal2 = "Price Currently in BUY ZONE #2";  
                                              Dolly_col2 =   C'0,180,250';
                                             }  
   if((Bid>=B3)&& (Bid<AvUP100)){Signal2 = "Price Currently Between BUY ZONE #2 & 100% D/AV";  
                                              Dolly_col2 = C'120,250,250';
                                             } 
   if((Bid<=S3)&& (Bid>AvDN100)){Signal2 = "Price Currently Between SELL ZONE #2 & 100% D/AV";  
                                              Dolly_col2 =  C'220,250,0';//
                                             }                                                                                                                                                                                                                                    
                                            } 
    if (Using_OpenGraphics == false)
   {
   Signal = "Currently Signals Pending ................................."; Dolly_col =  C'250,250,0';
   if(Ask>(B1-3*Point)&&Ask<(B1+3*Point)){Signal = "PIVOT + ["+BUY_Area+"] @ "+DoubleToStr(B1,Digits)+""
                                              +" - TP @ "+DoubleToStr(B1+20*Point,Digits)+""
                                              +" - SL @ "+DoubleToStr(B1-40*Point,Digits)+"";
                                              Dolly_col = C'0,250,250';
                                             }
   
   if(Ask>(B2-3*Point)&&Ask<(B2+3*Point)){Signal = "BUY Stop : PIVOT + ["+BUY_Target_1+"] @ "+DoubleToStr(B2,Digits)+""
                                             +" - TP @ "+DoubleToStr(B2+10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(B2-20*Point,Digits)+"";
                                             Dolly_col =  C'0,250,250';
                                            }
   if(Ask>(B3-3*Point)&&Ask<(B3+3*Point)){Signal = "BUY Stop : PIVOT + ["+BUY_Target_2 +"] @ "+DoubleToStr(B3,Digits)+""
                                             +" - TP @ "+DoubleToStr(B3+10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(B3-20*Point,Digits)+"";
                                             Dolly_col =C'0,250,250' ;
                                            }                      
   if(Ask>(AvUP100-3*Point)&&Ask<(AvUP100+3*Point)){Signal = "Caution approaching Daily Average Range @ "+DoubleToStr(AvUP100,Digits)+"";
                                                                                          Dolly_col = YellowGreen;
                                            }   
   if(Bid>(AvDN100+3*Point)&&Bid<(AvDN100-3*Point)){Signal = "Caution approaching Daily Average Range @ "+DoubleToStr(AvDN100,Digits)+"";
                                                                                          Dolly_col = YellowGreen;
                                            }                                                                            
   
   if(Bid<(S1+3*Point)&&Bid>(S1-3*Point)){Signal = "PIVOT - ["+SELL_Area+"] @ "+DoubleToStr(S1,Digits)+""
                                              +" - TP @ "+DoubleToStr(S1-20*Point,Digits)+""
                                              +" - SL @ "+DoubleToStr(S1+40*Point,Digits)+"";
                                              Dolly_col = C'250,150,0';
                                             }
   
   if(Bid<(S2+3*Point)&&Bid>(S2-3*Point)){Signal = "SELL Stop : PIVOT - ["+SELL_Target_1+"] @ "+DoubleToStr(S2,Digits)+""
                                             +" - TP @ "+DoubleToStr(S2-10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(S2+20*Point,Digits)+"";
                                             Dolly_col =  C'250,150,0';
                                            }
   if(Bid<(S3+3*Point)&&Bid>(S3-3*Point)){Signal = "SELL Stop : PIVOT - ["+SELL_Target_2+"] @ "+DoubleToStr(S3,Digits)+""
                                             +" - TP @ "+DoubleToStr(S3-10*Point,Digits)+""
                                             +" - SL @ "+DoubleToStr(S3+20*Point,Digits)+"";
                                             Dolly_col = C'250,150,0';
                                             }
 if(Bid<(P+3*Point)&&Bid>(P-3*Point)){Signal = "Caution possible reversal  PIVOT @ "+DoubleToStr(P,Digits)+"";
                                                                                          Dolly_col = White;
                                                                                          }
   if(Bid<(OPEN+2*Point)&&Bid>(OPEN-2*Point)){Signal = "Caution possible reversal  OPEN @ "+DoubleToStr(OPEN,Digits)+"";
                                                                                          Dolly_col = White;                                                                                       
                                            }  
   if((Bid>S1)&& (Bid<B1)){Signal2 = "Price Currently between BUY & SELL ZONES";  
                                              Dolly_col2 =  C'280,230,0';
                                             }
                                              
   if((Bid<=S1)&& (Bid>S2)){Signal2 = "Price Currently in SELL ZONE #1";  
                                              Dolly_col2 =  C'250,50,0';
                                             }  
                                               
   if((Bid<=S2)&& (Bid>S3)){Signal2 = "Price Currently in SELL ZONE #2";  
                                              Dolly_col2 =  C'250,90,0';
                                             } 
   if((Bid>=B1)&& (Bid<B2)){Signal2 = "Price Currently in BUY ZONE #1";  
                                              Dolly_col2 =  C'0,120,250';
                                             }  
                                               
   if((Bid>=B2)&& (Bid<B3)){Signal2 = "Price Currently in BUY ZONE #2";  
                                              Dolly_col2 =   C'0,180,250';
                                             }  
   if((Bid>=B3)&& (Bid<AvUP100)){Signal2 = "Price Currently Between BUY ZONE #2 & 100% D/AV";  
                                              Dolly_col2 = C'120,250,250';
                                             } 
   if((Bid<=S3)&& (Bid>AvDN100)){Signal2 = "Price Currently Between SELL ZONE #2 & 100% D/AV";  
                                              Dolly_col2 =  C'220,250,0';//
                                             }                                                                                                                                                                                                                                    
                                            }                                     
                                                                                        
  //{Signal = "Waiting..."; col = Orange;}
   ObjectDelete("Signal");                                         
   ObjectCreate("Signal", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Signal", Signal, 11,"Arial Bold", Dolly_col);
   ObjectSet("Signal", OBJPROP_CORNER, 0);
   ObjectSet("Signal", OBJPROP_XDISTANCE, 20+Shift_DollyCOMMENTS_SIDEWAYS);
   ObjectSet("Signal", OBJPROP_YDISTANCE, 65+Shift_DollyCOMMENTS_UP_DN);
   
   ObjectDelete("Signal2");                                         
   ObjectCreate("Signal2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Signal2", Signal2, 11,"Arial Bold", Dolly_col2);
   ObjectSet("Signal2", OBJPROP_CORNER, 0);
   ObjectSet("Signal2", OBJPROP_XDISTANCE, 20+Shift_DollyCOMMENTS_SIDEWAYS);
   ObjectSet("Signal2", OBJPROP_YDISTANCE, 85+Shift_DollyCOMMENTS_UP_DN);
   
   // Signal = "Currently Signals Pending ................................."; col = Yellow;
   
   ObjectDelete("Signal1");                                           
   ObjectCreate("Signal1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Signal1","Signal Auto Display", 9, "Arial", Silver);
   ObjectSet("Signal1", OBJPROP_CORNER, 4);
   ObjectSet("Signal1", OBJPROP_XDISTANCE, 20+Shift_DollyCOMMENTS_SIDEWAYS);
   ObjectSet("Signal1", OBJPROP_YDISTANCE, 47+Shift_DollyCOMMENTS_UP_DN);
   }}
 
 
    // Dolly Colored Levels
    CreateDollyGraphics(DollyBUY3, B3, B3, C'0,0,210' );
    CreateDollyGraphics(DollyBUY2, B2, B3,BUY_Color_2); //C'0,0,150'
    CreateDollyGraphics(DollyBUY1, B1, B2,BUY_Color_1 ); //C'0,0,100'
    CreateDollyGraphics(DollySELL1, S1, S2,SELL_Color_1 ); //C'120,0,0'
    CreateDollyGraphics(DollySELL2, S2, S3,SELL_Color_2 ); //C'180,0,0'
    CreateDollyGraphics(DollySELL3, S3, S3, C'230,0,0');
 
    //Daily Average Colored Levels   
    if (Show_DailyAverageGRAPHICS==true)
    {
      CreateAvGraphics(AvBUY150,AvUP150,AvUP125, DAILY_Av_UP_Color_150 ); // C'0,110,255'
      CreateAvGraphics(AvBUY125,AvUP125,AvUP100, DAILY_Av_UP_Color_125); //C'0,70,255'
      CreateAvGraphics(AvBUY100,AvUP100,AvUP75,DAILY_Av_UP_Color_100); //C'20,20,255'
      CreateAvGraphics(AvBUY75,AvUP75,B3,DAILY_Av_UP_Color_75 ); //C'0,0,210'
      CreateAvGraphics(AvSELL75,AvDN75,S3,DAILY_Av_DN_Color_75 ); //C'220,0,0'
      CreateAvGraphics(AvSELL100,AvDN100,AvDN75,DAILY_Av_DN_Color_100); // C'255,0,0'
      CreateAvGraphics(AvSELL125,AvDN100,AvDN125,DAILY_Av_DN_Color_125); //C'255,70,0'
      CreateAvGraphics(AvSELL150,AvDN125,AvDN150,DAILY_Av_DN_Color_150); // C'255,110,0'
    }
    
    //Create Pivot Line   
    CreatePivots1(P1,P,P,2,0, DimGray);
  
    
    //Show Pivot Support & Resistance Lines
    if (Show_PivotLines==true)
    {      
       CreatePivots(PP1,P,P,2,1, Gray);
       CreatePivots(RR3,r3,r3,1,0, Gray);
       CreatePivots(RR2,r2,r2,1,0, Gray);
       CreatePivots(RR1,r1,r1,1,0, Gray);
       CreatePivots(SS1,s1,s1,1,0, Gray);
       CreatePivots(SS2,s2,s2,1,0, Gray);
       CreatePivots(SS3,s3,s3,1,0, Gray);
    }
    
    //Show Middle Pivot Lines
    if (Show_M_PivotLines==true)
    {     
       CreatePivots(MM5,m5,m5,1,2, Gray);
       CreatePivots(MM4,m4,m4,1,2, Gray);
       CreatePivots(MM3,m3,m3,1,2, Gray);
       CreatePivots(MM2,m2,m2,1,2, Gray);
       CreatePivots(MM1,m1,m1,1,2, Gray);
       CreatePivots(MM0,m0,m0,1,2, Gray);
    }
    
    //Show Fibo Lines     
    if (Show_FibLines==true)
    { 
       CreateFibs(FibP100, FIBP100, FIBP100,1,0,Green );
       CreateFibs(FibP764, FIBP764, FIBP764,1,0, C'0,53,0' );
       CreateFibs(FibP618, FIBP618, FIBP618,1,0, Green);
       CreateFibs(FibP50, FIBP50, FIBP50,1,0, C'0,53,0' );
       CreateFibs(FibP382, FIBP382, FIBP382,1,0, Green );
       CreateFibs(FibP236, FIBP236, FIBP236,1,0, C'0,53,0' ); 
      
              
       CreateFibs(Fib100, FIB100, FIB100,1,0,  C'0,200,0');
       CreateFibs(Fib764, FIB764, FIB764,1,0, C'0,53,0' );
       CreateFibs(Fib618, FIB618, FIB618,1,0, Green );
       CreateFibs(Fib50, FIB50, FIB50,1,0, C'0,53,0' );
       CreateFibs(Fib382, FIB382, FIB382,1,0, Green );
       CreateFibs(Fib236, FIB236, FIB236,1,0, C'0,53,0' );
       CreateFibs(Fib0, FIB0, FIB0,1,0,  C'0,200,0' );
       
       
       
       CreateFibs(FibM236, FIBM236, FIBM236,1,0, C'0,53,0' );
       CreateFibs(FibM382, FIBM382, FIBM382,1,0, Green );
       CreateFibs(FibM50, FIBM50, FIBM50,1,0, C'0,53,0' );
       CreateFibs(FibM618, FIBM618, FIBM618,1,0, Green );
       CreateFibs(FibM764, FIBM764, FIBM764,1,0,C'0,53,0');
       CreateFibs(FibM100, FIBM100, FIBM100,1,0, Green );
    }
    
    //Show Extra Fibo Lines
    if (Show_EXTRAFibLines==true)
    {
       CreateFibs(FibP300, FIBP300, FIBP300,1,0, Green );
       CreateFibs(FibP250, FIBP250, FIBP250,1,0, Green );   
       CreateFibs(FibP200, FIBP200, FIBP200,1,0, Green );
       CreateFibs(FibP150, FIBP150, FIBP150,1,0, Green );      
  
  
       CreateFibs(FibM150, FIBM150, FIBM150,1,0, Green );
       CreateFibs(FibM200, FIBM200, FIBM200,1,0, Green );
       CreateFibs(FibM250, FIBM250, FIBM250,1,0, Green );
       CreateFibs(FibM300, FIBM300, FIBM300,1,0, Green );
    }
    
    //Show Daily HI-LOW
    if (Show_Daily_HI_LOW==true)
    {
       CreatePivots1(DHI,HI3,HI3,2,0, Turquoise);
       CreatePivots1(DLO,LOW3,LOW3,2,0, Turquoise);
       CreatePivots(DDHI,HI3,HI3,2,0, Turquoise);
       CreatePivots(DDLO,LOW3,LOW3,2,0, Turquoise);
    }
    
    //Show Daily Open
    if (Show_Daily_OPEN==true || Using_OpenGraphics == true) //Tweak for Open Graphics - hymns
    {
       CreatePivots1(DO,OPEN,OPEN,2,0, YellowGreen);
    }

    //Buy
    ObjectDelete("B1");	  
    if(ObjectFind("B1") != 0) 
    {  ObjectCreate("B1", OBJ_TEXT, 0, Time[SHIFT_DollyText], B1);
       ObjectSetText("B1", "                        BUY AREA", 8, "Arial",DodgerBlue);
       ObjectSet("B1",OBJPROP_BACK,true); } else{
       ObjectMove("B1", 0, Time[SHIFT_DollyText], B1);
    }
     ObjectDelete("B2");
    if(ObjectFind("B2") != 0)
    {  ObjectCreate("B2", OBJ_TEXT, 0, Time[SHIFT_DollyText], B2);
       ObjectSetText("B2", "                                   1st BUY TARGET ", 8, "Arial",DodgerBlue);
       ObjectSet("B2",OBJPROP_BACK,true); } else{
       ObjectMove("B2", 0, Time[SHIFT_DollyText],B2);
    }   
     ObjectDelete("B3");
    if(ObjectFind("B3") != 0)
    {   ObjectCreate("B3", OBJ_TEXT, 0, Time[SHIFT_DollyText], B3);
       ObjectSetText("B3", "                             2nd TARGET ", 8, "Arial",DodgerBlue);
       ObjectSet("B3",OBJPROP_BACK,true); } else{
       ObjectMove("B3", 0, Time[SHIFT_DollyText], B3);   
    }
    
    //Sell
    ObjectDelete("S1");
    if(ObjectFind("S1") != 0)
    {  ObjectCreate("S1", OBJ_TEXT, 0, Time[SHIFT_DollyText],S1);
       ObjectSetText("S1", "                         SELL AREA", 8, "Arial", Orange);
       ObjectSet("S1",OBJPROP_BACK,true); } else{
       ObjectMove("S1", 0, Time[SHIFT_DollyText], S1);
    }     
    ObjectDelete("S2");
    if(ObjectFind("S2") != 0)
    {  ObjectCreate("S2", OBJ_TEXT, 0, Time[SHIFT_DollyText], S2);
       ObjectSetText("S2", "                                   1st SELL TARGET ", 8, "Arial",Orange);
       ObjectSet("S2",OBJPROP_BACK,true); } else{
       ObjectMove("S2", 0, Time[SHIFT_DollyText], S2);
    }
     ObjectDelete("S3");
    if(ObjectFind("S3") != 0)
    {  ObjectCreate("S3", OBJ_TEXT, 0, Time[SHIFT_DollyText], S3);
       ObjectSetText("S3", "                             2nd TARGET ", 8, "Arial",Orange);
       ObjectSet("S3",OBJPROP_BACK,true); } else{
       ObjectMove("S3", 0, Time[SHIFT_DollyText], S3);
    }
	
    //Pivot
     ObjectDelete("Pivot");
    if(ObjectFind("Pivot") != 0)
    {  ObjectCreate("Pivot", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], P);
       ObjectSetText("Pivot", "                             PIVOT "+ DoubleToStr(P,Digits)+"", 8, "Arial",Silver);
       ObjectSet("Pivot",OBJPROP_BACK,true); } else{
       ObjectMove("Pivot", 0, Time[SHIFT_PivotPointText], P);
    }
    
    //Average Levels
    if (Show_DailyAverageGRAPHICS==true)
    {
        ObjectDelete("TOP/AV150");
       if(ObjectFind("TOP/AV150") != 0)
       {  ObjectCreate("TOP/AV150", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP150);
          ObjectSetText("TOP/AV150", "                                    150% ", 8, "Arial", DeepSkyBlue);
          ObjectSet("TOP/AV150",OBJPROP_BACK,true); } else{
          ObjectMove("TOP/AV150", 0, Time[SHIFT_DailyAverageText], AvUP150);
       }
          ObjectDelete("LOW/AV150");
       if(ObjectFind("LOW/AV150") != 0)
       {  ObjectCreate("LOW/AV150", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN150);
          ObjectSetText("LOW/AV150", "                                    150% ", 8, "Arial", Yellow);
          ObjectSet("LOW/AV150",OBJPROP_BACK,true); } else{
          ObjectMove("LOW/AV150", 0, Time[SHIFT_DailyAverageText], AvDN150);
       } 
       ObjectDelete("TOP/AV125");
       if(ObjectFind("TOP/AV125") != 0)
       {  ObjectCreate("TOP/AV125", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP125);
          ObjectSetText("TOP/AV125", "                                    125% ", 8, "Arial", DeepSkyBlue);
          ObjectSet("TOP/AV125",OBJPROP_BACK,true); } else{
          ObjectMove("TOP/AV125", 0, Time[SHIFT_DailyAverageText], AvUP125);
       }
       ObjectDelete("LOW/AV125");
       if(ObjectFind("LOW/AV125") != 0)
       {  ObjectCreate("LOW/AV125", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN125);
          ObjectSetText("LOW/AV125", "                                    125% ", 8, "Arial", Yellow);
          ObjectSet("LOW/AV125",OBJPROP_BACK,true); } else{
          ObjectMove("LOW/AV125", 0, Time[SHIFT_DailyAverageText], AvDN125);
       }
       ObjectDelete("TOP/AV100"); 
       if(ObjectFind("TOP/AV100") != 0)
       {  ObjectCreate("TOP/AV100", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP100);
          ObjectSetText("TOP/AV100", "                                   100%", 8, "Arial", DeepSkyBlue);
          ObjectSet("TOP/AV100",OBJPROP_BACK,true); } else{
          ObjectMove("TOP/AV100", 0, Time[SHIFT_DailyAverageText], AvUP100);
       }
       ObjectDelete("LOW/AV100");
       if(ObjectFind("LOW/AV100") != 0)
       {  ObjectCreate("LOW/AV100", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN100);
          ObjectSetText("LOW/AV100", "                                    100% ", 8, "Arial", Yellow);
          ObjectSet("LOW/AV100",OBJPROP_BACK,true); } else{
          ObjectMove("LOW/AV100", 0, Time[SHIFT_DailyAverageText], AvDN100);
       }
       ObjectDelete("TOP/AV75");
       if(ObjectFind("TOP/AV75") != 0)
       {  ObjectCreate("TOP/AV75", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP75);
          ObjectSetText("TOP/AV75", "                                      75% ", 8, "Arial", DeepSkyBlue);
          ObjectSet("TOP/AV75",OBJPROP_BACK,true); } else{
          ObjectMove("TOP/AV75", 0, Time[SHIFT_DailyAverageText], AvUP75);
       }
       ObjectDelete("LOW/AV75");
       if(ObjectFind("LOW/AV75") != 0)
       {  ObjectCreate("LOW/AV75", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN75);
          ObjectSetText("LOW/AV75", "                                     75%", 8, "Arial", Yellow);
          ObjectSet("LOW/AV75",OBJPROP_BACK,true); } else{
          ObjectMove("LOW/AV75", 0, Time[SHIFT_DailyAverageText], AvDN75);
       } 	
       ObjectDelete("LOW/AV50");
       if(ObjectFind("LOW/AV50") != 0)
       {  ObjectCreate("LOW/AV50", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP50);
          ObjectSetText("LOW/AV50", "                                       50% ", 8, "Arial",DeepSkyBlue );
          ObjectSet("LOW/AV50",OBJPROP_BACK,true); } else{
          ObjectMove("LOW/AV50", 0, Time[SHIFT_DailyAverageText], AvUP50);
       } 
       ObjectDelete("TOP/AV50");
       if(ObjectFind("TOP/AV50") != 0)
       {  ObjectCreate("TOP/AV50", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN50);
          ObjectSetText("TOP/AV50", "                                      50% ", 8, "Arial",Yellow );
          ObjectSet("TOP/AV50",OBJPROP_BACK,true); } else{
          ObjectMove("TOP/AV50", 0, Time[SHIFT_DailyAverageText], AvDN50);
       } 
       ObjectDelete("TOP/AV25");
       if(ObjectFind("TOP/AV25") != 0)
       {  ObjectCreate("TOP/AV25", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvUP25);
          ObjectSetText("TOP/AV25", "                                      25% ", 8, "Arial", DeepSkyBlue);
          ObjectSet("TOP/AV25",OBJPROP_BACK,true); } else{
          ObjectMove("TOP/AV25", 0, Time[SHIFT_DailyAverageText], AvUP25);
       }
       ObjectDelete("LOW/AV25");
       if(ObjectFind("LOW/AV25") != 0)
       {  ObjectCreate("LOW/AV25", OBJ_TEXT, 0, Time[SHIFT_DailyAverageText], AvDN25);
          ObjectSetText("LOW/AV25", "                                      25% ", 8, "Arial", Yellow);
          ObjectSet("LOW/AV25",OBJPROP_BACK,true); } else{
          ObjectMove("LOW/AV25", 0, Time[SHIFT_DailyAverageText], AvDN25);
       }
    } //Average Levels - End


    //Pivots Lines
    if (Show_PivotLines==true)
    {
       ObjectDelete("C/PIVOT"); 
       if(ObjectFind("C/PIVOT") != 0)
       {  ObjectCreate("C/PIVOT", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], P);
          ObjectSetText("C/PIVOT", "P", 8, "Arial", Silver); } else{
          ObjectMove("C/PIVOT", 0, Time[SHIFT_PivotPointText], P);
       }
       ObjectDelete("R3");
       if(ObjectFind("R3") != 0)
       {  ObjectCreate("R3", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], r3);
          ObjectSetText("R3", "R3", 8, "Arial", Silver); }  else{
          ObjectMove("R3", 0, Time[SHIFT_PivotPointText], r3);
       }
       ObjectDelete("R2");
       if(ObjectFind("R2") != 0)
       {  ObjectCreate("R2", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], r2);
          ObjectSetText("R2", "R2", 8, "Arial", Silver); }  else{
          ObjectMove("R2", 0, Time[SHIFT_PivotPointText], r2);
       }
       ObjectDelete("R1");
       if(ObjectFind("R1") != 0)
       {  ObjectCreate("R1", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], r1);
          ObjectSetText("R1", "R1", 8, "Arial", Silver); } else{
          ObjectMove("R1", 0, Time[SHIFT_PivotPointText], r1);
       }
       ObjectDelete("PS1");
       if(ObjectFind("PS1") != 0)
       {  ObjectCreate("PS1", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], s1);
          ObjectSetText("PS1", "S1", 8, "Arial", Silver); } else{
          ObjectMove("PS1", 0, Time[SHIFT_PivotPointText], s1);
       }
       ObjectDelete("PS2");
       if(ObjectFind("PS2") != 0)
       {  ObjectCreate("PS2", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], s2);
          ObjectSetText("PS2", "S2", 8, "Arial", Silver); } else{
          ObjectMove("PS2", 0, Time[SHIFT_PivotPointText], s2);
       }
       ObjectDelete("PS3");
       if(ObjectFind("PS3") != 0)
       {  ObjectCreate("PS3", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], s3);
          ObjectSetText("PS3", "S3", 8, "Arial", Silver); } else{
          ObjectMove("PS3", 0, Time[SHIFT_PivotPointText], s3);
       }
       
       //M Pivots
       if (Show_M_PivotLines==true)
       {  
          ObjectDelete("M5");
          if(ObjectFind("M5") != 0)
          {  ObjectCreate("M5", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m5);
             ObjectSetText("M5", "M5", 8, "Arial", Silver); } else{
             ObjectMove("M5", 0, Time[SHIFT_PivotPointText], m5);
          }
          ObjectDelete("M4");
          if(ObjectFind("M4") != 0)
          {  ObjectCreate("M4", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m4);
             ObjectSetText("M4", "M4", 8, "Arial", Silver); } else{
             ObjectMove("M4", 0, Time[SHIFT_PivotPointText], m4);
          }
          ObjectDelete("M3");
          if(ObjectFind("M3") != 0)
          {  ObjectCreate("M3", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m3);
             ObjectSetText("M3", "M3", 8, "Arial", Silver); } else{
             ObjectMove("M3", 0, Time[SHIFT_PivotPointText], m3);
          }
          ObjectDelete("M2");
          if(ObjectFind("M2") != 0)
          {  ObjectCreate("M2", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m2);
             ObjectSetText("M2", "M2", 8, "Arial", Silver); } else{
             ObjectMove("M2", 0, Time[SHIFT_PivotPointText], m2);
          }
          ObjectDelete("M1");
          if(ObjectFind("M1") != 0)
          {  ObjectCreate("M1", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m1);
             ObjectSetText("M1", "M1", 8, "Arial", Silver); } else{
             ObjectMove("M1", 0, Time[SHIFT_PivotPointText], m1);
          }
          ObjectDelete("M0"); 
          if(ObjectFind("M0") != 0)
          {  ObjectCreate("M0", OBJ_TEXT, 0, Time[SHIFT_PivotPointText], m0);
             ObjectSetText("M0", "M0", 8, "Arial", Silver); } else{
             ObjectMove("M0", 0, Time[SHIFT_PivotPointText], m0);
          }
       } // M Pivot - End
    } // Pivot Lines - End
    
     
       double FIB_OP = iOpen(NULL,1440,1);
       double FIB_CL = iClose(NULL,1440,1);

    //FIBS
    if (Show_FibLines==true)
    {
    
       if(FIB_OP>FIB_CL){
       ObjectDelete("FIB");
       if(ObjectFind("FIB") != 0)
       {  ObjectCreate("FIB", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB100);
          ObjectSetText("FIB", "FIB 100%   ", 8, "Arial", Green); } else{
          ObjectMove("FIB", 0, Time[SHIFT_FibText], FIB100);
       }
       ObjectDelete("FIB2");
       if(ObjectFind("FIB2") != 0)
       {  ObjectCreate("FIB2", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB50);
          ObjectSetText("FIB2", "FIB 50%     ", 8, "Arial", Green); } else{
          ObjectMove("FIB2", 0, Time[SHIFT_FibText], FIB50);
       }
       ObjectDelete("FIB3");
       if(ObjectFind("FIB3") != 0)
       {  ObjectCreate("FIB3", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB0);
          ObjectSetText("FIB3", "FIB 0.00%  ", 8, "Arial", Green); } else{
          ObjectMove("FIB3", 0, Time[SHIFT_FibText], FIB0);
       }
       ObjectDelete("FIB4");
       if(ObjectFind("FIB4") != 0)
       {  ObjectCreate("FIB4", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB382);
          ObjectSetText("FIB4", "FIB 0.382% ", 8, "Arial", Green); } else{
          ObjectMove("FIB4", 0, Time[SHIFT_FibText], FIB382);
       }
       ObjectDelete("FIB5");
       if(ObjectFind("FIB5") != 0)
       {  ObjectCreate("FIB5", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB618);
          ObjectSetText("FIB5", "FIB 0.618% ", 8, "Arial", Green); } else{
          ObjectMove("FIB5", 0, Time[SHIFT_FibText], FIB618);
        }   
          ObjectDelete("FIB14");
       if(ObjectFind("FIB14") != 0)
       {  ObjectCreate("FIB14", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB764);
          ObjectSetText("FIB14", "FIB 0.764% ", 8, "Arial", Green); } else{
          ObjectMove("FIB14", 0, Time[SHIFT_FibText], FIB764);
       }
       ObjectDelete("FIB15");
       if(ObjectFind("FIB15") != 0)
       {  ObjectCreate("FIB15", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB236);
          ObjectSetText("FIB15", "FIB 0.236% ", 8, "Arial", Green); } else{
          ObjectMove("FIB15", 0, Time[SHIFT_FibText], FIB236);
       }}
       
        if(FIB_OP<FIB_CL){
       ObjectDelete("FIB");
       if(ObjectFind("FIB") != 0)
       {  ObjectCreate("FIB", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB100);
          ObjectSetText("FIB", "FIB 0.00%  ", 8, "Arial", Green); } else{
          ObjectMove("FIB", 0, Time[SHIFT_FibText], FIB100);
       }
       ObjectDelete("FIB2");
       if(ObjectFind("FIB2") != 0)
       {  ObjectCreate("FIB2", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB50);
          ObjectSetText("FIB2", "FIB 0.50%   ", 8, "Arial", Green); } else{
          ObjectMove("FIB2", 0, Time[SHIFT_FibText], FIB50);
       }
       ObjectDelete("FIB3");
       if(ObjectFind("FIB3") != 0)
       {  ObjectCreate("FIB3", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB0);
          ObjectSetText("FIB3", "FIB 100%   ", 8, "Arial", Green); } else{
          ObjectMove("FIB3", 0, Time[SHIFT_FibText], FIB0);
       }
       ObjectDelete("FIB4");
       if(ObjectFind("FIB4") != 0)
       {  ObjectCreate("FIB4", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB382);
          ObjectSetText("FIB4", "FIB 0.618% ", 8, "Arial", Green); } else{
          ObjectMove("FIB4", 0, Time[SHIFT_FibText], FIB382);
       }
       ObjectDelete("FIB5");
       if(ObjectFind("FIB5") != 0)
       {  ObjectCreate("FIB5", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB618);
          ObjectSetText("FIB5", " FIB 0.382% ", 8, "Arial", Green); } else{
          ObjectMove("FIB5", 0, Time[SHIFT_FibText], FIB618);
        }   
          ObjectDelete("FIB14");
       if(ObjectFind("FIB14") != 0)
       {  ObjectCreate("FIB14", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB764);
          ObjectSetText("FIB14", " FIB 0.236% ", 8, "Arial", Green); } else{
          ObjectMove("FIB14", 0, Time[SHIFT_FibText], FIB764);
       }
       ObjectDelete("FIB15");
       if(ObjectFind("FIB15") != 0)
       {  ObjectCreate("FIB15", OBJ_TEXT, 0, Time[SHIFT_FibText], FIB236);
          ObjectSetText("FIB15", "FIB 0.764% ", 8, "Arial", Green); } else{
          ObjectMove("FIB15", 0, Time[SHIFT_FibText], FIB236);
       }}
       
       ObjectDelete("FIB6");
       if(ObjectFind("FIB6") != 0)
       {  ObjectCreate("FIB6", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP50);
          ObjectSetText("FIB6", "FIB +1.50% ", 8, "Arial",  C'0,93,0'); } else{
          ObjectMove("FIB6", 0, Time[SHIFT_FibText], FIBP50);
       }
       ObjectDelete("FIB7");
       if(ObjectFind("FIB7") != 0)
       {  ObjectCreate("FIB7", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP100);
          ObjectSetText("FIB7", "FIB +200% ", 8, "Arial", Green); } else{
          ObjectMove("FIB7", 0, Time[SHIFT_FibText], FIBP100);
       }
       ObjectDelete("FIB8");
       if(ObjectFind("FIB8") != 0)
       {  ObjectCreate("FIB8", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM50);
          ObjectSetText("FIB8", "FIB -1.50% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB8", 0, Time[SHIFT_FibText], FIBM50);
       }
       ObjectDelete("FIB9");
       if(ObjectFind("FIB9") != 0)
       {  ObjectCreate("FIB9", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM100);
          ObjectSetText("FIB9", "FIB -200% ", 8, "Arial", Green); } else{
          ObjectMove("FIB9", 0, Time[SHIFT_FibText], FIBM100);
       }
       ObjectDelete("FIB10");
       if(ObjectFind("FIB10") != 0)
       {  ObjectCreate("FIB10", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP382);
          ObjectSetText("FIB10", "FIB +1.382% ", 8, "Arial", Green); } else{
          ObjectMove("FIB10", 0, Time[SHIFT_FibText], FIBP382);
       }
       ObjectDelete("FIB11");
       if(ObjectFind("FIB11") != 0)
       {  ObjectCreate("FIB11", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM382);
          ObjectSetText("FIB11", "FIB -1.382% ", 8, "Arial", Green); } else{
          ObjectMove("FIB11", 0, Time[SHIFT_FibText], FIBM382);
       }
       ObjectDelete("FIB12");
       if(ObjectFind("FIB12") != 0)
       {  ObjectCreate("FIB12", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP618);
          ObjectSetText("FIB12", "FIB +1.618% ", 8, "Arial", Green); } else{
          ObjectMove("FIB12", 0, Time[SHIFT_FibText], FIBP618);
       }
       ObjectDelete("FIB13");
       if(ObjectFind("FIB13") != 0)
       {  ObjectCreate("FIB13", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM618);
          ObjectSetText("FIB13", "FIB -1.618% ", 8, "Arial", Green); } else{
          ObjectMove("FIB13", 0, Time[SHIFT_FibText], FIBM618);
       }
       ObjectDelete("FIB16");
       if(ObjectFind("FIB16") != 0)
       {  ObjectCreate("FIB16", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM236);
          ObjectSetText("FIB16", "FIB -1.236% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB16", 0, Time[SHIFT_FibText], FIBM236);
       }
       ObjectDelete("FIB17");
       if(ObjectFind("FIB17") != 0)
       {  ObjectCreate("FIB17", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP236);
          ObjectSetText("FIB17", "FIB +1.236% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB17", 0, Time[SHIFT_FibText], FIBP236);
       }
       ObjectDelete("FIB18");
       if(ObjectFind("FIB18") != 0)
       {  ObjectCreate("FIB18", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM764);
          ObjectSetText("FIB18", "FIB -1.764% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB18", 0, Time[SHIFT_FibText], FIBM764);
       }
       ObjectDelete("FIB19");
       if(ObjectFind("FIB19") != 0)
       {  ObjectCreate("FIB19", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP764);
          ObjectSetText("FIB19", "FIB +1.764% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB19", 0, Time[SHIFT_FibText], FIBP764);
       }
    } // Fibs - End

    //Fibs Extra
    if (Show_EXTRAFibLines==true)
    {
       ObjectDelete("FIB20"); 
       if(ObjectFind("FIB20") != 0)
       {  ObjectCreate("FIB20", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP150);
          ObjectSetText("FIB20", "FIB +250% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB20", 0, Time[SHIFT_FibText], FIBP150);
       }
       ObjectDelete("FIB21");
       if(ObjectFind("FIB21") != 0)
       {  ObjectCreate("FIB21", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM150);
          ObjectSetText("FIB21", "FIB -250% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB21", 0, Time[SHIFT_FibText], FIBM150);
       }
       ObjectDelete("FIB22");
       if(ObjectFind("FIB122") != 0)
       {  ObjectCreate("FIB22", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP200);
          ObjectSetText("FIB22", "FIB +300% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB22", 0, Time[SHIFT_FibText], FIBP200);
       }
       ObjectDelete("FIB23");
       if(ObjectFind("FIB23") != 0)
       {  ObjectCreate("FIB23", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM200);
          ObjectSetText("FIB23", "FIB -300% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB23", 0, Time[SHIFT_FibText], FIBM200);
       }
       ObjectDelete("FIB24");
       if(ObjectFind("FIB124") != 0)
       {  ObjectCreate("FIB24", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP250);
          ObjectSetText("FIB24", "FIB +350% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB24", 0, Time[SHIFT_FibText], FIBP250);
       }
       ObjectDelete("FIB125");
       if(ObjectFind("FIB25") != 0)
       {  ObjectCreate("FIB25", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM250);
          ObjectSetText("FIB25", "FIB -350% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB25", 0, Time[SHIFT_FibText], FIBM250);
       }
       ObjectDelete("FIB26");
       if(ObjectFind("FIB26") != 0)
       {  ObjectCreate("FIB26", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBP300);
          ObjectSetText("FIB26", "FIB +400% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB26", 0, Time[SHIFT_FibText], FIBP300);
       }
       ObjectDelete("FIB27");
       if(ObjectFind("FIB27") != 0)
       {  ObjectCreate("FIB27", OBJ_TEXT, 0, Time[SHIFT_FibText], FIBM300);
          ObjectSetText("FIB27", "FIB -400% ", 8, "Arial", C'0,93,0'); } else{
          ObjectMove("FIB27", 0, Time[SHIFT_FibText], FIBM300);
       }
    } // Fibs Extra - End
    
    // Daily HI-LOW
    if (Show_Daily_HI_LOW==true)
    {   
       ObjectDelete("DHIGH");   
       if(ObjectFind("DHIGH") != 0)
       {  ObjectCreate("DHIGH", OBJ_TEXT, 0, Time[SHIFT_HI_LOW_TEXT], HI3);
          ObjectSetText("DHIGH", "Daily High ", 8, "Arial", Turquoise); } else{
          ObjectMove("DHIGH", 0, Time[SHIFT_HI_LOW_TEXT], HI3);
       }
       ObjectDelete("DLOW");
       if(ObjectFind("DLOW") != 0)
       {  ObjectCreate("DLOW", OBJ_TEXT, 0, Time[SHIFT_HI_LOW_TEXT], LOW3);
          ObjectSetText("DLOW", "Daily Low ", 8, "Arial", Turquoise); } else{
          ObjectMove("DLOW", 0, Time[SHIFT_HI_LOW_TEXT], LOW3);
       }
    } // Daily HI-LOW - End
    
    // Daily Open
    if (Show_Daily_OPEN==true || Using_OpenGraphics == true) //Tweak for Open Graphics - hymns
    {
        ObjectDelete("Open"); 
       if(ObjectFind("Open") != 0)
       {
          ObjectCreate("Open", OBJ_TEXT, 0, Time[SHIFT_Daily_OPEN_TEXT], OPEN);
          ObjectSetText("Open", "                            OPEN "+ DoubleToStr(OPEN,Digits)+"", 8, "Arial Bold",YellowGreen);
       }
       else{
          ObjectMove("Open", 0, Time[SHIFT_Daily_OPEN_TEXT], OPEN);
       }
    } // Daily Open - End

	 // Show Comments
	 if (Show_DollyCOMMENTS==true)
	 {  
   	 string  NAME,BUYSTOP,BUYSTOP1,STOP,STOP1,PROFIT,PROFIT1,SELL,SELL1,STOP2,STOP3,PROFIT2,
	         PROFIT3,BUYTARGT,PROFIT4,SELLTARGT,PROFIT5,OPEN1,DAR,TOTAL,TDR,LDR,TIME, 
	         TIME2,PRICE,CHANGE,TDR1,LDR1,STOP4,STOP5 ; 
	         
	    if( StringFind( Symbol(), "JPY", 0) != -1 )
   {nDigitsMINUS = 0; Precision = 100; nDigits  = 2;}
   else {nDigitsMINUS = 2;  Precision = 10000; nDigits  = 4; }     
	    
	    double ChangeVal = (Bid - today_open)*Precision;
	       
	    NAME = IND_NAME;			
	    BUYSTOP = (DoubleToStr (B1,Digits));
	    BUYSTOP1 = (DoubleToStr(B2,Digits));
	    STOP = (DoubleToStr (S1,Digits));
	    STOP1 = (DoubleToStr(B1,Digits));
	    PROFIT = (DoubleToStr ((B2),Digits));
	    PROFIT1 = (DoubleToStr (B3,Digits));//((B2+(10*Point)),Digits)); 
	    SELL = (DoubleToStr (S1,Digits));
	    SELL1 = (DoubleToStr (S2,Digits)); 
	    STOP2 = (DoubleToStr (B1,Digits));
	    STOP3 = (DoubleToStr(S1,Digits));
	    PROFIT2 = (DoubleToStr ((S2),Digits));
	    PROFIT3 = (DoubleToStr (S3,Digits));//((S2-(10*Point)),Digits));
	    BUYTARGT = (DoubleToStr(S2,Digits));
	    PROFIT4 = (DoubleToStr(B1,Digits));
	    STOP4 = (DoubleToStr(S3,Digits));
	    SELLTARGT = (DoubleToStr(B2,Digits));
	    PROFIT5 = (DoubleToStr(S1,Digits));
	    STOP5 = (DoubleToStr(B3,Digits));
	    OPEN1 = (DoubleToStr(OPEN,Digits));
	    DAR = (DoubleToStr(AV,0));
	    TOTAL = (DoubleToStr(HI2-LOW2,Digits));
	    TDR = (DoubleToStr(P+AV,Digits));
	    LDR = (DoubleToStr(P-AV,Digits));
	    TDR1 = (DoubleToStr(P+AV/2,Digits));
	    LDR1 = (DoubleToStr(P-AV/2,Digits));
	    TIME = (TimeToStr(LocalTime(),Digits-6));
	    TIME2 = (TimeToStr(CurTime(),Digits-6));
	    PRICE = (DoubleToStr(iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0),Digits));//iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);        
       CHANGE = (DoubleToStr(ChangeVal,nDigits-nDigitsMINUS));

       ObjectDelete("Dolly");
       Dolly( "Dolly", 22, 12,4);
       ObjectSetText( "Dolly",""+ NAME +"", 11, "Arial", Yellow );
   
       ObjectDelete("Dolly1");
       Dolly1( "Dolly1", 35, 12,4);
       ObjectSetText( "Dolly1", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
   
       if ( Auto_Signals == false )
   {  
     
	    ObjectDelete("Dolly2");
       Dolly2( "Dolly2", 50, 12,4);
       ObjectSetText( "Dolly2", "BUY ZONE", 9, "Arial", DeepSkyBlue );
   
       ObjectDelete("Dolly3");
       Dolly3( "Dolly3", 60, 12,4);
       ObjectSetText( "Dolly3",",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,", 8, "Arial", White );
     ObjectDelete("Dolly4");
       Dolly4( "Dolly4", 75, 12,4);
       ObjectSetText( "Dolly4", "BUY STOP-1  "+Symbol()+ "  @ ", 9, "Arial", DodgerBlue );
   
       ObjectDelete("Dolly5");
       Dolly5( "Dolly5", 75, 12,4);
       ObjectSetText( "Dolly5"," "+ BUYSTOP +"", 9, "Arial", DarkOrange );
   
       ObjectDelete("Dolly6");
       Dolly6( "Dolly6", 90, 12,4);
       ObjectSetText( "Dolly6", "TP               and SL @    ", 9, "Arial", DodgerBlue);
   
       ObjectDelete("Dolly7");
       Dolly7( "Dolly7", 90, 12,4);
       ObjectSetText( "Dolly7"," "+ BUYSTOP1 +"", 9, "Arial", YellowGreen);
   
       ObjectDelete("Dolly8");
       Dolly8( "Dolly8", 90, 12,4);
       ObjectSetText( "Dolly8"," "+ STOP +"", 9, "Arial", Yellow );
   
       ObjectDelete("Dolly9");
       Dolly9( "Dolly9", 110, 12,4);
       ObjectSetText( "Dolly9", "BUY STOP-2  "+Symbol()+ "  @ ",9, "Arial", LightBlue );
   
       ObjectDelete("Dolly10");
       Dolly10( "Dolly10", 110, 12,4);
       ObjectSetText( "Dolly10"," "+ BUYSTOP1 +"", 9, "Arial", DarkOrange );
   
       ObjectDelete("Dolly11");
       Dolly11( "Dolly11", 125, 12,4);
       ObjectSetText( "Dolly11",  "TP               and SL @    ", 9, "Arial", LightBlue);
   
       ObjectDelete("Dolly12");
       Dolly12( "Dolly12", 125, 12,4);
       ObjectSetText( "Dolly12"," "+ PROFIT1 +"", 9, "Arial", YellowGreen );
   
       ObjectDelete("Dolly13");
       Dolly13( "Dolly13", 125, 12,4);
       ObjectSetText( "Dolly13", ""+ STOP1 +""  , 9, "Arial", Yellow );
  
   
       ObjectDelete("Dolly14");
       Dolly14( "Dolly14", 140, 12,4);
       ObjectSetText( "Dolly14", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
   
       ObjectDelete("Dolly15");
       Dolly15( "Dolly15", 155, 12,4);
       ObjectSetText( "Dolly15", "SELL ZONE"  , 9, "Arial", Orange );
   
       ObjectDelete("Dolly16");
       Dolly16( "Dolly16", 165, 12,4);
       ObjectSetText( "Dolly16", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
   
    
       ObjectDelete("Dolly17");
       Dolly17( "Dolly17", 180, 12,4);
       ObjectSetText( "Dolly17", "SELL STOP-1  "+Symbol()+ "  to ", 9, "Arial", OrangeRed );
   
       ObjectDelete("Dolly18");
       Dolly18( "Dolly18", 180, 12,4);
       ObjectSetText( "Dolly18"," "+ SELL +"", 9, "Arial",DarkOrange);
   
     
       ObjectDelete("Dolly19");
       Dolly19( "Dolly19", 195, 12,4);
       ObjectSetText( "Dolly19",  "TP               and SL @    ", 9, "Arial", OrangeRed );
   
       ObjectDelete("Dolly20");
       Dolly20( "Dolly20", 195, 12,4);
       ObjectSetText( "Dolly20"," "+ PROFIT2  +"", 9, "Arial", YellowGreen );
        
       ObjectDelete("Dolly21");
       Dolly21( "Dolly21", 195, 12,4);
       ObjectSetText( "Dolly21"," "+STOP1+ " " , 9, "Arial", Yellow );
   
     
       ObjectDelete("Dolly22");
       Dolly22( "Dolly22", 215, 12,4);
       ObjectSetText( "Dolly22", "SELL STOP-2  "+Symbol()+ "  to ", 9, "Arial", OrangeRed );
   
       ObjectDelete("Dolly23");
       Dolly23( "Dolly23", 215, 12,4);
       ObjectSetText( "Dolly23"," "+ SELL1 +"", 9, "Arial",DarkOrange);
   
       ObjectDelete("Dolly24");
       Dolly24( "Dolly24", 230, 12,4);
       ObjectSetText( "Dolly24",  "TP               and SL @    ", 9, "Arial", OrangeRed );
   
       ObjectDelete("Dolly25");
       Dolly25( "Dolly25", 230, 12,4);
       ObjectSetText( "Dolly25"," "+ PROFIT3 +"", 9, "Arial", YellowGreen );
        
       ObjectDelete("Dolly26");
       Dolly26( "Dolly26", 230, 12,4);
       ObjectSetText( "Dolly26"," "+STOP3+ " " , 9, "Arial", Yellow );
  
       ObjectDelete("Dolly27");
       Dolly27( "Dolly27", 245, 12,4);
       ObjectSetText( "Dolly27", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
   
       ObjectDelete("Dolly28");
       Dolly28( "Dolly28", 260, 12,4);
       ObjectSetText( "Dolly28", "POTENTIAL REVERSAL LEVELS"  , 9, "Arial",DarkSeaGreen);
 
 
       ObjectDelete("Dolly29");
       Dolly29( "Dolly29", 270, 12,4);
       ObjectSetText( "Dolly29", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
   
       ObjectDelete("Dolly30");
       Dolly30( "Dolly30", 285, 12,4);
       ObjectSetText( "Dolly30", "BEARISH CORRECTION : "  , 9, "Arial",DeepSkyBlue);
   
       ObjectDelete("Dolly31");
       Dolly31( "Dolly31", 300, 12,4);
       ObjectSetText( "Dolly31", "BUY STOP "+Symbol()+ "  @ ", 9, "Arial", DodgerBlue );
   
       ObjectDelete("Dolly32");
       Dolly32( "Dolly32", 300, 12,4);
       ObjectSetText( "Dolly32"," "+ BUYTARGT +"", 9, "Arial", DarkOrange );
   
       ObjectDelete("Dolly33");
       Dolly33( "Dolly33", 315, 12,4);
       ObjectSetText( "Dolly33",  "TP               and SL @    ", 9, "Arial", DodgerBlue );
   
       ObjectDelete("Dolly34");
       Dolly34( "Dolly34", 315, 12,4);
       ObjectSetText( "Dolly34"," "+ PROFIT4  +"", 9, "Arial", YellowGreen );
   
       ObjectDelete("Dolly35");
       Dolly35( "Dolly35", 315, 12,4);
       ObjectSetText( "Dolly35"," "+STOP4+ " " , 9, "Arial", Yellow );
   
       ObjectDelete("Dolly36");
       Dolly36( "Dolly36", 335, 12,4);
       ObjectSetText( "Dolly36", "BULLISH CORRECTION : "  , 9, "Arial",Orange);
   
       ObjectDelete("Dolly37");
       Dolly37( "Dolly37", 350, 12,4);
       ObjectSetText( "Dolly37", "SELL STOP "+Symbol()+ "  @ ", 9, "Arial",  OrangeRed );
   
       ObjectDelete("Dolly38");
       Dolly38( "Dolly38", 350, 12,4);
       ObjectSetText( "Dolly38"," "+ SELLTARGT +"", 9, "Arial", DarkOrange );
      
       ObjectDelete("Dolly39");
       Dolly39( "Dolly39", 365, 12,4);
       ObjectSetText( "Dolly39",  "TP               and SL @    ", 9, "Arial",  OrangeRed );
   
       ObjectDelete("Dolly40");
       Dolly40( "Dolly40", 365, 12,4);
       ObjectSetText( "Dolly40"," "+ PROFIT5  +"", 9, "Arial", YellowGreen );
           
       ObjectDelete("Dolly41");
       Dolly41( "Dolly41", 365, 12,4);
       ObjectSetText( "Dolly41"," "+STOP5+ " " , 9, "Arial", Yellow );
       
       ObjectDelete("Dolly42");
       Dolly42( "Dolly42", 380, 12,4);
       ObjectSetText( "Dolly42", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
       
       ObjectDelete("Dolly43");
       Dolly43( "Dolly43", 395, 12,4);
       ObjectSetText( "Dolly43",  "DAILY OPEN", 9, "Arial",  Orange );
   
       ObjectDelete("Dolly44");
       Dolly44( "Dolly44", 395, 12,4);
       ObjectSetText( "Dolly44"," "+ OPEN1 +"", 9, "Arial", YellowGreen );
   
       ObjectDelete("Dolly45");
       Dolly45( "Dolly45", 410, 12,4);
       ObjectSetText( "Dolly45","DAILY AVERAGE RANGE " , 9, "Arial",DarkSeaGreen);
   
       ObjectDelete("Dolly46");
       Dolly46( "Dolly46", 410, 12,4);
       ObjectSetText( "Dolly46"," "+DAR+ " " , 9, "Arial", DarkOrange );
   
       ObjectDelete("Dolly47");
       Dolly47( "Dolly47", 420, 12,4);
       ObjectSetText( "Dolly47", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
   
       // Market Price
       ObjectDelete("Dolly48");
       Dolly48( "Dolly48", 435, 12,4); 
       ObjectSetText( "Dolly48","Price", 10, "Arial", Silver);
   
       ObjectDelete("Dolly49");
       Dolly49( "Dolly49", 435, 12,4);
       ObjectSetText( "Dolly49"," "+PRICE+" ", 15, "Arial", Silver);
       }
       // Today Market Change
       
        x = Period();
       if(x > 240||x < 5) return(-1);
       if(Show_ChangeDISPLAY){
        
       ObjectDelete("Dolly50");
       Dolly50( "Dolly50", 10, 12,4);
       ObjectSetText( "Dolly50","Change", 10, "Arial", Silver);
   
       ObjectDelete("Dolly51");
       Dolly51( "Dolly51", 18, 12,4);
       if (ChangeVal == 0) 
       {
          ObjectSetText( "Dolly51","+"+CHANGE+" ", 15, "Arial", Gold);
       }
       else if (ChangeVal > 0) {
          ObjectSetText( "Dolly51","+"+CHANGE+" ", 15, "Arial", Lime);       
       } 
       else {
          ObjectSetText( "Dolly51"," "+CHANGE+" ", 15, "Arial", Red);
       }}
    } // Show Comment - End

           if ( Auto_Signals == true )
   {  
         if (Show_DollyCOMMENTS==true)
	 {  

       ObjectDelete("Dolly42");
       Dolly42( "Dolly42", 98, 12,4);
       ObjectSetText( "Dolly42", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
       
       ObjectDelete("Dolly43");
       Dolly43( "Dolly43", 112, 12,4);
       ObjectSetText( "Dolly43",  "DAILY OPEN", 9, "Arial",  Orange );
   
       ObjectDelete("Dolly44");
       Dolly44( "Dolly44", 112, 12,4);
       ObjectSetText( "Dolly44"," "+ OPEN1 +"", 9, "Arial", YellowGreen );
   
       ObjectDelete("Dolly45");
       Dolly45( "Dolly45", 125, 12,4);
       ObjectSetText( "Dolly45","DAILY AVERAGE RANGE " , 9, "Arial",DarkSeaGreen);
   
       ObjectDelete("Dolly46");
       Dolly46( "Dolly46", 125, 12,4);
       ObjectSetText( "Dolly46"," "+DAR+ " " , 9, "Arial", DarkOrange );
   
       ObjectDelete("Dolly47");
       Dolly47( "Dolly47", 134, 12,4);
       ObjectSetText( "Dolly47", ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"  , 8, "Arial", White );
   
       // Market Price
       ObjectDelete("Dolly48");
       Dolly48( "Dolly48", 148, 12,4); 
       ObjectSetText( "Dolly48","Price", 10, "Arial", Silver);
   
       ObjectDelete("Dolly49");
       Dolly49( "Dolly49", 148, 12,4);
       ObjectSetText( "Dolly49"," "+PRICE+" ", 15, "Arial", Silver);
      } }}
//+------------------------------------------------------------------+

   
int Dolly( string Text, int xOffset, int yOffset,int iCorner) //TITLE
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly1( string Text, int xOffset, int yOffset,int iCorner) //LINE
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly2( string Text, int xOffset, int yOffset,int iCorner)//Buy Zone
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly3( string Text, int xOffset, int yOffset,int iCorner) //LINE
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly4( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly5( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly6( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly7( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly8( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly9( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly10( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly11( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly12( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly13( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly14( string Text, int xOffset, int yOffset,int iCorner) //Line
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly15( string Text, int xOffset, int yOffset,int iCorner) //SELL ZONE
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly16( string Text, int xOffset, int yOffset,int iCorner) //LINE
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly17( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly18( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly19( string Text, int xOffset, int yOffset,int iCorner) // Line
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly20( string Text, int xOffset, int yOffset,int iCorner) // 1st SELL 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly21( string Text, int xOffset, int yOffset,int iCorner) // 1st SELL SL
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}  
int Dolly22( string Text, int xOffset, int yOffset,int iCorner) // 2nd SELL
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly23( string Text, int xOffset, int yOffset,int iCorner) // 2nd SELL
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly24( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly25( string Text, int xOffset, int yOffset,int iCorner)
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35+Shift_DollyCOMMENTS_SIDEWAYS);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly26( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly27( string Text, int xOffset, int yOffset,int iCorner)//LINE 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly28( string Text, int xOffset, int yOffset,int iCorner) // POTENTIAL 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly29( string Text, int xOffset, int yOffset,int iCorner) // LINE
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly30( string Text, int xOffset, int yOffset,int iCorner) //BEARISH CORR
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}   
int Dolly31( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly32( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly33( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly34( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly35( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly36( string Text, int xOffset, int yOffset,int iCorner) //BULLISH CORR
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly37( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly38( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 170+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly39( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly40( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 35+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly41( string Text, int xOffset, int yOffset,int iCorner)  
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 140+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly42( string Text, int xOffset, int yOffset,int iCorner)  
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly43( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly44( string Text, int xOffset, int yOffset,int iCorner) 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 100+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly45( string Text, int xOffset, int yOffset,int iCorner)  
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
} 
int Dolly46( string Text, int xOffset, int yOffset,int iCorner)  
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 160+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly47( string Text, int xOffset, int yOffset,int iCorner) //Line 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly48( string Text, int xOffset, int yOffset,int iCorner) //Price Text 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly49( string Text, int xOffset, int yOffset,int iCorner) //Price Value
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 50+Shift_DollyCOMMENTS_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_DollyCOMMENTS_UP_DN  );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly50( string Text, int xOffset, int yOffset,int iCorner) //Change Text
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 10+Shift_Change_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_Change_UP_DN );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}
int Dolly51( string Text, int xOffset, int yOffset,int iCorner) //Change Value 
{  ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 50+Shift_Change_SIDEWAYS );
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset+Shift_Change_UP_DN );
   ObjectSet   (Text,OBJPROP_BACK      , false );
}

bool BarChanged()
{
 static datetime dt = 0;

  if (dt != iTime(NULL,5,0))//Time[0])
  {
   dt = iTime(NULL,5,0);//Time[0];
   return(true);
  }
   return(false);
}

bool DataBarChanged()
{
 static datetime dt = 0;

  if (dt != iTime(NULL,1,0))
  {
   dt = iTime(NULL,1,0);
   return(true);
  }
   return(false);
}

//---- done
return(0);