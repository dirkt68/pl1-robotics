module current_sensor(
   input CLK100MHZ,
   input VPA,
   input VNA,
   input VPB,
   input VNB,
   output [11:0] current_value
 );
   
   wire enable;  
   wire ready;
   wire [15:0] data;   
   wire [6:0] Address_in;     
   reg [32:0] decimal;   
   reg [3:0] dig0;
   reg [3:0] dig1;
   reg [3:0] dig2;
   reg [3:0] dig3;
   reg [3:0] dig4;
   reg [3:0] dig5;
   reg [3:0] dig6;

    assign Address_in = 7'b0010110;
   
   //xadc instantiation connect the eoc_out .den_in to get continuous conversion
   xadc_wiz_0  XLXI_7 (.daddr_in(Address_in), //addresses can be found in the artix 7 XADC user guide DRP register space
                     .dclk_in(CLK100MHZ), 
                     .den_in(enable), 
                     .di_in(0), 
                     .dwe_in(), 
                     .busy_out(),                    
                     .vauxp6(VPA),
                     .vauxn6(VNA),
                     .vauxp14(VPB),
                     .vauxn14(VNB),
                     .vn_in(0), 
                     .vp_in(0), 
                     .alarm_out(), 
                     .do_out(data), 
                     .eoc_out(enable),
                     .channel_out(),
                     .drdy_out(ready));
      
     reg [32:0] count; 
     //binary to decimal conversion
      always @ (posedge(CLK100MHZ))
      begin
      
        if(count == 10000000)begin
        
        decimal = data >> 4;
        //looks nicer if our max value is 1V instead of .999755
        if(decimal >= 4093)
        begin
            dig0 = 0;
            dig1 = 0;
            dig2 = 0;
            dig3 = 0;
            dig4 = 0;
            dig5 = 0;
            dig6 = 1;
            count = 0;
        end
        else 
        begin
            decimal = decimal * 250000;
            decimal = decimal >> 10;
            
            
            dig0 = decimal % 10;
            decimal = decimal / 10;
            
            dig1 = decimal % 10;
            decimal = decimal / 10;
                   
            dig2 = decimal % 10;
            decimal = decimal / 10;
            
            dig3 = decimal % 10;
            decimal = decimal / 10;
            
            dig4 = decimal % 10;
            decimal = decimal / 10;
                   
            dig5 = decimal % 10;
            decimal = decimal / 10; 
            
            dig6 = decimal % 10;
            decimal = decimal / 10; 
            
            count = 0;
        end
       end
       
      count = count + 1;
               
      end
      assign current_value [11:8] = dig4;
      assign current_value [7:4] = dig5;
      assign current_value [3:0] = dig6;
endmodule