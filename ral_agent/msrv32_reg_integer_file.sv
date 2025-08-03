//MEMORY BLOCK FOR 32 GENERAL PURPOSE REGISTERS - x0 to x32

class msrv32_reg_integer_file extends uvm_mem;    //Equivalent to 32 registers in design

	//factory registration
	`uvm_object_utils(msrv32_reg_integer_file)

	//methods
	extern function new (string name = "msrv32_reg_integer_file");
endclass

function msrv32_reg_integer_file::new(string name = "msrv32_reg_integer_file");
	super.new(name, 32,32,"RW",UVM_NO_COVERAGE); 		// 32 registers, each of size 32 bits making it a memory like structure as 32x32
//name - unique name of this memory block, 32 - size (no of elements), 32 - width of each elements or registers, RW - ACCESS(Read / Write), UVM_NO_COVERAGE - Disables built in reg coverage
endfunction

////============================================================================================================//

//PROGRAM COUNTER REGISTER - A 32 bit register
class pc_reg extends uvm_reg;  //Program counter has only one info, the address of next instr - but specifically it has no fields but every reg has atleast 1 field, so here it is reg itself

	//factory registration
	`uvm_object_utils(pc_reg)

	//properties
	rand uvm_reg_field pc_1;

	//methods
	extern function new(string name = "pc_reg");
	extern function void build_phase(uvm_phase phase);
endclass

function pc_reg::new(string name = "pc_reg");
	super.new(name, 32,UVM_NO_COVERAGE);
endfunction

function void pc_reg::build_phase(uvm_phase phase);
	super.new(phase);
	pc_1 = uvm_reg_field::type_id::create("pc_1");
	pc_1.configure(this,32,0,"RW",0,32'h0000_0000,1,1,0);
endfunction

//EXPLANATION OF ABOVE CODE
/*.configure(
	this,            // Parent register
	32,              // Number of bits (width) or unsigned size
	0,               // unsigned LSB position
	"RW",            // Access type
	0,               // Volatility
	32'h0000_0000,   // Reset value
	1,               // Has reset?
	1,               // Is rand?
	0                // individually accesible
);
*/


