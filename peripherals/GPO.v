`timescale 1ns / 1ps

module GPO (
    input clk,
    input rst,
    input cs,
    input wr,
    input addr,
    input [31:0] wdata,
    output [31:0] rdata,
    output [7:0] gpo
);

    reg [7:0] reg_gpo;
    assign gpo = reg_gpo;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            reg_gpo <= 0;
        end else begin
            if (cs & wr) reg_gpo <= wdata;
        end
    end

    assign rdata = {24'b0, reg_gpo};

endmodule
