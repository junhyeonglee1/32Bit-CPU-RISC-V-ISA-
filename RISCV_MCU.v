`timescale 1ns / 1ps

module RISCV_MCU (
    input        clk,
    input        reset,
    input  [7:0] GPIB,
    output [7:0] GPOA,
    inout  [7:0] GPIOC,
    output [3:0] FNDCom,
    output [7:0] FNDFont,
    inout dht_signal
); 
    wire [31:0] instrData, instrAddr;
    wire [31:0] DRdData, DWrData, DAddr;
    wire       DWe;
    wire [1:0] BHW;
    wire [6:0] w_addrSel;

    wire [31:0] w_ramRdData, w_gpoRdData, w_gpiRdData, w_gpioRdData, w_rtcRdData, w_FNDRdData,w_dht11RdData;

    RV32I_Core U_MCU (
        .clk      (clk),
        .reset    (reset),
        .instrData(instrData),
        .instrAddr(instrAddr),
        .DRdData  (DRdData),
        .DWrData  (DWrData),
        .DWe      (DWe),
        .DAddr    (DAddr),
        .BHW      (BHW)
    );

    ROM U_ROM (
        .addr(instrAddr),
        .data(instrData)
    );

    addrDecoder u_addrDecoder (
        .DAddr(DAddr),
        .sel  (w_addrSel)
    );

    addrMux u_addrMux (
        .DAddr(DAddr),
        .a(w_ramRdData),
        .b(w_gpoRdData),
        .c(w_gpiRdData),
        .d(w_gpioRdData),
        .e(w_FNDRdData),
        .f(w_dht11RdData),
        .g(w_rtcRdData),
        .y(DRdData)
    );

    RAM U_RAM (
        .clk  (clk),
        .cs   (w_addrSel[0]),
        .we   (DWe),
        .addr (DAddr[7:0]),
        .wdata(DWrData),
        .rdata(w_ramRdData),
        .BHW  (BHW)
    );

    GPO u_GPOA (
        .clk  (clk),
        .rst  (reset),
        .cs   (w_addrSel[1]),
        .wr   (DWe),
        .addr (DAddr[7:0]),
        .wdata(DWrData),
        .rdata(w_gpoRdData),
        .gpo  (GPOA)
    );


    GPI u_GPIB (
        .clk  (clk),
        .rst  (reset),
        .cs   (w_addrSel[2]),
        .wr   (DWe),
        .addr (DAddr[7:0]),
        .wdata(DWrData),
        .rdata(w_gpiRdData),
        .gpi  (GPIB)
    );

    GPIO u_GPIO_0 (
        .clk  (clk),
        .rst  (reset),
        .cs   (w_addrSel[3]),
        .wr   (DWe),
        .addr (DAddr),
        .wdata(DWrData),
        .rdata(w_gpioRdData),
        .ioPort  (GPIOC)
    );

    FNDbus_top u_FNDbus_top (
        .clk  (clk),
        .rst  (reset),
        .cs   (w_addrSel[4]),
        .wr   (DWe),
        .addr (DAddr),
        .wdata(DWrData),
        .rdata(w_FNDRdData),
        .FNDCom(FNDCom),
        .FNDFont(FNDFont)
    );

    top_dht11_bus u_top_DHT11_bus(
        .clk  (clk),
        .rst  (reset),
        .cs   (w_addrSel[5]),
        .wr   (DWe),
        .addr (DAddr),
        .wdata(DWrData),
        .rdata(w_dht11RdData),
        .dht_signal(dht_signal)
    );

     RTC U_RTC (
        .clk  (clk),
        .reset(reset),
        .cs   (w_addrSel[6]),
        .wr   (DWe),
        .addr (DAddr),
        .wdata(DWrData),
        .rdata(w_rtcRdData)
    );

endmodule

module addrDecoder (
    input [31:0] DAddr,
    output reg [6:0] sel
);

    always @(*) begin
        casex (DAddr)
            32'h0000_02xx: sel = 7'b0000001;  // RAM
            32'h4000_00xx: sel = 7'b0000010;  // GPO
            32'h4000_01xx: sel = 7'b0000100;  // GPI
            32'h4000_02xx: sel = 7'b0001000;  // GPIO
            32'h4000_03xx: sel = 7'b0010000;  // FND
            32'h4000_04xx: sel = 7'b0100000;  // DHT11
            32'h4000_07xx: sel = 7'b1000000;  // rtc
            default: sel = 7'bxx;
        endcase
    end

endmodule

module addrMux (
    input [31:0] DAddr,
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input [31:0] e,
    input [31:0] f,
    input [31:0] g,
    output reg [31:0] y
);

    always @(*) begin
        casex (DAddr)
            32'h0000_02xx: y = a;  // RAM
            32'h4000_00xx: y = b;  // GPO
            32'h4000_01xx: y = c;  // GPI
            32'h4000_02xx: y = d;  // GPIO
            32'h4000_03xx: y = e;  // FND
            32'h4000_04xx: y = f;  // DHT11
            32'h4000_07xx: y = g;  // rtc
            default: y = 32'bx;
        endcase
    end

endmodule
