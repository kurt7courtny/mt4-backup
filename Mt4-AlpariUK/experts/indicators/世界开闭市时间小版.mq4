
//
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//����ʱ��
extern string     ��ӯ���Իƽ���㽻��Ⱥ = "QQȺ�ţ�171404820";
extern string		Ϥ�Ὺ��		= "09:00";   //10.4-4.4������r
extern string		Ϥ������		= "17:00";   
extern string	   ��������		= "09:00";
extern string		��������		= "15:30"; 
extern string		�W�ݿ���		= "09:00";   //3.29-10.25������r
extern string		�W������		= "16:00";  
extern string		���ؿ���		= "09:30";   //3.29-10.25������r
extern string		��������		= "15:30";   
extern string		Ŧ�s����		= "08:30";   //3.8-11.1������r
extern string		Ŧ�s����	   = "15:00";
extern int		   Ԥ������	   = 30;	       //�뿪�ж���ʱ��

//---- input parameters
extern double       ������ʱ��=-5;    //����
extern double       ����ʱ��=8;
extern bool         ShowLocal_GMT_BROK=false;  //�޸�
extern bool         ��������=true;
extern int          corner=1;
extern int          topOff=50;
extern color        ������ɫ=SpringGreen;
extern color        ������ɫ=LightGray;
extern color        Ԥ����ɫ=Yellow;
extern color        ����ʱ����ɫ=LightGray;
extern color        ShowLocal��ɫ=LightGray;
extern bool         show12HourTime=false;

//---- buffers
double ExtMapBuffer1[];
int SydneyTZ = 10;    //Ϥ��
int EurTZ = 1;        //�W��
int TokyoTZ = 9;      //�|��
int LondonTZ = 0;     //����
int NewYorkTZ = -5;   //�~�s


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
   datetime GMT = brokerTime - (������ʱ��)*3600;
     if ( �������� ) 
          local = GMT + (����ʱ�� ) * 3600;
     else local = GMT + (����ʱ��+dstDelta) * 3600;

   datetime yukai = Ԥ������*60;  //��Ԥ�����ӵ�ʱ��

//����  3.29-10.25������ʱ�ƣ���ǰһС�r
    if (DayOfYear()>=88 && DayOfYear()<=298) dstDelta=-1;
     else dstDelta = 0;
   datetime london = GMT + (LondonTZ+dstDelta) * 3600;
   datetime londonA = london+yukai;
   
//�W��  3.29-10.25������ʱ�ƣ���ǰһС�r
   if (DayOfYear()>=88 && DayOfYear()<=298) dstDelta=-1;
    else dstDelta = 0;
   datetime Eur = GMT + (EurTZ+dstDelta) * 3600;   
   datetime EurA = Eur+yukai;   
     
//Ϥ�� 10.4-4.4������r�ƣ��ƺ�һС�r
   if (DayOfYear()>=277 || DayOfYear()<=94) dstDelta=1;
    else dstDelta = 0;
   datetime Sydney = GMT + (SydneyTZ+dstDelta )* 3600;                
   datetime SydneyA = Sydney + yukai; 

//�|�������ĕr��
   datetime tokyo = GMT + (TokyoTZ )* 3600;
   datetime tokyoA = tokyo+yukai;

//�~�s 3.8-11.1������r�ƣ��ƺ�һС�r
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
   
  //�Ҽ�
   int Sydneycolor;
   int tokyocolor;
   int Eurcolor;
   int londoncolor;
   int newyorkcolor;
   
  
   if(SydneyB>Ϥ�Ὺ��&&Sydneys<Ϥ�Ὺ��) Sydneycolor=Ԥ����ɫ; else  if(Sydneys>=Ϥ�Ὺ��&&Sydneys<=Ϥ������)Sydneycolor=������ɫ;  else Sydneycolor=������ɫ;
   if(tokyoB>��������&&tokyos<��������) tokyocolor=Ԥ����ɫ; else  if(tokyos>=��������&&tokyos<=��������)tokyocolor=������ɫ;  else tokyocolor=������ɫ;
   if(EurB>�W�ݿ���&&Eurs<�W�ݿ���) Eurcolor=Ԥ����ɫ; else  if(Eurs>=�W�ݿ���&&Eurs<=�W������)Eurcolor=������ɫ;  else Eurcolor=������ɫ;
   if(londonB>���ؿ���&&londons<���ؿ���) londoncolor=Ԥ����ɫ; else  if(londons>=���ؿ���&&londons<=��������)londoncolor=������ɫ;  else londoncolor=������ɫ;
   if(newyorkB>Ŧ�s����&&newyorks<Ŧ�s����) newyorkcolor=Ԥ����ɫ; else  if(newyorks>=Ŧ�s����&&newyorks<=Ŧ�s����)newyorkcolor=������ɫ;  else newyorkcolor=������ɫ;
 
    //--------------------------------------------------------------       
   if ( ShowLocal_GMT_BROK ) {
      ObjectSetText( "barl", "K     ��", 9, "Arial", ShowLocal��ɫ );
      ObjectSetText( "bart", bars, 9, "Arial", ShowLocal��ɫ );
      ObjectSetText( "gmtl", "��    ׼", 9, "Arial", ShowLocal��ɫ );
      ObjectSetText( "gmtt", GMTs, 9, "Arial", ShowLocal��ɫ );
      ObjectSetText( "brol", "������", 9, "Arial", ShowLocal��ɫ );
      ObjectSetText( "brot", brokers, 9, "Arial", ShowLocal��ɫ );
   }
   //------------------------------------------------
   ObjectSetText( "Sydneyl", "Ϥ��", 9, "Arial Bold", Sydneycolor );     //�Ҽ�
   ObjectSetText( "Sydneyt", Sydneys, 9, "Arial Bold", Sydneycolor );      //�Ҽ�
   ObjectSetText( "tokl", "����", 9, "Arial", tokyocolor );
   ObjectSetText( "tokt", tokyos, 9, "Arial Bold", tokyocolor );
   ObjectSetText( "Eurl", "ŷ��", 9, "Arial", Eurcolor );   //�Ҽ�
   ObjectSetText( "Eurt", Eurs, 9, "Arial Bold", Eurcolor );  //�Ҽ�
   ObjectSetText( "nyl", "ŦԼ", 9, "Arial", newyorkcolor );
   ObjectSetText( "nyt", newyorks, 9, "Arial Bold", newyorkcolor );
   ObjectSetText( "lonl", "�׶�", 9, "Arial", londoncolor );
   ObjectSetText( "lont", londons, 9, "Arial Bold", londoncolor );
   ObjectSetText( "locl", "����", 9, "Arial", ����ʱ����ɫ );
   ObjectSetText( "loct", locals, 9, "Arial Bold", ����ʱ����ɫ );
      
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

