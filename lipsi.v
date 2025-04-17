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
//     instructions[0] = 8'hc7;    // sum of first 15 numbers
//     instructions[1] = 8'h0f;
//     instructions[2] = 8'h81;
//     instructions[3] = 8'h82;
//     instructions[4] = 8'hc1;
//     instructions[5] = 8'h01;
//     instructions[6] = 8'h81;
//     instructions[7] = 8'h02;
//     instructions[8] = 8'h82;
//     instructions[9] = 8'h71;
//     instructions[10] = 8'hd3;
//     instructions[11] = 8'h04;
//     instructions[12] = 8'h72;
//     instructions[13] = 8'hff;

//     instructions[0] = 8'hc7;   // sum of first n even numbers
//     instructions[1] = 8'h05;
//     instructions[2] = 8'he6;
//     instructions[3] = 8'h81;
//     instructions[4] = 8'h82;
//     instructions[5] = 8'h83;
//     instructions[6] = 8'hc1;
//     instructions[7] = 8'h02;
//     instructions[8] = 8'h82;
//     instructions[9] = 8'h03;
//     instructions[10] = 8'h83;
//     instructions[11] = 8'h72;
//     instructions[12] = 8'hd3;
//     instructions[13] = 8'h06;
//     instructions[14] = 8'h73;
//     instructions[15] = 8'hff;

//     instructions[0] = 8'hc7;       // Nth fibonacci number  
//     instructions[1] = 8'h00;
//     instructions[2] = 8'h81;
//     instructions[3] = 8'hc7;
//     instructions[4] = 8'h01;
//     instructions[5] = 8'h82;
//     instructions[6] = 8'hc7;
//     instructions[7] = 8'h0c;        // Input of number n
//     instructions[8] = 8'hc1;
//     instructions[9] = 8'h02;
//     instructions[10] = 8'h80;
//     instructions[11] = 8'h71;
//     instructions[12] = 8'h02;
//     instructions[13] = 8'h83;
//     instructions[14] = 8'h72;
//     instructions[15] = 8'h81;
//     instructions[16] = 8'h73;
//     instructions[17] = 8'h82;
//     instructions[18] = 8'h70;
//     instructions[19] = 8'hc1;
//     instructions[20] = 8'h01;
//     instructions[21] = 8'h80;
//     instructions[22] = 8'hd3;
//     instructions[23] = 8'h0b;
//     instructions[24] = 8'h72;
//     instructions[25] = 8'hff;

//     instructions[0] = 8'hc7;    // Left shifts and Right shifts     
//     instructions[1] = 8'hff;
//     instructions[2] = 8'hc0;
//     instructions[3] = 8'h0a;
//     instructions[4] = 8'he7;
//     instructions[5] = 8'he3;
//     instructions[6] = 8'hff;

//     instructions[0] = 8'hc7;
//     instructions[1] = 8'h80;
//     instructions[2] = 8'h81;
//     instructions[3] = 8'hc7;
//     instructions[4] = 8'h0a;
//     instructions[5] = 8'hb1;
//     instructions[6] = 8'hc7;
//     instructions[7] = 8'h00;
//     instructions[8] = 8'ha1;
//     instructions[9] = 8'hff;

//     instructions[0] = 8'hc7;       // Factrial of 5 
//     instructions[1] = 8'h05;
//     instructions[2] = 8'h81;
//     instructions[3] = 8'hc7;
//     instructions[4] = 8'h01;
//     instructions[5] = 8'h84;
//     instructions[6] = 8'h71;
//     instructions[7] = 8'h82;
//     instructions[8] = 8'h74;
//     instructions[9] = 8'h83;
//     instructions[10] = 8'hc7;
//     instructions[11] = 8'h00;
//     instructions[12] = 8'h75;
//     instructions[13] = 8'h03;
//     instructions[14] = 8'h85;
//     instructions[15] = 8'h72;
//     instructions[16] = 8'hc1;
//     instructions[17] = 8'h01;
//     instructions[18] = 8'h82;
//     instructions[19] = 8'hd3;
//     instructions[20] = 8'h0c;
//     instructions[21] = 8'h75;
//     instructions[22] = 8'h84;
//     instructions[23] = 8'h71;
//     instructions[24] = 8'hc1;
//     instructions[25] = 8'h01;
//     instructions[26] = 8'h81;
//     instructions[27] = 8'hc1;
//     instructions[28] = 8'h01;
//     instructions[29] = 8'hd3;
//     instructions[30] = 8'h07;
//     instructions[31] = 8'h74;
//     instructions[32] = 8'hff;

//     instructions[0] = 8'hc7;       // Branch and Link
//     instructions[1] = 8'h05;
//     instructions[2] = 8'h91;
//     instructions[3] = 8'hc7;
//     instructions[4] = 8'h0a;
//     instructions[5] = 8'h71;
//     instructions[6] = 8'hff;


    flagi = 1'b0;
    branch = 1'b0;
    branchifA0 = 1'b0;
    branchifAn0 = 1'b0;

    pc = 8'h0;
    c = 1'b0;
    
end


integer i;


always @ (posedge clk , posedge reset) 
begin
    if (reset)
    begin
        pc <= 0;
        for (i=0;i<256;i=i+1) memory[i] <= 8'h00; 
    end


    else begin

    if ((pc == 8'd255 || instructions[pc] == 8'd255) && (!flagi)) begin // exit
        pc <= pc;
        
    end
    else begin
    if (flagi) begin                   // ALU immediate second clock cycle
        op = instructions[pc];
        if (fff == 3'd0) begin
            {c,A} <= A + op;
        end
        else if (fff == 3'd1) begin
            A <= A-op;
        end
        else if (fff == 3'd2) begin
            {c,A} <= A + op + c;
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
            {c,A} = A + mr;
        end
        else if (fff == 3'd1) begin
            A = A - mr;
        end
        else if (fff == 3'd2) begin
            {c,A} = A + mr + c;
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

        if (count == 500) 
        begin
            clkout <= ~clkout;
            count <= 0;
        end

    end
    
endmodule