
module fpga_top
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           cfg_awvalid_i
    ,input  [ 31:0]  cfg_awaddr_i
    ,input           cfg_wvalid_i
    ,input  [ 31:0]  cfg_wdata_i
    ,input  [  3:0]  cfg_wstrb_i
    ,input           cfg_bready_i
    ,input           cfg_arvalid_i
    ,input  [ 31:0]  cfg_araddr_i
    ,input           cfg_rready_i
    ,input  [ 31:0]  dfi_rddata_i
    ,input           dfi_rddata_valid_i
    ,input  [  1:0]  dfi_rddata_dnv_i

    // Outputs
    ,output          cfg_awready_o
    ,output          cfg_wready_o
    ,output          cfg_bvalid_o
    ,output [  1:0]  cfg_bresp_o
    ,output          cfg_arready_o
    ,output          cfg_rvalid_o
    ,output [ 31:0]  cfg_rdata_o
    ,output [  1:0]  cfg_rresp_o
    ,output [ 14:0]  dfi_address_o
    ,output [  2:0]  dfi_bank_o
    ,output          dfi_cas_n_o
    ,output          dfi_cke_o
    ,output          dfi_cs_n_o
    ,output          dfi_odt_o
    ,output          dfi_ras_n_o
    ,output          dfi_reset_n_o
    ,output          dfi_we_n_o
    ,output [ 31:0]  dfi_wrdata_o
    ,output          dfi_wrdata_en_o
    ,output [  3:0]  dfi_wrdata_mask_o
    ,output          dfi_rddata_en_o
    ,output          status_busy_o
    ,output          status_err_o
);

wire           axi4_awready_w;
wire           axi4_arready_w;
wire  [  7:0]  axi4_arlen_w;
wire           axi4_wvalid_w;
wire  [ 31:0]  axi4_araddr_w;
wire  [  1:0]  axi4_bresp_w;
wire  [ 31:0]  axi4_wdata_w;
wire           axi4_rlast_w;
wire           axi4_awvalid_w;
wire  [  3:0]  axi4_rid_w;
wire  [  1:0]  axi4_rresp_w;
wire           axi4_bvalid_w;
wire  [  3:0]  axi4_wstrb_w;
wire  [  1:0]  axi4_arburst_w;
wire           axi4_arvalid_w;
wire  [  3:0]  axi4_awid_w;
wire  [  3:0]  axi4_bid_w;
wire  [  3:0]  axi4_arid_w;
wire           axi4_rready_w;
wire  [  7:0]  axi4_awlen_w;
wire           axi4_wlast_w;
wire  [ 31:0]  axi4_rdata_w;
wire           axi4_bready_w;
wire  [ 31:0]  axi4_awaddr_w;
wire           axi4_wready_w;
wire  [  1:0]  axi4_awburst_w;
wire           axi4_rvalid_w;


ram_tester
#(
     .AXI_ID(0)
)
u_tester
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(cfg_awvalid_i)
    ,.cfg_awaddr_i(cfg_awaddr_i)
    ,.cfg_wvalid_i(cfg_wvalid_i)
    ,.cfg_wdata_i(cfg_wdata_i)
    ,.cfg_wstrb_i(cfg_wstrb_i)
    ,.cfg_bready_i(cfg_bready_i)
    ,.cfg_arvalid_i(cfg_arvalid_i)
    ,.cfg_araddr_i(cfg_araddr_i)
    ,.cfg_rready_i(cfg_rready_i)
    ,.outport_awready_i(axi4_awready_w)
    ,.outport_wready_i(axi4_wready_w)
    ,.outport_bvalid_i(axi4_bvalid_w)
    ,.outport_bresp_i(axi4_bresp_w)
    ,.outport_bid_i(axi4_bid_w)
    ,.outport_arready_i(axi4_arready_w)
    ,.outport_rvalid_i(axi4_rvalid_w)
    ,.outport_rdata_i(axi4_rdata_w)
    ,.outport_rresp_i(axi4_rresp_w)
    ,.outport_rid_i(axi4_rid_w)
    ,.outport_rlast_i(axi4_rlast_w)

    // Outputs
    ,.cfg_awready_o(cfg_awready_o)
    ,.cfg_wready_o(cfg_wready_o)
    ,.cfg_bvalid_o(cfg_bvalid_o)
    ,.cfg_bresp_o(cfg_bresp_o)
    ,.cfg_arready_o(cfg_arready_o)
    ,.cfg_rvalid_o(cfg_rvalid_o)
    ,.cfg_rdata_o(cfg_rdata_o)
    ,.cfg_rresp_o(cfg_rresp_o)
    ,.status_busy_o(status_busy_o)
    ,.status_err_o(status_err_o)
    ,.outport_awvalid_o(axi4_awvalid_w)
    ,.outport_awaddr_o(axi4_awaddr_w)
    ,.outport_awid_o(axi4_awid_w)
    ,.outport_awlen_o(axi4_awlen_w)
    ,.outport_awburst_o(axi4_awburst_w)
    ,.outport_wvalid_o(axi4_wvalid_w)
    ,.outport_wdata_o(axi4_wdata_w)
    ,.outport_wstrb_o(axi4_wstrb_w)
    ,.outport_wlast_o(axi4_wlast_w)
    ,.outport_bready_o(axi4_bready_w)
    ,.outport_arvalid_o(axi4_arvalid_w)
    ,.outport_araddr_o(axi4_araddr_w)
    ,.outport_arid_o(axi4_arid_w)
    ,.outport_arlen_o(axi4_arlen_w)
    ,.outport_arburst_o(axi4_arburst_w)
    ,.outport_rready_o(axi4_rready_w)
);


ddr3_axi
#(
     .DDR_WRITE_LATENCY(3)
    ,.DDR_READ_LATENCY(3)
    ,.DDR_MHZ(24)
)
u_ddr
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(axi4_awvalid_w)
    ,.inport_awaddr_i(axi4_awaddr_w)
    ,.inport_awid_i(axi4_awid_w)
    ,.inport_awlen_i(axi4_awlen_w)
    ,.inport_awburst_i(axi4_awburst_w)
    ,.inport_wvalid_i(axi4_wvalid_w)
    ,.inport_wdata_i(axi4_wdata_w)
    ,.inport_wstrb_i(axi4_wstrb_w)
    ,.inport_wlast_i(axi4_wlast_w)
    ,.inport_bready_i(axi4_bready_w)
    ,.inport_arvalid_i(axi4_arvalid_w)
    ,.inport_araddr_i(axi4_araddr_w)
    ,.inport_arid_i(axi4_arid_w)
    ,.inport_arlen_i(axi4_arlen_w)
    ,.inport_arburst_i(axi4_arburst_w)
    ,.inport_rready_i(axi4_rready_w)
    ,.dfi_rddata_i(dfi_rddata_i)
    ,.dfi_rddata_valid_i(dfi_rddata_valid_i)
    ,.dfi_rddata_dnv_i(dfi_rddata_dnv_i)

    // Outputs
    ,.inport_awready_o(axi4_awready_w)
    ,.inport_wready_o(axi4_wready_w)
    ,.inport_bvalid_o(axi4_bvalid_w)
    ,.inport_bresp_o(axi4_bresp_w)
    ,.inport_bid_o(axi4_bid_w)
    ,.inport_arready_o(axi4_arready_w)
    ,.inport_rvalid_o(axi4_rvalid_w)
    ,.inport_rdata_o(axi4_rdata_w)
    ,.inport_rresp_o(axi4_rresp_w)
    ,.inport_rid_o(axi4_rid_w)
    ,.inport_rlast_o(axi4_rlast_w)
    ,.dfi_address_o(dfi_address_o)
    ,.dfi_bank_o(dfi_bank_o)
    ,.dfi_cas_n_o(dfi_cas_n_o)
    ,.dfi_cke_o(dfi_cke_o)
    ,.dfi_cs_n_o(dfi_cs_n_o)
    ,.dfi_odt_o(dfi_odt_o)
    ,.dfi_ras_n_o(dfi_ras_n_o)
    ,.dfi_reset_n_o(dfi_reset_n_o)
    ,.dfi_we_n_o(dfi_we_n_o)
    ,.dfi_wrdata_o(dfi_wrdata_o)
    ,.dfi_wrdata_en_o(dfi_wrdata_en_o)
    ,.dfi_wrdata_mask_o(dfi_wrdata_mask_o)
    ,.dfi_rddata_en_o(dfi_rddata_en_o)
);




endmodule
