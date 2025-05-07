
module tb_Smart_Parking_System;

    reg CLK, RST, Car_Enter, Car_Exit;
    wire Gate_Open;
    wire [6:0] seg0, seg1, seg2;

    Smart_Parking_System uut (
        .CLK(CLK),
        .RST(RST),
        .Car_Enter(Car_Enter),
        .Car_Exit(Car_Exit),
        .Gate_Open(Gate_Open),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2)
    );

    // Clock generation
    always #5 CLK = ~CLK;

    initial begin
        $monitor("Time=%0t | Enter=%b Exit=%b | Gate=%b | Spaces= %b %b %b",
                 $time, Car_Enter, Car_Exit, Gate_Open, seg2, seg1, seg0);

        CLK = 0; RST = 1; Car_Enter = 0; Car_Exit = 0;
        #10 RST = 0; #10 RST = 1;

        // Simulate 100 car entries
        repeat (100) begin
            #10 Car_Enter = 1; #10 Car_Enter = 0;
        end

        // Try to enter after full
        #20;
        repeat (3) begin
            #10 Car_Enter = 1; #10 Car_Enter = 0;
        end
			
        // Simulate 3 car exits
        repeat (10) begin
            #10 Car_Exit = 1; #10 Car_Exit = 0;
        end
        #50;
        // Simulate 2 car entries
        repeat (2) begin
            #10 Car_Enter = 1; #10 Car_Enter = 0;
        end

        #100 $finish;
    end
endmodule

