module pulse_generator #(
    parameter SIZE = 8
) (
    input  logic            clk_i,
    input  logic            nrst_i,
    input  logic [SIZE-1:0] ticks_i,
    output logic            pulse_o
);

    logic [SIZE-1:0] counter;

    // counts the ticks_i
    always_ff @(posedge clk_i or negedge nrst_i)
        if(!nrst_i)
            counter <= {SIZE{1'b0}};
        else
            counter <= (counter < ticks_i) ? counter + 1'b1 : {SIZE{1'b0}};

    // generats the pulse
    always_ff @(posedge clk_i or negedge nrst_i)
        if(!nrst_i)
            pulse_o <= 1'b0;
        else
            pulse_o <= (counter == ticks_i-1'b1) ? 1'b1: ~|ticks_i;

endmodule
