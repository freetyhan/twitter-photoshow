//Contains code by Fei Kuan written for CPEN 311, based on CPEN 311 slides.

module fpga_sdram_qsys (
    input  logic [15:0] readdata,
    input  logic        readdatavalid,
    input  logic        waitrequest,
    output logic [25:0] address,
    output logic [1:0]  byteenable_n,
    output logic        chipselect,
    output logic [15:0] writedata,
    output logic        read_n,
    output logic        write_n,

    //conduits
    input  logic        rw,
    input  logic [15:0] writedata_in,
    input  logic        pixreq,
    input  logic        wrfull,
    input  logic        bufferselect,
    output logic [15:0] pixeldata,
    output logic        wrreq,

    //clock
    input logic         clk, 

    //reset
    input logic         reset,

    //debug output
    output logic [5:0]  LEDR

);
    assign byteenable_n = 2'b11;
    assign chipselect = 1'b1;
    assign writedata = writedata_in;
    assign read_n = state[0];
    assign write_n = state[1];

    logic     [6:0] state = 7'd0;
    localparam [6:0] idle        = 7'b00_000_0_0;
    localparam [6:0] read        = 7'b00_001_0_1;
    localparam [6:0] waitdata    = 7'b00_010_0_1;
    localparam [6:0] getdata     = 7'b00_011_0_0;
    localparam [6:0] second      = 7'b00_100_0_0;
    localparam [6:0] write1      = 7'b00_101_1_0;
    localparam [6:0] write2      = 7'b00_110_1_0;
    localparam [6:0] write3      = 7'b00_111_1_0;
    assign LEDR = state[5:0];

    logic [25:0] addr_temp = 26'd0;
    logic frame_buffer = 1'b0;
    logic [15:0] temp_pixel;
    assign address = addr_temp;

    always_ff @(posedge clk) begin
        // if (reset) begin
        //     state <= idle;
        // end
        // else 
        // begin
            case (state)
                idle: begin
                    wrreq <= 1'b0;
                    if (addr_temp >= 26'hea600 && ~bufferselect) begin
                        frame_buffer <= 1'b0;
                        addr_temp <= 26'd0;
                        state <= idle;
                    end else if (addr_temp >= 26'h1d4c00 && bufferselect) begin
                        frame_buffer <= 1'b0;
                        addr_temp <= 26'hea600;
                        state <= idle;
                    end else if (rw)
                        state <= write1;
                    else if (pixreq && ~bufferselect) begin
                        frame_buffer <= 1'b1;
                        addr_temp <= 26'd0;
                        state <= read;
                    end else if (pixreq && bufferselect) begin 
                        frame_buffer <= 1'b1;
                        addr_temp <= 26'hea600;
                        state <= read;
                    end else if (frame_buffer)
                        state <= read;
                    else begin
                        state <= idle;
                    end
                end
                read: begin
                    if (!waitrequest) begin
                        temp_pixel <= readdata;
                        state <= getdata;
                    end 
                    else
                        state <= read;
                end
                waitdata: begin
                    // if (readdatavalid) begin
                        state <= getdata;
                    // end
                    // else
                    //     state <= waitdata;
                end
                getdata: begin
                    if(!wrfull) begin
                        wrreq <= 1'b1;
                        pixeldata <= temp_pixel;
                        state <= idle; //try read instead
                        addr_temp <= addr_temp + 26'h2;
                    end
                    else begin
                        wrreq <= 1'b0;
                        pixeldata <= temp_pixel;
                        state <= getdata;
                    end 

                end
                write1: begin
                    state <= write2;
                end
                write2: begin
                    if (!waitrequest) begin
                        state <= write3;
                    end
                    else
                        state <= write2;
                end
                write3: begin
                    state <= idle;
                    addr_temp <= addr_temp + 26'h2;
                end
                default: 
                    state <= idle;
            endcase
        // end
    end



endmodule