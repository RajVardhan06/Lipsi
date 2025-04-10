module lipsi_processor(
    input clk,
    input reset,
    output reg[7:0] A
);

reg[7:0] instructions[0:255];
reg[7:0] memory[0:255];


reg flagi;
reg branch;
reg branchifA0;
reg branchifAn0;
reg c;
reg mrbool;
reg[7:0] pc;

reg[7:0] branchto;
reg[2:0] fff;
reg[7:0] op;
reg[7:0] mr;
reg temp;


initial begin
    instructions[0] = 8'hc7;
    instructions[1] = 8'h05;
    instructions[2] = 8'h81;
    instructions[3] = 8'h82;
    instructions[4] = 8'hc1;
    instructions[5] = 8'h01;
    instructions[6] = 8'h81;
    instructions[7] = 8'h02;
    instructions[8] = 8'h82;
    instructions[9] = 8'h71;
    instructions[10] = 8'hd3;
    instructions[11] = 8'h04;
    instructions[12] = 8'h72;
    instructions[13] = 8'hff;
    flagi = 1'b0;
    branch = 1'b0;
    branchifA0 = 1'b0;
    branchifAn0 = 1'b0;

    pc = 8'h0;
    c = 1'b0;
    
end







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
    else begin
    if (flagi) begin                   // ALU immediate second clock cycle
        op = instructions[pc];
        if (fff == 3'd0) begin
            A <= A + op;
        end
        else if (fff == 3'd1) begin
            A <= A-op;
        end
        else if (fff == 3'd2) begin
            A <= A + op + c;
        end
        else if (fff == 3'd3) begin
            A <= A - op - c;
        end
        else if (fff == 3'd4) begin
            A <= A & op;
        end
        else if (fff == 3'd5) begin
            A <= A | op;
        end
        else if (fff == 3'd6) begin
            A <= A ^ op;
        end
        else if (fff == 3'd7) begin
            A <= op;
        end
        flagi = 1'b0;
        pc <= pc+1;
        
    end

    else if (branch) begin              // branch second clk cycle
        pc = branchto;
        branch = 0;
        
    end
    else if (branchifA0) begin          // branch if A = 0 second clk cycle
        branchifA0 = 0;
        if (A == 8'h0) begin
            pc = branchto;
            
        end
        else pc <= pc+1;
    end
    else if (branchifAn0) begin         // branch if A != 0 second clk cycle
        branchifAn0 = 0;
        if (A != 8'h0) begin
            pc = branchto;
            
        end
        else pc <= pc+1;
    end
 
    else if (instructions[pc][7:4] == 4'b1100) begin        // ALU immediate first clk cycle
        flagi = 1'b1;
        fff = instructions[pc][2:0];
        pc <= pc+1;
    end

    
    else if (instructions[pc][7] == 1'b0) begin             // ALU register
        fff = instructions[pc][6:4];
        mr = memory[instructions[pc][3:0]];
        if (fff == 3'd0) begin
            A = A + mr;
        end
        else if (fff == 3'd1) begin
            A = A - mr;
        end
        else if (fff == 3'd2) begin
            A = A + mr + c;
        end
        else if (fff == 3'd3) begin
            A = A - mr - c;
        end
        else if (fff == 3'd4) begin
            A = A & mr;
        end
        else if (fff == 3'd5) begin
            A = A | mr;
        end
        else if (fff == 3'd6) begin
            A = A ^ mr;
        end
        else if (fff == 3'd7) begin
            A = mr;
        end
        pc <= pc+1;
        
    end

    else if (instructions[pc][7:4] == 4'b1000) begin        // store A into memory
        memory[instructions[pc][3:0]] = A;
        pc <= pc+1;
    end

    else if (instructions[pc][7:4] == 4'b1101) begin        // branch first clk cycle
        case (instructions[pc][1:0])    
            2'b00 : begin 
                branch = 1'b1;
                branchto <= instructions[pc+1];
            end
            2'b10 : begin
                 branchifA0 = 1'b1;
                 branchto <= instructions[pc+1];
            end
            2'b11 : begin
                 branchifAn0 = 1'b1;
                 branchto <= instructions[pc+1];
            end
            // default: branch = 1'b1;
        endcase
        pc <= pc+1;
    end

    else if (instructions[pc][7:4] == 4'b1001) begin
        memory[instructions[pc][3:0]] <= pc;
        pc <= A;
    end
    
    else if (instructions[pc][7:4] == 4'b1010) begin
        A <= memory[memory[instructions[pc][3:0]]];
        pc <= pc+1;
    end

    else if (instructions[pc][7:4] == 4'b1011) begin
        memory[memory[instructions[pc][3:0]]] <= A;
        pc <= pc+1;
    end

    else if (instructions[pc][7:4] == 4'b1110) begin
        if (instructions[pc][2] == 1'b0) begin
            if (instructions[pc][1:0] == 2'b00) begin
                temp = A[0];
                A = A >> 1;
                A[7] = temp;
            end
            else if (instructions[pc][1:0] == 2'b01) begin
                temp = A[0];
                A = A >> 1;
                A[7] = c;
                c = temp;
            end
            else if (instructions[pc][1:0] == 2'b10) begin
                A = A >> 1;
            end
            else begin
                A = A >> 1;
                A[7] = c;
                c = 1'b0;
            end
        end
        else begin
            if (instructions[pc][1:0] == 2'b00) begin
                temp = A[7];
                A = A << 1;
                A[0] = temp;
            end
            else if (instructions[pc][1:0] == 2'b01) begin
                temp = A[7];
                A = A << 1;
                A[0] = c;
                c = temp;
            end
            else if (instructions[pc][1:0] == 2'b10) begin
                A = A << 1;
            end
            else begin
                c = A[7];
                A = A << 1;
            end
        end
        pc <= pc+1;
    end

    end
    
        
    end



    

end

endmodule



module Lipsi_seven_segment_display(
    input clock_100Mhz,
    input reset,
    output reg [3:0] Anode_Activate,
    output reg [6:0] LED_out
);

wire [7:0] displayed_number;
reg [3:0] LED_BCD;
reg [19:0] refresh_counter;
wire [1:0] LED_activating_counter;
wire clk1hz;
clkdiv(clock_100Mhz, clk1hz);

lipsi_processor l(clk1hz,reset,displayed_number);


always @(posedge clock_100Mhz or posedge reset)
begin
    if (reset == 1)
        refresh_counter <= 0;
    else
        refresh_counter <= refresh_counter + 1;
end

assign LED_activating_counter = refresh_counter[19:18];

always @(*)
begin
    case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b0111; 
            LED_BCD = displayed_number/1000;
              end
        2'b01: begin
            Anode_Activate = 4'b1011;
            LED_BCD = (displayed_number%1000)/100;
              end
        2'b10: begin
            Anode_Activate = 4'b1101;
            LED_BCD = ((displayed_number % 1000)%100)/10;
                end
        2'b11: begin
            Anode_Activate = 4'b1110;
            LED_BCD = ((displayed_number % 1000)%100)%10;
               end
        endcase
end

always @(*)
begin
    case(LED_BCD)
        4'b0000: LED_out = 7'b0000001;
        4'b0001: LED_out = 7'b1001111;
        4'b0010: LED_out = 7'b0010010;
        4'b0011: LED_out = 7'b0000110;
        4'b0100: LED_out = 7'b1001100;
        4'b0101: LED_out = 7'b0100100;
        4'b0110: LED_out = 7'b0100000;
        4'b0111: LED_out = 7'b0001111;
        4'b1000: LED_out = 7'b0000000;
        4'b1001: LED_out = 7'b0000100;
        default: LED_out = 7'b0000001;
    endcase
end

endmodule

module clkdiv (input clk, output reg clkout);
    reg[31:0] count;
    always @(posedge clk)
    begin 
        count <= count + 1;

        if (count == 50000000) 
        begin
            clkout <= ~clkout;
            count <= 0;
        end

    end
    
endmodule