
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
