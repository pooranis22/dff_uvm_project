//uvm object class
class dff_sequence extends uvm_sequence;
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
