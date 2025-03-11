`timescale 1ns / 100ps

module morse_tb();

    reg din;
    reg clk = 0;
    reg rst;
    wire [16:0]sixteen_disp;

    morseMain dut(
        din,
        clk,
        rst,
        sixteen_disp
    );
    
    always #5 clk = ~clk;

    task w0();
        begin
            din = 1;
            #1010;
            din = 0;
            #1010;
        end
	endtask

    task w1();
        begin
            din = 1;
            #30010;
            din = 0;
            #1010;
        end
	endtask

    task wv1();
        begin
            din = 1;
            #60010;
            din = 0;
            #1010;
        end
	endtask

    task wv2();
        begin
            din = 0;
            #61200;
        end
	endtask

    task rev();
        begin
            din = 1;
            #200010;
            din = 0;
            #1010;
        end
    endtask

    
    initial begin
        $dumpvars;
        rst = 1;
        din = 0;
        #101;
        rst = 0;
        
        // variant 1 
        `ifdef v1
        w0();w0();w0();w0();wv1(); // H
        w0();wv1();                // E
        w0();w1();w0();w0();wv1(); // L
        w0();w1();w0();w0();wv1(); // L
        w1();w1();w1();wv1();      // O

        w0();w1();w1();wv1();      // W
        w1();w1();w1();wv1();      // O
        w0();w1();w0();wv1();      // R
        w0();w1();w0();w0();wv1(); // L
        w1();w0();w0();wv1();      // D
        `endif

        // variant 2
        `ifdef v2
        w0();w0();w0();w0();wv2(); // H
        w0();wv2();                // E
        w0();w1();w0();w0();wv2(); // L
        w0();w1();w0();w0();wv2(); // L
        w1();w1();w1();wv2();      // O

        w0();w1();w1();wv2();      // W
        w1();w1();w1();wv2();      // O
        w0();w1();w0();wv2();      // R
        w0();w1();w0();w0();wv2(); // L
        w1();w0();w0();wv2();      // D
        `endif

        `ifndef v1
            `ifndef v2
                w0();w0();w0();w0();wv2(); // H
                wv1();                     //   reverse to v1
                w0();wv1();                // E
                w0();w1();w0();w0();wv1(); // L
                rev();                     //   reverse to v2
                w0();w1();w0();w0();wv2(); // L
                w1();w1();w1();wv2();      // O

                w0();w1();w1();wv2();      // W
                w1();w1();w1();wv2();      // O
                w0();w1();w0();wv2();      // R
                w0();w1();w0();w0();wv2(); // L
                w1();w0();w0();wv2();      // D
            `endif
        `endif

        #100000 $finish;
    end
endmodule