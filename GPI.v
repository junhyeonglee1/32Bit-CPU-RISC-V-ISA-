module GPI(
    input clk,
    input rst,
    input cs,
    input wr,
    input addr,
    input [31:0] wdata,
    output [31:0] rdata,
    input [7:0] gpi
    );

    reg [31:0] regGpi, temp;

    always @(*) begin
        if(clk) temp = gpi; //latch circuit
        else temp = temp;
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regGpi <= 0; // synchronizer
        end
        else begin
            regGpi <= {24'b0, temp};
        end
    end

    assign rdata = regGpi;

endmodule
