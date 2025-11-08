module ALU(
  input  logic [31:0] A, B,
  input  logic [4:0]  ALUControl,
  output logic [31:0] Result,
  output logic        Zero,
  output logic        Carry,
  output logic        OverFlow,
  output logic        Negative
);

  logic [31:0] condinvb, sum;
  logic        v;              // overflow
  logic        isAddSub;       // true when is add or subtract operation
  logic signed [31:0] sa, sb;
  logic [4:0]  shift_amount;
  logic        slt_sign_bit;
  logic [30:0] a_low_31_rol, a_high_31_ror;
  logic        a_high_1_rol, a_low_1_ror, a_sign_bit;

  assign condinvb = ALUControl[0] ? ~B : B;
  assign sum = A + condinvb + ALUControl[0];
  assign isAddSub = ~ALUControl[2] & ~ALUControl[1] |
                    ~ALUControl[1] & ALUControl[0];

  assign sa = $signed(A);
  assign sb = $signed(B);
  assign shift_amount = B[4:0];
  assign slt_sign_bit = sum[31];

  // For rotate and abs
  assign a_low_31_rol = A[30:0];
  assign a_high_1_rol = A[31];
  assign a_low_1_ror = A[0];
  assign a_high_31_ror = A[31:1];
  assign a_sign_bit = A[31];

  always_comb
    case (ALUControl)
      5'b10000: Result = A & ~B;                        // andn
      5'b10001: Result = A | ~B;                        // orn 
      5'b10010: Result = ~(A ^ B);                      // xnor
      5'b10011: Result = (sa < sb) ? A : B;             // min 
      5'b10100: Result = (sa > sb) ? A : B;             // max 
      5'b10101: Result = (A < B) ? A : B;               // minu
      5'b10110: Result = (A > B) ? A : B;               // maxu
      //rol
      5'b11000: Result = (A << shift_amount) | (A >> (32 - shift_amount));
      //ror
      5'b11001: Result = (A >> shift_amount) | (A << (32 - shift_amount));
      5'b10111: Result = (A == 32'h80000000) ? 32'h80000000 :
                          (a_sign_bit ? -A : A);         // abs 

      5'b00000: Result = sum;                           // add
      5'b00001: Result = sum;                           // subtract
      5'b00010: Result = A & B;                         // and
      5'b00011: Result = A | B;                         // or
      5'b00100: Result = A ^ B;                         // xor
      5'b00101: Result = slt_sign_bit ^ v;              // slt 
      5'b00110: Result = A << shift_amount;             // sll
      5'b00111: Result = A >> shift_amount;             // srl
      default: Result = 32'bx;
    endcase

  assign Zero = (Result == 32'b0);
  assign v = ~(ALUControl[0] ^ A[31] ^ B[31]) & (A[31] ^ sum[31]) & isAddSub;
  assign Carry = (ALUControl[0] ? (A < B) : (sum < A)); // Check if there's a carry
  assign Overflow = v;
  assign Negative = Result[31]; // Most significant bit indicates negativity

endmodule
