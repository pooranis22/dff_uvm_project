// Code your testbench here
// or browse Examples
`timescale 1ns/1ns
`include "uvm_macros.svh" //contains all uvm macros
import uvm_pkg::*;
//contains all the uvm base class
`include "interface.sv"
`include "test.sv"
`include "environment.sv"
`include "driver.sv"
`include "sequencer.sv"
`include "seqence.sv"
`include "seq_item.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"

module top;
  logic clk;
  
//instantiate the lower module DUT/Interface
  
  dff dut1(
    .clk(intf.clk),
    .reset(intf.reset),
    .d(intf.d),
    .q(intf.q)
  );
  
  dff_intf intf(.clk(clk))
  
  initial begin
    uvm_config_db#(virtual dff_intf)::set(null,"*","vif",intf);
  end
  
  //pass name of interface
  //use set method used interfacing to the config
  // null or uvm_root
  //* allows interface to get lower components, if not can mention particular component
  // vif is the key for config database
  
  //generating clock
  
  initial 
    clk = 0;
    always #10 clk = ~clk;
    initial begin
      $monitor($time,("clk = %d",clk));
      #100 $finish;
    end
endmodule
