//------------------------------------------------------------------
//-- Verilog template
//-- Test-bench entity
//-- Board: icezum
//------------------------------------------------------------------

`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module setbit_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 10;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

//-- Led port
wire A;

//-- Instantiation of the unit to test

setbit SB1(
  .A (A)
  );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, setbit_tb);





   #(DURATION)  if (A != 1)
                  $display("Error!!!");
                else
                  $display("End of simulation");
  $finish;
end

endmodule
