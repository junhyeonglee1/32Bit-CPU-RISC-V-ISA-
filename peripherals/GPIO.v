module GPIO (
    input         clk,
    input         rst,
    input         cs,
    input         wr,
    input  [31:0] addr,
    input  [31:0] wdata,
    output [31:0] rdata,
    inout  [ 7:0] ioPort
);

    reg [31:0] regGPIO[0:2];

    wire [31:0] MODER = regGPIO[0];
    wire [31:0] IDR = regGPIO[1];
    wire [31:0] ODR = regGPIO[2];

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regGPIO[0] <= 0;  //modeR
            regGPIO[2] <= 0;  //ODR
        end else begin
            if (cs & wr) begin
                case (addr[3:2])
                    2'b00: regGPIO[0] <= wdata;  // modeR 
                    2'b10: regGPIO[2] <= wdata;  //ODR]
                endcase
            end
        end
    end

    integer i;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            regGPIO[1] <= 0;
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                if (~MODER[i]) regGPIO[1][i] <= ioPort[i];  //IDR
            end
        end
    end

    genvar j;
    generate
        for ( j=0 ; j<8 ; j=j+1 ) begin
           assign ioPort[j] = MODER[j] ? ODR[j]: 1'bz;
    end
    endgenerate

    assign rdata = regGPIO[addr[31:2]];

endmodule
