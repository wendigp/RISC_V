interface msrv32_rst_if(input logic ms_riscv32_mp_clk_in);
	
	logic ms_riscv32_mp_rst_in;
	wire [63:0] ms_riscv32_mp_rc_in;

	//Driver clocking block
	clocking drv_cb @(posedge ms_riscv32_mp_clk_in);
	default input #1 output #1;
	output ms_riscv32_mp_rst_in;
	output ms_riscv32_mp_rc_in;
	endclocking

	//REFERNCE MODEL Clocking block
	clocking rm_cb @(posedge ms_riscv32_mp_clk_in);
	default input #1 output #1;
	input ms_riscv32_mp_rst_in;
	input ms_riscv32_mp_rc_in;
	endclocking

	//Monitor clocking block
	clocking mon_cb @(posedge ms_riscv32_mp_clk_in);
	default input #1 output #1;
	input ms_riscv32_mp_rst_in;
	input ms_riscv32_mp_rc_in;
	endclocking


	//MODPORTS
	modport DRV_MP(clocking drv_cb);
	modport MON_MP(clocking mon_cb);
	modport RM_MP(clocking rm_cb);
endinterface