DESIGN.sv

module dff (
  input clk,
  input reset,
  input d,
  output reg q);
  
  always@(posedge clk)
    begin
    if(reset)
        q<=0;
    else
        q<=d;
      end
endmodule

TESTBENCH.sv

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

INTERFACE.sv

interface dff_intf(input logic clk);
  //interface has all dut signals
  //declared using logic types
  //clock is generating and coming from testbench.sv top module is it is input for interface
  
  logic reset;
  logic d;
  logic q;
endinterface


TEST.sv
//test class
class dff_test extends uvm_test;
  `uvm_component_utilis(dff_test) //register class to factory
  dff_env env;
  dff_sequence seq;
  
  //standard constructor
  function new(string name = "dff_test", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test class", "constructor",UVM_MEDIUM)
  endfunction
  
  //build phase
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //creating lower modules
    env = dff_env::type_id::create("env",this); //create object
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("Test class", "connect phase", UVM_MEDIUM);
    //connect the components
  endfunction  
  
  //end of ellaboration phase gives uvm_hierarchy 
  virtual function void end_of_elaboration();
    `uvm_info("Test class", "elab phase",UVM_MEDIUM)
    print();
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("Test class", "run phase", UVM_MEDIUM);
    phase.raise_objection(this); //stay in run_phase until the test drop objection
    seq.start(env.agent.seqr); //until this sequence gets completed the objection is raised and dropped, if not the simulation might get completed in less time 
    phase.drop_objection(this);
  endtask
    
  
endclass

ENVIRONMENT.sv
class dff_env extends uvm_env;
  `uvm_component_utilis(dff_env) //register class to factory
  dff_agent agent;
  dff_scoreboard scb;
  
  
  //standard constructor
  function new(string name = "dff_env", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test environment", "constructor",UVM_MEDIUM)
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase)
    
    //creating lower modules
    
    agent = dff_agent::type_id::create("agent",this);
    scb = dff_scoreboard::type_id::create("scoreboard",this);
  endfunction
  
  
    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      `uvm_phase("Test environment", "connect phase", UVM_MEDIUM);
    //connect the components
      agent.mon.item_collected_port.connect(scb.item_collected_export);
  endfunction  
endclass

AGENT.sv

class dff_agent extends uvm_agent;
  `uvm_component_utilis(dff_agent) //register class to factory
  
  dff_driver drv;
  dff_montior mon;
  dff_sequencer seqr;
  //standard constructor
  function new(string name = "dff_agent", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test agent", "constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase)
    
    //creating lower modules
    
    drv = dff_driver::type_id::create("driver",this);
    mon = dff_monitor::type_id::create("monitor",this);
    seqr = dff_sequencer::type_id::create("sequencer",this);
  endfunction
  
  
    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      `uvm_phase("agent class", "connect phase", UVM_MEDIUM);
    //connect the components driver sequencer using TLM ports
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction  
endclass

MONITOR.sv


class dff_monitor extends uvm_monitor;
  `uvm_component_utilis(dff_monitor) //register class to factory
  virtual dff_intf intf;
  uvm_analysis_port #(dff_seq_item) item_collected_port;
  dff_seq_ietm tx;
  
  //standard constructor
  function new(string name = "dff_monitor", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test monitor", "constructor",UVM_MEDIUM)
  endfunction
  
    function void build_phase(uvm_phase phase);
    super.build_phase(phase)
      item_collected_port = new("item_collected_port",this);
      `uvm_info("monitor_class" ,"build_phase",UVM_MEDIUM);      
    if(!uvm_config_db#(virtual dff_intf)::get(this,"","vif",intf))
      `uvm_fatal("no interface in monitor","virtual interface gets failed from config db");
    
  endfunction
  
  task run_phase(uvm_phase phase);
    tx = dff_seq_item::type_id::create("tx");
    wait(!intf.rst)
    @(posedge intf.clk)
    tx.rst = intf.rst;
    tx.d = intf.d;
    tx.q = intf.q;
  endtask
  
endclass


DRIVER.SV


class dff_driver extends uvm_driver#(dff_seq_item);
  `uvm_component_utilis(dff_driver) //register class to factory
  virtual dff_intf intf
  
  //standard constructor
  function new(string name = "dff_driver", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test driver", "constructor",UVM_MEDIUM)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase)
    `uvm_info("driver_class" ,"build_phase",UVM_MEDIUM);
    if(!uvm_config_db#(virtual dff_intf)::get(this,"","vif",intf))
      `uvm_fatal("no interface in driver","virtual interface gets failed from config db");
    
  endfunction
  
    task run_phase(uvm_phase phase);
      forever begin
        `uvm_info("driver class", "run phase", UVM_MEDIUM);
        seq_item_port.get_next_item(tx);
        drive(tx);
        seq_item_port.item_done();
      end
    endtask

  task drive(dff_seq_item tx);
    @(posedge intf.clk)
    intf.rst <= tx.rst;
    intf.d <= tx.d;
    intf.q <= tx.q;
    endtask  
endclass


SEQUENCE.SV
//uvm object class
class dff_sequence extends uvm_sequence#(dff_seq_item);
  `uvm_object_utilis(dff_sequence) //register class to factory
  dff_seq_item tx;
  
  
  //standard constructor
  function new(string name = "dff_sequence");
    super.new(name);
    `uvm_info("Test sequence", "constructor",UVM_MEDIUM)
  endfunction
  
  task body();
    repeat (5) begin
      tx = dff_seq_item::type_id::create("tx");
      wait_for_grant(); //req to the seq item from driver
      tx.randomize();
      send_request(tx);
      wait_for_item_done();
    end
    
    endtask
endclass

SEQUENCER.SV

class dff_sequencer extends uvm_sequencer#(dff_seq_item);
  `uvm_component_utilis(dff_sequencer) //register class to factory
  
  //standard constructor
  function new(string name = "dff_sequencer", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test sequencer", "constructor",UVM_MEDIUM)
  endfunction
  
  
  
endclass


SEQ_ITEM.SV

class dff_seq_item extends uvm_seq_item;
  `uvm_object_utilis(dff_seq_item) //register class to factory
  rand logic reset;
  rand logic d;
  logic q;
  //standard constructor
  function new(string name = "dff_seq_item");
    super.new(name);
    `uvm_info("Test sequence item", "constructor",UVM_MEDIUM)
  endfunction
endclass


SCOREBOARD.SV


class dff_scoreboard extends uvm_scoreboard;
  `uvm_component_utilis(dff_scoreboard) //register class to factory
  uvm_analysis_imp#(dff_seq_item,dff_scoreboard) item_collected_export;
  dff_seq_item tx_q[$];
  
  //standard constructor
  function new(string name = "dff_scoreboard", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test scoreboard", "constructor",UVM_MEDIUM)
  endfunction
  
    function void build_phase(uvm_phase phase);
    super.build_phase(phase)
      item_collected_export = new("item_collected_export",this);
    
  endfunction

  //write method used to receive the pkt from monitor and pushes into queue
  virtual function void write(dff_seq_item tx);
    tx.q.push_back(tx);
  endfunction
  
endclass

