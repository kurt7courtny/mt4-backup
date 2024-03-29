#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 Aqua
#property indicator_color2 Blue
#property indicator_color3 Yellow
#property indicator_color4 Green
#property indicator_color5 MediumOrchid
#property indicator_color6 Red
#property indicator_color7 White
#property indicator_color8 Black
#property indicator_width1 1

extern int SMA_variable = 5;
extern int SMA_base = 30;

//extern string ����QQ�� = "";
double g_ibuf_96[];
double g_ibuf_100[];
double g_ibuf_104[];
double g_ibuf_108[];
double g_ibuf_112[];
double g_ibuf_116[];
double g_ibuf_120[];

int init() {
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID);
   SetIndexBuffer(0, g_ibuf_96);
   SetIndexBuffer(1, g_ibuf_100);
   SetIndexBuffer(2, g_ibuf_104);
   SetIndexBuffer(3, g_ibuf_108);
   SetIndexBuffer(4, g_ibuf_112);
   SetIndexBuffer(5, g_ibuf_116);
   SetIndexBuffer(6, g_ibuf_120);
   SetIndexLabel(0, "EUR");
   SetIndexLabel(1, "GBP");
   SetIndexLabel(2, "AUD");
   SetIndexLabel(3, "CAD");
   SetIndexLabel(4, "CHF");
   SetIndexLabel(5, "JPY");
   SetIndexLabel(6, "USD");
   //SMA_variable = SMA_variable * SMA_unit / Period();
   //SMA_base = SMA_base * SMA_unit / Period();
   IndicatorShortName("G7_USD(" + SMA_variable + "," + SMA_base + ")");
   IndicatorDigits(4);
   return (0);
}

int start() {
   double lda_8[6];
   int li_4 = IndicatorCounted();
   if (li_4 > 0) li_4--;
   int li_0 = Bars - li_4;
   for (int li_12 = 0; li_12 < li_0; li_12++) {
      if (SMA_variable == 0) {
         lda_8[0] = iClose("EURUSD", 0, li_12) / iMA("EURUSD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12);
         lda_8[1] = iClose("GBPUSD", 0, li_12) / iMA("GBPUSD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12);
         lda_8[2] = iClose("AUDUSD", 0, li_12) / iMA("AUDUSD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12);
         lda_8[3] = iMA("USDCAD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12) / iClose("USDCAD", 0, li_12);
         lda_8[4] = iMA("USDCHF", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12) / iClose("USDCHF", 0, li_12);
         lda_8[5] = iMA("USDJPY", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12) / iClose("USDJPY", 0, li_12);
      } else {
         if (SMA_variable > 0) {
            lda_8[0] = iMA("EURUSD", 0, SMA_variable, 0, MODE_SMA, PRICE_CLOSE, li_12) / iMA("EURUSD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12);
            lda_8[1] = iMA("GBPUSD", 0, SMA_variable, 0, MODE_SMA, PRICE_CLOSE, li_12) / iMA("GBPUSD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12);
            lda_8[2] = iMA("AUDUSD", 0, SMA_variable, 0, MODE_SMA, PRICE_CLOSE, li_12) / iMA("AUDUSD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12);
            lda_8[3] = iMA("USDCAD", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12) / iMA("USDCAD", 0, SMA_variable, 0, MODE_SMA, PRICE_CLOSE, li_12);
            lda_8[4] = iMA("USDCHF", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12) / iMA("USDCHF", 0, SMA_variable, 0, MODE_SMA, PRICE_CLOSE, li_12);
            lda_8[5] = iMA("USDJPY", 0, SMA_base, 0, MODE_SMA, PRICE_CLOSE, li_12) / iMA("USDJPY", 0, SMA_variable, 0, MODE_SMA, PRICE_CLOSE, li_12);
         }
      }
      g_ibuf_96[li_12] = lda_8[0] * (100 / lda_8[1] + 100.0 + 100 / lda_8[2] + 100 / lda_8[3] + 100 / lda_8[4] + 100 / lda_8[5]) - 600.0;
      //if (����QQ�� == "6303590") {
         g_ibuf_100[li_12] = lda_8[1] * (100 / lda_8[0] + 100.0 + 100 / lda_8[2] + 100 / lda_8[3] + 100 / lda_8[4] + 100 / lda_8[5]) - 600.0;
         g_ibuf_104[li_12] = lda_8[2] * (100 / lda_8[0] + 100.0 + 100 / lda_8[1] + 100 / lda_8[3] + 100 / lda_8[4] + 100 / lda_8[5]) - 600.0;
         g_ibuf_108[li_12] = lda_8[3] * (100 / lda_8[0] + 100.0 + 100 / lda_8[1] + 100 / lda_8[2] + 100 / lda_8[4] + 100 / lda_8[5]) - 600.0;
         g_ibuf_112[li_12] = lda_8[4] * (100 / lda_8[0] + 100.0 + 100 / lda_8[1] + 100 / lda_8[2] + 100 / lda_8[3] + 100 / lda_8[5]) - 600.0;
         g_ibuf_116[li_12] = lda_8[5] * (100 / lda_8[0] + 100.0 + 100 / lda_8[1] + 100 / lda_8[2] + 100 / lda_8[3] + 100 / lda_8[4]) - 600.0;
         g_ibuf_120[li_12] = 100 / lda_8[0] + 100 / lda_8[1] + 100 / lda_8[2] + 100 / lda_8[3] + 100 / lda_8[4] + 100 / lda_8[5] - 600.0;
      //}
   }
   return (0);
}