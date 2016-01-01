/**
 * cell
 * Joshua Vasquez
 * December 31, 2015
 */

/**
 * \brief top level architecure
 * \details DATA_WIDTH defines the width of the data being stored
 * \param enable enables internal logic
 * \param write indicates if unsorted data is being written or sorted data is
 *        being read out while module is enabled.
 * \param unsorted_data serial input for unsorted list elements
 * \param sorted_data serial output for sorted list elements
 */
module fast_serial_sort
#(parameter DATA_WIDTH = 8,
  parameter SIZE = 3)
          ( input logic clk, reset, enable,
            input logic write,
            input logic [(DATA_WIDTH-1):0] unsorted_data,
           output logic [(DATA_WIDTH-1):0] sorted_data);


// Generate Chain of cell elements.
logic [SIZE-1:0] prev_cell_state;
logic [DATA_WIDTH-1:0] prev_cell_data[SIZE-1:0];
logic [SIZE-1:0] cell_data_is_pushed;
logic [SIZE-1:0] cell_state;
logic [DATA_WIDTH-1:0] cell_data[SIZE-1:0];
genvar i;

generate for (i = 0; i < SIZE; i++) begin: cell_array
    if (i == 0)
    begin
    // Starting cell has parameters fixed to force it to accept the
    // the first value.
        sorting_cell #(.DATA_WIDTH(DATA_WIDTH))
                     cell_instance (.clk(clk), .reset(reset), .enable(enable),
                                    .prev_cell_data_pushed('b0), // pseudo-previous cell acts unpushed
                                    .prev_cell_state('b1), // pseudo-previous cell acts full
                                    .shift_up(~write),
                                    .prev_cell_data('b0),
                                    .new_data(unsorted_data),
                                    .next_cell_data(cell_data[i + 1]),
                                    .cell_data_is_pushed(cell_data_is_pushed[i]),
                                    .cell_state(cell_state[i]),
                                    .cell_data(cell_data[i]));

    end
    else if (i == SIZE-1)
    // Final cell has parameters that we don't care about.
    begin
        sorting_cell #(.DATA_WIDTH(DATA_WIDTH))
                     cell_instance (.clk(clk), .reset(reset), .enable(enable),
                                    .prev_cell_data_pushed(cell_data_is_pushed[i-1]),
                                    .prev_cell_state(cell_state[i-1]),
                                    .shift_up(~write),
                                    .prev_cell_data(cell_data[i-1]),
                                    .new_data(unsorted_data),
                                    .next_cell_data(),
                                    .cell_data_is_pushed(),
                                    .cell_state(cell_state[i]),
                                    .cell_data(cell_data[i]));
    end
    else
    // all other parameters...
    begin
        sorting_cell #(.DATA_WIDTH(DATA_WIDTH))
                     cell_instance (.clk(clk), .reset(reset), .enable(enable),
                                    .prev_cell_data_pushed(cell_data_is_pushed[i-1]),
                                    .prev_cell_state(cell_state[i-1]),
                                    .shift_up(~write),
                                    .prev_cell_data(cell_data[i-1]),
                                    .new_data(unsorted_data),
                                    .next_cell_data(cell_data[i+1]),
                                    .cell_data_is_pushed(cell_data_is_pushed[i]),
                                    .cell_state(cell_state[i]),
                                    .cell_data(cell_data[i]));
    end
end endgenerate

assign sorted_data = cell_data[0];
endmodule
