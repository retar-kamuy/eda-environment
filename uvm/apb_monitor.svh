class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)

    function new(string name="apb_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(apb_seq_item) mon_analysis_port;
    virtual apb_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual apb_if)::get(this, "", "des_vif", vif))
            `uvm_fatal("MON", "Could not get vif")
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(vif.cb);
            if (vif.PRESETn) begin
                apb_seq_item item = apb_seq_item::type_id::create("item");
                // item.in = vif.in;
                // item.out = vif.cb.out;
                mon_analysis_port.write(item);
                // `uvm_info("MON", $sformatf("Saw item %s", item.convert2str()), UVM_HIGH)
            end
        end
    endtask
endclass