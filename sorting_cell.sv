/**
 * sorting_cell
 * Joshua Vasquez
 * December 31, 2015
 */

/**
 * \brief a single cell unit
 * \details DATA_WIDTH defines the width of the data being stored
 * \param clk
 * \param reset
 * \param enable
 * \param prev_cell_data_pushed indicates that cell must take prev_cell_data
 * \param shift_up indicates that sorting_cell should lock in next_cell_data
*         (only used when data (now sorted) is being clocked out)
 * \param prev_cell_data
 * \param new_data
 * \param next_cell_data taken when data (now sorted) is being clocked out
 * \param cell_data_is_pushed true if this cell's data is set to be pushed out
 *        on the next clock cycle
 * \param cell_state 0 (EMPTY) or 1 (OCCUPIED)
 * \param cell_data
 */
module sorting_cell
#(parameter DATA_WIDTH = 8)
          ( input logic clk, reset, enable,
            input logic prev_cell_data_pushed,
            input logic prev_cell_state,
            input logic shift_up,
            input logic [(DATA_WIDTH-1):0] prev_cell_data,
            input logic [(DATA_WIDTH-1):0] new_data,
            input logic [(DATA_WIDTH-1):0] next_cell_data,
           output logic cell_data_is_pushed,
           output logic cell_state,
           output logic [(DATA_WIDTH-1):0] cell_data);

// Cell State FSM states:
parameter EMPTY = 0;
parameter OCCUPIED = 1;

logic new_data_fits;
assign new_data_fits = (new_data < cell_data) || (cell_state == EMPTY);

assign cell_data_is_pushed = new_data_fits & (cell_state == OCCUPIED);

logic [4:0] priority_vector;
assign priority_vector [4:0] = {shift_up, new_data_fits, prev_cell_data_pushed,
                          cell_state, prev_cell_state};

always_ff @ (posedge clk, posedge reset)
begin
    if (reset)
    begin
        cell_state <= EMPTY;
    end
    else if (enable)
    begin
        case (cell_state)
            EMPTY:
                cell_state <= prev_cell_data_pushed ?
                                  OCCUPIED :
                                  prev_cell_state ? // prev cell OCCUPIED ?
                                      OCCUPIED :
                                      EMPTY;
            OCCUPIED:
                cell_state <= OCCUPIED;
        endcase
    end
end

always_ff @ (posedge clk, posedge reset)
begin
    if (reset)
    begin
        cell_data <= 'b0;
    end
    else if (enable)
    begin
//{shift_up, new_data_fits, prev_cell_data_pushed, cell_state, prev_cell_state}
        casez (priority_vector)
            'b0?1??: cell_data <= prev_cell_data;
            'b0101?: cell_data <= new_data;
            'b0?001: cell_data <= new_data;
            'b1????: cell_data <= next_cell_data;
        default: cell_data <= cell_data;
        endcase
    end
    else
    begin
        cell_data <= cell_data;
    end
end

endmodule
