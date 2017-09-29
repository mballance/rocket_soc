/****************************************************************************
 * rocket_soc.sv
 ****************************************************************************/

/**
 * Module: rocket_soc
 * 
 * TODO: Add module documentation
 */
module rocket_soc(
		input		clk
		);
	reg rst=1;
	reg[31:0] rst_cnt = 0;

	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rst <= 0;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	reg[1:0] irq_r = 0;
	initial begin
		while (rst == 1) begin
			@(posedge clk);
		end
		
		repeat (1000) begin
			@(posedge clk);
		end
		
		//		irq_r <= 3;
	end
			
	
	localparam AXI4_ADDRESS_WIDTH = 32;
	localparam AXI4_DATA_WIDTH = 64;
	localparam AXI4_ID_WIDTH = 4;
	localparam WB_ADDRESS_WIDTH = 32;
	localparam WB_DATA_WIDTH = 32;
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
			.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
			.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) mem (
		);
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
			.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
			.AXI4_ID_WIDTH       (AXI4_ID_WIDTH      )
		) mmio (
		);
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
			.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH    ),
			.AXI4_ID_WIDTH       (8     )
		) l2 (
		);
	
	//	assign mem.AWREADY = 1;
	//	assign mem.WREADY = 1;
	//	assign mem.BVALID = 0;
	//	assign mem.ARREADY = 1;
	//	assign mem.RVALID = 0;
	//	assign mem.RDATA = 0;
	//	assign mem.RRESP = 0;
	
	//	assign mmio.AWREADY = 1;
	//	assign mmio.WREADY = 1;
	//	assign mmio.BVALID = 0;
	//	assign mmio.ARREADY = 1;
	//	assign mmio.RVALID = 0;
	//	assign mmio.RDATA = 0;
	//	assign mmio.RRESP = 0;
	
	wire[30:0] mmio_AWADDR, mmio_ARADDR;
	assign mmio.AWADDR = mmio_AWADDR[9:0];
	assign mmio.ARADDR = mmio_ARADDR[9:0];
	
	wire[31:0] mem_AWADDR, mem_ARADDR;
	assign mem.AWADDR = mem_AWADDR[15:0];
	assign mem.ARADDR = mem_ARADDR[15:0];
	
	assign l2.AWVALID = 0;
	assign l2.WVALID = 0;
	assign l2.BREADY = 0;
	assign l2.ARVALID = 0;
	assign l2.ARADDR = 0;
	assign l2.AWADDR = 0;
	assign l2.RREADY = 0;
	assign l2.WDATA = 0;
	

	wire        debug_clockeddmi_dmi_req_ready;
	wire         debug_clockeddmi_dmi_req_valid = 0;
	wire  [6:0]  debug_clockeddmi_dmi_req_bits_addr = 0;
	wire  [31:0] debug_clockeddmi_dmi_req_bits_data = 0;
	wire  [1:0]  debug_clockeddmi_dmi_req_bits_op = 0;
	wire         debug_clockeddmi_dmi_resp_ready = 0;
	wire        debug_clockeddmi_dmi_resp_valid;
	wire [31:0] debug_clockeddmi_dmi_resp_bits_data;
	wire [1:0]  debug_clockeddmi_dmi_resp_bits_resp;
	wire         debug_clockeddmi_dmiClock = clk;
	wire         debug_clockeddmi_dmiReset = rst;
	wire        debug_ndreset;
	wire        debug_dmactive;

	wire[1:0]	interrupts = irq_r;
	
	ExampleRocketTop u_dut (
			.clock                                 (clk                                ), 
			.reset                                 (rst                                ), 
			.interrupts                            (interrupts                           ), 
			.mem_axi4_0_aw_ready                   (mem.AWREADY                  ), 
			.mem_axi4_0_aw_valid                   (mem.AWVALID                  ), 
			.mem_axi4_0_aw_bits_id                 (mem.AWID                ), 
			.mem_axi4_0_aw_bits_addr               (mem_AWADDR              ), 
			.mem_axi4_0_aw_bits_len                (mem.AWLEN               ), 
			.mem_axi4_0_aw_bits_size               (mem.AWSIZE              ), 
			.mem_axi4_0_aw_bits_burst              (mem.AWBURST             ), 
			.mem_axi4_0_aw_bits_lock               (mem.AWLOCK              ), 
			.mem_axi4_0_aw_bits_cache              (mem.AWCACHE             ), 
			.mem_axi4_0_aw_bits_prot               (mem.AWPROT              ), 
			.mem_axi4_0_aw_bits_qos                (mem.AWQOS               ), 
			.mem_axi4_0_w_ready                    (mem.WREADY                   ), 
			.mem_axi4_0_w_valid                    (mem.WVALID                   ), 
			.mem_axi4_0_w_bits_data                (mem.WDATA               ), 
			.mem_axi4_0_w_bits_strb                (mem.WSTRB               ), 
			.mem_axi4_0_w_bits_last                (mem.WLAST               ), 
			.mem_axi4_0_b_ready                    (mem.BREADY                   ), 
			.mem_axi4_0_b_valid                    (mem.BVALID                   ), 
			.mem_axi4_0_b_bits_id                  (mem.BID                 ), 
			.mem_axi4_0_b_bits_resp                (mem.BRESP               ), 
			.mem_axi4_0_ar_ready                   (mem.ARREADY                  ), 
			.mem_axi4_0_ar_valid                   (mem.ARVALID                  ), 
			.mem_axi4_0_ar_bits_id                 (mem.ARID                ), 
			.mem_axi4_0_ar_bits_addr               (mem_ARADDR              ), 
			.mem_axi4_0_ar_bits_len                (mem.ARLEN               ), 
			.mem_axi4_0_ar_bits_size               (mem.ARSIZE              ), 
			.mem_axi4_0_ar_bits_burst              (mem.ARBURST             ), 
			.mem_axi4_0_ar_bits_lock               (mem.ARLOCK              ), 
			.mem_axi4_0_ar_bits_cache              (mem.ARCACHE             ), 
			.mem_axi4_0_ar_bits_prot               (mem.ARPROT              ), 
			.mem_axi4_0_ar_bits_qos                (mem.ARQOS               ), 
			.mem_axi4_0_r_ready                    (mem.RREADY                   ), 
			.mem_axi4_0_r_valid                    (mem.RVALID                   ), 
			.mem_axi4_0_r_bits_id                  (mem.RID                 ), 
			.mem_axi4_0_r_bits_data                (mem.RDATA               ), 
			.mem_axi4_0_r_bits_resp                (mem.RRESP               ), 
			.mem_axi4_0_r_bits_last                (mem.RLAST               ), 
			.mmio_axi4_0_aw_ready                  (mmio.AWREADY                 ), 
			.mmio_axi4_0_aw_valid                  (mmio.AWVALID                 ), 
			.mmio_axi4_0_aw_bits_id                (mmio.AWID               ), 
			.mmio_axi4_0_aw_bits_addr              (mmio_AWADDR             ), 
			.mmio_axi4_0_aw_bits_len               (mmio.AWLEN              ), 
			.mmio_axi4_0_aw_bits_size              (mmio.AWSIZE             ), 
			.mmio_axi4_0_aw_bits_burst             (mmio.AWBURST            ), 
			.mmio_axi4_0_aw_bits_lock              (mmio.AWLOCK             ), 
			.mmio_axi4_0_aw_bits_cache             (mmio.AWCACHE            ), 
			.mmio_axi4_0_aw_bits_prot              (mmio.AWPROT             ), 
			.mmio_axi4_0_aw_bits_qos               (mmio.AWQOS              ), 
			.mmio_axi4_0_w_ready                   (mmio.WREADY                  ), 
			.mmio_axi4_0_w_valid                   (mmio.WVALID                  ), 
			.mmio_axi4_0_w_bits_data               (mmio.WDATA              ), 
			.mmio_axi4_0_w_bits_strb               (mmio.WSTRB              ), 
			.mmio_axi4_0_w_bits_last               (mmio.WLAST              ), 
			.mmio_axi4_0_b_ready                   (mmio.BREADY                  ), 
			.mmio_axi4_0_b_valid                   (mmio.BVALID                  ), 
			.mmio_axi4_0_b_bits_id                 (mmio.BID                ), 
			.mmio_axi4_0_b_bits_resp               (mmio.BRESP              ), 
			.mmio_axi4_0_ar_ready                  (mmio.ARREADY                 ), 
			.mmio_axi4_0_ar_valid                  (mmio.ARVALID                 ), 
			.mmio_axi4_0_ar_bits_id                (mmio.ARID               ), 
			.mmio_axi4_0_ar_bits_addr              (mmio_ARADDR             ), 
			.mmio_axi4_0_ar_bits_len               (mmio.ARLEN              ), 
			.mmio_axi4_0_ar_bits_size              (mmio.ARSIZE             ), 
			.mmio_axi4_0_ar_bits_burst             (mmio.ARBURST            ), 
			.mmio_axi4_0_ar_bits_lock              (mmio.ARLOCK             ), 
			.mmio_axi4_0_ar_bits_cache             (mmio.ARCACHE            ), 
			.mmio_axi4_0_ar_bits_prot              (mmio.ARPROT             ), 
			.mmio_axi4_0_ar_bits_qos               (mmio.ARQOS              ), 
			.mmio_axi4_0_r_ready                   (mmio.RREADY                  ), 
			.mmio_axi4_0_r_valid                   (mmio.RVALID                  ), 
			.mmio_axi4_0_r_bits_id                 (mmio.RID                ), 
			.mmio_axi4_0_r_bits_data               (mmio.RDATA              ), 
			.mmio_axi4_0_r_bits_resp               (mmio.RRESP              ), 
			.mmio_axi4_0_r_bits_last               (mmio.RLAST              ), 
			.l2_frontend_bus_axi4_0_aw_ready       (l2.AWREADY      ), 
			.l2_frontend_bus_axi4_0_aw_valid       (l2.AWVALID      ), 
			.l2_frontend_bus_axi4_0_aw_bits_id     (l2.AWID    ), 
			.l2_frontend_bus_axi4_0_aw_bits_addr   (l2.AWADDR  ), 
			.l2_frontend_bus_axi4_0_aw_bits_len    (l2.AWLEN   ), 
			.l2_frontend_bus_axi4_0_aw_bits_size   (l2.AWSIZE  ), 
			.l2_frontend_bus_axi4_0_aw_bits_burst  (l2.AWBURST ), 
			.l2_frontend_bus_axi4_0_aw_bits_lock   (l2.AWLOCK  ), 
			.l2_frontend_bus_axi4_0_aw_bits_cache  (l2.AWCACHE ), 
			.l2_frontend_bus_axi4_0_aw_bits_prot   (l2.AWPROT  ), 
			.l2_frontend_bus_axi4_0_aw_bits_qos    (l2.AWQOS   ), 
			.l2_frontend_bus_axi4_0_w_ready        (l2.WREADY       ), 
			.l2_frontend_bus_axi4_0_w_valid        (l2.WVALID       ), 
			.l2_frontend_bus_axi4_0_w_bits_data    (l2.WDATA   ), 
			.l2_frontend_bus_axi4_0_w_bits_strb    (l2.WSTRB   ), 
			.l2_frontend_bus_axi4_0_w_bits_last    (l2.WLAST   ), 
			.l2_frontend_bus_axi4_0_b_ready        (l2.BREADY       ), 
			.l2_frontend_bus_axi4_0_b_valid        (l2.BVALID       ), 
			.l2_frontend_bus_axi4_0_b_bits_id      (l2.BID     ), 
			.l2_frontend_bus_axi4_0_b_bits_resp    (l2.BRESP   ), 
			.l2_frontend_bus_axi4_0_ar_ready       (l2.ARREADY      ), 
			.l2_frontend_bus_axi4_0_ar_valid       (l2.ARVALID      ), 
			.l2_frontend_bus_axi4_0_ar_bits_id     (l2.ARID    ), 
			.l2_frontend_bus_axi4_0_ar_bits_addr   (l2.ARADDR  ), 
			.l2_frontend_bus_axi4_0_ar_bits_len    (l2.ARLEN   ), 
			.l2_frontend_bus_axi4_0_ar_bits_size   (l2.ARSIZE  ), 
			.l2_frontend_bus_axi4_0_ar_bits_burst  (l2.ARBURST ), 
			.l2_frontend_bus_axi4_0_ar_bits_lock   (l2.ARLOCK  ), 
			.l2_frontend_bus_axi4_0_ar_bits_cache  (l2.ARCACHE ), 
			.l2_frontend_bus_axi4_0_ar_bits_prot   (l2.ARPROT  ), 
			.l2_frontend_bus_axi4_0_ar_bits_qos    (l2.ARQOS   ), 
			.l2_frontend_bus_axi4_0_r_ready        (l2.RREADY       ), 
			.l2_frontend_bus_axi4_0_r_valid        (l2.RVALID       ), 
			.l2_frontend_bus_axi4_0_r_bits_id      (l2.RID     ), 
			.l2_frontend_bus_axi4_0_r_bits_data    (l2.RDATA   ), 
			.l2_frontend_bus_axi4_0_r_bits_resp    (l2.RRESP   ), 
			.l2_frontend_bus_axi4_0_r_bits_last    (l2.RLAST   ), 
			.debug_clockeddmi_dmi_req_ready        (debug_clockeddmi_dmi_req_ready       ), 
			.debug_clockeddmi_dmi_req_valid        (debug_clockeddmi_dmi_req_valid       ), 
			.debug_clockeddmi_dmi_req_bits_addr    (debug_clockeddmi_dmi_req_bits_addr   ), 
			.debug_clockeddmi_dmi_req_bits_data    (debug_clockeddmi_dmi_req_bits_data   ), 
			.debug_clockeddmi_dmi_req_bits_op      (debug_clockeddmi_dmi_req_bits_op     ), 
			.debug_clockeddmi_dmi_resp_ready       (debug_clockeddmi_dmi_resp_ready      ), 
			.debug_clockeddmi_dmi_resp_valid       (debug_clockeddmi_dmi_resp_valid      ), 
			.debug_clockeddmi_dmi_resp_bits_data   (debug_clockeddmi_dmi_resp_bits_data  ), 
			.debug_clockeddmi_dmi_resp_bits_resp   (debug_clockeddmi_dmi_resp_bits_resp  ), 
			.debug_clockeddmi_dmiClock             (debug_clockeddmi_dmiClock            ), 
			.debug_clockeddmi_dmiReset             (debug_clockeddmi_dmiReset            ), 
			.debug_ndreset                         (debug_ndreset                        ), 
			.debug_dmactive                        (debug_dmactive                       ));

//	wb_if #(
//		.WB_ADDR_WIDTH  (WB_ADDRESS_WIDTH ), 
//		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
//		) bridge2periph (
//		);
//	
//	axi4_wb_bridge #(
//		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH  ), 
//		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH     ), 
//		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH       ), 
//		.WB_ADDRESS_WIDTH    (WB_ADDRESS_WIDTH    ), 
//		.WB_DATA_WIDTH       (WB_DATA_WIDTH       )
//		) u_axi2wb (
//		.axi_clk             (clk            	  ), 
//		.rstn                (!rst                ), 
//		.axi_i               (mmio.slave          ), 
//		.wb_o                (bridge2periph.master));
//
//	wire[31:0]	wb_periph_0_addr_base  = 'h6000_0000;
//	wire[31:0]	wb_periph_0_addr_limit = 'h6000_0FFF;
//	
//	wishbone_ic_32_32_1x1 wishbone_ic_32_32_1x1 (
//		.clock             (clk            ), 
//		.reset             (rst            ), 
//		.io_addr_base_0    (wb_periph_0_addr_base   ), 
//		.io_addr_limit_0   (wb_periph_0_addr_limit  ), 
//		.io_m_0_req_ADR    (bridge2periph.ADR   ), 
//		.io_m_0_req_TGA    (bridge2periph.TGA   ), 
//		.io_m_0_req_CTI    (bridge2periph.CTI   ), 
//		.io_m_0_req_BTE    (bridge2periph.BTE   ), 
//		.io_m_0_req_DAT_W  (bridge2periph.DAT_W ), 
//		.io_m_0_req_TGD_W  (bridge2periph.TGD_W ), 
//		.io_m_0_req_CYC    (bridge2periph.CYC   ), 
//		.io_m_0_req_TGC    (bridge2periph.TGC   ), 
//		.io_m_0_req_SEL    (bridge2periph.SEL   ), 
//		.io_m_0_req_STB    (bridge2periph.STB   ), 
//		.io_m_0_req_WE     (bridge2periph.WE    ), 
//		.io_m_0_rsp_DAT_R  (bridge2periph.DAT_R ), 
//		.io_m_0_rsp_TGD_R  (bridge2periph.TGD_R ), 
//		.io_m_0_rsp_ERR    (bridge2periph.ERR   ), 
//		.io_m_0_rsp_ACK    (bridge2periph.ACK   ), 
//		.io_s_0_req_ADR    (io_s_0_req_ADR   ), 
//		.io_s_0_req_TGA    (io_s_0_req_TGA   ), 
//		.io_s_0_req_CTI    (io_s_0_req_CTI   ), 
//		.io_s_0_req_BTE    (io_s_0_req_BTE   ), 
//		.io_s_0_req_DAT_W  (io_s_0_req_DAT_W ), 
//		.io_s_0_req_TGD_W  (io_s_0_req_TGD_W ), 
//		.io_s_0_req_CYC    (io_s_0_req_CYC   ), 
//		.io_s_0_req_TGC    (io_s_0_req_TGC   ), 
//		.io_s_0_req_SEL    (io_s_0_req_SEL   ), 
//		.io_s_0_req_STB    (io_s_0_req_STB   ), 
//		.io_s_0_req_WE     (io_s_0_req_WE    ), 
//		.io_s_0_rsp_DAT_R  (io_s_0_rsp_DAT_R ), 
//		.io_s_0_rsp_TGD_R  (io_s_0_rsp_TGD_R ), 
//		.io_s_0_rsp_ERR    (io_s_0_rsp_ERR   ), 
//		.io_s_0_rsp_ACK    (io_s_0_rsp_ACK   ));
	
	axi4_sram #(
			.MEM_ADDR_BITS      (10     		), 
			.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
			.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
			.AXI_ID_WIDTH       (AXI4_ID_WIDTH      )
		) u_mmio (
			.ACLK               (clk              ), 
			.ARESETn            (!rst             ), 
			.s                  (mmio.slave       ));
	
	axi4_sram #(
			.MEM_ADDR_BITS      (12     ),  // 64K of 64-bit words
			.AXI_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH ), 
			.AXI_DATA_WIDTH     (AXI4_DATA_WIDTH    ), 
			.AXI_ID_WIDTH       (AXI4_ID_WIDTH      ),
			.INIT_FILE			("ram.hex")
		) u_mem (
			.ACLK               (clk              ), 
			.ARESETn            (!rst             ), 
			.s                  (mem.slave        ));	

endmodule


