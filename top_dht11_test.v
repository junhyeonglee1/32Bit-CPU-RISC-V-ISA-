`timescale 1ns / 1ps

module tb_dht11 ();

    reg clk, rst;
    reg dht11_sig;
    reg start;
    wire [7:0] w_hum_high, w_hum_low, w_tem_high, w_tem_low, w_checksum;
    wire w_dht11_sig;

    assign w_dht11_sig = dht11_sig;

    top_dht11 dut1 (
        .clk       (clk),
        .rst       (rst),
        //.start     (start),
        .dht_signal(w_dht11_sig),
        .hum_high  (w_hum_high),
        .hum_low   (w_hum_low),
        .tem_high  (w_tem_high),
        .tem_low   (w_tem_low),
        .checksum  (w_checksum)
    );

    always #5 clk = ~clk;

    initial begin
        #00 clk = 0;
        rst = 1;
        dht11_sig = 1'bz;
        #10 rst = 0;
        #9005 dht11_sig = 1;
        #5000 dht11_sig = 0;  //to readyLOW
        #8000 dht11_sig = 1;  //to readyHIGH
        //==================hum_HIGH=============================//
        #8000 dht11_sig = 0;  //to DATALOW bit[0]
        #5000 dht11_sig = 1;  //to DATAHIGH bit[0]
        #3000 dht11_sig = 0;  //to DATALOW bit[1] bit[0] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[1]
        #3000 dht11_sig = 0;  //to DATALOW bit[2] bit[1] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[2]
        #3000 dht11_sig = 0;  //to DATALOW bit[3] bit[2] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[3]
        #3000 dht11_sig = 0;  //to DATALOW bit[4] bit[3] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[4]
        #7000 dht11_sig = 0;  //to DATALOW bit[5] bit[4] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[5]
        #7000 dht11_sig = 0;  //to DATALOW bit[6] bit[5] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[6]
        #7000 dht11_sig = 0;  //to DATALOW bit[7] bit[6] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[7]
        #7000 dht11_sig = 0;  //to DATALOW bit[8] bit[7] = 1;
        //==================hum_low=============================//
        #5000 dht11_sig = 1;  //to DATAHIGH bit[8]
        #3000 dht11_sig = 0;  // to DATALOW bit[9]  bit[8] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[9]
        #3000 dht11_sig = 0;  // to DATALOW bit[10] bit[9] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[10]
        #3000 dht11_sig = 0;  // to DATALOW bit[11] bit[10] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[11]
        #3000 dht11_sig = 0;  // to DATALOW bit[12] bit[11] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[12]
        #3000 dht11_sig = 0;  // to DATALOW bit[13] bit[12] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[13]
        #7000 dht11_sig = 0;  // to DATALOW bit[14] bit[13] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[14]
        #3000 dht11_sig = 0;  // to DATALOW bit[15] bit[14] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[15]
        #7000 dht11_sig = 0;  // to DATALOW bit[16] bit[15] = 1;
        //==================hum_low=============================//
        #5000 dht11_sig = 1;  //to DATAHIGH bit[16]
        #3000 dht11_sig = 0;  // to DATALOW bit[17] bit[16] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[17]
        #3000 dht11_sig = 0;  // to DATALOW bit[18] bit[17] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[18]
        #3000 dht11_sig = 0;  // to DATALOW bit[19] bit[18] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[19]
        #3000 dht11_sig = 0;  // to DATALOW bit[20] bit[19] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[20]
        #7000 dht11_sig = 0;  // to DATALOW bit[21] bit[20] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[21]
        #7000 dht11_sig = 0;  // to DATALOW bit[22] bit[21] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[22]
        #7000 dht11_sig = 0;  // to DATALOW bit[23] bit[22] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[23]
        #7000 dht11_sig = 0;  // to DATALOW bit[24] bit[23] = 1;
        //==================tem_low=============================//
        #5000 dht11_sig = 1;  //to DATAHIGH bit[24]
        #3000 dht11_sig = 0;  // to DATALOW bit[25]  bit[24] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[25]
        #3000 dht11_sig = 0;  // to DATALOW bit[26] bit[25] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[26]
        #3000 dht11_sig = 0;  // to DATALOW bit[27] bit[26] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[27]
        #3000 dht11_sig = 0;  // to DATALOW bit[28] bit[27] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[28]
        #3000 dht11_sig = 0;  // to DATALOW bit[29] bit[28] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[29]
        #7000 dht11_sig = 0;  // to DATALOW bit[30] bit[29] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[30]
        #3000 dht11_sig = 0;  // to DATALOW bit[31] bit[30] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[31]
        #7000 dht11_sig = 0;  // to DATALOW bit[32] bit[31] = 1;
        //==================parity=============================//
        #5000 dht11_sig = 1;  //to DATAHIGH bit[32]
        #3000 dht11_sig = 0;  // to DATALOW bit[33]  bit[32] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[33]
        #3000 dht11_sig = 0;  // to DATALOW bit[34] bit[33] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[34]
        #3000 dht11_sig = 0;  // to DATALOW bit[35] bit[34] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[35]
        #3000 dht11_sig = 0;  // to DATALOW bit[36] bit[35] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[36]
        #3000 dht11_sig = 0;  // to DATALOW bit[37] bit[36] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[37]
        #7000 dht11_sig = 0;  // to DATALOW bit[38] bit[37] = 1;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[38]
        #3000 dht11_sig = 0;  // to DATALOW bit[39] bit[38] = 0;
        #5000 dht11_sig = 1;  //to DATAHIGH bit[39]
        #7000 dht11_sig = 0;  // to DATALOW bit[40] bit[39] = 1;

        #1000 $finish;
    end

endmodule

