module deserializer(
    input clk,
    input rst_n,
    input deser_en,
    input [5:0] prescale,
    input sampled_bit,
    output [7:0] P_DATA
);
//Internals:
integer i = 0;
reg [7:0] shift_reg;
reg [5:0] clk_count;
wire sampling_clk;
always @(posedge sampling_clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_reg <= 0;
    end
    else if(deser_en) begin
        for(i = 0; i < 8; i = i + 1) begin
            shift_reg[0] <= sampled_bit;
            shift_reg[i+1] <= shift_reg[i];
        end
    end
end

//counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        clk_count <= 0;
    end
    else if(deser_en) begin
        if(clk_count < prescale) begin
            clk_count <= clk_count + 1;
        end
        else begin
            clk_count <= 0;
        end
    end
end

assign P_DATA = shift_reg;
assign sampling_clk = (clk_count < (prescale >> 1))?1'b1:1'b0;
endmodule