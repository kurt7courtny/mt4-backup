//+------------------------------------------------------------------+
//|                                                     MsgAlert.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"
#define ObjName "BandsAlert"

#property indicator_chart_window
//---- input parameters
extern double  bandwidth  = 0.0006;
extern int     continuous = 3;
extern bool		EmailAlert	= false;
extern bool		PopupAlert	= true;


int lastime = 0;
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
   bool found = false;
   if( lastime != iTime(NULL, PERIOD_D1, 0))
   {
      for( int i = 1; i < 1 + continuous; i++)
      {
         if( iHigh( NULL, PERIOD_D1, i) - iLow( NULL, PERIOD_D1, i) <= bandwidth)
         {  
            found = true;
         }
         else
         {
            found = false;
            break;
         }
      }
      if( found)
      {
         createIndicatorLabel( ObjName, "true");
      }
      else
      {  
         createIndicatorLabel( ObjName, "false");
      }
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void createIndicatorLabel(string sObjName, string tof) {
	
	// Set the text
	string sObjText = "Alerter: bandwidth: " + bandwidth + " continue days: " + continuous + "---: " + tof;
	//if (EmailAlert) sObjText = sObjText + "  Emails Alerts ON.";
	//else            sObjText = sObjText + "  Emails Alerts OFF.";
	//if (PopupAlert) sObjText = sObjText + "  Popup Alerts ON.";
	//else			sObjText = sObjText + "  Popup Alerts OFF.";
	ObjectDelete( sObjName);
	// Create and position the label
	ObjectCreate(sObjName,OBJ_LABEL,0,0,0);
	ObjectSetText(sObjName,sObjText,8,"Arial",Yellow);
	ObjectSet(sObjName,OBJPROP_XDISTANCE,5);
	ObjectSet(sObjName,OBJPROP_YDISTANCE,5);
	ObjectSet(sObjName,OBJPROP_CORNER,1);
	
}