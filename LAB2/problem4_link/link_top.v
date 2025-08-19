// link_top_2005.v: connects master and slave
module link_top(
  input  wire clk,
  input  wire rst,
  output wire done
);

  wire       req;
  wire       ack;
  wire [7:0] data;

  master_fsm u_master (
    .clk (clk),
    .rst (rst),
    .ack (ack),
    .req (req),
    .data(data),
    .done(done)
  );

  slave_fsm u_slave (
    .clk      (clk),
    .rst      (rst),
    .req      (req),
    .data_in  (data),
    .ack      (ack),
    .last_byte()       // unconnected
  );

endmodule
