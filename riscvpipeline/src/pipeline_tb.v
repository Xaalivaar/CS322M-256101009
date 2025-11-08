module tb();

    reg clk=0, rst;
    logic [31:0] WriteData, DataAdr;
    logic MemWrite;
    
    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b0;
        #200;
        rst <= 1'b1;
        #1000;
        $finish;    
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, dut);
    end

    always @(negedge clk) begin
        begin
            if(MemWrite) begin
                if(DataAdr === 100 & WriteData === 25) begin
                    $display("%d %d", DataAdr, WriteData);
                    $display("Simulation succeeded");
                    $stop;
                end else if(DataAdr !== 96) begin
                    $display("%d %d", DataAdr, WriteData);
                    $display("Simulation failed");
                    $stop;
                end else begin
                    $display("%d %d", DataAdr, WriteData);
                    $stop;
                end
            end
        end
    end

    Pipeline_top dut (.clk(clk), .rst(rst), .WriteData(WriteData), .DataAdr(DataAdr), .MemWrite(MemWrite));
endmodule