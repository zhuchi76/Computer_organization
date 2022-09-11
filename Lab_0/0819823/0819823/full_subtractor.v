`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
    wire H1_D, H1_B;
    Half_Subtractor HSUB1 (
        .In_A(In_A), 
        .In_B(In_B), 
        .Difference(H1_D), 
        .Borrow_out(H1_B)
    );
    wire H2_B;
    Half_Subtractor HSUB2 (
        .In_A(H1_D), 
        .In_B(Borrow_in), 
        .Difference(Difference), 
        .Borrow_out(H2_B)
    );
    or(Borrow_out, H1_B, H2_B);

endmodule
