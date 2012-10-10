//+------------------------------------------------------------------+
//|                                                      KCandle.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#include <WinUser32.mqh>

extern double Version = 1.3;
extern string BuildInfo = "2010.11.06 by kurt";
extern int tz = 1;
extern bool Enabled = TRUE;
extern bool Debug = FALSE;

int g_file = -1;
int g_filepos = 0;
int gi_164 = 0;

int g_time_start=0;
int g_time_end=0;

double value[3][8];

int jpy[9] ={-1,0 ,1 ,2 ,3 ,4 ,5 ,6 ,7 }; 
int eur[9] ={6 ,7 ,8 ,9 ,10,11,12,13,14};
int usd[9] ={12,13,14,15,16,17,18,19,20};
int sep=22;

void DebugMsg(string info) {
   if (Debug) Alert(info);
}

void resetvalue() {   
   for( int i = 0; i < 3; i++)
      for( int j = 0; j < 8; j++) 
         value[i][j]=0;
}

int init()
  {
//---- indicators
//----
   for( int k =0; k < 9; k++) {
      jpy[k]=(jpy[k]+tz)%24;
      Print("reset jpy ", k ," to ", jpy[k]);
      eur[k]=(eur[k]+tz)%24;
      usd[k]=(usd[k]+tz)%24;
   }
   resetvalue();
   OpenHistoryFile();
   WriteHistoryHeader();
   return(0);
  }


int deinit()
  {
//----
      if (g_file >= 0) {
      FileClose(g_file);
      g_file = -1;
  }

//----
   return(0);
  }

int OpenHistoryFile() {
   g_file = FileOpenHistory(Symbol() + "100.hst", FILE_BIN|FILE_WRITE);
   if (g_file < 0) return (-1);
   return (0);
}

int WriteHistoryHeader() {
   int l_digits_8 = Digits;
   int lia_12[13] = {0};
   int li_16 = 400;
   if (g_file < 0) return (-1);
   string ls_0 = "(C)opyright 2003, MetaQuotes Software Corp.";
   FileWriteInteger(g_file, li_16, LONG_VALUE);
   FileWriteString(g_file, ls_0, 64);
   FileWriteString(g_file, Symbol(), 12);
   FileWriteInteger(g_file, 100, LONG_VALUE);
   FileWriteInteger(g_file, l_digits_8, LONG_VALUE);
   FileWriteInteger(g_file, 0, LONG_VALUE);
   FileWriteInteger(g_file, 0, LONG_VALUE);
   FileWriteArray(g_file, lia_12, 0, ArraySize(lia_12));
   g_filepos = FileTell( g_file);
   return (0);
}

int WriteHistoryFile( int recordnumb) {
   datetime dt = iTime( NULL, PERIOD_H1, recordnumb);
   int ih=(dt/3600)%24;
   // sep time
   Print("recn = ", recordnumb, " ih = ", ih);
   if( ih==sep) {
      resetvalue();
      g_filepos = FileTell( g_file);
      Print("reset value, file pos ", g_filepos);
   }
   
   //jpy start 
   if( ih==jpy[0] && value[0][0]==0) {
      value[0][0]=dt;
      value[0][1]=iOpen(NULL, PERIOD_H1, recordnumb);
      Print( "jpy start set time and open price", value[0][1]);
   }
      
   // eur start
   if( ih==eur[0] && value[1][0]==0) {
      value[1][0]=dt;
      value[1][1]=iOpen(NULL, PERIOD_H1, recordnumb);
   }   
   
   // usd start
   if( ih==usd[0] && value[2][0]==0) {
      value[2][0]=dt;
      value[2][1]=iOpen(NULL, PERIOD_H1, recordnumb);
   }
   
   // set value
   for( int i = 0; i < 9; i++) {
      if( ih==jpy[i]) {
         if( value[0][2]==0)
            value[0][2]=iLow(NULL, PERIOD_H1, recordnumb);
         else
            value[0][2]=MathMin( value[0][2], iLow(NULL, PERIOD_H1, recordnumb));
            
         value[0][3]=MathMax( iHigh(NULL, PERIOD_H1, recordnumb), value[0][2]);
         value[0][4]=iClose(NULL, PERIOD_H1, recordnumb);
         if( value[0][6] != dt) {
            if( value[0][5] == 0)
               value[0][5]=iVolume(NULL, PERIOD_H1, recordnumb);
            value[0][6]=dt;
            value[0][7]=value[0][5];
         }
         else {
            value[0][5]=value[0][7]+iVolume(NULL, PERIOD_H1, recordnumb);
            // Print("volume ", iVolume(NULL, PERIOD_H1, recordnumb));
         }
         Print("values JPY ", value[0][0]," ", value[0][1]," ", value[0][2]," ", value[0][3]," ", value[0][4]," ", value[0][5]);
      }
      if( ih==eur[i]) {
         if( value[1][2]==0)
            value[1][2]=iLow(NULL, PERIOD_H1, recordnumb);
         else
            value[1][2]=MathMin( value[1][2], iLow(NULL, PERIOD_H1, recordnumb));
            
         value[1][3]=MathMax( iHigh(NULL, PERIOD_H1, recordnumb), value[1][2]);
         value[1][4]=iClose(NULL, PERIOD_H1, recordnumb);
         if( value[1][6] != dt) {
            if( value[1][5] == 0)
               value[1][5]=iVolume(NULL, PERIOD_H1, recordnumb);
            value[1][6]=dt;
            value[1][7]=value[1][5];
         }
         else {
            value[1][5]=value[01][7]+iVolume(NULL, PERIOD_H1, recordnumb);
            // Print("volume ", iVolume(NULL, PERIOD_H1, recordnumb));
         }
         Print("values 1 ", value[1][0]," ", value[1][1]," ", value[1][2]," ", value[1][3]," ", value[1][4]," ", value[1][5]);
      }
      if( ih==usd[i]) {
         if( value[2][2]==0)
            value[2][2]=iLow(NULL, PERIOD_H1, recordnumb);
         else
            value[2][2]=MathMin( value[2][2], iLow(NULL, PERIOD_H1, recordnumb));
            
         value[2][3]=MathMax( iHigh(NULL, PERIOD_H1, recordnumb), value[2][2]);
         value[2][4]=iClose(NULL, PERIOD_H1, recordnumb);
         if( value[2][6] != dt) {
            if( value[2][5] == 0)
               value[2][5]=iVolume(NULL, PERIOD_H1, recordnumb);
            value[2][6]=dt;
            value[2][7]=value[2][5];
         }
         else {
            value[2][5]=value[2][7]+iVolume(NULL, PERIOD_H1, recordnumb);
            // Print("volume ", iVolume(NULL, PERIOD_H1, recordnumb));
         }
         Print("values 2 ", value[2][0]," ", value[2][1]," ", value[2][2]," ", value[2][3]," ", value[2][4]," ", value[2][5]);
      }
   }
   FileSeek( g_file, g_filepos, SEEK_SET);
   for( i =0;i<3;i++) {
      if(value[i][0]*value[i][1]*value[i][2]*value[i][3]*value[i][4]*value[i][5]!=0) {
         FileWriteInteger(g_file, value[i][0], LONG_VALUE);
         FileWriteDouble(g_file, value[i][1], DOUBLE_VALUE);
         FileWriteDouble(g_file, value[i][2], DOUBLE_VALUE);
         FileWriteDouble(g_file, value[i][3], DOUBLE_VALUE);
         FileWriteDouble(g_file, value[i][4], DOUBLE_VALUE);
         FileWriteDouble(g_file, value[i][5], DOUBLE_VALUE);
         FileFlush(g_file);
         //Print("write file");
      }
   }
   //if( dt
   return (0);
}

int UpdateChartWindow() {
   if (gi_164 == 0) gi_164 = WindowHandle(Symbol(), PERIOD_H1);
   if (gi_164 != 0) {
      if (IsDllsAllowed() == FALSE) {
         DebugMsg("Dll calls must be allowed");
         return (-1);
      }
      if (PostMessageA(gi_164, WM_COMMAND, 33324, 0) == 0) gi_164 = 0;
      else return (0);
   }
   return (-1);
}

int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   while( limit >=0) {
      WriteHistoryFile( limit);
      limit--;
   }
   //UpdateChartWindow();
//----
   return(0);
  }
//+------------------------------------------------------------------+