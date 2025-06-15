
// ============================================================
// TOP MODULE: Connect Fitness, Sort, and Mate Blocks Together
// ============================================================
module genetic_top #(
    parameter GENOME_LENGTH = 28,
    parameter POP_SIZE = 10,
    parameter WIDTH = 5
)(
    input  logic clk,
    input  logic rst,
    input  logic start,

input wire logic [7:0] chromosome [GENOME_LENGTH],
input wire logic [7:0] target [GENOME_LENGTH],
input wire logic [7:0] parent1 [GENOME_LENGTH],
input wire logic [7:0] parent2 [GENOME_LENGTH],
input wire logic [WIDTH-1:0] fitness_array [POP_SIZE],


    output logic [4:0] fitness,
    output logic [WIDTH-1:0] sorted_array [POP_SIZE],
    output logic [7:0] child [GENOME_LENGTH],
    output logic done_fit,
    output logic done_sort,
    output logic done_mate
);

    logic fit_start, sort_start, mate_start;

    assign fit_start = start;
    assign sort_start = start;
    assign mate_start = start;

    fitness_calculator #(.GENOME_LENGTH(GENOME_LENGTH)) FC (
        .clk(clk), .rst(rst), .start(fit_start),
        .chromosome(chromosome), .target(target),
        .fitness(fitness), .done(done_fit)
    );

    sort_population #(.N(POP_SIZE), .WIDTH(WIDTH)) SORT (
        .clk(clk), .rst(rst), .start(sort_start),
        .fitness_array(fitness_array), .sorted_array(sorted_array),
        .done(done_sort)
    );

    mate_unit #(.GENOME_LENGTH(GENOME_LENGTH)) MATE (
        .clk(clk), .rst(rst), .start(mate_start),
        .parent1(parent1), .parent2(parent2), .child(child),
        .done(done_mate)
    );
endmodule
