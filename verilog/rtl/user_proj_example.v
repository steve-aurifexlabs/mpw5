// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    
    // LA
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

    /////////// End clk and rst code //////////

    // Data bus switch
    wire [31:0] data_out;
    wire select;

    assign select = la_data_in[112];
    assign data_out = select ? la_data_in[63:32] : prng_out;

    hyperram hyperram(
        .clk(clk),
        .rst(rst),

	// CPU Interface
	.address(la_data_in[31:0]),
	//.data_out(la_data_in[63:32]),
	.data_out(data_out),
	.data_in(la_data_out[31:0]),
	.write_enable(la_data_in[66]),
	.write_mask(la_data_in[70:67]),
	.transaction_begin(la_data_in[71]),
	.transaction_end(la_data_out[32]),

	// Hyperram Interface
	.dq_in(io_in[15:8]),
	.dq_out(io_out[15:8]),
	.dq_oeb(io_oeb[15:8]),
	.ck(io_out[16]),
	.ck_bar(io_out[17]),
	.cs_bar(io_out[18]),
	.rwds_in(io_in[19]),
	.rwds_out(io_out[19]),
	.rwds_oeb(io_oeb[19]),

	// Config
	.timed_read(la_data_in[72]),
	.WAIT_LATENCY(la_data_in[78:73]),
	.DONE_LATENCY(la_data_in[84:79]),

	// For testbench
	.control_state(la_data_out[102:96])
    );


    wire [31:0] prng_out;
    assign prng_out[31:12] = 0;

    acorn_prng acorn_prng(
	.clk(clk),
        .reset(rst),
         
        .load(la_data_in[85]),
        .select(la_data_in[87:86]),
        .gpio_seed(la_data_in[99:88]),
        .LA1_seed(la_data_in[111:100]),
        .out(prng_out[11:0]),
        .io_oeb(la_data_out[115:103]),
        .reset_out(la_data_out[116])
    );
endmodule


module counter #(
    parameter BITS = 32
)(
    input clk,
    input reset,
    input valid,
    input [3:0] wstrb,
    input [BITS-1:0] wdata,
    input [BITS-1:0] la_write,
    input [BITS-1:0] la_input,
    output ready,
    output [BITS-1:0] rdata,
    output [BITS-1:0] count
);
    reg ready;
    reg [BITS-1:0] count;
    reg [BITS-1:0] rdata;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            ready <= 0;
        end else begin
            ready <= 1'b0;
            if (~|la_write) begin
                count <= count + 1;
            end
            if (valid && !ready) begin
                ready <= 1'b1;
                rdata <= count;
                if (wstrb[0]) count[7:0]   <= wdata[7:0];
                if (wstrb[1]) count[15:8]  <= wdata[15:8];
                if (wstrb[2]) count[23:16] <= wdata[23:16];
                if (wstrb[3]) count[31:24] <= wdata[31:24];
            end else if (|la_write) begin
                count <= la_write & la_input;
            end
        end
    end

endmodule


module hyperram (
	input clk,
	input rst,

	// CPU Interface
	input [31:0] address,
	input [31:0] data_out,
	output [31:0] data_in,
	input write_enable,
	input [3:0] write_mask,
	input transaction_begin,
	output reg transaction_end,

	// Hyperram Interface
	input [7:0] dq_in,
	output [7:0] dq_out,
	output [7:0] dq_oeb,
	output ck,
	output ck_bar,
	output cs_bar,
	input rwds_in,
	output rwds_out,
	output rwds_oeb,

	// Config
	input timed_read,
	input [5:0] WAIT_LATENCY,
	input [5:0] DONE_LATENCY,

	// For testbench
	output [6:0] control_state
);
	//localparam WAIT_LATENCY = 4;
	//localparam DONE_LATENCY = 4;

	reg ck_gate;
	reg ck;

	always @(posedge clk) begin
		if(!ck_gate) begin
			ck <= 0;
		end
		else begin
			ck <= !ck;
		end	
	end

	assign ck_bar = !ck;


	reg cs_bar;

	reg [7:0] dq_out;
	reg dq_oeb;
	reg rwds_out;
	reg rwds_oeb;

	//assign dq = dq_oeb ? 'hz : dq_out;
	//assign rwds = rwds_oeb ? 'hz : rwds_out;

	wire write_enable_register;
	assign write_enable_register = !command_address[47];

	assign data_in = data_in_register;

	reg [7:0] wait_counter;
	reg [7:0] next_wait_counter;

	reg [7:0] done_counter;
	reg [7:0] next_done_counter;

	// FSM
	reg [6:0] control_state;
	reg [6:0] next_control_state;

	reg [31:0] next_data_in;
	reg [31:0] data_in_register;

	always @(posedge clk) begin
		if(rst) begin
			control_state <= 0;
			data_in_register <= 0;
			wait_counter <= 0;
			done_counter <= 0;
		end
		else begin
			control_state <= next_control_state;
			data_in_register <= next_data_in;
			wait_counter <= next_wait_counter;
			done_counter <= next_done_counter;
		end
	end

	always @(*) begin
		next_control_state = control_state;
		cs_bar = 0;
		ck_gate = 1;
		dq_oeb = 1;
		rwds_oeb = 1;
		next_data_in = data_in_register;
		next_wait_counter = wait_counter;
		next_done_counter = done_counter;
		dq_out = 'hzz;
		rwds_out = 'hz;
		transaction_end = 0;


		case(control_state)
			// IDLE state
			'h0 : begin
				cs_bar = 1;
				ck_gate = 0;
				transaction_end = 1;

				if(transaction_begin) begin
					next_control_state = control_state + 1;
				end
			end

			// CA0 state
			'h1 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[47:40];
				dq_oeb = 0;
			end
			// CA1 state
			'h2 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[39:32];
				dq_oeb = 0;
			end
			// CA2 state
			'h3 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[31:24];				
				dq_oeb = 0;
			end
			// CA3 state
			'h4 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[23:16];
				dq_oeb = 0;
			end
			// CA4 state
			'h5 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[15:8];
				dq_oeb = 0;
			end
			// CA5 state
			'h6 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[7:0];
				dq_oeb = 0;
			end

			// WAIT state
			'h7 : begin
				next_wait_counter = wait_counter + 1;

				if(wait_counter == WAIT_LATENCY) begin
					next_wait_counter = 0;
					if(write_enable_register) begin
						next_control_state = 'h8; 
					end
					else begin
						next_control_state = 'hc;
					end
				end
			end

			// WRITE0 state
			'h8 : begin 
				next_control_state = control_state + 1;
				rwds_out = write_mask_register[0];
				rwds_oeb = 0;
				dq_out = data_out_register[7:0];
				dq_oeb = 0;
			end
			// WRITE1 state
			'h9 : begin 
				next_control_state = control_state + 1;
				rwds_out = write_mask_register[1];
				rwds_oeb = 0;
				dq_out = data_out_register[15:8];
				dq_oeb = 0;
			end
			// WRITE2 state
			'ha : begin 
				next_control_state = control_state + 1;
				rwds_out = write_mask_register[2];
				rwds_oeb = 0;
				dq_out = data_out_register[23:16];
				dq_oeb = 0;
			end
			// WRITE3 state
			'hb : begin 
				next_control_state = 'h10;
				rwds_out = write_mask_register[3];
				rwds_oeb = 0;
				dq_out = data_out_register[31:24];
				dq_oeb = 0;
			end


			// READ0 state - wait for rwds strobe
			'hc : begin 
				if(rwds_in || timed_read) begin
					next_data_in[7:0] = dq_in;
					next_control_state = control_state + 1;
				end
			end
			// READ1 state
			'hd : begin 
				next_data_in[15:8] = dq_in;
				next_control_state = control_state + 1;
			end
			// READ2 state
			'he : begin 
				next_data_in[23:16] = dq_in;
				next_control_state = control_state + 1;
			end
			// READ3 state
			'hf : begin 
				next_data_in[31:24] = dq_in;
				next_control_state = control_state + 1;
			end


			// DONE state
			'h10 : begin
				next_done_counter = done_counter + 1;

				if(done_counter == DONE_LATENCY) begin
					next_control_state = 0; 
					next_done_counter = 0;
				end
			end
		endcase
	end


	reg [47:0] command_address;
	reg [47:0] next_command_address;

	reg [3:0] write_mask_register;
	reg [3:0] next_write_mask_register;

	reg [31:0] data_out_register;
	reg [31:0] next_data_out_register;

	always @(posedge transaction_begin) begin
		command_address <= next_command_address;
		write_mask_register <= next_write_mask_register;
		data_out_register <= next_data_out_register;
	end

	always @(*) begin
		next_command_address = {
			!write_enable, 1'h0, 1'h1, 9'h000,
			address[22:9], address[8:3], 13'h0000, address[2:0]
		};

		next_write_mask_register = write_mask;
		next_data_out_register = data_out;
	end




	`ifdef FORMAL
		reg [5:0] read_count;
		reg [5:0] write_count;
		
		always @(posedge clk) begin
			if(control_state == 'h0f) begin
				read_count <= read_count + 1;
			end
			if(control_state == 'h0b) begin
				write_count <= write_count + 1;
			end
		end

		initial begin
			control_state = 'h0;
			read_count = 0;
			write_count = 0;
			rst = 1;
			address = 'h12345678;

			wait_counter = 0;
			done_counter = 0;

			data_in = 'haaaabbbb;
			data_out = 'hccccdddd;

			#10;

			rst = 0;
		end

		always @(posedge clk) begin
			cover_idle: cover (control_state == 0);
			cover_ca: cover (control_state == 6);
			cover_wait: cover (control_state == 7);
			cover_write: cover (control_state == 8);
			cover_read: cover (control_state == 'hc);
			cover_done: cover (control_state == 'h10);
			cover_write_2: cover (write_count == 'h2);
			cover_read_2: cover (read_count == 'h2);
			cover_write_read: cover (read_count == 1 && write_count == 1);
		end

	`endif
endmodule




//////////////////////////////
// Third-party Code Section //
//////////////////////////////

// Everything below this point is third party code. Included inline to simplify tapeout.

////////////////////////////////////////////////////////////////////////////////////////////
// ACORN (Additive Congruential Random Number) generator, a pseudo random number generator

// Source: https://github.com/ZhenleC/wrapped_acorn_prng/blob/main/acorn_prng/src/acorn_prng.v
// License: https://github.com/ZhenleC/wrapped_acorn_prng/blob/main/LICENSE

////////////////////////////////////////////////////////////////////////////////////////////
// ACORN (Additive Congruential Random Number) generator, a pseudo random number generator
// Inspired from this page: http://acorn.wikramaratna.org/ 
// Made by Zhenle Cao for the ZerotoASIC course
// Huge shoutout and appreciation to Steven Goldsmith for his invaluable assistance.
// March 2022, to be taped out on MPW5
// 16th order ACORN with modulus = 2^16, and easily scalable to higher modulos.
////////////////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`timescale 1ns/1ps

module acorn_prng (

`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V power
	inout vssd1,	// User area 1 digital ground
`endif

    input clk,
    input reset,
    input wire load,
    input wire [1:0] select,
    input wire [11:0] gpio_seed,
    input wire [11:0] LA1_seed,
    output reg [11:0] out,
    output [12:0] io_oeb,
    output wire reset_out
);

assign io_oeb = 13'b0;

assign reset_out = reset;

reg [11:0] seed;

reg [11:0] r01;
reg [11:0] r02;
reg [11:0] r03;
reg [11:0] r04;
reg [11:0] r05;
reg [11:0] r06;
reg [11:0] r07;
reg [11:0] r08;
reg [11:0] r09;
reg [11:0] r010;
reg [11:0] r011;
reg [11:0] r012;
reg [11:0] r013;
reg [11:0] r014;
reg [11:0] r015;

reg [11:0] r10;
reg [11:0] r11;
reg [11:0] r12;
reg [11:0] r13;
reg [11:0] r14;
reg [11:0] r15;
reg [11:0] r16;
reg [11:0] r17;
reg [11:0] r18;
reg [11:0] r19;
reg [11:0] r110;
reg [11:0] r111;
reg [11:0] r112;
reg [11:0] r113;
reg [11:0] r114;
reg [11:0] r115;


reg [3:0] counter;



always @(posedge clk) begin


	if (reset) begin 

//everything to zero 

		counter <= 0;
		r01 <= 0;
		r02 <= 0;
		r03 <= 0;
		r04 <= 0;
		r05 <= 0;
		r06 <= 0;
		r07 <= 0;
		r08 <= 0;
		r09 <= 0;
		r010 <= 0;
		r011 <= 0;
		r012 <= 0;
		r013 <= 0;
		r014 <= 0;
		r015 <= 0;

		r11 <= 0;
		r12 <= 0;
		r13 <= 0;
		r14 <= 0;
		r15 <= 0;
		r16 <= 0;
		r17 <= 0;
		r18 <= 0;
		r19 <= 0;
		r110 <= 0;
		r111 <= 0;
		r112 <= 0;
		r113 <= 0;
		r114 <= 0;
		r115 <= 0;

		out <= 0;
		seed <= 0;
		

	end else 
	
	if (load) begin
	
	if(select == 2'b00)
	seed <= 12'b100000000001;
	
	if(select == 2'b11)
	seed <= 12'b111111111111;
	
	if(select == 2'b01)
	seed <= gpio_seed;
	
	if(select == 2'b10)
	seed <= LA1_seed;
	
	
	end else begin

	counter <= counter + 1;
	
	if(counter == 0)

	r11 <= r01+seed;
	
	if(counter == 1)

	r12 <= r02+r11;

	if(counter == 2)

	r13 <= r03+r12;

	if(counter == 3)
	r14 <= r04+r13;

	if(counter == 4)
	r15 <= r05+r14;

	if(counter == 5)
	r16 <= r06+r15;

	if(counter == 6)
	r17 <= r07+r16;

	if(counter == 7)
	r18 <= r08+r17;

	if(counter == 8)
	r19 <= r09+r18;

	if(counter == 9)
	r110 <= r010+r19;

	if(counter == 10)
	r111 <= r011+r110;

	if(counter == 11)
	r112 <= r012+r111;

	if(counter == 12)
	r113 <= r013+r112;

	if(counter == 13)
	r114 <= r014+r113;

	if(counter == 14)
	r115 <= r015+r114;

	if(counter == 15)

		out <= r115;

		r01 <= r11;
		r02 <= r12;
		r03 <= r13;
		r04 <= r14;
		r05 <= r15;
		r06 <= r16;
		r07 <= r17;
		r08 <= r18;
		r09 <= r19;
		r010 <= r110;
		r011 <= r111;
		r012 <= r112;
		r013 <= r113;
		r014 <= r114;
		r015 <= r115;
		


	end
end


endmodule
