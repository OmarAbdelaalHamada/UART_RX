module UART_RX_TB();
    reg clk;
    reg rst_n;
    reg RX_IN;
    reg PAR_EN;
    reg PAR_TYP;
    reg [5:0] prescale;

    wire [7:0] P_DATA;
    wire par_err;
    wire stp_err;
    wire data_valid;
    parameter CLK_PERIOD = 10;

    //CLK GENERATION:
    initial begin
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    //DUT instantiation:
    UART_RX DUT (
        .clk(clk),
        .rst_n(rst_n),
        .RX_IN(RX_IN),
        .PAR_EN(PAR_EN),
        .PAR_TYP(PAR_TYP),
        .prescale(prescale),
        .P_DATA(P_DATA),
        .par_err(par_err),
        .stp_err(stp_err),
        .data_valid(data_valid)
    );


    //Initial block:
    initial begin
        init();
        reset();
        feed_input(1,1,8);
        feed_input(1,0,8);

        feed_input(1,1,8);
        feed_input(1,0,8);
        feed_input(0,1,8);
        feed_input(0,1,8);
        
        $finish;
    end

    //Tasks:
    //reset task:
    task reset;
        begin
            rst_n = 0;
            #(CLK_PERIOD*prescale);
            rst_n = 1;
        end
    endtask
    //Initialization task:
    task init;
        begin
            clk = 0;
            rst_n = 0;
            RX_IN = 1;
            PAR_EN = 1;
            PAR_TYP = 1;
            prescale = 6'b001000;
        end
    endtask
    //feeding input tasks:
    task feed_input;
        input PAR_EN;
        input PAR_TYP;
        input [5:0] prescale;
        integer i;
        reg [7:0] data;
        begin
            data = 8'b00001001; // Example data pattern
            RX_IN = 0;// start bit
            #(CLK_PERIOD*prescale);

            for (i = 7; i >= 0; i = i - 1) begin
                RX_IN = data[i];
                #(CLK_PERIOD*prescale);
            end
            if(PAR_EN) begin
                if(PAR_TYP) begin
                    RX_IN = ~^data; // Odd parity bit
                    #(CLK_PERIOD*prescale);
                end else begin
                    RX_IN = ^data; // Even parity bit
                    #(CLK_PERIOD*prescale);
                end
            end
            RX_IN = 1; // Stop bit
            #(CLK_PERIOD*prescale);
            if(data == P_DATA && par_err == 0 && stp_err == 0) begin
                $display("input test passed.");
            end else begin
                $display("input test failed.");
            end
        end
    endtask
    
endmodule