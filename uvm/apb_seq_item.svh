class apb_seq_item extends uvm_sequence_item;
    // typedef enum {
    //     TLM_READ_COMMAND,
    //     TLM_WRITE_COMMAND,
    //     TLM_IGNORE_COMMAND
    // } uvm_tlm_command_e;

    rand bit [63:0] address;
    rand int command;
    rand byte data;
    rand int unsigned length;

    `uvm_object_utils_begin(apb_seq_item)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(command, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(length, UVM_ALL_ON)
    `uvm_object_utils_end

    virtual function void set_command(uvm_tlm_command_e command);
    endfunction

    virtual function bit is_read();
    endfunction

    virtual function void set_read();
    endfunction

    virtual function void set_write();
    endfunction

    virtual function bit is_write();
    endfunction

    function new(string name = "apb_seq_item");
        super.new(name);
    endfunction
endclass
