
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
