/**
 * fast_serial_sort demo with an SPI wrapper
 * Joshua Vasquez
 * December 31, 2015
 */

/**
 * \brief spi wrapper to test with a micocontroller
 * \details DATA_WIDTH defines the width of the data being stored (should
 *          be a power of 2 in this case so it fits in an SPI frame)
 */
module spi_wrapper_main
#(parameter DATA_WIDTH = 8,
  parameter SIZE = 20)
          ( input logic clk, reset,
            input logic sck, mosi, cs,
            input logic write,
           output logic miso);

logic enable;
logic [DATA_WIDTH-1:0] unsorted_data;
logic [DATA_WIDTH-1:0] sorted_data;

fast_serial_sort #(.DATA_WIDTH(DATA_WIDTH),
                   .SIZE(SIZE))
                 fast_serial_sort_inst(.clk(clk), .reset(reset),
                                       .enable(enable),
                                       .write(write),
                                       .unsorted_data(unsorted_data),
                                       .sorted_data(sorted_data));

// SPI slave logic
logic [1:0] new_data_pulse_gen;
logic new_data;

logic [DATA_WIDTH-1:0] spi_data_received;

assign enable = new_data_pulse_gen[1] & ~new_data_pulse_gen[0];


/// Clear new data as soon as it arrives to prevent it from being
/// continuously loaded into the buffer.
always_ff @ (posedge clk, posedge reset)
begin
    if (reset)
    begin
        new_data_pulse_gen[1:0] <= 'b0;
    end
    else begin
        new_data_pulse_gen[0] <= new_data_pulse_gen[1];
        new_data_pulse_gen[1] <= new_data;
    end
end

spi_slave_interface #(DATA_WIDTH)
    spi_inst(.clk(clk),
             .cs(cs),
             .sck(sck),
             .mosi(mosi),
             .miso(miso),
             .clear_new_data_flag(enable),
             .synced_new_data_flag(new_data),
             .data_to_send(sorted_data),
             .synced_data_received(unsorted_data));

endmodule
