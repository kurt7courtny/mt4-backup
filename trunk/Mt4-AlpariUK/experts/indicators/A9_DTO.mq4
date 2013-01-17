//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1 Blue
#property indicator_color2 MediumSeaGreen
#property indicator_color3 MediumSpringGreen
#property indicator_color4 Coral
#property indicator_color5 Red

//---- input parameters


extern bool		EmailAlert	= false;
extern bool		PopupAlert	= false;

extern int DTO_MA = 8;
extern int DTO_HL = 55;
extern int DTO_REF1 = 1;
extern int DTO_REF2 = 56;

double DTOBuffer[];
double DTOBufferRH1[];
double DTOBufferRH2[];
double DTOBufferRL1[];
double DTOBufferRL2[];

//int count=0;
int deinit()
  {
   return(0);
  }
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(5);
   SetIndexBuffer(0, DTOBuffer);
   SetIndexBuffer(1, DTOBufferRH1);
   SetIndexBuffer(2, DTOBufferRH2);
   SetIndexBuffer(3, DTOBufferRL1);
   SetIndexBuffer(4, DTOBufferRL2);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE, STYLE_DOT);
   SetIndexStyle(2,DRAW_LINE, STYLE_DASH);
   SetIndexStyle(3,DRAW_LINE, STYLE_DOT);
   SetIndexStyle(4,DRAW_LINE, STYLE_DASH);
   
   //SetIndexShift(0, 0);
   //SetIndexShift(1, 1);
   //SetIndexShift(2, 1);
   //SetIndexShift(3, 1);
   //SetIndexShift(4, 1);
   
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("DTO");
   SetIndexLabel(0,"DTO");
   SetIndexLabel(1,"DTO H Ref1");
   SetIndexLabel(2,"DTO H Ref2");
   SetIndexLabel(3,"DTO L Ref1");
   SetIndexLabel(4,"DTO L Ref2");
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, -100);
   SetIndexEmptyValue(2, -100);
   SetIndexEmptyValue(3, 100);
   SetIndexEmptyValue(4, 100);
   SetLevelValue(0,0);
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
/*
DTO:C-MA((H+L)/2,8);
REF(HHV(DTO,55),1),COLORRED;
REF(LLV(DTO,55),1),COLORRED;
REF(HHV(DTO,55),56),COLORGREEN;
REF(LLV(DTO,55),56),COLORGREEN;
*/
//---- 
   for(i=0; i<limit; i++)
   {
      DTOBuffer[i]=Close[i]-iMA(NULL, NULL, DTO_MA, 0, MODE_SMA, PRICE_MEDIAN,i);
      Print("DTO:",DTOBuffer[i]);
   }
   
   for(i=0; i<limit-DTO_REF2-DTO_HL; i++)
   {
      for(k=0;k<=DTO_HL;k++)
      {
         DTOBufferRH1[i]=MathMax(DTOBufferRH1[i], DTOBuffer[i+k+DTO_REF1]);
         DTOBufferRL1[i]=MathMin(DTOBufferRL1[i], DTOBuffer[i+k+DTO_REF1]);
         DTOBufferRH2[i]=MathMax(DTOBufferRH2[i], DTOBuffer[i+k+DTO_REF2]);
         DTOBufferRL2[i]=MathMin(DTOBufferRL2[i], DTOBuffer[i+k+DTO_REF2]);  
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+