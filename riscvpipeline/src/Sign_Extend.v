
// module Sign_Extend (In,ImmSrc,Imm_Ext);
//     input [31:0] In;
//     input [1:0] ImmSrc;
//     output [31:0] Imm_Ext;

//     assign Imm_Ext =  (ImmSrc == 2'b00) ? {{20{In[31]}},In[31:20]} : 
//                      (ImmSrc == 2'b01) ? {{20{In[31]}},In[31:25],In[11:7]} : 32'h00000000; 

// endmodule



module Sign_Extend(
  input  logic [31:0] In,
  input  logic [1:0]  ImmSrc,
  output logic [31:0] Imm_Ext
);

  logic [31:0] imm_i;
  logic [31:0] imm_s;
  logic [31:0] imm_b;
  logic [31:0] imm_j;

  // construct immediates with explicit bit widths
  assign imm_i = {{20{In[31]}}, In[31:20]};                             // I-type
  assign imm_s = {{20{In[31]}}, In[31:25], In[11:7]};               // S-type
  assign imm_b = {{19{In[31]}}, In[31], In[7], In[30:25], In[11:8], 1'b0}; // B-type
  // Note: B-type sign replicate 19 bits because imm field is 12 bits (bits [12]=In[31], [11]=In[7], [10:5]=In[30:25], [4:1]=In[11:8], [0]=0) -> total 13 bits, so 32-13 = 19
  assign imm_j = {{11{In[31]}}, In[31], In[19:12], In[20], In[30:21], 1'b0}; // J-type
  // Note: J-type immediate is 21 bits (including sign), so replicate 11 bits to reach 32.

  always_comb begin
    // unique case (ImmSrc)
    case (ImmSrc)
      2'b00: Imm_Ext = imm_i;
      2'b01: Imm_Ext = imm_s;
      2'b10: Imm_Ext = imm_b;
      2'b11: Imm_Ext = imm_j;
      default: Imm_Ext = 32'bx;
    endcase
  end

endmodule