//+------------------------------------------------------------------+
//|                                                   KJEUCandle.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#include <WinUser32.mqh>

extern double Version = 1.3;
extern string BuildInfo = "2010.11.06 by kurt";
extern int PeriodInfo = 3;
extern bool Enabled = TRUE;
extern bool Debug = FALSE;

extern int tz = 1;
extern int jpysta = -1;
extern int jpyend = 5;
extern int jesta = 6;
extern int jeend = 8;
extern int eursta = 9;
extern int eurend = 14;
extern int eusta = 15;
extern int euend = 17;
extern int usdsta = 18;
extern int usdend = 21;

int      FileHandle = -1; 
int      lastfpos = 0;
#define  CHART_CMD_UPDATE_DATA            33324 
#define  D1                               86400 
 
void DebugMsg(string msg) 
{ 
   if (Debug) Alert(msg); 
} 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
//----
   if (OpenHistoryFile() < 0) 
   {
      Print("open file failed");
      return (-1);
   }
   WriteHistoryHeader(); 
   UpdateChartWindow(); 
   jpysta += tz;
   jpyend += tz;
   eursta += tz;
   eurend += tz;
   usdsta += tz;
   usdend += tz;
   return (0); 
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{ 
   //Close file handle 
   if(FileHandle >=  0) {  
      FileClose(FileHandle);  
      FileHandle = -1;  
      return (0);
   } 
}
   
int OpenHistoryFile() 
{ 
   FileHandle = FileOpenHistory(Symbol()+PeriodInfo+".hst", FILE_BIN|FILE_WRITE); 
   if(FileHandle < 0) return(-1); 
   return (0); 
}

int WriteHistoryHeader() 
{
   string c_copyright; 
   int    i_digits = Digits; 
   int    i_unused[13] = {0}; 
   int    version = 400;    
 
   if (FileHandle < 0) return (-1); 
   c_copyright = "(C)opyright 2003, MetaQuotes Software Corp."; 
   FileWriteInteger(FileHandle, version, LONG_VALUE); 
   FileWriteString(FileHandle, c_copyright, 64); 
   FileWriteString(FileHandle, Symbol(), 12); 
   FileWriteInteger(FileHandle, PeriodInfo, LONG_VALUE); 
   FileWriteInteger(FileHandle, i_digits, LONG_VALUE); 
   FileWriteInteger(FileHandle, 0, LONG_VALUE);       //timesign 
   FileWriteInteger(FileHandle, 0, LONG_VALUE);       //last_sync 
   FileWriteArray(FileHandle, i_unused, 0, ArraySize(i_unused)); 
   lastfpos=FileTell(FileHandle);
   Print("Write File Header OK");
   return (0); 
} 

int WriteHistoryFile( int recordnumb) 
{
   double value[5][6];
   for( int j = 0; j < 6; j ++)
   {
      value[0][j]=0;
      value[1][j]=0;
      value[2][j]=0;
      value[3][j]=0;
      value[4][j]=0;
   }
   value[0][2]=100000;
   value[1][2]=100000;
   value[2][2]=100000;
   value[3][2]=100000;
   value[4][2]=100000;
   
   static int LastWriteTime=0; 
   for( int i = recordnumb; i < recordnumb + 24; i++)
   {
      datetime iNow = iTime( Symbol(), PERIOD_H1, i);
      datetime dt = iNow / D1 * D1;
      //Print("iNow " , iNow + " i " + i);
      if(  iNow >= dt + jpysta * 3600 && iNow < dt + jpyend * 3600)
      {
         value[0][0] = iOpen( Symbol(), PERIOD_H1, i);
         value[0][1] = MathMax( iHigh( Symbol(), PERIOD_H1, i), value[0][1]);
         value[0][2] = MathMin( iLow( Symbol(), PERIOD_H1, i), value[0][2]);
         if( value[0][3] == 0)
            value[0][3] = iClose( Symbol(), PERIOD_H1, i);
         value[0][4] += iVolume( Symbol(), PERIOD_H1, i);
         value[0][5] = iNow;
      } 
      if(  iNow >= dt + jesta * 3600 && iNow < dt + jeend * 3600)
      {
         value[1][0] = iOpen( Symbol(), PERIOD_H1, i);
         value[1][1] = MathMax( iHigh( Symbol(), PERIOD_H1, i), value[1][1]);
         value[1][2] = MathMin( iLow( Symbol(), PERIOD_H1, i), value[1][2]);
         if( value[1][3] == 0)
            value[1][3] = iClose( Symbol(), PERIOD_H1, i);
         value[1][4] += iVolume( Symbol(), PERIOD_H1, i);
         value[1][5] = iNow;
      } 
      if(  iNow >= dt + eursta * 3600 && iNow < dt + eurend * 3600)
      {
         value[2][0] = iOpen( Symbol(), PERIOD_H1, i);
         value[2][1] = MathMax( iHigh( Symbol(), PERIOD_H1, i), value[2][1]);
         value[2][2] = MathMin( iLow( Symbol(), PERIOD_H1, i), value[2][2]);
         if( value[2][3] == 0)
            value[2][3] = iClose( Symbol(), PERIOD_H1, i);
         value[2][4] += iVolume( Symbol(), PERIOD_H1, i);
         value[2][5] = iNow;
      }
      if(  iNow >= dt + eusta * 3600 && iNow < dt + euend * 3600)
      {
         value[3][0] = iOpen( Symbol(), PERIOD_H1, i);
         value[3][1] = MathMax( iHigh( Symbol(), PERIOD_H1, i), value[3][1]);
         value[3][2] = MathMin( iLow( Symbol(), PERIOD_H1, i), value[3][2]);
         if( value[3][3] == 0)
            value[3][3] = iClose( Symbol(), PERIOD_H1, i);
         value[3][4] += iVolume( Symbol(), PERIOD_H1, i);
         value[3][5] = iNow;
      }
      if(  iNow >= dt + usdsta * 3600 && iNow < dt + usdend * 3600)
      {
         value[4][0] = iOpen( Symbol(), PERIOD_H1, i);
         value[4][1] = MathMax( iHigh( Symbol(), PERIOD_H1, i), value[4][1]);
         value[4][2] = MathMin( iLow( Symbol(), PERIOD_H1, i), value[4][2]);
         if( value[4][3] == 0)
            value[4][3] = iClose( Symbol(), PERIOD_H1, i);
         value[4][4] += iVolume( Symbol(), PERIOD_H1, i);
         value[4][5] = iNow;
      }

      if( MathMod( iNow / 3600 , 24) == MathMod( jpysta + 24, 24)) 
      {
         if( iNow / 3600 / 24 != LastWriteTime)
         {
            LastWriteTime = iNow / 3600 / 24;   
            lastfpos=FileTell(FileHandle);
         }
         break;
      }
 
   }
   FileSeek( FileHandle, lastfpos, SEEK_SET);
   for( i = 0; i < 5 && value[i][4] != 0; i++)
   {
      dt = value[i][5];
      
      FileWriteInteger(FileHandle, dt, LONG_VALUE); 
      FileWriteDouble(FileHandle, value[i][0], DOUBLE_VALUE); 
      FileWriteDouble(FileHandle, value[i][2], DOUBLE_VALUE); 
      FileWriteDouble(FileHandle, value[i][1], DOUBLE_VALUE); 
      FileWriteDouble(FileHandle, value[i][3], DOUBLE_VALUE); 
      FileWriteDouble(FileHandle, value[i][4], DOUBLE_VALUE);  
      Print("write record " + i );
   }
   return (0);
}

int UpdateChartWindow() 
{ 
   static int hwnd = 0; 
 
   if(hwnd == 0) { 
      //trying to detect the chart window for updating 
      hwnd = WindowHandle(Symbol(), PeriodInfo); 
   } 
   if(hwnd!= 0) { 
      if (IsDllsAllowed() == false) { 
         //DLL calls must be allowed 
         DebugMsg("Dll calls must be allowed"); 
         return (-1); 
      } 
      if (PostMessageA(hwnd,WM_COMMAND,CHART_CMD_UPDATE_DATA,0) == 0) { 
         //PostMessage failed, chart window closed 
         hwnd = 0; 
      } else { 
         //PostMessage succeed 
         return (0); 
      } 
   } 
   //window not found or PostMessage failed 
   return (-1); 
} 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
   UpdateChartWindow();
//----
   return(0);
  }
//+------------------------------------------------------------------+