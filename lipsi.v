module lipsi_processor(
    input clk,
    input reset,
    output reg[7:0] A
);

reg[7:0] instructions[0:255];
reg[7:0] memory[0:255];




initial begin
    instructions[0] = 8'hc7;
    instructions[1] = 8'h0a;
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
    
end




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
        else if (fff == 3'd1) begin
            A <= A - mr;
        end
        else if (fff == 3'd2) begin
            A <= A + mr + c;
        end
        else if (fff == 3'd3) begin
            A <= A - mr - c;
        end
        else if (fff == 3'd4) begin
            A <= A & mr;
        end
        else if (fff == 3'd5) begin
            A <= A | mr;
        end
        else if (fff == 3'd6) begin
            A <= A ^ mr;
        end
        else if (fff == 3'd7) begin
            A <= mr;
        end
    end

    else if (instructions[pc][7:4] == 4'b1000) begin        // store A into memory
        memory[instructions[pc][3:0]] = A;
    end

    else if (instructions[pc][7:4] == 4'b1101) begin        // branch first clk cycle
        case (instructions[pc][1:0])    
            2'b00 : branch = 1'b1;
            2'b10 : branchifA0 = 1'b1;
            2'b11 : branchifAn0 = 1'b1;
            default: branch = 1'b1;
        endcase
    end

    // else if ()


    
    
    
        
    end



    pc <= pc+1;

end

endmodule



module Seven_segment_LED_Display_Controller(
    input clock_100Mhz,
    input reset,
    output reg [3:0] Anode_Activate,
    output reg [6:0] LED_out
);

// reg [26:0] one_second_counter;
// wire one_second_enable;
wire [7:0] displayed_number; // 4-bit counter
reg [3:0] LED_BCD;
reg [19:0] refresh_counter;
wire [1:0] LED_activating_counter;
wire clk1hz;
clkdiv(clock_100Mhz,clk1hz);

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
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = displayed_number/1000;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            Anode_Activate = 4'b1011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (displayed_number % 1000)/100;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            Anode_Activate = 4'b1101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((displayed_number % 1000)%100)/10;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            Anode_Activate = 4'b1110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((displayed_number % 1000)%100)%10;
            // the fourth digit of the 16-bit number    
               end
        endcase
end

always @(*)
begin
    case(LED_BCD)
        4'b0000: LED_out = 7'b0000001; // "0"
        4'b0001: LED_out = 7'b1001111; // "1"
        4'b0010: LED_out = 7'b0010010; // "2"
        4'b0011: LED_out = 7'b0000110; // "3"
        4'b0100: LED_out = 7'b1001100; // "4"
        4'b0101: LED_out = 7'b0100100; // "5"
        4'b0110: LED_out = 7'b0100000; // "6"
        4'b0111: LED_out = 7'b0001111; // "7"
        4'b1000: LED_out = 7'b0000000; // "8"
        4'b1001: LED_out = 7'b0000100; // "9"
        default: LED_out = 7'b0000001; // "0"
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

