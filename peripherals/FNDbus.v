module FNDbus_top (
    input         clk,
    input         rst,
    input         cs,
    input         wr,
    input  [31:0] addr,
    input  [31:0] wdata,
    output [31:0] rdata,
    output [ 3:0] FNDCom,
    output [ 7:0] FNDFont
);

    wire w_FCR;
    wire [13:0] w_FDR;

    FNDbus u_FNDbus_0 (
        .clk  (clk),
        .rst  (rst),
        .cs   (cs),
        .wr   (wr),
        .addr (addr),
        .wdata(wdata),
        .rdata(rdata),
        .FCR  (w_FCR),
        .FDR  (w_FDR)
    );

    FNDController u_FNDController_IP (
        .clk    (clk),
        .rst    (rst),
        .FCR    (w_FCR),
        .FDR    (w_FDR),
        .FNDCom (FNDCom),
        .FNDFont(FNDFont)
    );

endmodule

module FNDbus (
    input         clk,
    input         rst,
    input         cs,
    input         wr,
    input  [31:0] addr,
    input  [31:0] wdata,
    output [31:0] rdata,
    output        FCR,
    output [13:0] FDR
);
    reg [13:0] regFND[0:1];

    assign FCR = regFND[0][0];
    assign FDR = regFND[1][13:0];

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regFND[0] <= 0;
            regFND[1] <= 0;
        end else begin
            if (cs & wr) begin
                case (addr[2])
                    2'b0: regFND[0] <= wdata;
                    2'b1: regFND[1] <= wdata;
                endcase
            end
        end
    end

    assign rdata = {24'b0, regFND[addr[2]]};


endmodule


module FNDController (
    input         clk,
    input         rst,
    input         FCR,
    input  [13:0] FDR,
    output [ 3:0] FNDCom,
    output [ 7:0] FNDFont
);

    wire w_1khz;
    wire [1:0] w_cnt;
    wire [3:0] w_digit, w_dig_1, w_dig_10, w_dig_100, w_dig_1000;

    clkDiv_1kHz u_clk_1khz (
        .clk  (clk),
        .rst  (rst),
        .o_clk(w_1khz)
    );

    counter u_4counter (
        .clk  (w_1khz),
        .rst  (rst),
        .count(w_cnt)
    );

    decoder_2x4 u_decoder_2x4 (
        .en(FCR),
        .x (w_cnt),
        .y (FNDCom)
    );

    digitSplitter u_digitsplitter (
        .x       (FDR),
        .dig_1   (w_dig_1),
        .dig_10  (w_dig_10),
        .dig_100 (w_dig_100),
        .dig_1000(w_dig_1000)

    );

    mux_4x1 u_mux_4x1_1 (
        .sel(w_cnt),
        .x0 (w_dig_1),
        .x1 (w_dig_10),
        .x2 (w_dig_100),
        .x3 (w_dig_1000),
        .y  (w_digit)
    );

    BIN2SEG u_bin2seg_0 (
        .bin(w_digit),
        .seg(FNDFont)
    );

endmodule

module BIN2SEG (
    input [3:0] bin,
    output reg [7:0] seg
);

    always @(bin) begin
        case (bin)
            4'h0: seg = 8'hc0;
            4'h1: seg = 8'hf9;
            4'h2: seg = 8'ha4;
            4'h3: seg = 8'hb0;
            4'h4: seg = 8'h99;
            4'h5: seg = 8'h92;
            4'h6: seg = 8'h82;
            4'h7: seg = 8'hf8;
            4'h8: seg = 8'h80;
            4'h9: seg = 8'h90;
            4'ha: seg = 8'h88;
            4'hb: seg = 8'h83;
            4'hc: seg = 8'hc6;
            4'hd: seg = 8'ha1;
            4'he: seg = 8'h86;
            4'hf: seg = 8'h8e;
        endcase
    end
endmodule

module decoder_2x4 (
    input        en,
    input  [1:0] x,
    output [3:0] y
);

    reg [3:0] y1;

    always @(*) begin
            case (x)
                2'b00: y1 = 4'b1110;
                2'b01: y1 = 4'b1101;
                2'b10: y1 = 4'b1011;
                2'b11: y1 = 4'b0111;
            endcase
    end

    assign y = (en) ? y1 : 4'b1111;

endmodule

module digitSplitter (
    input  [13:0] x,
    output [ 3:0] dig_1,
    output [ 3:0] dig_10,
    output [ 3:0] dig_100,
    output [ 3:0] dig_1000

);

    assign dig_1    = x % 10;
    assign dig_10   = x / 10 % 10;
    assign dig_100  = x / 100 % 10;
    assign dig_1000 = x / 1000 % 10;

endmodule

module mux_4x1 (
    input [1:0] sel,
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    output reg [3:0] y
);

    always @(*) begin
        case (sel)
            2'b00: y = x0;
            2'b01: y = x1;
            2'b10: y = x2;
            2'b11: y = x3;
        endcase
    end

endmodule

module counter (
    input        clk,
    input        rst,
    output [1:0] count
);
    reg [1:0] r_counter;
    assign count = r_counter;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_counter <= 0;
        end else begin
            if (r_counter == 3) r_counter <= 0;
            else r_counter <= r_counter + 1;
        end
    end

endmodule

module clkDiv_1kHz (
    input  clk,
    input  rst,
    output o_clk
);

    reg [16:0] r_counter;
    reg r_clk;
    assign o_clk = r_clk;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if (r_counter == 100_000 - 1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end

endmodule
