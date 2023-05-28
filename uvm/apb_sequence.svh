class apb_sequence extends uvm_sequence #(apb_seq_item);
    `uvm_object_utils(apb_sequence)

    function new(string name="apb_sequence");
        super.new(name);
    endfunction

    virtual task body();
        // for (int i = 0; i < num; i ++) begin
        //     apb_seq_item item = apb_seq_item::type_id::create("item");
        //     start_item(item);
        //     item.randomize();
        //     `uvm_info("SEQ", $sformatf("Generate new item: %s", item.convert2str()), UVM_HIGH)
        //     finish_item(item);
        // end
        forever begin
            apb_seq_item item = apb_seq_item::type_id::create("time");
            start_item(item);
            item.randomize();
            get_response(item);
            
            finish_item(item);
        end
        // `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
    endtask
endclass
