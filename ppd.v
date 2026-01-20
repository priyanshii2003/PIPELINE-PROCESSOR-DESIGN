module pipeline_processor (
    input clk
);

    // Instruction format: [7:6] opcode, [5:3] rd, [2:0] rs
    // opcode: 00=ADD, 01=SUB, 10=LOAD

    reg [7:0] instr_mem [0:3];
    reg [7:0] regfile [0:7];
    reg [7:0] data_mem [0:7];

    // Pipeline registers
    reg [7:0] IF_ID;
    reg [7:0] ID_EX;
    reg [7:0] EX_WB;

    integer pc;

    initial begin
        pc = 0;

        // Instructions
        instr_mem[0] = 8'b00_001_010; // ADD R1, R2
        instr_mem[1] = 8'b01_011_001; // SUB R3, R1
        instr_mem[2] = 8'b10_100_011; // LOAD R4, mem[R3]

        // Register init
        regfile[2] = 8'd10;
        regfile[1] = 8'd5;
        regfile[3] = 8'd2;

        data_mem[2] = 8'd50;
    end

    always @(posedge clk) begin
        // IF stage
        IF_ID <= instr_mem[pc];
        pc <= pc + 1;

        // ID stage
        ID_EX <= IF_ID;

        // EX stage
        case (ID_EX[7:6])
            2'b00: EX_WB <= regfile[ID_EX[5:3]] + regfile[ID_EX[2:0]];
            2'b01: EX_WB <= regfile[ID_EX[5:3]] - regfile[ID_EX[2:0]];
            2'b10: EX_WB <= data_mem[regfile[ID_EX[2:0]]];
        endcase

        // WB stage
        regfile[ID_EX[5:3]] <= EX_WB;
    end

endmodule
