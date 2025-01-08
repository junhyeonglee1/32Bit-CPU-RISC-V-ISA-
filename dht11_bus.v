module top_dht11_bus (
    input         clk,
    input         rst,
    input         cs,
    input         wr,
    input  [31:0] addr,
    input  [31:0] wdata,
    output [31:0] rdata,
    inout         dht_signal
);

    wire [7:0] w_hum_high, w_hum_low, w_tem_high, w_tem_low, w_checksum;

    top_dht11 u_dht11 (
        .clk       (clk),
        .rst       (rst),
        .dht_signal(dht_signal),
        .hum_high  (w_hum_high),
        .hum_low   (w_hum_low),
        .tem_high  (w_tem_high),
        .tem_low   (w_tem_low),
        .checksum  (w_checksum)
    );

    dht11_bus u_dht11_bus (
        .clk  (clk),
        .rst  (rst),
        .cs   (cs),
        .wr   (wr),
        .addr (addr),
        .wdata(wdata),
        .rdata(rdata),
        .hum_high  (w_hum_high),
        .hum_low   (w_hum_low),
        .tem_high  (w_tem_high),
        .tem_low   (w_tem_low),
        .checksum  (w_checksum)
    );


endmodule

module dht11_bus (
    input         clk,
    input         rst,
    input         cs,
    input         wr,
    input  [31:0] addr,
    input  [31:0] wdata,
    output [31:0] rdata,
    input  [ 7:0] hum_high,
    input  [ 7:0] hum_low,
    input  [ 7:0] tem_high,
    input  [ 7:0] tem_low,
    input  [ 7:0] checksum
);

    reg [31:0] regDHT[0:4];
    reg [31:0] temp  [0:4];

    always @(*) begin
        if (clk) begin
            temp[0] = hum_high;
            temp[1] = hum_low;
            temp[2] = tem_high;
            temp[3] = tem_low;
            temp[4] = checksum;
        end else begin
            temp[0] = temp[0];
            temp[1] = temp[1];
            temp[2] = temp[2];
            temp[3] = temp[3];
            temp[4] = temp[4];
        end
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regDHT[0] <= 0;
            regDHT[1] <= 0;
            regDHT[2] <= 0;
            regDHT[3] <= 0;
            regDHT[4] <= 0;
        end
        else begin
            regDHT[0] <= {24'b0, temp[0]};
            regDHT[1] <= {24'b0, temp[1]};
            regDHT[2] <= {24'b0, temp[2]};
            regDHT[3] <= {24'b0, temp[3]};
            regDHT[4] <= {24'b0, temp[4]};
        end
    end


    assign rdata = regDHT[addr[4:2]];

endmodule
