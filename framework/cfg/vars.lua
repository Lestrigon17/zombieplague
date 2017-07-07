local zm = zm or {};

--[[-------------------------------------------------------------------------
Colors
---------------------------------------------------------------------------]]
zm.colors = zm.colors or {};	// TABLE
zm.colors.red 				= Color(255,0,0);
zm.colors.green 			= Color(0,255,0);
zm.colors.blue 				= Color(0,0,255);
zm.colors.white 			= Color(255,255,255);
zm.colors.black 			= Color(0,0,0);
-- Transporents
zm.colors.twhite 			= Color(225,225,225,100);
zm.colors.tblack 			= Color(0,0,0,150);
-- Special color
zm.colors.aliceblue 		= Color(240, 248, 255)
zm.colors.antiquewhite 		= Color(250, 235, 215)
zm.colors.aqua 				= Color(0, 255, 255)
zm.colors.aquamarine 		= Color(127, 255, 212)
zm.colors.azure		 		= Color(240, 255, 255)
zm.colors.beige 			= Color(245, 245, 220)
zm.colors.bisque 			= Color(255, 228, 196)
zm.colors.black 			= Color(0, 0, 0)
zm.colors.blanchedalmond 	= Color(255, 235, 205)
zm.colors.blue 				= Color(0, 0, 255)
zm.colors.blueviolet 		= Color(138, 43, 226)
zm.colors.brown 			= Color(165, 42, 42)
zm.colors.burlywood	 		= Color(222, 184, 135)
zm.colors.cadetblue 		= Color(95, 158, 160)
zm.colors.chartreuse 		= Color(127, 255, 0)
zm.colors.chocolate 		= Color(210, 105, 30)
zm.colors.coral				= Color(255, 127, 80)
zm.colors.cornflowerblue 	= Color(100, 149, 237)
zm.colors.cornsilk 			= Color(255, 248, 220)
zm.colors.crimson 			= Color(220, 20, 60)
zm.colors.cyan 				= Color(0, 255, 255)
zm.colors.darkblue 			= Color(0, 0, 139)
zm.colors.darkcyan 			= Color(0, 139, 139)
zm.colors.darkgoldenrod 	= Color(184, 134, 11)
zm.colors.darkgray 			= Color(169, 169, 169)
zm.colors.darkgreen 		= Color(0, 100, 0)
zm.colors.darkgrey 			= Color(169, 169, 169)
zm.colors.darkkhaki 		= Color(189, 183, 107)
zm.colors.darkmagenta 		= Color(139, 0, 139)
zm.colors.darkolivegreen 	= Color(85, 107, 47)
zm.colors.darkorange 		= Color(255, 140, 0)
zm.colors.darkorchid 		= Color(153, 50, 204)
zm.colors.darkred 			= Color(139, 0, 0)
zm.colors.darksalmon 		= Color(233, 150, 122)
zm.colors.darkseagreen 		= Color(143, 188, 143)
zm.colors.darkslateblue 	= Color(72, 61, 139)
zm.colors.darkslategray 	= Color(47, 79, 79)
zm.colors.darkslategrey 	= Color(47, 79, 79)
zm.colors.darkturquoise 	= Color(0, 206, 209)
zm.colors.darkviolet 		= Color(148, 0, 211)
zm.colors.deeppink 			= Color(255, 20, 147)
zm.colors.deepskyblue 		= Color(0, 191, 255)
zm.colors.dimgray 			= Color(105, 105, 105)
zm.colors.dimgrey 			= Color(105, 105, 105)
zm.colors.dodgerblue 		= Color(30, 144, 255)
zm.colors.firebrick 		= Color(178, 34, 34)
zm.colors.floralwhite 		= Color(255, 250, 240)
zm.colors.forestgreen 		= Color(34, 139, 34)
zm.colors.fuchsia 			= Color(255, 0, 255)
zm.colors.gainsboro 		= Color(220, 220, 220)
zm.colors.ghostwhite 		= Color(248, 248, 255)
zm.colors.gold 				= Color(255, 215, 0)
zm.colors.goldenrod 		= Color(218, 165, 32)
zm.colors.gray 				= Color(128, 128, 128)
zm.colors.grey 				= Color(128, 128, 128)
zm.colors.green 			= Color(0, 128, 0)
zm.colors.greenyellow 		= Color(173, 255, 47)
zm.colors.honeydew 			= Color(240, 255, 240)
zm.colors.hotpink 			= Color(255, 105, 180)
zm.colors.indianred 		= Color(205, 92, 92)
zm.colors.indigo 			= Color(75, 0, 130)
zm.colors.ivory 			= Color(255, 255, 240)
zm.colors.khaki 			= Color(240, 230, 140)
zm.colors.lavender 			= Color(230, 230, 250)
zm.colors.lavenderblush 	= Color(255, 240, 245)
zm.colors.lawngreen 		= Color(124, 252, 0)
zm.colors.lemonchiffon 		= Color(255, 250, 205)
zm.colors.lightblue 		= Color(173, 216, 230)
zm.colors.lightcoral 		= Color(240, 128, 128)
zm.colors.lightcyan 		= Color(224, 255, 255)
zm.colors.lightgoldenrodyellow = Color(250, 250, 210)
zm.colors.lightgray 		= Color(211, 211, 211)
zm.colors.lightgreen 		= Color(144, 238, 144)
zm.colors.lightgrey 		= Color(211, 211, 211)
zm.colors.lightpink 		= Color(255, 182, 193)
zm.colors.lightsalmon 		= Color(255, 160, 122)
zm.colors.lightseagreen 	= Color(32, 178, 170)
zm.colors.lightskyblue 		= Color(135, 206, 250)
zm.colors.lightslategray 	= Color(119, 136, 153)
zm.colors.lightslategrey 	= Color(119, 136, 153)
zm.colors.lightsteelblue 	= Color(176, 196, 222)
zm.colors.lightyellow 		= Color(255, 255, 224)
zm.colors.lime 				= Color(0, 255, 0)
zm.colors.limegreen 		= Color(50, 205, 50)
zm.colors.linen 			= Color(250, 240, 230)
zm.colors.magenta 			= Color(255, 0, 255)
zm.colors.maroon 			= Color(128, 0, 0)
zm.colors.mediumaquamarine 	= Color(102, 205, 170)
zm.colors.mediumblue 		= Color(0, 0, 205)
zm.colors.mediumorchid 		= Color(186, 85, 211)
zm.colors.mediumpurple 		= Color(147, 112, 219)
zm.colors.mediumseagreen 	= Color(60, 179, 113)
zm.colors.mediumslateblue 	= Color(123, 104, 238)
zm.colors.mediumspringgreen = Color(0, 250, 154)
zm.colors.mediumturquoise 	= Color(72, 209, 204)
zm.colors.mediumvioletred 	= Color(199, 21, 133)
zm.colors.midnightblue 		= Color(25, 25, 112)
zm.colors.mintcream 		= Color(245, 255, 250)
zm.colors.mistyrose 		= Color(255, 228, 225)
zm.colors.moccasin 			= Color(255, 228, 181)
zm.colors.navajowhite 		= Color(255, 222, 173)
zm.colors.navy		 		= Color(0, 0, 128)
zm.colors.oldlace 			= Color(253, 245, 230)
zm.colors.olive 			= Color(128, 128, 0)
zm.colors.olivedrab 		= Color(107, 142, 35)
zm.colors.orange 			= Color(255, 165, 0)
zm.colors.orangered 		= Color(255, 69, 0)
zm.colors.orchid 			= Color(218, 112, 214)
zm.colors.palegoldenrod 	= Color(238, 232, 170)
zm.colors.palegreen 		= Color(152, 251, 152)
zm.colors.paleturquoise 	= Color(175, 238, 238)
zm.colors.palevioletred 	= Color(219, 112, 147)
zm.colors.papayawhip 		= Color(255, 239, 213)
zm.colors.peachpuff 		= Color(255, 218, 185)
zm.colors.peru 				= Color(205, 133, 63)
zm.colors.pink 				= Color(255, 192, 203)
zm.colors.plum 				= Color(221, 160, 221)
zm.colors.powderblue 		= Color(176, 224, 230)
zm.colors.purple 			= Color(128, 0, 128)
zm.colors.red 				= Color(255, 0, 0)
zm.colors.rosybrown 		= Color(188, 143, 143)
zm.colors.royalblue 		= Color(65, 105, 225)
zm.colors.saddlebrown 		= Color(139, 69, 19)
zm.colors.salmon 			= Color(250, 128, 114)
zm.colors.sandybrown 		= Color(244, 164, 96)
zm.colors.seagreen 			= Color(46, 139, 87)
zm.colors.seashell 			= Color(255, 245, 238)
zm.colors.sienna 			= Color(160, 82, 45)
zm.colors.silver 			= Color(192, 192, 192)
zm.colors.skyblue 			= Color(135, 206, 235)
zm.colors.slateblue 		= Color(106, 90, 205)
zm.colors.slategray 		= Color(112, 128, 144)
zm.colors.slategrey 		= Color(112, 128, 144)
zm.colors.snow 				= Color(255, 250, 250)
zm.colors.springgreen 		= Color(0, 255, 127)
zm.colors.steelblue 		= Color(70, 130, 180)
zm.colors.tan 				= Color(210, 180, 140)
zm.colors.teal 				= Color(0, 128, 128)
zm.colors.thistle			= Color(216, 191, 216)
zm.colors.tomato 			= Color(255, 99, 71)
zm.colors.turquoise 		= Color(64, 224, 208)
zm.colors.violet 			= Color(238, 130, 238)
zm.colors.wheat 			= Color(245, 222, 179)
zm.colors.white 			= Color(255, 255, 255)
zm.colors.whitesmoke 		= Color(245, 245, 245)
zm.colors.yellow 			= Color(255, 255, 0)
zm.colors.yellowgreen 		= Color(154, 205, 50)

concommand.Add("GetColors", function()
	for k,v in pairs(zm.colors) do
		chat.AddText(v, "Color: "..k);
	end;
end);