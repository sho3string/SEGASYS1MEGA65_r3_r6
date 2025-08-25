// Copyright (c) 2019 MiSTer-X

module hvgen
(
        output       [8:0] HPOS,
        output       [8:0] VPOS,
        input              CLK,
        input              PCLK_EN,
        input       [11:0] iRGB,

        output reg  [11:0] oRGB,
        output             HBLK,
        output reg         VBLK = 1,
        output reg         HSYN = 1,
        output reg         VSYN = 1,

        input              H240,

        input signed [3:0] HOFFS,
        input signed [3:0] VOFFS
);

localparam [8:0] width = 320;
localparam [8:0] height = 260;

reg [8:0] hcnt = 0;
reg [8:0] vcnt = 0;

assign HPOS = hcnt-16;
assign VPOS = !vcnt[8] ? vcnt : vcnt - height;

wire [8:0] HS_B0 = 296+HOFFS;
wire [8:0] HS_B = HS_B0 % width;
wire [8:0] HS_E = (HS_B+24) % width;

wire [8:0] VS_B0 = 234+VOFFS;
wire [8:0] VS_B = VS_B0 % height;
wire [8:0] VS_E = (VS_B+4) % height;

reg hblk240;
reg hblk256;

wire hblack = H240 ? hblk240 : hblk256;
assign HBLK = hblk256;

always @(posedge CLK) begin
	if (PCLK_EN) begin
		if (hcnt < width-1)
			hcnt <= hcnt+1;
		else begin
			hcnt <= 0;
			vcnt <= (vcnt+1) % height;
		end

		hblk256 <= (hcnt < 29) | (hcnt >= 285);
		hblk240 <= (hcnt < 37) | (hcnt >= 277);
		VBLK <= (vcnt >= 224);
		HSYN <= (hcnt < HS_B) ^ (hcnt < HS_E) ^ (HS_B < HS_E);
		VSYN <= (vcnt < VS_B) ^ (vcnt < VS_E) ^ (VS_B < VS_E);
		oRGB <= (hblack|VBLK) ? 12'h0 : iRGB;
	end
end
endmodule
