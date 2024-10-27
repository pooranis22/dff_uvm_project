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
