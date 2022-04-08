//Heavily modified from GHRD provided in DE1-SoC CD-ROM

`define ENABLE_HPS

module ghrd_top(

      ///////// CLOCK2 /////////
      input logic              CLOCK2_50,

      ///////// CLOCK3 /////////
      input logic              CLOCK3_50,

      ///////// CLOCK4 /////////
      input logic              CLOCK4_50,

      ///////// CLOCK /////////
      input logic              CLOCK_50,
		
		///////// DRAM /////////
      output logic      [12:0] DRAM_ADDR,
      output logic      [1:0]  DRAM_BA,
      output logic            DRAM_CAS_N,
      output logic            DRAM_CKE,
      output logic            DRAM_CLK,
      output logic            DRAM_CS_N,
      inout  logic     [15:0] DRAM_DQ,
      output logic            DRAM_LDQM,
      output logic            DRAM_RAS_N,
      output logic            DRAM_UDQM,
      output logic            DRAM_WE_N,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      output logic      [14:0] HPS_DDR3_ADDR,
      output logic     [2:0]  HPS_DDR3_BA,
      output logic            HPS_DDR3_CAS_N,
      output logic            HPS_DDR3_CKE,
      output logic            HPS_DDR3_CK_N,
      output logic            HPS_DDR3_CK_P,
      output logic            HPS_DDR3_CS_N,
      output logic     [3:0]  HPS_DDR3_DM,
      inout  logic     [31:0] HPS_DDR3_DQ,
      inout  logic     [3:0]  HPS_DDR3_DQS_N,
      inout  logic     [3:0]  HPS_DDR3_DQS_P,
      output logic            HPS_DDR3_ODT,
      output logic            HPS_DDR3_RAS_N,
      output logic            HPS_DDR3_RESET_N,
      input  logic            HPS_DDR3_RZQ,
      output logic            HPS_DDR3_WE_N,
`endif  /*ENABLE_HPS*/


      ///////// LEDR /////////
      output logic      [9:0]  LEDR,
		
		input logic [9:0] SW,
		
		input logic [3:0] KEY,
		
		output logic [6:0] HEX0,
		output logic [6:0] HEX1,
		output logic [6:0] HEX2,

      ///////// VGA /////////
      output logic     [7:0]  VGA_B,
      output logic            VGA_BLANK_N,
      output logic            VGA_CLK,
      output logic     [7:0]  VGA_G,
      output logic            VGA_HS,
      output logic     [7:0]  VGA_R,
      output logic            VGA_SYNC_N,
      output logic            VGA_VS
);

//=======================================================
//  WIRE declarations
//=======================================================
    logic sdram_clock, sdram_read, sdram_write, sdram_readvalid, sdram_waitreq, pll_locked;
    logic [24:0] sdram_addr;
    logic [15:0] sdram_writedata, sdram_readdata;
    logic [15:0] pixel;
    logic [15:0] bkg_clr;
    // assign {LEDR[8:0], HEX0[6:0]} = pixel;
    assign {HEX2[2:0], HEX1[6:0], HEX0[6:0]} = pixel;
    logic sdram_clk, sdram_ctrl_clk;
    assign DRAM_CLK = sdram_clk;
    sdram_pll pll (
        .refclk(CLOCK_50),
        .rst(~KEY[0]),
        .outclk_0(sdram_ctrl_clk),
        .outclk_1(sdram_clk)
    );
//=======================================================
//  Structural coding
//=======================================================
soc_system u0 (      
		  .clk_clk                               (sdram_ctrl_clk),                             //                clk.clk
		  .reset_reset_n                         (1'b1),                                 //                reset.reset_n
		  //HPS ddr3
		.memory_mem_a                          ( HPS_DDR3_ADDR),                       //                memory.mem_a
        .memory_mem_ba                         ( HPS_DDR3_BA),                         //                .mem_ba
        .memory_mem_ck                         ( HPS_DDR3_CK_P),                       //                .mem_ck
        .memory_mem_ck_n                       ( HPS_DDR3_CK_N),                       //                .mem_ck_n
        .memory_mem_cke                        ( HPS_DDR3_CKE),                        //                .mem_cke
        .memory_mem_cs_n                       ( HPS_DDR3_CS_N),                       //                .mem_cs_n
        .memory_mem_ras_n                      ( HPS_DDR3_RAS_N),                      //                .mem_ras_n
        .memory_mem_cas_n                      ( HPS_DDR3_CAS_N),                      //                .mem_cas_n
        .memory_mem_we_n                       ( HPS_DDR3_WE_N),                       //                .mem_we_n
        .memory_mem_reset_n                    ( HPS_DDR3_RESET_N),                    //                .mem_reset_n
        .memory_mem_dq                         ( HPS_DDR3_DQ),                         //                .mem_dq
        .memory_mem_dqs                        ( HPS_DDR3_DQS_P),                      //                .mem_dqs
        .memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      //                .mem_dqs_n
        .memory_mem_odt                        ( HPS_DDR3_ODT),                        //                .mem_odt
        .memory_mem_dm                         ( HPS_DDR3_DM),                         //                .mem_dm
        .memory_oct_rzqin                      ( HPS_DDR3_RZQ),                        //                .oct_rzqin
         

        .sdram_cond_addr(DRAM_ADDR),
        .sdram_cond_ba(DRAM_BA),
        .sdram_cond_cas_n(DRAM_CAS_N),
        .sdram_cond_cke(DRAM_CKE),
        .sdram_cond_cs_n(DRAM_CS_N),
        .sdram_cond_dq(DRAM_DQ),
        .sdram_cond_dqm({DRAM_UDQM, DRAM_LDQM}),
        .sdram_cond_ras_n(DRAM_RAS_N),
        .sdram_cond_we_n(DRAM_WE_N),
        .sdram_controller_pixeldata(pixel),
        .sdram_controller_rw(1'b0),
        .sdram_controller_writedata_in(16'd0),
        .sdram_controller_ledr(LEDR[5:0]),
        .sdram_controller_pixelreq(pixelreq),
        .sdram_controller_wrfull(wrfull),
        .sdram_controller_wrreq(wrreq),
        .sdram_controller_bufferselect(bufferselect),

        .bkg_clr_export(bkg_clr),
        .effect_export(effect)
    );

    pll86 vga_pll (
        .refclk(CLOCK_50),
        .rst(~KEY[0]),
        .outclk_1(VGA_CLK)
    );

    logic rdreq, rdempty, wrreq, wrfull, pixelreq;
    logic bufferselect = 1'b0;
    
    logic[15:0] q;
    fifo sdram_to_vga(
        .data(pixel),
        .rdclk(VGA_CLK),
        .rdreq(rdreq),
        .wrclk(sdram_ctrl_clk),
        .wrreq(wrreq),
        .q(q),
        .rdempty(rdempty),
        .wrfull(wrfull)

    );
    assign LEDR[6] = rdempty;
    assign LEDR[7] = wrfull;

    logic [11:0] hcounter = 12'd0;
    logic [10:0] vcounter = 11'd0;
    logic out_act;

    assign out_act = (hcounter >= 128 && hcounter <= 927 && vcounter >= 22 && vcounter <= 622);

    logic [7:0] red, green, blue;

    always_comb begin
        if ((vcounter <= 40) || (vcounter >= 603)) begin
            {red[7:3], green[7:2], blue[7:3]} = bkg_clr;
            {red[2:0], green[1:0], blue[2:0]} = 8'b00000000;
        end else if ((hcounter <= 140) || (hcounter > 915)) begin
            {red[7:3], green[7:2], blue[7:3]} = bkg_clr;
            {red[2:0], green[1:0], blue[2:0]} = 8'b00000000;
        end else begin
            {red[7:3], green[7:2], blue[7:3]} = q;
            {red[2:0], green[1:0], blue[2:0]} = 8'b00000000;
        end 
    end

    assign VGA_R = (out_act && ((hcounter - 12'd128) > scroll) && ((vcounter - 11'd22) > scroll_v)) ? (red*256 - fade*red)/256 : 8'b0;
    assign VGA_G = (out_act && ((hcounter - 12'd128) > scroll) && ((vcounter - 11'd22) > scroll_v)) ? (green*256 - fade*green)/256 : 8'b0;
    assign VGA_B = (out_act && ((hcounter - 12'd128) > scroll) && ((vcounter - 11'd22) > scroll_v)) ? (blue*256 - fade*blue)/256 : 8'b0;

    /*assign VGA_R = out_act ? red : 8'd0;
    assign VGA_G = out_act ? green : 8'd0;
    assign VGA_B = out_act ? blue : 8'd0;*/

    assign rdreq = out_act;
    assign LEDR[8] = rdreq;

    assign pixelreq = (hcounter == 0 && vcounter == 0);

    assign VGA_SYNC_N = 1'b0;
    assign VGA_BLANK_N = 1'b1;

    /*assign {red[7:3], green[7:2], blue[7:3]} = q;
    assign {red[2:0], green[1:0], blue[2:0]} = 8'b00000000;*/

    assign VGA_HS = (hcounter >= 952) ? 1'b0 : 1'b1;
    assign VGA_VS = (vcounter >= 623) ? 1'b0 : 1'b1;

    always_ff @(posedge VGA_CLK) begin
        if (hcounter >= 12'd1023) begin
            hcounter <= 12'd0;
            if (vcounter >= 11'd624)
                vcounter <= 11'd0;
            else 
                vcounter <= vcounter + 11'd1;
        end else begin
            hcounter <= hcounter + 12'd1;
        end
    end


    logic [7:0] fade = 8'd0;
    logic [9:0] scroll = 10'd0;
    logic [9:0] scroll_v = 10'd0;
    logic [4:0] delay = 5'd0;
    logic [7:0] effect;
    logic [3:0] state = 4'd0;
    localparam [3:0] idle = 4'd0;
    localparam [3:0] fade_out = 4'd1;
    localparam [3:0] fade_in = 4'd2;
    localparam [3:0] pan_out = 4'd3;
    localparam [3:0] pan_in = 4'd4;
    localparam [3:0] pan_down = 4'd5;
    localparam [3:0] pan_up = 4'd6;
    localparam [3:0] zoom_out = 4'd7;
    localparam [3:0] zoom_in = 4'd8;

    //state machine for transition effects
    always_ff @(posedge VGA_CLK) begin
        case(state) 
            idle: begin
                if(effect[0]) begin
                    delay <= 5'd0;
                    if(effect[7:1] == 7'd1) begin
                        fade <= 8'd0;
                        state <= fade_out;
                    end else if(effect[7:1] == 7'd2) begin
                        scroll <= 10'd0;
                        state <= pan_out;
                    end else if(effect[7:1] == 7'd3) begin 
                        scroll_v <= 10'd0;
                        state <= pan_down;
                    end else if(effect[7:1] == 7'd4) begin
                        scroll_v <= 10'd0;
                        scroll <= 10'd0;
                        state <= zoom_out;
                    end else
                        state <= idle;
                end else 
                    state <= idle;
            end
            fade_out: begin
                if(fade == 8'd255) begin
                    bufferselect <= ~bufferselect;
                    state <= fade_in;
                end else if(pixelreq) begin
                    fade <= fade + 8'd3;
                    state <= fade_out;
                end else
                    state <= fade_out;
            end
            fade_in: begin
                if(fade == 8'd255 && pixelreq && delay <= 5'd28) begin
                    state <= fade_in;
                    delay <= delay + 5'd1;
                end else if(fade == 8'd0)
                    state <= idle;
                else if(pixelreq) begin
                    fade <= fade - 8'd3;
                    state <= fade_in;
                end else
                    state <= fade_in;
            end
            pan_out: begin
                if(scroll == 10'd800) begin
                    bufferselect <= ~bufferselect;
                    state <= pan_in;
                end else if (pixelreq) begin
                    scroll <= scroll + 10'd4;
                    state <= pan_out;
                end else
                    state <= pan_out;
            end
            pan_in: begin
                if (scroll == 10'd800 && pixelreq && delay <= 5'd28) begin
                    state <= pan_in;
                    delay <= delay + 5'd1;
                end else if(scroll == 10'd0)
                    state <= idle;
                else if (pixelreq) begin
                    scroll <= scroll - 10'd4;
                    state <= pan_in;
                end else
                    state <= pan_in;
            end
            pan_down: begin
                if(scroll_v == 10'd600) begin
                    bufferselect = ~bufferselect;
                    state <= pan_up;
                end else if (pixelreq) begin
                    scroll_v <= scroll_v + 10'd3;
                    state <= pan_down;
                end else 
                    state <= pan_down;
            end
            pan_up: begin
                if(scroll_v == 10'd600 && pixelreq && delay <= 5'd28) begin
                    state <= pan_up;
                    delay <= delay + 5'd1;
                end else if(scroll_v == 10'd0) begin
                    state <= idle;
                end else if(pixelreq) begin
                    scroll_v <= scroll_v - 10'd3;
                    state <= pan_up;
                end else
                    state <= pan_up;
            end
            zoom_out: begin
                if(scroll == 10'd800) begin
                    bufferselect <= ~bufferselect;
                    state <= zoom_in;
                end else if(pixelreq) begin
                    scroll <= scroll + 10'd4;
                    scroll_v <= scroll_v + 10'd3;
                    state <= zoom_out;
                end else
                    state <= zoom_out;
            end
            zoom_in: begin
                if (scroll == 10'd800 && pixelreq && delay <= 5'd28) begin
                    state <= zoom_in;
                    delay <= delay + 5'd1;
                end else if(scroll == 10'd0)
                    state <= idle;
                else if (pixelreq) begin
                    scroll <= scroll - 10'd4;
                    scroll_v <= scroll_v - 10'd3;
                    state <= zoom_in;
                end else
                    state <= zoom_in;
            end
            default: 
                state <= idle;
        endcase
    end
endmodule