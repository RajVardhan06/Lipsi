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
    if (pc == 8'd255 || instructions[pc] == 8'd255) begin // exit
        pc <= pc;
    end
    else if (flagi) begin                   // ALU immediate second clock cycle
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

    else if (branch) begin              // branch second clk cycle
        pc <= instructions[pc];
        branch = 0;
    end
    else if (branchifA0) begin          // branch if A = 0 second clk cycle
        if (A == 8'h0) begin
            pc <= instructions[pc];
            branchifA0 = 0;
        end
    end
    else if (branchifAn0) begin         // branch if A != 0 second clk cycle
        if (A != 8'h0) begin
            pc <= instructions[pc];
            branchifAn0 = 0;
        end
    end

    else if (instructions[pc][7:4] == 4'b1100) begin        // ALU immediate first clk cycle
        flagi = 1'b1;
        fff = instructions[pc][2:0];
    end

    else if (instructions[pc][7] == 1'b0) begin             // ALU register
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

    else if (instructions[pc][7:4] == 4'b1000) begin        // store A into memory
        memory[instructions[pc][3:0]] = A;
    end

    else if (instructions[pc][7:4] == 4'b1101) begin        // branch first clk cycle
        case (instructions[pc][1:0])    
            2'b00 : branch = 1'b1;
            2'b01 : branchifA0 = 1'b1;
            2'b10 : branchifAn0 = 1'b1;
            default: branch = 1'b1;
        endcase
    end

    // else if ()


    
    
    
        
    end



    pc <= pc+1;

end

endmodule