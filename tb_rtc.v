`timescale 1ns / 1ps

module tb_rtc ();

    reg clk, rst;


    // RTC dut_rtc (
    //     .clk  (clk),
    //     .reset(rst),
    //     .wr   (),
    //     .cs   (),
    //     .addr (addr),
    //     .wdata(),
    //     .rdata(rdata)
    // );
    RISCV_MCU u_dut(
    .clk(clk),
    .reset(rst),
    .GPIB(),
    .GPOA(),
    .GPIOC(),
    .FNDCom(),
    .FNDFont()
);


    always #5 clk = ~clk;

    initial begin
        #00 rst = 1; clk = 0;
        #10 rst = 0;
    end

endmodule
