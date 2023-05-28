class apb_driver extends uvm_driver #(apb_seq_item);
    `uvm_component_utils(apb_driver)

    function new(string name = "apb_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual apb_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual apb_if)::get(this, "", "apb_vif", vif))
            `uvm_fatal("DRV", "Could not get vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        vif.PREADY = 0;
        vif.PRDATA = 0;
        vif.PSLVERR = 0;

        forever begin
            apb_seq_item item;
            `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_HIGH)
            seq_item_port.put_response(item);
            vif.PREADY = 1;
        end
    endtask

    // virtual task apb_write(apb_seq_item item);
    //     seq_item_port.get_next_item(item);
    //     vif.PADDR = item.address;
    //     vif.PPROT = ;
    //     vif.PNSE = ;
    //     vif.PSEL =;
    //     vif.PENABLE = ;
    //     vif.PWRITE = ;
    //     vif.PREADY = ;
    //     vif.PWDATA = ;
    //     vif.PSTRB = ;
    //     @(posedge vif.PCLK);
    //     seq_item_port.item_done();
    // endtask
endclass
