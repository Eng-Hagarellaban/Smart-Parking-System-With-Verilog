module Smart_Parking_System (
    input  wire CLK,
    input  wire RST,
    input  wire Car_Enter,
    input  wire Car_Exit,
    output reg  Gate_Open,
    output  [6:0] seg0, // Units
    output  [6:0] seg1, // Tens
    output  [6:0] seg2  // Hundreds
);

// ========== Parameters ==========
parameter MAX_SPACES = 7'd100;

// ========== Internal Signals ==========
reg [6:0] car_counter; // Up/Down Counter for number of cars
reg [6:0] available_spaces;
wire [6:0] ones, tens, hundreds;

// ========== FSM States ==========
reg [1:0] state, next_state;
localparam IDLE  = 2'b00,
           ENTER = 2'b01,
           EXIT  = 2'b10,
           FULL  = 2'b11;

// ========== Sequential Logic ==========
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        car_counter <= 0;
        state <= IDLE;
    end else begin
        state <= next_state;

        // Up/down counter logic
        if (Car_Enter && (car_counter < MAX_SPACES))
            car_counter <= car_counter + 1;
        else if (Car_Exit && (car_counter > 0))
            car_counter <= car_counter - 1;
    end
end

// ========== Next State Logic ==========
always @(*) begin
    case (state)
        IDLE: begin
            if (Car_Enter && (car_counter < MAX_SPACES))
                next_state = ENTER;
            else if (Car_Exit && (car_counter > 0))
                next_state = EXIT;
            else if (car_counter == MAX_SPACES)
                next_state = FULL;
            else
                next_state = IDLE;
        end
        ENTER: next_state = IDLE;
        EXIT:  next_state = IDLE;
        FULL: begin
            if (Car_Exit)
                next_state = EXIT;
            else
                next_state = FULL;
        end
        default: next_state = IDLE;
    endcase
end

// ========== Output Logic ==========
always @(*) begin
    available_spaces = MAX_SPACES - car_counter;

    // Gate control
    if (available_spaces == 0)
        Gate_Open = 0;
    else
        Gate_Open = 1;

     // seg0 = dec_to_7seg(ones);
    // seg1 = dec_to_7seg(tens);
   // seg2 = dec_to_7seg(hundreds);
end


    // Extract digits
   assign hundreds = available_spaces / 100;
   assign tens     = (available_spaces % 100) / 10;
   assign ones     = available_spaces % 10;

seven_segment_decoder #(.COMMON_ANODE(1))  Units_inst (
.i_data(ones), // 4-bit binary input
.o_display(seg0) // 7-segment output (a, b, c, d, e, f, g)
);


seven_segment_decoder #(.COMMON_ANODE(1))  Tens_inst (
.i_data(tens), // 4-bit binary input
.o_display(seg1) // 7-segment output (a, b, c, d, e, f, g)
);


seven_segment_decoder #(.COMMON_ANODE(1))  Hundreds_inst (
.i_data(hundreds), // 4-bit binary input
.o_display(seg2) // 7-segment output (a, b, c, d, e, f, g)
);

endmodule

