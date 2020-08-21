//-----------------------------------------------------------------
// TOP
//-----------------------------------------------------------------
module top
(
     input          clk48

    ,output         rgb_led_r
    ,output         rgb_led_g
    ,output         rgb_led_b

    ,output [15:0]  ddram_a
    ,output [2:0]   ddram_ba
    ,output         ddram_ras_n
    ,output         ddram_cas_n
    ,output         ddram_we_n
    ,output         ddram_cs_n
    ,output [1:0]   ddram_dm
    ,inout [15:0]   ddram_dq
    ,inout [1:0]    ddram_dqs_p
    ,output         ddram_clk_p
    ,output         ddram_cke
    ,output         ddram_odt
    ,output         ddram_reset_n
);

localparam DDR_SIZE = (128 * 1024 * 1024);

`define RAM_TEST_CFG    8'h0

    `define RAM_TEST_CFG_BURST_LEN_DEFAULT    0
    `define RAM_TEST_CFG_BURST_LEN_B          28
    `define RAM_TEST_CFG_BURST_LEN_T          31
    `define RAM_TEST_CFG_BURST_LEN_W          4
    `define RAM_TEST_CFG_BURST_LEN_R          31:28

    `define RAM_TEST_CFG_READ      8
    `define RAM_TEST_CFG_READ_DEFAULT    0
    `define RAM_TEST_CFG_READ_B          8
    `define RAM_TEST_CFG_READ_T          8
    `define RAM_TEST_CFG_READ_W          1
    `define RAM_TEST_CFG_READ_R          8:8

    `define RAM_TEST_CFG_RND_DELAY      7
    `define RAM_TEST_CFG_RND_DELAY_DEFAULT    0
    `define RAM_TEST_CFG_RND_DELAY_B          7
    `define RAM_TEST_CFG_RND_DELAY_T          7
    `define RAM_TEST_CFG_RND_DELAY_W          1
    `define RAM_TEST_CFG_RND_DELAY_R          7:7

    `define RAM_TEST_CFG_USER      3
    `define RAM_TEST_CFG_USER_DEFAULT    0
    `define RAM_TEST_CFG_USER_B          3
    `define RAM_TEST_CFG_USER_T          3
    `define RAM_TEST_CFG_USER_W          1
    `define RAM_TEST_CFG_USER_R          3:3

    `define RAM_TEST_CFG_INCR      2
    `define RAM_TEST_CFG_INCR_DEFAULT    0
    `define RAM_TEST_CFG_INCR_B          2
    `define RAM_TEST_CFG_INCR_T          2
    `define RAM_TEST_CFG_INCR_W          1
    `define RAM_TEST_CFG_INCR_R          2:2

    `define RAM_TEST_CFG_ONES      1
    `define RAM_TEST_CFG_ONES_DEFAULT    0
    `define RAM_TEST_CFG_ONES_B          1
    `define RAM_TEST_CFG_ONES_T          1
    `define RAM_TEST_CFG_ONES_W          1
    `define RAM_TEST_CFG_ONES_R          1:1

    `define RAM_TEST_CFG_ZERO      0
    `define RAM_TEST_CFG_ZERO_DEFAULT    0
    `define RAM_TEST_CFG_ZERO_B          0
    `define RAM_TEST_CFG_ZERO_T          0
    `define RAM_TEST_CFG_ZERO_W          1
    `define RAM_TEST_CFG_ZERO_R          0:0

`define RAM_TEST_BASE    8'h4

    `define RAM_TEST_BASE_ADDR_DEFAULT    0
    `define RAM_TEST_BASE_ADDR_B          0
    `define RAM_TEST_BASE_ADDR_T          31
    `define RAM_TEST_BASE_ADDR_W          32
    `define RAM_TEST_BASE_ADDR_R          31:0

`define RAM_TEST_END    8'h8

    `define RAM_TEST_END_ADDR_DEFAULT    0
    `define RAM_TEST_END_ADDR_B          0
    `define RAM_TEST_END_ADDR_T          31
    `define RAM_TEST_END_ADDR_W          32
    `define RAM_TEST_END_ADDR_R          31:0

`define RAM_TEST_STS    8'hc

    `define RAM_TEST_STS_BUSY      0
    `define RAM_TEST_STS_BUSY_DEFAULT    0
    `define RAM_TEST_STS_BUSY_B          0
    `define RAM_TEST_STS_BUSY_T          0
    `define RAM_TEST_STS_BUSY_W          1
    `define RAM_TEST_STS_BUSY_R          0:0

`define RAM_TEST_CURRENT    8'h10

    `define RAM_TEST_CURRENT_ADDR_DEFAULT    0
    `define RAM_TEST_CURRENT_ADDR_B          0
    `define RAM_TEST_CURRENT_ADDR_T          31
    `define RAM_TEST_CURRENT_ADDR_W          32
    `define RAM_TEST_CURRENT_ADDR_R          31:0

`define RAM_TEST_WRITE    8'h14

    `define RAM_TEST_WRITE_PATTERN_DEFAULT    0
    `define RAM_TEST_WRITE_PATTERN_B          0
    `define RAM_TEST_WRITE_PATTERN_T          31
    `define RAM_TEST_WRITE_PATTERN_W          32
    `define RAM_TEST_WRITE_PATTERN_R          31:0

`define RAM_TEST_TIME    8'h18

    `define RAM_TEST_TIME_CYCLES_DEFAULT    0
    `define RAM_TEST_TIME_CYCLES_B          0
    `define RAM_TEST_TIME_CYCLES_T          31
    `define RAM_TEST_TIME_CYCLES_W          32
    `define RAM_TEST_TIME_CYCLES_R          31:0

`define RAM_TEST_ERRORS    8'h1c

    `define RAM_TEST_ERRORS_COUNT_DEFAULT    0
    `define RAM_TEST_ERRORS_COUNT_B          0
    `define RAM_TEST_ERRORS_COUNT_T          31
    `define RAM_TEST_ERRORS_COUNT_W          32
    `define RAM_TEST_ERRORS_COUNT_R          31:0

`define RAM_TEST_LAST    8'h20

    `define RAM_TEST_LAST_RD_DATA_DEFAULT    0
    `define RAM_TEST_LAST_RD_DATA_B          0
    `define RAM_TEST_LAST_RD_DATA_T          31
    `define RAM_TEST_LAST_RD_DATA_W          32
    `define RAM_TEST_LAST_RD_DATA_R          31:0


//-----------------------------------------------------------------
// PLL
//-----------------------------------------------------------------
wire [3:0] clk_pll_w;

ecp5pll
#(
   .in_hz(48000000)
  ,.out0_hz(24000000)
  ,.out1_hz(24000000)
  ,.out1_deg(90)
)
u_pll
(
     .clk_i(clk48)
    ,.clk_o(clk_pll_w)
    ,.reset(1'b0)
    ,.standby(1'b0)
    ,.phasesel(2'b0)
    ,.phasedir(1'b0) 
    ,.phasestep(1'b0)
    ,.phaseloadreg(1'b0)
    ,.locked()
);

wire clk_w;
wire clk_ddr_w;
wire rst_w;

assign clk_w     = clk_pll_w[0];
assign clk_ddr_w = clk_pll_w[1];

reset_gen
u_rst
(
     .clk_i(clk_w)
    ,.rst_o(rst_w)
);

//-----------------------------------------------------------------
// Test Sequence
//-----------------------------------------------------------------
reg        cfg_req_q;
reg [7:0]  cfg_addr_q;
reg [31:0] cfg_data_q;
wire       cfg_accept_w;

wire       status_busy_w;
wire       status_err_w;

reg [31:0] test_idx_q;

always @ (posedge clk_w or posedge rst_w)
if (rst_w)
begin
    cfg_req_q  <= 1'b0;
    cfg_addr_q <= 8'b0;
    cfg_data_q <= 32'b0;
    test_idx_q <= 32'b0;
end
else if (cfg_req_q && ~cfg_accept_w)
    ;
else
begin
    cfg_req_q  <= 1'b0;

    case (test_idx_q)
    32'd100:
    begin
        cfg_req_q  <= 1'b1;
        cfg_addr_q <= `RAM_TEST_END;
        cfg_data_q <= DDR_SIZE;
        test_idx_q <= test_idx_q + 32'd1;
    end
    32'd110:
    begin
        cfg_req_q                             <= 1'b1;
        cfg_addr_q                            <= `RAM_TEST_CFG;
        cfg_data_q                            <= 32'b0;
        cfg_data_q[`RAM_TEST_CFG_BURST_LEN_R] <= (16/4)-1;
        cfg_data_q[`RAM_TEST_CFG_INCR_R]      <= 1'b1;
        test_idx_q <= test_idx_q + 32'd1;
    end
    32'd120:
    begin
        if (status_err_w)
            ;
        else if (!status_busy_w)
            test_idx_q <= test_idx_q + 32'd1;
    end
    32'd130:
    begin
        cfg_req_q                             <= 1'b1;
        cfg_addr_q                            <= `RAM_TEST_CFG;
        cfg_data_q                            <= 32'b0;
        cfg_data_q[`RAM_TEST_CFG_BURST_LEN_R] <= (16/4)-1;
        cfg_data_q[`RAM_TEST_CFG_INCR_R]      <= 1'b1;
        cfg_data_q[`RAM_TEST_CFG_READ_R]      <= 1'b1;
        test_idx_q <= test_idx_q + 32'd1;
    end
    32'd140:
    begin
        if (status_err_w)
            ;
        else if (!status_busy_w)
            test_idx_q <= test_idx_q + 32'd1;
    end
    32'd200:
    begin
        cfg_req_q                             <= 1'b1;
        cfg_addr_q                            <= `RAM_TEST_CFG;
        cfg_data_q                            <= 32'b0;
        cfg_data_q[`RAM_TEST_CFG_BURST_LEN_R] <= (16/4)-1;
        cfg_data_q[`RAM_TEST_CFG_ONES_R]      <= 1'b1;
        test_idx_q <= test_idx_q + 32'd1;
    end
    32'd210:
    begin
        if (status_err_w)
            ;
        else if (!status_busy_w)
            test_idx_q <= test_idx_q + 32'd1;
    end
    32'd220:
    begin
        cfg_req_q                             <= 1'b1;
        cfg_addr_q                            <= `RAM_TEST_CFG;
        cfg_data_q                            <= 32'b0;
        cfg_data_q[`RAM_TEST_CFG_BURST_LEN_R] <= (16/4)-1;
        cfg_data_q[`RAM_TEST_CFG_ONES_R]      <= 1'b1;
        cfg_data_q[`RAM_TEST_CFG_READ_R]      <= 1'b1;
        test_idx_q <= test_idx_q + 32'd1;
    end
    32'd230:
    begin
        if (status_err_w)
            ;
        else if (!status_busy_w)
            test_idx_q <= test_idx_q + 32'd1;
    end
    default:
    begin
        if (test_idx_q != 32'hFFFFFFFF)
            test_idx_q <= test_idx_q + 32'd1;
    end
    endcase
end

reg red_q, grn_q, blu_q;

always @ (posedge clk_w or posedge rst_w)
if (rst_w)
begin
    red_q  <= 1'b0;
    grn_q  <= 1'b0;
    blu_q  <= 1'b0;
end
else
begin
    // Failed (red)
    if (status_err_w)
    begin
        red_q  <= 1'b1;
        grn_q  <= 1'b0;
        blu_q  <= 1'b0;
    end
    // Test in progress (blue)
    else if (status_busy_w)
    begin
        red_q  <= 1'b0;
        grn_q  <= 1'b0;
        blu_q  <= 1'b1;
    end
    else // Pass (green)
    begin
        red_q  <= 1'b0;
        grn_q  <= 1'b1;
        blu_q  <= 1'b0;
    end
end

assign rgb_led_r = ~red_q;
assign rgb_led_g = ~grn_q;
assign rgb_led_b = ~blu_q;

//-----------------------------------------------------------------
// Core
//-----------------------------------------------------------------
wire [ 14:0]  dfi_address_w;
wire [  2:0]  dfi_bank_w;
wire          dfi_cas_n_w;
wire          dfi_cke_w;
wire          dfi_cs_n_w;
wire          dfi_odt_w;
wire          dfi_ras_n_w;
wire          dfi_reset_n_w;
wire          dfi_we_n_w;
wire [ 31:0]  dfi_wrdata_w;
wire          dfi_wrdata_en_w;
wire [  3:0]  dfi_wrdata_mask_w;
wire          dfi_rddata_en_w;
wire [ 31:0]  dfi_rddata_w;
wire          dfi_rddata_valid_w;
wire [  1:0]  dfi_rddata_dnv_w;

fpga_top
u_top
(
     .clk_i(clk_w)
    ,.rst_i(rst_w)

    ,.dfi_rddata_i(dfi_rddata_w)
    ,.dfi_rddata_valid_i(dfi_rddata_valid_w)
    ,.dfi_rddata_dnv_i(dfi_rddata_dnv_w)
    ,.dfi_address_o(dfi_address_w)
    ,.dfi_bank_o(dfi_bank_w)
    ,.dfi_cas_n_o(dfi_cas_n_w)
    ,.dfi_cke_o(dfi_cke_w)
    ,.dfi_cs_n_o(dfi_cs_n_w)
    ,.dfi_odt_o(dfi_odt_w)
    ,.dfi_ras_n_o(dfi_ras_n_w)
    ,.dfi_reset_n_o(dfi_reset_n_w)
    ,.dfi_we_n_o(dfi_we_n_w)
    ,.dfi_wrdata_o(dfi_wrdata_w)
    ,.dfi_wrdata_en_o(dfi_wrdata_en_w)
    ,.dfi_wrdata_mask_o(dfi_wrdata_mask_w)
    ,.dfi_rddata_en_o(dfi_rddata_en_w)

    ,.cfg_awvalid_i(cfg_req_q)
    ,.cfg_awaddr_i({24'b0,cfg_addr_q})
    ,.cfg_wvalid_i(cfg_req_q)
    ,.cfg_wdata_i(cfg_data_q)
    ,.cfg_wstrb_i(4'hF)
    ,.cfg_bready_i(1'b1)
    ,.cfg_arvalid_i(1'b0)
    ,.cfg_araddr_i(32'b0)
    ,.cfg_rready_i(1'b1)
    ,.cfg_awready_o(cfg_accept_w)
    ,.cfg_wready_o()
    ,.cfg_bvalid_o()
    ,.cfg_bresp_o()
    ,.cfg_arready_o()
    ,.cfg_rvalid_o()
    ,.cfg_rdata_o()
    ,.cfg_rresp_o()

    ,.status_busy_o(status_busy_w)
    ,.status_err_o(status_err_w)
);

wire [14:0] ddram_a_w;

ddr3_dfi_phy
u_phy
(
     .clk_i(clk_w)
    ,.rst_i(rst_w)

    ,.clk_ddr_i(clk_ddr_w)

    ,.dfi_address_i(dfi_address_w)
    ,.dfi_bank_i(dfi_bank_w)
    ,.dfi_cas_n_i(dfi_cas_n_w)
    ,.dfi_cke_i(dfi_cke_w)
    ,.dfi_cs_n_i(dfi_cs_n_w)
    ,.dfi_odt_i(dfi_odt_w)
    ,.dfi_ras_n_i(dfi_ras_n_w)
    ,.dfi_reset_n_i(dfi_reset_n_w)
    ,.dfi_we_n_i(dfi_we_n_w)
    ,.dfi_wrdata_i(dfi_wrdata_w)
    ,.dfi_wrdata_en_i(dfi_wrdata_en_w)
    ,.dfi_wrdata_mask_i(dfi_wrdata_mask_w)
    ,.dfi_rddata_en_i(dfi_rddata_en_w)
    ,.dfi_rddata_o(dfi_rddata_w)
    ,.dfi_rddata_valid_o(dfi_rddata_valid_w)
    ,.dfi_rddata_dnv_o(dfi_rddata_dnv_w)
    
    ,.ddr3_ck_p_o(ddram_clk_p)
    ,.ddr3_cke_o(ddram_cke)
    ,.ddr3_reset_n_o(ddram_reset_n)
    ,.ddr3_ras_n_o(ddram_ras_n)
    ,.ddr3_cas_n_o(ddram_cas_n)
    ,.ddr3_we_n_o(ddram_we_n)
    ,.ddr3_cs_n_o(ddram_cs_n)
    ,.ddr3_ba_o(ddram_ba)
    ,.ddr3_addr_o(ddram_a_w)
    ,.ddr3_odt_o(ddram_odt)
    ,.ddr3_dm_o(ddram_dm)
    ,.ddr3_dqs_p_io(ddram_dqs_p)
    ,.ddr3_dq_io(ddram_dq)
);

assign ddram_a = {1'b0, ddram_a_w};

endmodule
