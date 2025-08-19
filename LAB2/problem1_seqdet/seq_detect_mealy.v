
module seq_detect_mealy(
    input wire clk,
    input wire rst,
    input wire din,
    output reg y
);

// implementation of the state machine
// Define states :- 

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg[1:0] current_state,next_state;


// reset block
always @(*) begin
    if(rst)
    current_state  = S0;
    else
    current_state <=next_state;
end


//combinational logic
always @(posedge clk)begin
    next_state = current_state; // default to current state
    y = 1'b0; // default output


    case(current_state)
        S0: begin
            if(din) next_state = S1; // i/p = 1
            else next_state = S0; // i/p = 0
        end
        S1: begin
            if(din) next_state = S2; // total i/p = 11
            else next_state = S0; // total i/p = 10
        end
        S2: begin
            if(din) next_state = S2; // total i/p = 110
            else next_state = S3; // total i/p = 111
        end
        S3: begin
            if(din) begin
                y <= 1'b1; // total i/p = 1101 detected
                next_state = S1; // overlap, go back to state S1 for the next bit
            end 
            else begin
                y <= 0; // no pulse if din is not 1 after detecting 1101
                next_state = S0; // reset to state S0 if din is not 1
            end
        end
        default: begin
            next_state = S0; // default case to handle unexpected states
        end
    endcase
end


endmodule

