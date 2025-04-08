module lipsi_processor(
    input clk,
    input reset,
    output reg[7:0] A
);

reg[7:0] instructions[0:255];
reg[7:0] memory[0:255];

reg pc = 4'h0;
integer flagi = 1'b0;
integer branch = 1'b0;
integer branchifA0 = 1'b0;
integer branchifAn0 = 1'b0;

integer branchto = 8'h0;
integer fff = 3'b0;
integer op = 8'h0;
reg c = 1'b0;
integer mr = 8'h0;



always @ (posedge clk , posedge reset) 
begin
    if (reset)
    begin
        pc <= 0;
    end


    else begin
    if (pc == 8'd255 || instructions[pc] == 8'd255) begin
        pc <= pc;
    end
    if (flagi) begin
        op = instructions[pc];
        if (fff == 3'd0) begin
            A <= A + op;
        end
        else if (fff = 3'd1) begin
            A <= A-op;
        end
        else if (fff = 3'd2) begin
            A <= A + op + c;
        end
        else if (fff = 3'd3) begin
            A <= A - op - c;
        end
        else if (fff = 3'd4) begin
            A <= A & op;
        end
        else if (fff = 3'd5) begin
            A <= A | op;
        end
        else if (fff = 3'd6) begin
            A <= A ^ op;
        end
        else if (fff = 3'd7) begin
            A <= op;
        end
        flag = 1'b0;
        
    end

    if (branch) begin
        pc <= instructions[pc];
        branch = 0;
    end
    if (branchifA0) begin
        if (A == 8'h0) begin
            pc <= instructions[pc];
            branchifA0 = 0;
        end
    end
    if (branchifAn0) begin
        if (A != 8'h0) begin
            pc <= instructions[pc];
            branchifAn0 = 0;
        end
    end

    else if (instructions[pc][7:4] == 4'b1100) begin
        flagi = 1'b1;
        fff = instructions[pc][2:0];
    end

    else if (instructions[pc][7] == 1'b0) begin
        fff = instructions[pc][6:4];
        mr = memory[instructions[pc][3:0]];
        if (fff == 3'd0) begin
            A <= A + mr;
        end
        else if (fff = 3'd1) begin
            A <= A - mr;
        end
        else if (fff = 3'd2) begin
            A <= A + mr + c;
        end
        else if (fff = 3'd3) begin
            A <= A - mr - c;
        end
        else if (fff = 3'd4) begin
            A <= A & mr;
        end
        else if (fff = 3'd5) begin
            A <= A | mr;
        end
        else if (fff = 3'd6) begin
            A <= A ^ mr;
        end
        else if (fff = 3'd7) begin
            A <= mr;
        end
    end

    else if (instructions[pc][7:4] == 4'b1000) begin
        memory[instructions[pc][3:0]] = A;
    end

    else if (instructions[pc][7:4] == 4'b1101) begin
        case (instructions[pc][1:0])
            2'b00 : branch = 1'b1;
            2'b01 : branchifA0 = 1'b1;
            2'b10 : branchifAn0 = 1'b1;
            default: branch = 1'b1;
        endcase
    end


    
    
    
        
    end



    pc <= pc+1;

end

endmodule