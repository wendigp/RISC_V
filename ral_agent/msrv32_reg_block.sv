//REG Block

class msrv32_reg_block extends uvm_reg_block;

	//factory registeration
	`uvm_object_utils(msrv32_reg_block)

	rand msrv32_reg_integer_file 	reg_file;   	//Replica of 32 registers in form of memory
	
	uvm_reg_map 			rv32_reg_map;   //as uvm_reg_map is a non_virtual class , we will directly create an object for base class

	extern function new(string name = "msrv32_reg_block");
	extern function void build();
endclass

function msrv32_reg_block :: new(string name = "msrv32_reg_block");
	super.new(name,UVM_NO_COVERAGE);
endfunction

function void msrv32_reg_block :: build();		//This is build function not build phase 
	
	reg_file=msrv32_reg_integer_file::type_id::create("reg_file");		//Create memory/registers
	reg_file.configure(this,"");						//Configure them

	//These both hdl path combinedly be used for backdoor access
	add_hdl_path("msrv32_tb_top.DUT","RTL");				//add hdl path - specifying where the DUT exists in the simulation hierarchy
	//hdl slice is the path of actual reg present in design
	reg_file.add_hdl_path_slice("DUT.IRF.reg_file",0,32);			//maps the memory reg_file to a specific RTL signal inside the DUT - (signal name,offset,width)
	

	rv32_reg_map= create_map("rv32_reg_map",`h0,4,UVM_LITTLE_ENDIAN,0);	//Creating object of map named as rv32_reg_map (name,offset addr/base addr, size of each registers,endianess)
	rv32_reg_map.add_mem(reg_file,32`h0,"RW");				//add memory replica to register map
endfunction

////REG BLOCK FOR PC
class msrv32_reg_block_for_pc extends uvm_reg_block;

	//factory registeration
	`uvm_object_utils(msrv32_reg_block_for_pc)

	rand pc_reg		 pc_h;

	uvm_reg_map 		rv32_reg_map;

	extern function new(string name = "msrv32_reg_block_for_pc");
	extern function void build();
endclass

function msrv32_reg_block_for_pc::new(string name = "msrv32_reg_block_for_pc");
	super.new(name,UVM_NO_COVERAGE);
endfunction

function void msrv32_reg_block_for_pc::build();

	pc_h = pc_reg::type_id::create("pc_h");
	pc_h.configure(this,null,"");

	add_hdl_path("msrv32_tb_top.DUT","RTL");
	pc_h.add_hdl_path_slice("DUT.REG1.pc_out",0,32);

	rv32_reg_map = create("rv32_reg_map",0,4,UVM_LITTLE_ENDIAN,0);
	rv32_reg_map.add_reg(pc_h,32'h0,"RW");
	lock_model();		//Locks the register model so it cannot be modified after build
endfunction
