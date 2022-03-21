`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  reg [3:0] PI_write_mask;
  reg [0:0] PI_transaction_begin;
  reg [5:0] PI_wait_latency;
  reg [0:0] PI_write_enable;
  reg [31:0] PI_address;
  reg [5:0] PI_done_latency;
  reg [7:0] PI_dq;
  reg [31:0] PI_data_out;
  reg [0:0] PI_timed_read;
  wire [0:0] PI_clk = clock;
  reg [0:0] PI_rwds;
  reg [0:0] PI_rst;
  hyperram UUT (
    .write_mask(PI_write_mask),
    .transaction_begin(PI_transaction_begin),
    .wait_latency(PI_wait_latency),
    .write_enable(PI_write_enable),
    .address(PI_address),
    .done_latency(PI_done_latency),
    .dq(PI_dq),
    .data_out(PI_data_out),
    .timed_read(PI_timed_read),
    .clk(PI_clk),
    .rwds(PI_rwds),
    .rst(PI_rst)
  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    // UUT.$formal$hyperram.\v:296$1_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:296$1_EN  = 1'b0;
    // UUT.$formal$hyperram.\v:297$2_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:298$3_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:299$4_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:300$5_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:301$6_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:302$7_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:303$8_CHECK  = 1'b0;
    // UUT.$formal$hyperram.\v:304$9_CHECK  = 1'b0;
    UUT.ck = 1'b0;
    UUT.command_address = 48'b000000000000000000000000000000000000000000000000;
    UUT.control_state = 7'b0000000;
    UUT.data_out_register = 32'b00000000000000000000000000000000;
    UUT.done_counter = 8'b00000000;
    UUT.read_count = 6'b000000;
    UUT.wait_counter = 8'b00000000;
    UUT.write_count = 6'b000000;
    UUT.write_mask_register = 4'b0000;

    // state 0
    PI_write_mask = 4'b0000;
    PI_transaction_begin = 1'b1;
    PI_wait_latency = 6'b000000;
    PI_write_enable = 1'b0;
    PI_address = 32'b00010010001101000101011001111000;
    PI_done_latency = 6'b000000;
    PI_dq = 8'b00000000;
    PI_data_out = 32'b11001100110011001101110111011101;
    PI_timed_read = 1'b0;
    PI_rwds = 1'b0;
    PI_rst = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b10100000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 2
    if (cycle == 1) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000110;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b10001010;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 4
    if (cycle == 3) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b11001111;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 6
    if (cycle == 5) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 8
    if (cycle == 7) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 9
    if (cycle == 8) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 10
    if (cycle == 9) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 11
    if (cycle == 10) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b1;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 12
    if (cycle == 11) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b1;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 13
    if (cycle == 12) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 14
    if (cycle == 13) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 15
    if (cycle == 14) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b1;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 16
    if (cycle == 15) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b1;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b1;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 17
    if (cycle == 16) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 18
    if (cycle == 17) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 19
    if (cycle == 18) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 20
    if (cycle == 19) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b1;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 21
    if (cycle == 20) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b1;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 22
    if (cycle == 21) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b1;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00100000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 23
    if (cycle == 22) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b1;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000110;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 24
    if (cycle == 23) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b10001010;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 25
    if (cycle == 24) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b11001111;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b1;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 26
    if (cycle == 25) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 27
    if (cycle == 26) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 28
    if (cycle == 27) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 29
    if (cycle == 28) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 30
    if (cycle == 29) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b1;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 31
    if (cycle == 30) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 32
    if (cycle == 31) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b1;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 33
    if (cycle == 32) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b1;
      PI_rst <= 1'b0;
    end

    // state 34
    if (cycle == 33) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b1;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 35
    if (cycle == 34) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 36
    if (cycle == 35) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 37
    if (cycle == 36) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    // state 38
    if (cycle == 37) begin
      PI_write_mask <= 4'b0000;
      PI_transaction_begin <= 1'b0;
      PI_wait_latency <= 6'b000000;
      PI_write_enable <= 1'b0;
      PI_address <= 32'b00010010001101000101011001111000;
      PI_done_latency <= 6'b000000;
      PI_dq <= 8'b00000000;
      PI_data_out <= 32'b11001100110011001101110111011101;
      PI_timed_read <= 1'b0;
      PI_rwds <= 1'b0;
      PI_rst <= 1'b0;
    end

    genclock <= cycle < 38;
    cycle <= cycle + 1;
  end
endmodule
