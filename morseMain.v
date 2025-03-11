module morseMain(
    input din,
    input clk,
    input rst,
    output reg [16:0] sixteen_disp
);
wire [16:0] sixteen_disp_buf;
wire [3:0] morse_length;
wire [7:0] morse_input;
wire validio;
wire validtr;
reg isiovalid;

morseio io(
    .morsein(din),
    .clk(clk),
    .rst(rst),
    .valid(validio),
    .morse_length(morse_length),
    .morse_input(morse_input)
);
morseTR tr(
    .morse_length(morse_length),
    .morse_input(morse_input),
    .clk(clk),
    .valid_reg(validtr),
    .sixteen_disp(sixteen_disp_buf)
);

always @(posedge clk)
if (rst)
begin
    isiovalid <= 0;
    sixteen_disp <= 0;
end
else 
begin
    if (validio) isiovalid <= 1;
    if ((isiovalid||validio)&&validtr)
    begin
        sixteen_disp <= sixteen_disp_buf;
        isiovalid <= 0;
    end
end

endmodule