interface dff_intf(input logic clk);
  //interface has all dut signals
  //declared using logic types
  //clock is generating and coming from testbench.sv top module is it is input for interface
  
  logic reset;
  logic d;
  logic q;
endinterface
