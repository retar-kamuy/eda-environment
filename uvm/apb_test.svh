`timescale 1ns / 1ns

class apb_base_test extends uvm_test;
    `uvm_component_utils(apb_base_test)

    function new(string name = "apb_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    apb_env env;
    apb_sequence seq;
    virtual apb_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = apb_env::type_id::create("env", this);

        if (!uvm_config_db #(virtual apb_if)::get(this, "", "apb_vif", vif))
            `uvm_fatal("TEST", "Did not get vif")
        uvm_config_db #(virtual apb_if)::set(this, "env.agent.*", "apb_vif", vif);

        seq = apb_sequence::type_id::create("seq");
        seq.randomize();
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agent.sequencer);
        #200ns;
        phase.drop_objection(this);
    endtask
endclass

// class test_1011 extends apb_base_test;
//     `uvm_component_utils(test_1011)
// 
//     function new(string name="test_1011", uvm_component parent=null);
//         super.new(name, parent);
//     endfunction
// 
//     virtual function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         seq.randomize() with { num inside {[300:500]}; };
//     endfunction
// endclass
