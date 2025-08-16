`timescale 100ns/100ps
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
    parameter CLK_PERIOD = 10*8.680555555556;
    //internal signals
    reg par_en;
    reg par_typ;

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
        //prescale 8
        repeat(10) begin
            #(CLK_PERIOD/prescale);
            par_en = $random % 2;
            par_typ = $random % 2;
            feed_input(par_en, par_typ, 8);
        end
        //prescale 16
        repeat(10) begin
            #(CLK_PERIOD/prescale);
            par_en = $random % 2;
            par_typ = $random % 2;
            feed_input(par_en, par_typ, 16);
        end
        //prescale 32
        repeat(10) begin
            #(CLK_PERIOD/prescale);
            par_en = $random % 2;
            par_typ = $random % 2;
            feed_input(par_en, par_typ, 32);
        end

        // Glitch test
            strt_glitch_check();


        $finish;
    end

    //Tasks:
    //reset task:
    task reset;
        begin
            rst_n = 0;
            #(CLK_PERIOD/prescale);
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
            prescale = 6'h8;
        end
    endtask
    //feeding input tasks:
    task feed_input;
        input PAR_EN_task;
        input PAR_TYP_task;
        input [5:0] prescale_task;
        integer i;
        reg [7:0] data;
        begin
            data = $random; // Example data pattern
            PAR_EN = PAR_EN_task;
            PAR_TYP = PAR_TYP_task;
            prescale = prescale_task;
            RX_IN = 0;// start bit
            #(CLK_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                RX_IN = data[i];
                #(CLK_PERIOD);
            end
            if(PAR_EN) begin
                if(PAR_TYP) begin
                    RX_IN = ~^data; // Odd parity bit
                    #(CLK_PERIOD);
                end else begin
                    RX_IN = ^data; // Even parity bit
                    #(CLK_PERIOD);
                end
            end
            RX_IN = 1; // Stop bit
            #(CLK_PERIOD);
            if(data == P_DATA && par_err == 0 && stp_err == 0) begin
                $display("input test passed.");
            end else begin
                $display("input test failed.");
            end
        end
    endtask
    //CLK GENERATION:

    always begin
        if(prescale == 6'h8)
            #(CLK_PERIOD/(2*8)) clk = ~clk;
        else if(prescale == 6'h10)
            #(CLK_PERIOD/(2*16)) clk = ~clk;
        else if(prescale == 6'h20)
            #(CLK_PERIOD/(2*32)) clk = ~clk;
    end
    task strt_glitch_check;
        begin
            #(CLK_PERIOD/prescale);
            RX_IN = 0;
            #(CLK_PERIOD/prescale);
            RX_IN = 1;
            #(CLK_PERIOD);
            if(DUT.u_fsm.current_state == DUT.u_fsm.IDLE) begin
                $display("Start glitch test passed.");
            end else begin
                $display("Start glitch test failed.");
            end
        end
    endtask
endmodule