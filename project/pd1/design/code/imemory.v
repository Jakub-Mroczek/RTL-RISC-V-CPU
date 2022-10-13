module imemory (
    input wire clock,
    input wire read_write,
    input wire [31:0] address,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);

    reg [7:0] main_mem [`MEM_DEPTH:0];
    reg [31:0] temp_memory [`LINE_COUNT - 1:0];
    integer i;
    initial begin
        $readmemh(`MEM_PATH, temp_memory);
        for (i = 0; i < `LINE_COUNT; i = i + 1) begin
            // {main_mem[4 * i], main_mem[4 * i + 1], main_mem[4 * i + 2], main_mem[4 * i + 3]} = temp_memory[i];
            main_mem[4 * i + 0] = temp_memory[i][7:0];
            main_mem[4 * i + 1] = temp_memory[i][15:8];
            main_mem[4 * i + 2] = temp_memory[i][23:16];
            main_mem[4 * i + 3] = temp_memory[i][31:24];
            // $display("main_mem: 0x%0h 0x%0h 0x%0h 0x%0h, /n", main_mem[4 * i + 0], main_mem[4 * i + 1], main_mem[4 * i + 2], main_mem[4 * i + 3], data_in);
        end

    end

    // Reading memory
    always @ (*) begin
        if (!read_write) begin
            data_out[31:24] = main_mem[address - 32'h01000000 + 3];
            data_out[23:16] = main_mem[address - 32'h01000000 + 2];
            data_out[15:8]  = main_mem[address - 32'h01000000 + 1];
            data_out[7:0]   = main_mem[address - 32'h01000000 + 0];
            // $display("read_write: %b, address: 0x%0h, data_in: 0x%0h", read_write, address, data_out);
        end else begin
            data_out[31:0] = 32'h00000000;
        end
    end

    // Writing to memory
    always @ (posedge clock) begin
        if (read_write) begin
            // $display("read_write: %b, address: 0x%0h, data_in: 0x%0h", read_write, address, data_in);
            main_mem[address - 32'h01000000 + 3] <= data_in[31:24];
            main_mem[address - 32'h01000000 + 2] <= data_in[23:16];
            main_mem[address - 32'h01000000 + 1] <= data_in[15:8];
            main_mem[address - 32'h01000000 + 0] <= data_in[7:0];

            // $display("read_write: %b, address: 0x%0h, data_in: 0x%0h", read_write, address, data_in);
        end

    end

endmodule
