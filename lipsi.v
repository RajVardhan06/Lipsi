module lipsi_processor(
    input clk,
    input reset,
    output reg[7:0] A
);

reg[7:0] instructions[0:255];
reg[7:0] memory[0:255];

reg pc = 4'h0;

always @ (posedge clk) 
begin
    
end

endmodule