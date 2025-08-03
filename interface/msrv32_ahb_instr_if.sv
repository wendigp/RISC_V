
interface msrv32_ahb_instr_if (input logic ms_riscv32_mp_clk_in);

	wire [31:0] ms_riscv32_mp_instr_in;
	wire [31:0] ms_riscv32_mp_imaddr_out;
	wire ms_riscv32_mp_instr_hready_in;

	//Driver clocking block
	clocking drv_cb @(posedge ms_riscv32_mp_clk_in);
	default input #1 output #1;
	output ms_riscv32_mp_instr_in;
	output ms_riscv32_mp_instr_hready_in;
	input ms_riscv32_mp_imaddr_out;
	endclocking

	//REFERNCE MODEL Clocking block
	clocking rm_cb @(posedge ms_riscv32_mp_clk_in);
	default input #1 output #1;
	input ms_riscv32_mp_instr_in;
	output ms_riscv32_mp_imaddr_out;
	endclocking

	//Monitor clocking block
	clocking mon_cb @(posedge ms_riscv32_mp_clk_in);
	default input #1 output #1;
	input ms_riscv32_mp_instr_in;
	input ms_riscv32_mp_instr_hready_in;
	output ms_riscv32_mp_imaddr_out;
	endclocking


	//MODPORTS
	modport DRV_MP(clocking drv_cb);
	modport MON_MP(clocking mon_cb);
	modport RM_MP(clocking rm_cb);
endinterface