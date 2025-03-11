// Тут не ровно столько мс, а столько и больше (Ns-Nl это . Nl-Nw это - и т.д.), таким образом поддерживаем ручной ввод

`define Ns  10      // Время для . в мс
`define Nl  300     // Время для - в мс
`define Nw  600     // Время для записи в мс
`define Nsw 2000    // Время для сброса режима автопаузы в мс    

`define frq 20 /2      // Частота clk в кГц (для загрузки в ПЛИС надо пошаманить с PLL)
`define Nd  10      // Через сколько мс начинается 0 (для дребезга)

// `define v1
// `define v2
`define v3


// Локальные константы
`define pns  `Ns  * `frq
`define pnl  `Nl  * `frq
`define pnw  `Nw  * `frq
`define pnsw `Nsw * `frq
`define pndf `Nd  * `frq

module morseio(
    input morsein,
    input clk,
    input rst,
    output reg valid,
    output reg [3:0] morse_length,
    output reg [7:0] morse_input
);


reg [31:0] cnt1;
reg [31:0] cnt0;

`ifndef v1
    `ifndef v2
        reg state;
    `endif 
`endif
 
always @(posedge clk)
begin
    if (rst || valid)
    begin
        cnt1 <= 0;
        cnt0 <= 0;
        morse_length <= 0;
        morse_input <= 0;
        valid <= 0;
        `ifndef v1
            `ifndef v2
                if (rst) state <= 0;
            `endif 
        `endif
    end
    else
    begin
        if (morsein)
        begin
            cnt1 <= cnt1 + 1;
            cnt0 <= 0;
            
        end
        else 
        begin 
            cnt0 <= cnt0 + 1;
            if (cnt0 + 1 >= `pndf)
            begin
                    // Считали сигнал
                    if (cnt1 >= `pns)
                        if (cnt1 < `pnl)
                        begin
                            morse_input <= {morse_input, 1'b0};
                            morse_length <= morse_length + 1;
                        end
                        else if (cnt1 < `pnw)
                        begin
                            morse_input <= {morse_input, 1'b1};
                            morse_length <= morse_length + 1;
                        end 

                `ifdef v1
                    if (cnt1 >= `pnw)
                    begin
                        valid <= 1;
                    end
                    cnt0 <= 0;
                `endif

                `ifdef v2
                    if (cnt0 + 1 >= `pnw)
                    begin
                        valid <= 1;
                        cnt0 <= 0;
                    end
                    if (cnt1 >= `pnl)
                    begin
                        morse_input <= {morse_input, 1'b1};
                        morse_length <= morse_length + 1;
                    end 
                `endif

                `ifndef v1
                    `ifndef v2
                        if (state)
                        begin
                            if (cnt1 >= `pnsw)
                            begin
                                state <= 0;
                            end 
                            else if (cnt1 + 1 >= `pnw)
                            begin
                                valid <= 1;
                            end
                            cnt0 <= 0;
                        end
                        else
                        begin 
                            if (cnt1 >= `pnw)
                            begin
                                state <= 1;
                                cnt0 <= 0;
                            end 
                            else if (cnt0 + 1 >= `pnw)
                            begin
                                valid <= 1;
                                cnt0 <= 0;
                            end
                        end

                    `endif
                `endif
                    

                cnt1 <= 0;
            end


        end
    end
end


endmodule