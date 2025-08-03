
//TEST FILE

class msrv32_test_base extends uvm_test;

	//factory registeration
	`uvm_component_utils(msrv32_test_base)

	//TB COMPONENTS DECLARATION
	msrv32_env			env;
	msrv32_env_config		m_cfg;

	msrv32_instr_agent_config 	in_cfg[];
	msrv32_data_agent_config	d_cfg[];
	msrv32_irq_agent_config		ir_cfg[];
	msrv32_rst_agent_config		r_cfg[];

	//PROPERTIES
	bit has_instr_agent 	 = 1;
	bit has_data_agent  	 = 1;
	bit has_irq_agent   	 = 1;
	bit has_rst_agent   	 = 1;
	bit has_instr_subscriber = 1;

	int no_of_instr_agent = 2;
	int no_of_data_agent  = 2;
	int no_of_irq_agent   = 2;
	int no_of_rst_agent   = 2;

	//DECLARATION OF RAL
	msrv32_reg_block 		rv32_reg_block_h;
	msrv32_reg_block_for_pc		rv32_reg_block_h_for_pc;	

	string test_case_name;

	//METHODS
	extern function new(string name = "msrv32_test_base", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern function void config_riscv();
	extern function void report_phase(uvm_phase phase);
endclass

//===========================NEW CONSTRUCTOR=================================================
function msrv32_test_base::new(string name = "msrv32_test_base", uvm_component parent);
	super.new(name,parent);
endfunction

//==========================END OF ELABORATION=======================================================
function void msrv32_test_base::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	//PRINT TOPOLOGY
	uvm_top.print_topology();
endfunction

//==========================RISCV CONFIG============================================================
function void msrv32_test_base::config_riscv();
	
	//INSTR AGENT
	if(has_instr_agent)
	 begin
	  in_cfg = new[no_of_instr_agent];
	   foreach(in_cfg[i])
	     begin
		in_cfg[i] = msrv32_instr_agent_config::type_id::create($sformatf("in_cfg[%0d]",i));
	
		if(!uvm_config_db #(virtual msrv32_ahb_instr_if)::get(this,"",$sformatf("msrv32_ahb_instr_if_%0d",i),in_cfg[i].vif))
		  `uvm_fatal("VIF CONFIG.WRITE","cannot get instr interface vif from uvm_config_db. Have you set it?")
		in_cfg[i].is_active = UVM_ACTIVE;
		m_cfg.in_cfg[i] = in_cfg[i];
	    end
	end
	
	//DATA AGENT
	if(has_data_agent)
	 begin
	  d_cfg = new[no_of_data_agent];
	    foreach(d_cfg[i])
		begin
		  d_cfg[i] = msrv32_data_agent_config::type_id::create($sformatf("d_cfg[%0d]",i));
		
		  if(!uvm_config_db #(virtual msrv32_ahb_data_if)::get(this,"",$sformatf("msrv32_ahb_data_if_%0d",i),d_cfg[i].vif))
		    `uvm_fatal("VIF CONFIG.WRITE","cannot get data interface vif from uvm_config_db. Have you set it?")
		  d_cfg[i].is_active = UVM_ACTIVE;
		  m_cfg.d_cfg[i] = d_cfg[i];
		end
	 end

	//RST AGENT
	if(has_rst_agent)
	 begin
	  r_cfg = new[no_of_rst_agent];
	    foreach(r_cfg[i])
		begin
		  r_cfg[i] = msrv32_rst_agent_config::type_id::create($sformatf("r_cfg[%0d]",i));
		
		  if(!uvm_config_db #(virtual msrv32_ahb_rst_if)::get(this,"",$sformatf("msrv32_ahb_rst_if_%0d",i),r_cfg[i].vif))
		    `uvm_fatal("VIF CONFIG.WRITE","cannot get rst interface vif from uvm_config_db. Have you set it?")
		  r_cfg[i].is_active = UVM_ACTIVE;
		  m_cfg.r_cfg[i] = r_cfg[i];
		end
	 end

	//INTERRUPT AGENT
	if(has_irq_agent)
	 begin
	  ir_cfg = new[no_of_irq_agent];
	    foreach(ir_cfg[i])
		begin
		  ir_cfg[i] = msrv32_irq_agent_config::type_id::create($sformatf("ir_cfg[%0d]",i));
		
		  if(!uvm_config_db #(virtual msrv32_ahb_irq_if)::get(this,"",$sformatf("msrv32_ahb_irq_if_%0d",i),ir_cfg[i].vif))
		    `uvm_fatal("VIF CONFIG.WRITE","cannot get irq interface vif from uvm_config_db. Have you set it?")
		  ir_cfg[i].is_active = UVM_ACTIVE;
		  m_cfg.ir_cfg[i] = ir_cfg[i];
		end
	 end	

	m_cfg.has_instr_agent 	= has_instr_agent;
	m_cfg.has_data_agent	= has_data_agent;
	m_cfg.has_rst_agent	= has_rst_agent;
	m_cfg.has_irq_agent	= has_irq_agent;

	m_cfg.no_of_instr_agent 	= no_of_instr_agent;
	m_cfg.no_of_data_agent		= no_of_data_agent;
	m_cfg.no_of_rst_agent		= no_of_rst_agent;
	m_cfg.no_of_irq_agent		= no_of_irq_agent;
endfunction

//====================BUILD PHASE=====================================================
function void msrv32_test_base::build_phase(uvm_phase phase);
	super.build_phase(phase);

	//CREATING OBJECT FOR ENV CONFIG
	m_cfg = msrv32_env_config::type_id::create("m_cfg");

	//CREATING OBJECT FOR REG BLOCK
	rv32_reg_block_h = msrv32_reg_block::type_id::create("rv32_reg_block_h");
	rv32_reg_block_h.build();
	m_cfg.rv32_reg_block_h = this.rv32_reg_block_h;		//Assigning a handle to register model in env config or in simple words putting reg block in env config

	//CREATING OBJECT FOR REG FOR PC
	rv32_reg_block_h_for _pc = msrv32_reg_block_for_pc::type_id::create("rv32_reg_block_h_for_pc");
	rv32_reg_block_h_for_pc.build();
	m_cfg.rv32_reg_block_h_for_pc = this.rv32_reg_block_h_for_pc;
	
	if(has_inst_agent)
	begin
		m_cfg.in_cfg = new[no_of_instr_agent];
	end

	if(has_data_agent)
	begin
		m_cfg.d_cfg = new{no_of_data_agent];
	end

	if(has_rst_agent)
	begin
		m_cfg.r_cfg = new[no_of_rst_agent];
	end

	if(has_irq_agent)
	begin
		m_cfg.ir_cfg = new[no_of_irq_agent];
	end

	//CALLING CONFIG_RISCV
	config_riscv();
	
	//SETTING VALUES TO ENV CONFIG
	uvm_config_db #(msrv32_env_config)::set(this,"*","msrv32_env_config",m_cfg);

	//CREATING ENV CLASS OBJECT
	env = msrv32_env::type_id::create("env",this);
endfunction

//=============================Report Phase====================================
function void msrv32_test_base::report_phase(uvm_phase phase);
	super.report_phase(phase);

	if(m_cfg.failed_commands.size() != 0)
	begin
	`uvm_info(get_type_name(),$sformatf("\n failed commands : %p", m_cfg.failed_commands),UVM_LOW)
	end

	else if(m_cfg.passed_commands.size() != 0)
	begin
	`uvm_info(get_type_name(), $sformatf("n passed commands : %p",m_cfg.passed_commands),UVM_LOW)
	end
endfunction


//========================================================================================
//====================================================================================
//==========================RESET TEST==========================================
class msrv32_reset_test extends msrv32_test_base;

	//Factory registeration
	`uvm_component_utils(msrv32_reset_test)

	//HANDLE RESET VIRTUAL SEQ
	reset_vseq	rst_seqh;

	//STANDARD METHODS
	extern function new(string name = "msrv32_reset_test", uvm_component parent)
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//============================New Constructor==============================
function msrv32_reset_test::new(string name = "msrv32_reset_test",uvm_component parent);
	super.new(name,parent);
endfunction

//==========================BUILD PHASE OF RESET TEST=================================
function void msrv32_reset_test::build_phase(uvm_phase phase);
	super.new(phase);
endfunction

//========================RUN PHASE FOR _RESET TEST========================================
task msrv32_reset_test::run_phase(uvm_phase phase);
	super.new(phase);

	begin
	//RAISING OBJECTION
	phase.raise_objection(this);
	`uvm_info(get_type_name(),"RESET TEST RUN_PHASE STARTS",UVM_DEBUG)
	
	//OBJECT CREATION FOR RESET V_SEQ
	rst_seqh = reset_vseq::type_id::create("rst_seqh");

	//CALLING START METHOD
	rst_seqh.start(env.v_seqeuncer);
	//DROPPING OBJECTION
	phase.drop_objection(this);
	end
endtask
	

