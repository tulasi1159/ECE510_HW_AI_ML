
// ================================================
// FITNESS CALCULATOR (Parallelized and Synthesizable)
// ================================================
module fitness_calculator #(
    parameter GENOME_LENGTH = 28
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  start,
    input  var logic [7:0]            chromosome   [GENOME_LENGTH],
    input  var logic [7:0]            target       [GENOME_LENGTH],
    output logic [4:0]            fitness,
    output logic                  done
);

    logic [4:0] mismatch_count;
    logic [4:0] index;
    logic       running;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mismatch_count <= 0;
            index <= 0;
            fitness <= 0;
            done <= 0;
            running <= 0;
        end else begin
            if (start) begin
                mismatch_count <= 0;
                index <= 0;
                running <= 1;
                done <= 0;
            end else if (running) begin
                if (chromosome[index] != target[index]) begin
                    mismatch_count <= mismatch_count + 1;
                end
                index <= index + 1;
                if (index == GENOME_LENGTH - 1) begin
                    fitness <= mismatch_count;
                    done <= 1;
                    running <= 0;
                end
            end
        end
    end
endmodule
