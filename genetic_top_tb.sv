
// ==============================================================
// TESTBENCH: Complete Timing + Generation Reporting + Auto-Exit
// ==============================================================
`timescale 1ns/1ps
module genetic_top_tb;
    parameter GENOME_LENGTH = 28;
    parameter POP_SIZE = 10;
    parameter WIDTH = 5;
    parameter CLK_PERIOD = 10;

    logic clk = 0, rst = 0, start = 0;
    logic [7:0] chromosome [GENOME_LENGTH];
    logic [7:0] target     [GENOME_LENGTH];
    logic [7:0] parent1    [GENOME_LENGTH];
    logic [7:0] parent2    [GENOME_LENGTH];
    logic [WIDTH-1:0] fitness_array [POP_SIZE];
    logic [4:0] fitness;
    logic [WIDTH-1:0] sorted_array [POP_SIZE];
    logic [7:0] child [GENOME_LENGTH];
    logic done_fit, done_sort, done_mate;

    integer fitness_cycles = 0;
    integer sort_cycles = 0;
    integer mate_cycles = 0;
    integer generation = 1;
    real exec_time_ns;

    genetic_top #(.GENOME_LENGTH(GENOME_LENGTH), .POP_SIZE(POP_SIZE), .WIDTH(WIDTH)) DUT (
        .clk(clk), .rst(rst), .start(start),
        .chromosome(chromosome), .target(target),
        .parent1(parent1), .parent2(parent2),
        .fitness_array(fitness_array),
        .fitness(fitness), .sorted_array(sorted_array),
        .child(child), .done_fit(done_fit), .done_sort(done_sort), .done_mate(done_mate)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
       automatic string tgt = "Sai Tulasi Prasad";
        rst = 1; #20; rst = 0;

        for (int i = 0; i < GENOME_LENGTH; i++) begin
            target[i] = tgt[i];
            chromosome[i] = $urandom_range(97, 122);
            parent1[i] = $urandom_range(97, 122);
            parent2[i] = $urandom_range(97, 122);
        end

        for (int i = 0; i < POP_SIZE; i++) begin
            fitness_array[i] = $urandom_range(0, GENOME_LENGTH);
        end

        #20; start = 1; #10; start = 0;

        while (!done_fit) begin #10; fitness_cycles++; end
        $display("[GEN %0d] Fitness Done in %0d cycles", generation, fitness_cycles);

        while (!done_sort) begin #10; sort_cycles++; end
        $display("[GEN %0d] Sorting Done in %0d cycles", generation, sort_cycles);

        while (!done_mate) begin #10; mate_cycles++; end
        $display("[GEN %0d] Mating Done in %0d cycles", generation, mate_cycles);

        exec_time_ns = (fitness_cycles + sort_cycles + mate_cycles) * CLK_PERIOD;
        $display("TOTAL Time (ns): %0.1f", exec_time_ns);
        $finish;
    end
endmodule
