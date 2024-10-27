
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
