
// ====================================================
// 3. MATE FUNCTION (Faster Pipelined Generation Unit)
// ====================================================
module mate_unit #(
    parameter GENOME_LENGTH = 28
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  var logic [7:0] parent1 [GENOME_LENGTH],
    input  var logic [7:0] parent2 [GENOME_LENGTH],
    output logic [7:0] child   [GENOME_LENGTH],
    output logic done
);

    logic [$clog2(GENOME_LENGTH):0] index;
    logic running;
    logic [31:0] rand_v;

    function logic [7:0] mutated_gene();
        mutated_gene = $urandom_range(32, 126);
    endfunction

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            index <= 0;
            running <= 0;
            done <= 0;
        end else if (start) begin
            index <= 0;
            running <= 1;
            done <= 0;
        end else if (running) begin
            rand_v = $urandom;
            if (rand_v < 32'd1500000000) begin
                child[index] <= parent1[index];
            end else if (rand_v < 32'd3000000000) begin
                child[index] <= parent2[index];
            end else begin
                child[index] <= mutated_gene();
            end
            index <= index + 1;
            if (index == GENOME_LENGTH - 1) begin
                running <= 0;
                done <= 1;
            end
        end
    end
endmodule
