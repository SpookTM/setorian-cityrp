function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("Channel_buttons", {
		font = "Consolas",
		size = ScreenScale(5.5),
		antialias = true,
		extended = true,
		weight = 500,
	})

	surface.CreateFont("Channel_labels", {
		font = "Consolas",
		size = ScreenScale(5),
		antialias = true,
		extended = true,
	})

	surface.CreateFont("Channel_big_title", {
		font = "CloseCaption_Bold",
		size = ScreenScale(15),
		antialias = true,
		extended = true,
		weight = 800,
	})

	surface.CreateFont("Channel_big_topic", {
		font = "Trebuchet18",
		size = ScreenScale(8),
		antialias = true,
		extended = true,
	})
end;