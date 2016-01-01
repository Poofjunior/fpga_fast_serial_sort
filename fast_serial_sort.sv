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
genvar i;
logic [SIZE-1:0] prev_cell_data_pushed;
logic [SIZE-1:0] prev_cell_state;
logic [SIZE-1:0] prev_cell_data[DATA_WIDTH-1:0];
logic [SIZE-1:0] cell_data_is_pushed;
logic [SIZE-1:0] cell_state;
logic [SIZE-1:0] cell_data;

for (i = 0; i < SIZE; i++)
begin
    sorting_cell #(.DATA_WIDTH(DATA_WIDTH))
                 cell_instance (clk, reset, enable,
                                prev_cell_data_pushed[i],
                                prev_cell_state[i],
                                prev_cell_data[i],
                                unsorted_data,
                                cell_data_is_pushed[i],
                                cell_state[i],
                                cell_data[i]);
end

assign sorted_data = cell_data[0];
endmodule
