
//
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//当地时间
extern string     非盈利性黄金外汇交流群 = "QQ群号：171404820";
extern string		悉尼开市		= "09:00";   //10.4-4.4為夏令時
extern string		悉尼收市		= "17:00";   
extern string	   东京开市		= "09:00";
extern string		东京收市		= "15:30"; 
extern string		歐州开市		= "09:00";   //3.29-10.25為夏令時
extern string		歐州收市		= "16:00";  
extern string		倫敦开市		= "09:30";   //3.29-10.25為夏令時
extern string		倫敦收市		= "15:30";   
extern string		纽約开市		= "08:30";   //3.8-11.1為夏令時
extern string		纽約收市	   = "15:00";
extern int		   预开分钟	   = 30;	       //离开市多少时间

//---- input parameters
extern double       服务器时区=-5;    //美国
extern double       本地时区=8;
extern bool         ShowLocal_GMT_BROK=false;  //修改
extern bool         亚洲区域=true;
extern int          corner=1;
extern int          topOff=50;
extern color        开市颜色=SpringGreen;
extern color        关市颜色=LightGray;
extern color        预开颜色=Yellow;
extern color        北京时间颜色=LightGray;
extern color        ShowLocal颜色=LightGray;
extern bool         show12HourTime=false;

//---- buffers
double ExtMapBuffer1[];
int SydneyTZ = 10;    //悉尼
int EurTZ = 1;        //歐州
int TokyoTZ = 9;      //東京
int LondonTZ = 0;     //倫敦
int NewYorkTZ = -5;   //紐約


string TimeToString( datetime when ) {
   if ( !show12HourTime )
      return (TimeToStr( when, TIME_MINUTES ));
      
   int hour = TimeHour( when );
   int minute = TimeMinute( when );
   string ampm = " AM";
   
   string timeStr;
   if ( hour >= 12 ) {
      hour = hour - 12;
      ampm = " PM";
   }
      
   if ( hour == 0 )
      hour = 12;
   timeStr = DoubleToStr( hour, 0 ) + ":";
   if ( minute < 10 )
      timeStr = timeStr + "0";
   timeStr = timeStr + DoubleToStr( minute, 0 );
   timeStr = timeStr + ampm;
   
   return (timeStr);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int dstDelta;
   double local;
   datetime brokerTime = CurTime();
   datetime GMT = brokerTime - (服务器时区)*3600;
     if ( 亚洲区域 ) 
          local = GMT + (本地时区 ) * 3600;
     else local = GMT + (本地时区+dstDelta) * 3600;

   datetime yukai = 预开分钟*60;  //加预开分钟的时间

//倫敦  3.29-10.25為夏令时制，提前一小時
    if (DayOfYear()>=88 && DayOfYear()<=298) dstDelta=-1;
     else dstDelta = 0;
   datetime london = GMT + (LondonTZ+dstDelta) * 3600;
   datetime londonA = london+yukai;
   
//歐州  3.29-10.25為夏令时制，提前一小時
   if (DayOfYear()>=88 && DayOfYear()<=298) dstDelta=-1;
    else dstDelta = 0;
   datetime Eur = GMT + (EurTZ+dstDelta) * 3600;   
   datetime EurA = Eur+yukai;   
     
//悉尼 10.4-4.4為夏令時制，推后一小時
   if (DayOfYear()>=277 || DayOfYear()<=94) dstDelta=1;
    else dstDelta = 0;
   datetime Sydney = GMT + (SydneyTZ+dstDelta )* 3600;                
   datetime SydneyA = Sydney + yukai; 

//東京不搞夏時制
   datetime tokyo = GMT + (TokyoTZ )* 3600;
   datetime tokyoA = tokyo+yukai;

//紐約 3.8-11.1為夏令時制，推后一小時
   if (DayOfYear()>=67 && DayOfYear()<=304) dstDelta=1;
    else dstDelta = 0;
   datetime newyork = GMT + (NewYorkTZ+dstDelta) * 3600;
   datetime newyorkA = newyork + yukai;
   
       
  //Print( brokerTime, " ", GMT, " ", local, " ", london, " ", tokyo, " ", newyork  );
   string GMTs = TimeToString( GMT );
   string locals = TimeToString( local );
   string Eurs = TimeToString( Eur );    
   string londons = TimeToString( london );
   string Sydneys = TimeToString( Sydney );        
   string tokyos = TimeToString( tokyo );
   string newyorks = TimeToString( newyork );
   string brokers = TimeToString( CurTime() );
   string bars = TimeToStr( CurTime() - Time[0], TIME_MINUTES );
   string londonB = TimeToString( londonA );
   string SydneyB = TimeToString( SydneyA );
   string tokyoB = TimeToString(tokyoA );
   string newyorkB = TimeToString( newyorkA );
   string EurB = TimeToString( EurA );
   
  //我加
   int Sydneycolor;
   int tokyocolor;
   int Eurcolor;
   int londoncolor;
   int newyorkcolor;
   
  
   if(SydneyB>悉尼开市&&Sydneys<悉尼开市) Sydneycolor=预开颜色; else  if(Sydneys>=悉尼开市&&Sydneys<=悉尼收市)Sydneycolor=开市颜色;  else Sydneycolor=关市颜色;
   if(tokyoB>东京开市&&tokyos<东京开市) tokyocolor=预开颜色; else  if(tokyos>=东京开市&&tokyos<=东京收市)tokyocolor=开市颜色;  else tokyocolor=关市颜色;
   if(EurB>歐州开市&&Eurs<歐州开市) Eurcolor=预开颜色; else  if(Eurs>=歐州开市&&Eurs<=歐州收市)Eurcolor=开市颜色;  else Eurcolor=关市颜色;
   if(londonB>倫敦开市&&londons<倫敦开市) londoncolor=预开颜色; else  if(londons>=倫敦开市&&londons<=倫敦收市)londoncolor=开市颜色;  else londoncolor=关市颜色;
   if(newyorkB>纽約开市&&newyorks<纽約开市) newyorkcolor=预开颜色; else  if(newyorks>=纽約开市&&newyorks<=纽約收市)newyorkcolor=开市颜色;  else newyorkcolor=关市颜色;
 
    //--------------------------------------------------------------       
   if ( ShowLocal_GMT_BROK ) {
      ObjectSetText( "barl", "K     柱", 9, "Arial", ShowLocal颜色 );
      ObjectSetText( "bart", bars, 9, "Arial", ShowLocal颜色 );
      ObjectSetText( "gmtl", "标    准", 9, "Arial", ShowLocal颜色 );
      ObjectSetText( "gmtt", GMTs, 9, "Arial", ShowLocal颜色 );
      ObjectSetText( "brol", "服务器", 9, "Arial", ShowLocal颜色 );
      ObjectSetText( "brot", brokers, 9, "Arial", ShowLocal颜色 );
   }
   //------------------------------------------------
   ObjectSetText( "Sydneyl", "悉尼", 9, "Arial Bold", Sydneycolor );     //我加
   ObjectSetText( "Sydneyt", Sydneys, 9, "Arial Bold", Sydneycolor );      //我加
   ObjectSetText( "tokl", "东京", 9, "Arial", tokyocolor );
   ObjectSetText( "tokt", tokyos, 9, "Arial Bold", tokyocolor );
   ObjectSetText( "Eurl", "欧洲", 9, "Arial", Eurcolor );   //我加
   ObjectSetText( "Eurt", Eurs, 9, "Arial Bold", Eurcolor );  //我加
   ObjectSetText( "nyl", "纽约", 9, "Arial", newyorkcolor );
   ObjectSetText( "nyt", newyorks, 9, "Arial Bold", newyorkcolor );
   ObjectSetText( "lonl", "伦敦", 9, "Arial", londoncolor );
   ObjectSetText( "lont", londons, 9, "Arial Bold", londoncolor );
   ObjectSetText( "locl", "北京", 9, "Arial", 北京时间颜色 );
   ObjectSetText( "loct", locals, 9, "Arial Bold", 北京时间颜色 );
      
//----
   return(0);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int ObjectMakeLabel( string n, int xoff, int yoff ) {
   ObjectCreate( n, OBJ_LABEL, 0, 0, 0 );
   ObjectSet( n, OBJPROP_CORNER, corner );
   ObjectSet( n, OBJPROP_XDISTANCE, xoff );
   ObjectSet( n, OBJPROP_YDISTANCE, yoff );
   ObjectSet( n, OBJPROP_BACK, true );
}

int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   
   int top=topOff;
   int left = 600;
   if ( show12HourTime )
      left = 102;
   if ( ShowLocal_GMT_BROK ) {
      ObjectMakeLabel( "barl", left+130, top );
      ObjectMakeLabel( "bart", left+80, top );
      ObjectMakeLabel( "gmtl", left+130, top-15 );
      ObjectMakeLabel( "gmtt", left+80, top-15 );
      ObjectMakeLabel( "brol", left+130, top-30 );
      ObjectMakeLabel( "brot", left+80, top-30 );
  }
   ObjectMakeLabel( "locl", left-50, top-50 );
   ObjectMakeLabel( "loct", left-90, top-50 );
   ObjectMakeLabel( "Sydneyl", left-130, top-50 );    
   ObjectMakeLabel( "Sydneyt", left-170, top-50 );          
   ObjectMakeLabel( "tokl", left-210, top-50 );
   ObjectMakeLabel( "tokt", left-250, top-50 );
   ObjectMakeLabel( "Eurl", left-290, top-50 );   
   ObjectMakeLabel( "Eurt", left-330, top-50 );         
   ObjectMakeLabel( "lonl", left-370, top-50 );
   ObjectMakeLabel( "lont", left-410, top-50 );
   ObjectMakeLabel( "nyl",  left-450, top-50 );
   ObjectMakeLabel( "nyt",  left-490, top-50 );
   
   
   
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete( "locl" );
   ObjectDelete( "loct" );
   ObjectDelete( "nyl" );
   ObjectDelete( "nyt" );
   ObjectDelete( "gmtl" );
   ObjectDelete( "gmtt" );
   ObjectDelete( "Eurl" );   
   ObjectDelete( "Eurt" );   
   ObjectDelete( "lonl" );
   ObjectDelete( "lont" );
   ObjectDelete( "Sydneyl" );   
   ObjectDelete( "Sydneyt" );   
   ObjectDelete( "tokl" );
   ObjectDelete( "tokt" );
   ObjectDelete( "brol" );
   ObjectDelete( "brot" );
   ObjectDelete( "barl" );
   ObjectDelete( "bart" );
//----
   return(0);
  }

