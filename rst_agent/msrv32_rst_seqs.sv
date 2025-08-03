//RESET AGENT SEQUENCE 
class msrv32_rst_seqs_base extends uvm_sequence#(msrv32_rst_trans);

	//Factory registeration
	`uvm_object_utils(msrv32_rst_seqs_base)

	//Methods
	extern function new(string name = "msrv32_rst_seqs_base");
endclass

//========================New Constructor============================================
function msrv32_rst_seqs_base::new(string name = "msrv32_rst_seqs_base");
	super.new(name);
endfunction

//====================================================================================

//===========================RESET SEQUENCE==========================================
class msrv32_rst_seq extends msrv32_rst_seqs_base;

	//Factory registration
	`uvm_object_utils(msrv32_rst_seq)

	//METHODS
	extern function new (string name = "msrv32_rst_seq");
	extern task body();
endclass

//====================New Constructor================================================
function msrv32_rst_seq::new(string name = "msrv32_rst_seq");
	super.new(name);
endfunction

//====================BODY=======================================================
task msrv32_rst_seq::body();

	//Object creation for req as handle of rst trans
	req = msrv32_rst_trans::type_id::create("req");

	//RESET DRIVER SEQ HANDSHAKING STARTS
	start_item(req);
	assert(req.randomize() with {ms_riscv32_mp_rst_in == 1'b1;});
	finish_item(req);
endtask
