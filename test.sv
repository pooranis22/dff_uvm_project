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
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("Test class", "run phase", UVM_MEDIUM);
    phase.raise_objection(this); //stay in run_phase until the test drop objection
    seq.start(env.agent.seqr); //until this sequence gets completed the objection is raised and dropped, if not the simulation might get completed in less time 
    phase.drop_objection(this);
  endtask
    
  
endclass
