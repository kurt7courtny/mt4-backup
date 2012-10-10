//+------------------------------------------------------------------+
//|                                                     ibreplay.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
//---- input parameters
extern double    TimeZone=6.8;
extern string    RecordFileName = "5.24-6.15.csv";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   startreplay();
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
      ObjectsDeleteAll(0, OBJ_TREND);
      ObjectsDeleteAll(0, OBJ_ARROW);
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
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

// Replay!
int startreplay()
{
   string strSymbol, strRealSymbol, strDate, strTime, strLot, strTemp;
   double dPrice;
   int ilot, iuptime;
   int pfile = FileOpen(RecordFileName, FILE_CSV|FILE_READ, ",");
   if (pfile < 0) 
   {
      int err=GetLastError();
      Print("error(",err,"): ");
      return (0);
   }
   ObjectsDeleteAll(0, OBJ_TREND);
   ObjectsDeleteAll(0, OBJ_ARROW);
   while (!FileIsEnding(pfile)) 
   {
      strSymbol = FileReadString(pfile);  
      strRealSymbol = checksymbol( strSymbol); 
      if( strRealSymbol == "")
      {
         continue;
      }  
      else
      {
         strDate = FileReadString( pfile);     
         strDate = StringSubstr( strDate, 1, StringLen( strDate) - 1);
         strTime = FileReadString( pfile);     
         strTime = StringSubstr( strTime, 1, StringLen( strTime) - 1);
         strLot = FileReadString( pfile);     
         strLot = StringSubstr( strLot, 1, StringLen( strLot) - 1);
         strTemp = FileReadString( pfile);     
         dPrice = FileReadNumber( pfile);
         //Print("time =", strDate + strTime);
         ilot = StrToInteger( strLot);
         iuptime = StrToTime( StringConcatenate( strDate, " ", strTime));
         iuptime += TimeZone * 3600;
         // time lot price
         DrawTrade( iuptime, ilot, dPrice);
      }
   }
}

//check symbol return the real one
string checksymbol(string strS)
{
   int idot;
   string stresp = "", ss;   
   idot = StringFind( strS, ".");
   if( idot > 0 && idot <= StringLen( strS))
   {
      ss = StringConcatenate( StringSubstr( strS, 0, idot), StringSubstr( strS, idot + 1, StringLen( strS) - idot - 1));
      if( ss == Symbol())
      {
        stresp = ss;  
      }
   }
   return (stresp);
}

void DrawTrade( int iuptime, int ilot, double dprice)
{
   string obname;
   if( ilot > 0)
   {
      obname = StringConcatenate( TimeToStr(iuptime, TIME_DATE|TIME_MINUTES), " Buy ", ilot, " at ", dprice);
      ObjectCreate(obname, OBJ_ARROW, 0, iuptime, dprice);
      ObjectSet(obname, OBJPROP_COLOR, Red);
      ObjectSet(obname, OBJPROP_ARROWCODE, 1);
      ObjectSet(obname, OBJPROP_WIDTH, 1);
   }
   else
   {
      obname = StringConcatenate( TimeToStr(iuptime, TIME_DATE|TIME_MINUTES), " Sell ", ilot, " at ", dprice);
      ObjectCreate(obname, OBJ_ARROW, 0, iuptime, dprice);
      ObjectSet(obname, OBJPROP_COLOR, Blue);
      ObjectSet(obname, OBJPROP_ARROWCODE, 1);
      ObjectSet(obname, OBJPROP_WIDTH, 1);
   }
}