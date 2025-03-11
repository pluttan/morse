
module morseTR(
    input [3:0] morse_length,
    input [7:0] morse_input,
    input clk,
    output reg valid_reg,
    output reg [16:0] sixteen_disp
);

reg [6:0] morse_index;
reg valid;

wire [16:0] sixteen_disp_arr [0:60];
 
// Индексы массива по ASCII - 17 выходов на 16 сегментный дисплей (и точка)
assign sixteen_disp_arr[0] = 'h00000; /* (space) */
assign sixteen_disp_arr[1] = 'h1000C; /* ! */
// assign sixteen_disp_arr[2] = 'h00204; /* " */ 
// assign sixteen_disp_arr[3] = 'h0AA3C; /* # */
// assign sixteen_disp_arr[4] = 'h0AABB; /* $ */
// assign sixteen_disp_arr[5] = 'h0EE99; /* % */
assign sixteen_disp_arr[6] = 'h09371; /* & */
assign sixteen_disp_arr[7] = 'h00200; /* ' */
assign sixteen_disp_arr[8] = 'h01400; /* ( */
assign sixteen_disp_arr[9] = 'h04100; /* ) */
// assign sixteen_disp_arr[10] = 'h0FF00; /* * */
assign sixteen_disp_arr[11] = 'h0AA00; /* + */
assign sixteen_disp_arr[12] = 'h04000; /* , */
assign sixteen_disp_arr[13] = 'h08800; /* - */
assign sixteen_disp_arr[14] = 'h10000; /* . */
assign sixteen_disp_arr[15] = 'h04400; /* / */
assign sixteen_disp_arr[16] = 'h044FF; /* 0 */
assign sixteen_disp_arr[17] = 'h0040C; /* 1 */
assign sixteen_disp_arr[18] = 'h08877; /* 2 */
assign sixteen_disp_arr[19] = 'h0083F; /* 3 */
assign sixteen_disp_arr[20] = 'h0888C; /* 4 */
assign sixteen_disp_arr[21] = 'h090B3; /* 5 */
assign sixteen_disp_arr[22] = 'h088FB; /* 6 */
assign sixteen_disp_arr[23] = 'h0000F; /* 7 */
assign sixteen_disp_arr[24] = 'h088FF; /* 8 */
assign sixteen_disp_arr[25] = 'h088BF; /* 9 */
assign sixteen_disp_arr[26] = 'h02200; /* : */
assign sixteen_disp_arr[27] = 'h04200; /* ; */
// assign sixteen_disp_arr[28] = 'h09400; /* < */
assign sixteen_disp_arr[29] = 'h08830; /* = */
// assign sixteen_disp_arr[30] = 'h04900; /* > */
assign sixteen_disp_arr[31] = 'h12807; /* ? */
assign sixteen_disp_arr[32] = 'h00AF7; /* @ */
assign sixteen_disp_arr[33] = 'h088CF; /* A */
assign sixteen_disp_arr[34] = 'h02A3F; /* B */
assign sixteen_disp_arr[35] = 'h000F3; /* C */
assign sixteen_disp_arr[36] = 'h0223F; /* D */
assign sixteen_disp_arr[37] = 'h080F3; /* E */
assign sixteen_disp_arr[38] = 'h080C3; /* F */
assign sixteen_disp_arr[39] = 'h008FB; /* G */
assign sixteen_disp_arr[40] = 'h088CC; /* H */
assign sixteen_disp_arr[41] = 'h02233; /* I */
assign sixteen_disp_arr[42] = 'h0007C; /* J */
assign sixteen_disp_arr[43] = 'h094C0; /* K */
assign sixteen_disp_arr[44] = 'h000F0; /* L */
assign sixteen_disp_arr[45] = 'h005CC; /* M */
assign sixteen_disp_arr[46] = 'h011CC; /* N */
assign sixteen_disp_arr[47] = 'h000FF; /* O */
assign sixteen_disp_arr[48] = 'h088C7; /* P */
assign sixteen_disp_arr[49] = 'h010FF; /* Q */
assign sixteen_disp_arr[50] = 'h098C7; /* R */
assign sixteen_disp_arr[51] = 'h088BB; /* S */
assign sixteen_disp_arr[52] = 'h02203; /* T */
assign sixteen_disp_arr[53] = 'h000FC; /* U */
assign sixteen_disp_arr[54] = 'h044C0; /* V */
assign sixteen_disp_arr[55] = 'h050CC; /* W */
assign sixteen_disp_arr[56] = 'h05500; /* X */
assign sixteen_disp_arr[57] = 'h088BC; /* Y */
assign sixteen_disp_arr[58] = 'h04433; /* Z */
assign sixteen_disp_arr[59] = 'h00030; /* _ */

// По длине последовательности и ее содержимому определяем какой символ по ASCII был передан
always @(*)
    case (morse_length)
        0: begin // Длина кода не может быть 0
            morse_index = 0; // Ошибка
            valid = 1'b0;
        end
        1: begin // Длина кода 1
            if (morse_input[0] == 1'b0) begin morse_index = 37; valid = 1'b1; end // 'E': '0'
            else if (morse_input[0] == 1'b1) begin morse_index = 52; valid = 1'b1; end // 'T': '1'
        end
        2: begin // Длина кода 2
            if (morse_input[1:0] == 2'b00) begin morse_index = 41; valid = 1'b1; end // 'I': '00'
            else if (morse_input[1:0] == 2'b01) begin morse_index = 33; valid = 1'b1; end // 'A': '01'
            else if (morse_input[1:0] == 2'b10) begin morse_index = 46; valid = 1'b1; end // 'N': '10'
            else if (morse_input[1:0] == 2'b11) begin morse_index = 45; valid = 1'b1; end // 'M': '11'
        end
        3: begin // Длина кода 3
            if (morse_input[2:0] == 3'b000) begin morse_index = 51; valid = 1'b1; end // 'S': '000'
            else if (morse_input[2:0] == 3'b001) begin morse_index = 53; valid = 1'b1; end // 'U': '001'
            else if (morse_input[2:0] == 3'b010) begin morse_index = 50; valid = 1'b1; end // 'R': '010'
            else if (morse_input[2:0] == 3'b011) begin morse_index = 55; valid = 1'b1; end // 'W': '011'
            else if (morse_input[2:0] == 3'b100) begin morse_index = 36; valid = 1'b1; end // 'D': '100'
            else if (morse_input[2:0] == 3'b110) begin morse_index = 39; valid = 1'b1; end // 'G': '110'
            else if (morse_input[2:0] == 3'b111) begin morse_index = 47; valid = 1'b1; end // 'O': '111'
        end
        4: begin // Длина кода 4
            if (morse_input[3:0] == 4'b0000) begin morse_index = 40; valid = 1'b1; end // 'H': '0000'
            else if (morse_input[3:0] == 4'b0001) begin morse_index = 54; valid = 1'b1; end // 'V': '0001'
            else if (morse_input[3:0] == 4'b0010) begin morse_index = 38; valid = 1'b1; end // 'F': '0010'
            else if (morse_input[3:0] == 4'b0100) begin morse_index = 44; valid = 1'b1; end // 'L': '0100'
            else if (morse_input[3:0] == 4'b0110) begin morse_index = 48; valid = 1'b1; end // 'P': '0110'
            else if (morse_input[3:0] == 4'b0111) begin morse_index = 42; valid = 1'b1; end // 'J': '0111'
            else if (morse_input[3:0] == 4'b1000) begin morse_index = 34; valid = 1'b1; end // 'B': '1000'
            else if (morse_input[3:0] == 4'b1001) begin morse_index = 56; valid = 1'b1; end // 'X': '1001'
            else if (morse_input[3:0] == 4'b1010) begin morse_index = 35; valid = 1'b1; end // 'C': '1010'
            else if (morse_input[3:0] == 4'b1011) begin morse_index = 57; valid = 1'b1; end // 'Y': '1011'
            else if (morse_input[3:0] == 4'b1100) begin morse_index = 58; valid = 1'b1; end // 'Z': '1100'
            else if (morse_input[3:0] == 4'b1101) begin morse_index = 49; valid = 1'b1; end // 'Q': '1101'
        end
        5: begin // Длина кода 5
            if (morse_input[4:0] == 5'b10001) begin morse_index = 29; valid = 1'b1; end // '=': '10001'
            else if (morse_input[4:0] == 5'b11111) begin morse_index = 21; valid = 1'b1; end // '5': '00000'
            else if (morse_input[4:0] == 5'b00001) begin morse_index = 20; valid = 1'b1; end // '4': '00001'
            else if (morse_input[4:0] == 5'b00011) begin morse_index = 19; valid = 1'b1; end // '3': '00011'
            else if (morse_input[4:0] == 5'b00111) begin morse_index = 18; valid = 1'b1; end // '2': '00111'
            else if (morse_input[4:0] == 5'b01111) begin morse_index = 17; valid = 1'b1; end // '1': '01111'
            else if (morse_input[4:0] == 5'b10000) begin morse_index = 22; valid = 1'b1; end // '6': '10000'
            else if (morse_input[4:0] == 5'b11000) begin morse_index = 23; valid = 1'b1; end // '7': '11000'
            else if (morse_input[4:0] == 5'b11100) begin morse_index = 24; valid = 1'b1; end // '8': '11100'
            else if (morse_input[4:0] == 5'b11110) begin morse_index = 25; valid = 1'b1; end // '9': '11110'
            else if (morse_input[4:0] == 5'b11111) begin morse_index = 16; valid = 1'b1; end // '0': '11111'
            else if (morse_input[4:0] == 5'b10010) begin morse_index = 15; valid = 1'b1; end // '/': '10010'
            else if (morse_input[4:0] == 5'b10110) begin morse_index = 8; valid = 1'b1; end // '(': '10110'
        end
        6: begin // Длина кода 6
            if (morse_input[5:0] == 6'b001100) begin morse_index = 31; valid = 1'b1; end // '?': '001100'
            else if (morse_input[5:0] == 6'b101010) begin morse_index = 27; valid = 1'b1; end // ';': '101010'
            else if (morse_input[5:0] == 6'b110011) begin morse_index = 12; valid = 1'b1; end // ',': '110011'
            else if (morse_input[5:0] == 6'b100001) begin morse_index = 13; valid = 1'b1; end // '-': '100001'
            else if (morse_input[5:0] == 6'b101101) begin morse_index = 9; valid = 1'b1; end // ')': '101101'
            else if (morse_input[5:0] == 6'b011110) begin morse_index = 7; valid = 1'b1; end // '\'': '011110'
            else if (morse_input[5:0] == 6'b010101) begin morse_index = 11; valid = 1'b1; end // '+': '010101'
            else if (morse_input[5:0] == 6'b111000) begin morse_index = 26; valid = 1'b1; end // ':': '111000'
            else if (morse_input[5:0] == 6'b001101) begin morse_index = 59; valid = 1'b1; end // '_': '001101'
        end
        7: begin // Длина кода 7
            if (morse_input[6:0] == 7'b1011001) begin morse_index = 1; valid = 1'b1; end // '!': '1011001'
            else if (morse_input[6:0] == 7'b0101110) begin morse_index = 6; valid = 1'b1; end // '&': '0101110'
            else if (morse_input[6:0] == 7'b0101010) begin morse_index = 14; valid = 1'b1; end // '.': '0101010'
            else if (morse_input[6:0] == 7'b0110010) begin morse_index = 32; valid = 1'b1; end // '@': '0110010'
            else if (morse_input == 7'b0000000) morse_index = 0;    valid = 1'b1; // ' ': '' (Пробел, дополнен нулями)

        end
        default: begin
            morse_index = 0; // Ошибка
            valid = 1'b0;
        end
    endcase

// На след такте выводим на дисплей 
always @(posedge clk)
    begin
        sixteen_disp <= sixteen_disp_arr[morse_index];
        valid_reg <= valid;
    end

endmodule