module traffic_light(
    input  wire clk,        // system clock
    input  wire rst,        // synchronous active-high reset
    input  wire tick,       // 1-cycle per-second pulse
    output reg  ns_g, ns_y, ns_r,
    output reg  ew_g, ew_y, ew_r
);

    // FSM states
    localparam S_NS_GREEN  = 2'd0,
               S_NS_YELLOW = 2'd1,
               S_EW_GREEN  = 2'd2,
               S_EW_YELLOW = 2'd3;

    reg [1:0] state, next_state;

    // We'll use a down-counter for remaining seconds in current phase.
    // Max duration is 5 -> need 3 bits (0..5)
    reg [2:0] remain; // remaining ticks (0 means phase complete)

    // Phase durations (in seconds)
    localparam D_NS_GREEN  = 3'd5;
    localparam D_NS_YELLOW = 3'd2;
    localparam D_EW_GREEN  = 3'd5;
    localparam D_EW_YELLOW = 3'd2;

    // Sequential: state and remaining counter update (synchronous reset)
    always @(posedge clk) begin
        if (rst) begin
            state  <= S_NS_GREEN;
            remain <= D_NS_GREEN; // start with full duration
        end else begin
            state <= next_state;
            if (tick) begin
                if (remain != 3'd0)
                    remain <= remain - 3'd1;
                else begin
                    // on phase completion load next phase duration
                    case (next_state)
                        S_NS_GREEN:  remain <= D_NS_GREEN;
                        S_NS_YELLOW: remain <= D_NS_YELLOW;
                        S_EW_GREEN:  remain <= D_EW_GREEN;
                        S_EW_YELLOW: remain <= D_EW_YELLOW;
                        default:     remain <= D_NS_GREEN;
                    endcase
                end
            end
        end
    end

    // Next-state (combinational)
    always @(*) begin
        next_state = state;
        // If tick and remain==0 then transition to next phase
        if (tick && remain == 3'd0) begin
            case (state)
                S_NS_GREEN:  next_state = S_NS_YELLOW;
                S_NS_YELLOW: next_state = S_EW_GREEN;
                S_EW_GREEN:  next_state = S_EW_YELLOW;
                S_EW_YELLOW: next_state = S_NS_GREEN;
                default:     next_state = S_NS_GREEN;
            endcase
        end
    end

    // Moore outputs (combinational)
    always @(*) begin
        // defaults: all red
        ns_g = 1'b0; ns_y = 1'b0; ns_r = 1'b1;
        ew_g = 1'b0; ew_y = 1'b0; ew_r = 1'b1;

        case (state)
            S_NS_GREEN:  begin ns_g = 1'b1; ns_y = 1'b0; ns_r = 1'b0; ew_g = 1'b0; ew_y = 1'b0; ew_r = 1'b1; end
            S_NS_YELLOW: begin ns_g = 1'b0; ns_y = 1'b1; ns_r = 1'b0; ew_g = 1'b0; ew_y = 1'b0; ew_r = 1'b1; end
            S_EW_GREEN:  begin ew_g = 1'b1; ew_y = 1'b0; ew_r = 1'b0; ns_g = 1'b0; ns_y = 1'b0; ns_r = 1'b1; end
            S_EW_YELLOW: begin ew_g = 1'b0; ew_y = 1'b1; ew_r = 1'b0; ns_g = 1'b0; ns_y = 1'b0; ns_r = 1'b1; end
            default:     begin ns_g = 1'b0; ns_y = 1'b0; ns_r = 1'b1; ew_g = 1'b0; ew_y = 1'b0; ew_r = 1'b1; end
        endcase
    end

endmodule
