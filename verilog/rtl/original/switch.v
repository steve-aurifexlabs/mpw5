  GNU nano 4.8                                                                                    hyperram.v                                                                                               
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



module switch(
        // CPU Interface A
        input [31:0] address_a,
        input [31:0] data_out_a,
        output [31:0] data_in_a,
        input write_enable_a,
        input [3:0] write_mask_a,
        input transaction_begin_a,
        output transaction_end_a,

	// CPU Interface B
        input [31:0] address_b,
        input [31:0] data_out_b,
        output [31:0] data_in_b,
        input write_enable_b,
        input [3:0] write_mask_b,
        input transaction_begin_b,
        output transaction_end_b,

	// CPU Interface Y
        output [31:0] address_y,
        output [31:0] data_out_y,
        input [31:0] data_in_y,
        output write_enable_y,
        output [3:0] write_mask_y,
        output transaction_begin_y,
        input transaction_end_y,

	input select;
);

	assign address_y = select ? address_b : address_a;
	assign data_out_y = select ? address_b : address_a;
	assign data_in_a = data_in_y;
	assign data_in_b = data_in_y;

	assign write_enable_y = select ? write_enable_b : write_enable_a;
	assign write_mask_y = select ? write_mask_b : write_mask_a;
	assign transaction_begin_y = select ? transaction_begin_b : transaction_begin_a;
	assign transaction_end_a = transaction_end_y;
	assign transaction_end_b = transaction_end_y;

endmodule
