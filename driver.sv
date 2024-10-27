
class dff_driver extends uvm_driver;
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
