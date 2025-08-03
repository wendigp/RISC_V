class msrv32_rst_trans extends uvm_sequence_item;

	//factory registration
	`uvm_object_utils(msrv32_rst_trans)

	//Properties
	rand bit ms_riscv32_mp_rst_in;

	//METHODS
	extern function new(string name = "msrv32_rst_trans");
	extern function void do_print(uvm_printer printer);
endclass

//====================New Constructor==============================================
function msrv32_rst_trans::new(string name = "msrv32_rst_trans");
	super.new(name);
endfunction

//=====================PRINT=================================================
function void msrv32_rst_trans::do_print(uvm_printer printer);
	super.dp_print(print);

	printer.print_field("ms_risc32_mp_rst_in", this.ms_risc32_mp_rst_in, 1 , UVM_BIN);
endfunction