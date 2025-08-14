module deserializer(
    input clk,
    input rst_n,
    input deser_en,
    input sampled_bit,
    output [7:0] P_DATA
);
//Internals:
integer i = 0;
reg [7:0] shift_reg;
always @(posedge clk or negedge rst_n) begin
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

assign P_DATA = shift_reg;

endmodule