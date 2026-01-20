module pipeline_processor_tb;

reg clk;

pipeline_processor uut (.clk(clk));

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, pipeline_processor_tb);

    clk = 0;
    #100 $finish;
end

endmodule
