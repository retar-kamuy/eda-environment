class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)

    function new(string name="apb_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    apb_driver driver;
    apb_sequencer sequencer;
    apb_monitor monitor;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if ( get_is_active() == UVM_ACTIVE ) begin
            sequencer = apb_sequencer::type_id::create("sequencer", this);
            driver = apb_driver::type_id::create("driver", this);
        end

        monitor = apb_monitor::type_id::create("monitor", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if( get_is_active() == UVM_ACTIVE ) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
endclass
