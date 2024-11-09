
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
