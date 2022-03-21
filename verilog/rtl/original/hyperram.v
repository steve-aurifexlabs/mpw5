// SPDX-FileCopyrightText: 2022 Steve Goldsmith, Aurifex Labs LLC
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

module hyperram(
	input clk,
	input rst,

	// CPU Interface
	input [31:0] address,
	input [31:0] data_out,
	output [31:0] data_in,
	input write_enable,
	input [3:0] write_mask,
	input transaction_begin,
	output transaction_end,

	// Hyperram Interface
	inout [7:0] dq,
	output ck,
	output ck_bar,
	output cs_bar,
	inout rwds,

	// Config
	input timed_read,
	input [5:0] wait_latency,
	input [5:0] done_latency,
);
	localparam WAIT_LATENCY = 4;
	localparam DONE_LATENCY = 4;

	reg ck_gate;
	reg ck;

	always_ff @(posedge clk) begin
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
	reg dq_oe;
	reg rwds_out;
	reg rwds_oe;

	assign dq = !dq_oe ? 'hz : dq_out;
	assign rwds = !rwds_oe ? 'hz : rwds_out;

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

	always_ff @(posedge clk) begin
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

	always_comb begin
		next_control_state = control_state;
		cs_bar = 0;
		ck_gate = 1;
		dq_oe = 0;
		rwds_oe = 0;
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
				dq_oe = 1;
			end
			// CA1 state
			'h2 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[39:32];
				dq_oe = 1;
			end
			// CA2 state
			'h3 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[31:24];				
				dq_oe = 1;
			end
			// CA3 state
			'h4 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[23:16];
				dq_oe = 1;
			end
			// CA4 state
			'h5 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[15:8];
				dq_oe = 1;
			end
			// CA5 state
			'h6 : begin 
				next_control_state = control_state + 1;
				dq_out = command_address[7:0];
				dq_oe = 1;
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
				rwds_oe = 1;
				dq_out = data_out_register[7:0];
				dq_oe = 1;
			end
			// WRITE1 state
			'h9 : begin 
				next_control_state = control_state + 1;
				rwds_out = write_mask_register[1];
				rwds_oe = 1;
				dq_out = data_out_register[15:8];
				dq_oe = 1;
			end
			// WRITE2 state
			'ha : begin 
				next_control_state = control_state + 1;
				rwds_out = write_mask_register[2];
				rwds_oe = 1;
				dq_out = data_out_register[23:16];
				dq_oe = 1;
			end
			// WRITE3 state
			'hb : begin 
				next_control_state = 'h10;
				rwds_out = write_mask_register[3];
				rwds_oe = 1;
				dq_out = data_out_register[31:24];
				dq_oe = 1;
			end


			// READ0 state - wait for rwds strobe
			'hc : begin 
				if(rwds || timed_read) begin
					next_data_in[7:0] = dq;
					next_control_state = control_state + 1;
				end
			end
			// READ1 state
			'hd : begin 
				next_data_in[15:8] = dq;
				next_control_state = control_state + 1;
			end
			// READ2 state
			'he : begin 
				next_data_in[23:16] = dq;
				next_control_state = control_state + 1;
			end
			// READ3 state
			'hf : begin 
				next_data_in[31:24] = dq;
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

	always_ff @(posedge transaction_begin) begin
		command_address <= next_command_address;
		write_mask_register <= next_write_mask_register;
		data_out_register <= next_data_out_register;
	end

	always_comb begin
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
		
		always_ff @(posedge clk) begin
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
