
class dff_sequencer extends uvm_sequencer#(dff_seq_item);
  `uvm_component_utilis(dff_sequencer) //register class to factory
  
  //standard constructor
  function new(string name = "dff_sequencer", uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test sequencer", "constructor",UVM_MEDIUM)
  endfunction
  
  
  
endclass
