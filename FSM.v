module FSM (
    input clk,
    input rst_n,
    input RX_IN,
    input PAR_EN,
    input [3:0] bit_cnt,      // width depends on implementation
    input [5:0] edge_cnt,     // width depends on implementation
    input [5:0] prescale,
    input par_err,
    input stp_err,
    input strt_glitch,
    output reg enable,
    output reg par_chk_en,
    output reg strt_chk_en,
    output reg stp_chk_en,
    output reg dat_samp_en,
    output reg deser_en,
    output reg data_valid
);
    
// Internal state variables
reg [2:0] current_state;
reg [2:0] next_state;

// State encoding
localparam IDLE          = 3'b000;
localparam START_CHECK   = 3'b001;
localparam DATA_SAMPLING = 3'b011;
localparam PARITY_CHECK  = 3'b010;
localparam STOP_CHECK    = 3'b110;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (!RX_IN) begin
                next_state = START_CHECK;
            end 
            else begin
                next_state = IDLE;
            end
        end
        START_CHECK: begin
            next_state = DATA_SAMPLING;
        end
        DATA_SAMPLING: begin
            if (bit_cnt < 4'h9) begin
                next_state = DATA_SAMPLING;
            end 
            else begin
                if(PAR_EN) begin
                    next_state = PARITY_CHECK;
                end
                else begin
                    next_state = STOP_CHECK;
                end
            end
        end
        PARITY_CHECK: begin
           next_state = STOP_CHECK;
        end
        STOP_CHECK: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic based on current state
always @(*) begin
    enable = 1'b0;
    par_chk_en = 1'b0;
    strt_chk_en = 1'b0;
    stp_chk_en = 1'b0;
    dat_samp_en = 1'b0;
    deser_en = 1'b0;
    data_valid = 1'b0;
    case (current_state)
        IDLE: begin
            enable = 1'b0;
            par_chk_en = 1'b0;
            strt_chk_en = 1'b0;
            stp_chk_en = 1'b0;
            dat_samp_en = 1'b0;
            deser_en = 1'b0;
            data_valid = 1'b0;
        end
        START_CHECK: begin
            enable = 1'b1;
            par_chk_en = 1'b0;
            strt_chk_en = 1'b1;
            stp_chk_en = 1'b0;
            dat_samp_en = 1'b1;
            deser_en = 1'b0;
            data_valid = 1'b0;
        end
        DATA_SAMPLING: begin
            enable = 1'b1;
            par_chk_en = 1'b0;
            strt_chk_en = 1'b0;
            stp_chk_en = 1'b0;
            dat_samp_en = 1'b1;
            deser_en = 1'b1;
            data_valid = 1'b0;
        end
        PARITY_CHECK: begin
            enable = 1'b1;
            par_chk_en = 1'b1;
            strt_chk_en = 1'b0;
            stp_chk_en = 1'b0;
            dat_samp_en = 1'b1;
            deser_en = 1'b0;
            data_valid = 1'b0;
        end
        STOP_CHECK: begin
            enable = 1'b1;
            par_chk_en = 1'b0;
            strt_chk_en = 1'b0;
            stp_chk_en = 1'b1;
            dat_samp_en = 1'b1;
            deser_en = 1'b0;
            if(!stp_err && !strt_glitch && !par_err) begin
                data_valid = 1'b1; // Data is valid if no errors
            end else begin
                data_valid = 1'b0; // Data is invalid if any error occurs
        end
        end
        default: begin
            enable = 1'b0;
            par_chk_en = 1'b0;
            strt_chk_en = 1'b0;
            stp_chk_en = 1'b0;
            dat_samp_en = 1'b0;
            deser_en = 1'b0;
            data_valid = 1'b0;
        end
    endcase
end
endmodule