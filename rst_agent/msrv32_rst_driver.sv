//RESET DRIVER
class msrv32_rst_driver extends uvm_driver #(msrv32_rst_trans);

	//Factory Registration
	`uvm_component_utils(msrv32_rst_driver)

	//RST CONFIG HANDLE
	msrv32_rst_agent_config		r_cfg;

	//RST TRANSACTION HANDLE
	msrv32_rst_trans		rst_xtn;

	//VIRTUAL RST INTERFACE FOR DRIVER
	virtual msrv32_rst_if.DRV_MP	vif;

	//METHODS
	extern function new(string name = "msrv32_rst_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(msrv32_rst_trans rst_xtn);
endclass

//========================New Constructor============================================
function msrv32_rst_driver::new(string name = "msrv32_rst_driver", uvm_component parent);
	super.new(name,parent);
endfunction

//======================RESET DRIVER BUILD PHASE=================================
function void msrv32_rst_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);

	//GETTING DATA FROM RST AGENT CONFIG
	if(!uvm_config_db #(msrv32_rst_agent_config)::get(this,"","msrv32_rst_agent_config",r_cfg))
		`uvm_fatal("RESET DRIVER", "Cannot get data from rst config. Have you set it?")
endfunction

//=============================RESET DRIVER CONNECT PHASE======================================
function void msrv32_rst_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	//Handle ASSIGNMENT
	vif = vif.r_cfg;
endfunction

//============================RESET RUN PHASE==================================
task msrv32_rst_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	//HANDSHAKING OF DRIVER AND SEQUENCER
	forever
	begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done();
	end
endtask

//==========================SEND TO DUT TASK=======================================
task msrv32_rst_driver::send_to_dut(msrv32_rst_trans rst_xtn);

	`uvm_info(get_type_name(),$sformatf("SEND DATA FROM RST DRIVER: \n %s ",rst_xtn.sprint()),UVM_DEBUG)
	@(vif.drv_cb)
	if(rst_xtn.ms_riscv32_mp_rst_in = 1'b1)
		vif.drv_cb.ms_riscv32_mp_rst_in  <= rst_xtn.ms_riscv32_mp_rst_in;
		repeat(1)
		@(vif.drv_cb);
		vif.drv_cb.ms_riscv32_mp_rst_in <= 1'b0;
		
		r_cfg.drv_rst_count++;
endtask