/**
 * cell
 * Joshua Vasquez
 * December 31, 2015
 */

/**
 * \brief spi wrapper to test with a micocontroller
 * \details DATA_WIDTH defines the width of the data being stored (should
 *          be a power of 2 in this case so it fits in an SPI frame)
 */
module fast_serial_sort
#(parameter DATA_WIDTH = 8,
  parameter SIZE = 3)
          ( input logic clk, reset,
            input logic sck, mosi, cs,
           output logic miso);

    spi #(.DATA_WIDTH(DATA_WIDTH))
        spi(.clk(clk), .reset(reset),
            .cs(cs), .sck(sck), .mosi(mosi), .miso(miso),
            .data_to_send(),
            .data_received());

    fast_serial_sort #(.DATA_WIDTH(DATA_WIDTH),
                       .SIZE(SIZE))
                     fast_serial_sort_inst(.clk(clk), .reset(reset),...);
endmodule
