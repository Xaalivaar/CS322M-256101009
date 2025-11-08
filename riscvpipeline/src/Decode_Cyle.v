module decode_cycle (
    input  logic         clk,
    input  logic         rst,
    // Writeback stage inputs
    input  logic         RegWriteW,
    input  logic [4:0]   RDW,
    input  logic [31:0]  ResultW,
    // From Fetch stage
    input  logic [31:0]  InstrD,
    input  logic [31:0]  PCD,
    input  logic [31:0]  PCPlus4D,
    // Hazard control signals
    input  logic         StallD,
    input  logic         FlushE,
    // Outputs to Execute stage
    output logic         RegWriteE,
    output logic         ALUSrcE,
    output logic         MemWriteE,
    output logic         ResultSrcE,
    output logic         BranchE,
    output logic [4:0]   ALUControlE,
    output logic [31:0]  RD1_E,
    output logic [31:0]  RD2_E,
    output logic [31:0]  Imm_Ext_E,
    output logic [4:0]   RD_E,
    output logic [31:0]  PCE,
    output logic [31:0]  PCPlus4E,
    output logic [4:0]   RS1_E,
    output logic [4:0]   RS2_E
);

    // --- Internal wires from control and register file ---
    logic        RegWriteD, ALUSrcD, MemWriteD, ResultSrcD, BranchD;
    logic [1:0]  ImmSrcD;
    logic [4:0]  ALUControlD;
    logic [31:0] RD1_D, RD2_D, Imm_Ext_D;

    // --- Pipeline registers (Decode → Execute) ---
    logic        RegWriteD_r, ALUSrcD_r, MemWriteD_r, ResultSrcD_r, BranchD_r;
    logic [4:0]  ALUControlD_r;
    logic [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
    logic [4:0]  RD_D_r, RS1_D_r, RS2_D_r;
    logic [31:0] PCD_r, PCPlus4D_r;

    // ---------------- CONTROL UNIT ----------------
    Control_Unit_Top control (
        .Op(InstrD[6:0]),
        .RegWrite(RegWriteD),
        .ImmSrc(ImmSrcD),
        .ALUSrc(ALUSrcD),
        .MemWrite(MemWriteD),
        .ResultSrc(ResultSrcD),
        .Branch(BranchD),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .ALUControl(ALUControlD)
    );

    // ---------------- REGISTER FILE ----------------
    Register_File rf (
        .clk(clk),
        .rst(rst),
        .WE3(RegWriteW),
        .WD3(ResultW),
        .A1(InstrD[19:15]),   // RS1
        .A2(InstrD[24:20]),   // RS2
        .A3(RDW),             // destination from Writeback
        .RD1(RD1_D),
        .RD2(RD2_D)
    );

    // ---------------- SIGN EXTEND ----------------
    Sign_Extend extension (
        .In(InstrD),
        .Imm_Ext(Imm_Ext_D),
        .ImmSrc(ImmSrcD)
    );

    // ---------------- PIPELINE REGISTER UPDATE ----------------
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset all pipeline registers
            RegWriteD_r  <= 1'b0;
            ALUSrcD_r    <= 1'b0;
            MemWriteD_r  <= 1'b0;
            ResultSrcD_r <= 1'b0;
            BranchD_r    <= 1'b0;
            ALUControlD_r<= 5'b00000;
            RD1_D_r      <= 32'h0;
            RD2_D_r      <= 32'h0;
            Imm_Ext_D_r  <= 32'h0;
            RD_D_r       <= 5'h00;
            PCD_r        <= 32'h0;
            PCPlus4D_r   <= 32'h0;
            RS1_D_r      <= 5'h00;
            RS2_D_r      <= 5'h00;
        end else if (FlushE) begin
            // FLUSH: Insert a NOP into Execute stage
            RegWriteD_r  <= 1'b0;
            ALUSrcD_r    <= 1'b0;
            MemWriteD_r  <= 1'b0;
            ResultSrcD_r <= 1'b0;
            BranchD_r    <= 1'b0;
            ALUControlD_r<= 5'b00000;
            RD1_D_r      <= 32'h0;
            RD2_D_r      <= 32'h0;
            Imm_Ext_D_r  <= 32'h0;
            RD_D_r       <= 5'h00;
            PCD_r        <= PCD;        // Keep PC values for debug
            PCPlus4D_r   <= PCPlus4D;
            RS1_D_r      <= 5'h00;
            RS2_D_r      <= 5'h00;
        end else if (!StallD) begin
            // NORMAL OPERATION (no stall)
            RegWriteD_r  <= RegWriteD;
            ALUSrcD_r    <= ALUSrcD;
            MemWriteD_r  <= MemWriteD;
            ResultSrcD_r <= ResultSrcD;
            BranchD_r    <= BranchD;
            ALUControlD_r<= ALUControlD;
            RD1_D_r      <= RD1_D;
            RD2_D_r      <= RD2_D;
            Imm_Ext_D_r  <= Imm_Ext_D;
            RD_D_r       <= InstrD[11:7];
            PCD_r        <= PCD;
            PCPlus4D_r   <= PCPlus4D;
            RS1_D_r      <= InstrD[19:15];
            RS2_D_r      <= InstrD[24:20];
        end
        // else: hold previous values when stalled
    end

    // ---------------- OUTPUT ASSIGNMENTS ----------------
    assign RegWriteE   = RegWriteD_r;
    assign ALUSrcE     = ALUSrcD_r;
    assign MemWriteE   = MemWriteD_r;
    assign ResultSrcE  = ResultSrcD_r;
    assign BranchE     = BranchD_r;
    assign ALUControlE = ALUControlD_r;
    assign RD1_E       = RD1_D_r;
    assign RD2_E       = RD2_D_r;
    assign Imm_Ext_E   = Imm_Ext_D_r;
    assign RD_E        = RD_D_r;
    assign PCE         = PCD_r;
    assign PCPlus4E    = PCPlus4D_r;
    assign RS1_E       = RS1_D_r;
    assign RS2_E       = RS2_D_r;

endmodule
