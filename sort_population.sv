
// =================================================
// SORTING BLOCK (Bubble Sort - Synthesis-Friendly)
// =================================================
module sort_population #(
    parameter N = 10,
    parameter WIDTH = 5
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  var logic [WIDTH-1:0] fitness_array [N],
    output logic [WIDTH-1:0] sorted_array [N],
    output logic done
);

    typedef enum logic [1:0] { IDLE, COPY, SORT, DONE } state_t;
    state_t state;

    logic [WIDTH-1:0] array [N];
    logic [$clog2(N)-1:0] i, j;
    logic [WIDTH-1:0] temp;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            i <= 0; j <= 0; state <= IDLE; done <= 0;
        end else begin
            case (state)
                IDLE: if (start) begin i <= 0; j <= 0; done <= 0; state <= COPY; end
                COPY: begin
                    for (int k = 0; k < N; k++) array[k] <= fitness_array[k];
                    state <= SORT;
                end
                SORT: begin
                    if (i < N) begin
                        if (j < N - i - 1) begin
                            if (array[j] > array[j+1]) begin
                                temp = array[j];
                                array[j] = array[j+1];
                                array[j+1] = temp;
                            end
                            j <= j + 1;
                        end else begin
                            j <= 0; i <= i + 1;
                        end
                    end else begin
                        for (int k = 0; k < N; k++) sorted_array[k] <= array[k];
                        done <= 1; state <= DONE;
                    end
                end
                DONE: state <= IDLE;
            endcase
        end
    end
endmodule
