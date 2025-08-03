//VIRTUAL SEQUENCER
class msrv32_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	//Factory Registeration
	`uvm_component_utils(msrv32_virtual_sequencer)

	//HANDLE OF ALL ACTUAL SEQUENCER
	msrv32_instr_sequencer		in_seqrh[];
	msrv32_data_sequencer		d_seqrh[];
	msrv32_irq_sequencer		ir_seqrh[];
	msrv32_rst_sequencer		r_seqrh[];

	//ENV CONFIG HANDLE
	msrv32_env_config		m_cfg;

	//STANDARD METHODS
	extern function new(string name = "msrv32_virtual_sequencer", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

//=================================New Constructor==================================
function msrv32_virtual_sequencer::new(string name = "msrv32_virtual_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction

//================================BUILD PHASE============================================
function void msrv32_virtual_sequencer::build_phase(uvm_phase phase);
	super.build_phase(phase);

	//GETTING DATA FROM ENV CONFIG
	if(!uvm_config_db #(msrv32_env_config)::get(this,"","msrv32_virtual_sequencer",m_cfg))
		`uvm_fatal("VIRTUAL SEQUENCER","Cannot get() m_cfg from uvm_config_db. Have you set it?")

	//Creating object for actual sequencer in virtual sequencer
	in_seqrh 	= new[m_cfg.no_of_instr_agent];
	d_seqrh 	= new[m_cfg.no_of_data_agent];
	ir_seqrh	= new[m_cfg.no_of_irq_agent];
	r_seqrh		= new[m)cfg.no_of_rst_agent];
endfunction