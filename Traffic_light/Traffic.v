// 3-road traffic light with overlap: during the LAST yellow_time cycles
// of a road's GREEN, the NEXT road shows YELLOW.
// Example: when Road3 is GREEN, Road1 becomes YELLOW (pre-green).

module trafficlight(
  input  clk, rst,
  output reg [3:0] present_state, next_state,
  output reg [3:0] out, out2, out3
);

  reg [5:0] count = 0;

  // Encodings you provided
  parameter got_0    = 4'd0;   // Road1 RED
  parameter got_1    = 4'd1;   // Road1 YELLOW
  parameter got_10   = 4'd2;   // Road1 GREEN
  parameter got_11   = 4'd3;   // Road2 RED
  parameter got_100  = 4'd4;   // Road2 YELLOW
  parameter got_101  = 4'd5;   // Road2 GREEN
  parameter got_110  = 4'd6;   // Road3 RED
  parameter got_111  = 4'd7;   // Road3 YELLOW
  parameter got_1000 = 4'd8;   // Road3 GREEN

  // Durations
  parameter red_time    = 5; // not used explicitly; implied by (green - yellow)
  parameter yellow_time = 2;
  parameter green_time  = 7;

  // State register and counter (one counter per state)
  // NOTE: Only "green states" are used as FSM states: got_10, got_101, got_1000
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      present_state <= got_10;   // start with Road1 GREEN (you can change if you want)
      count <= 0;
    end else begin
      present_state <= next_state;
      if (present_state != next_state)
        count <= 0;
      else
        count <= count + 1;
    end
  end

  // Next-state logic: rotate which road is GREEN after green_time cycles
  always @(*) begin
    case (present_state)
      got_10:    next_state = (count == green_time-1) ? got_101  : got_10;   // R1G -> R2G
      got_101:   next_state = (count == green_time-1) ? got_1000 : got_101;  // R2G -> R3G
      got_1000:  next_state = (count == green_time-1) ? got_10   : got_1000; // R3G -> R1G
      default:   next_state = got_10; // safety
    endcase
  end

  // Output logic with overlap:
  // - Current road shows GREEN for green_time cycles.
  // - During the LAST yellow_time cycles of that GREEN, the NEXT road shows YELLOW.
  // - The third road stays RED.
  localparam integer PRE_Y_START = green_time - yellow_time;

  always @(*) begin
    // defaults: all RED
    out  = got_0;    // Road1 RED
    out2 = got_11;   // Road2 RED
    out3 = got_110;  // Road3 RED

    case (present_state)
      // Road1 GREEN phase
      got_10: begin
        out = got_10; // R1 GREEN
        // In the last yellow_time cycles of R1 green, pre-yellow for NEXT road (Road2)
        if (count >= PRE_Y_START) out2 = got_100; // R2 YELLOW
        // Road3 remains RED
      end

      // Road2 GREEN phase
      got_101: begin
        out2 = got_101; // R2 GREEN
        if (count >= PRE_Y_START) out3 = got_111; // pre-yellow for Road3
        // Road1 remains RED
      end

      // Road3 GREEN phase
      got_1000: begin
        out3 = got_1000; // R3 GREEN
        if (count >= PRE_Y_START) out = got_1;    // pre-yellow for Road1 (your requirement)
        // Road2 remains RED
      end
    endcase
  end

endmodule
