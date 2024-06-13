local PLUGIN = PLUGIN
PLUGIN.name = "Clothing Shop System"
PLUGIN.description = "Adds modern clothing store UI"
PLUGIN.author = "JohnyReaper"

-- PLUGIN.ShopPos = Vector( 355.84, 246.71, -12287.85 )
PLUGIN.ShopPos = Vector(-1876.9285888672,10391.390625,132.03125)
PLUGIN.PacDatabase = {}

 --[[ 
	  [1] = {                            -- Sorting order
		CategoryName = "Outfit Variants",-- Name
		ViewVector = {                   -- Setting the view after selecting a category
			VFor = -25,
			VRight = 5,
			VUp = -20
		},
		ShopItems = {

			["Test"] = {     -- Name
				price = 20,  -- Price
				Appearance = {
					

					// Change PlayerModel
					ModelData = {
						PModel = "models/player/citizen_v2/male_07.mdl", -- A new playermodel
						ModelReplace = "male_0",  -- If you want the model to be replacement, then here enter what part from the model path should remain unchanged. 
					},                            --The script will automatically search for the digit after the zero 

					Skin = 0,  -- Skin
					
					-- You can even specify here the unique id of the items that are created in the pacoutfit category. 
					-- If you are using pac clothes that have been declared in the "customoutfits" folder remember to add "clothingstore_" in front of the name
					-- Here are the PAC items a player will receive after purchasing an item
					Pac = "clothingstore_hat1"    // pac outfit unique id

					BodyGroups = {
						["Body"] = 1,  -- bodygroup name and value
					}

				},
			},

		},

	  },
--]] 

local scarfs = {
	["White Scarf"]  = "clothingstore_scarf",
	["Gray Scarf"]   = "clothingstore_scarf2",
	["Black Scarf"]  = "clothingstore_scarf3",
	["Purple Scarf"] = "clothingstore_scarf4",
	["Red Scarf"]  = "clothingstore_scarf5",
	["Green Scarf"]  = "clothingstore_scarf6",
	["Pink Scarf"]  = "clothingstore_scarf7",
}

local cap6 = {}

for cap6V = 1, 11 do
	cap6["Cap [Variant "..cap6V.."]"]  = "clothingstore_hat6_"..cap6V
end

local cap7 = {}

for cap7V = 1, 12 do
	cap7["Cap 2 [Variant "..cap7V.."]"]  = "clothingstore_hat7_"..cap7V
end

local cap1 = {}

for cap1V = 1, 8 do
	cap1["Fedora [Variant "..cap1V.."]"]  = "clothingstore_hat1_"..cap1V
end

PLUGIN.Clothes = {

	-- [1] = {
	-- 	CategoryName = "Outfit Variants",

	-- 	ShopItems = {

	-- 		["Variant 1"] = {
	-- 			price = 20,
	-- 			Appearance = {
	-- 				Skin = 0,
	-- 			},
	-- 		},
	-- 		["Variant 2"] = {
	-- 			price = 20,
	-- 			Appearance = {
	-- 				Skin = 1,
	-- 			},
	-- 		},
	-- 		["Variant 3"] = {
	-- 			price = 20,
	-- 			Appearance = {
	-- 				Skin = 2,
	-- 			},
	-- 		},
	-- 		["Variant 4"] = {
	-- 			price = 20,
	-- 			Appearance = {
	-- 				Skin = 3,
	-- 			},
	-- 		},

	-- 	},

	-- },

	[1] = {
		CategoryName = "Suits",
		Gender = "male",
		ShopItems = {

			-- ["No Suit"] = {
			-- 	price = 0,
			-- 	Appearance = {
			-- 		Pacs = {
			-- 		},
			-- 	},
			-- },
			-- ["Black Coat"] = {
			-- 	price = 60,
			-- 	Appearance = {
			-- 		ModelData = {
			-- 			PModel = "models/player/suits/male_07_closed_coat_tie.mdl",
			-- 			ModelReplace = "male_0",
			-- 		},
			-- 	},
			-- },
			-- ["Blue Coat"] = {
			-- 	price = 80,
			-- 	Appearance = {
			-- 		ModelData = {
			-- 			PModel = "models/player/suits/male_07_closed_coat_tie.mdl",
			-- 			ModelReplace = "male_0",
			-- 		},
			-- 		Skin = 6,
			-- 	},
			-- },
			-- ["Black Suit"] = {
			-- 	price = 50,
			-- 	Appearance = {
			-- 		ModelData = {
			-- 			PModel = "models/player/suits/male_07_open.mdl",
			-- 			ModelReplace = "male_0",
			-- 		},
			-- 	},
			-- },
			-- ["Grey Suit"] = {
			-- 	price = 75,
			-- 	Appearance = {
			-- 		ModelData = {
			-- 			PModel = "models/player/suits/male_07_open.mdl",
			-- 			ModelReplace = "male_0",
			-- 		},
			-- 		Skin = 4,
			-- 	},
			-- },
			-- ["White Suit"] = {
			-- 	price = 75,
			-- 	Appearance = {
			-- 		ModelData = {
			-- 			PModel = "models/player/suits/male_07_open.mdl",
			-- 			ModelReplace = "male_0",
			-- 		},
			-- 		Skin = 3,
			-- 	},
			-- },
			-- ["Black Suit 2"] = {
			-- 	price = 55,
			-- 	Appearance = {
			-- 		ModelData = {
			-- 			PModel = "models/player/suits/male_07_open.mdl",
			-- 			ModelReplace = "male_0",
			-- 		},
			-- 		Skin = 11,
			-- 	},
			-- },

		},

	},

	[2] = {
		CategoryName = "Hats",
		ViewVector = {
			VFor = -25,
			VRight = 5,
			VUp = -20
		},
		ShopItems = {

			-- ["No Hat"] = {
			-- 	price = 0,
			-- 	Appearance = {
			-- 		Pacs = {
			-- 		},
			-- 	},
			-- },

			-- ["Fedora"] = {
			-- 	price = 20,
			-- 	Appearance = {

			-- 		Pacs = {
			-- 			["clothingstore_hat1"] = true,
			-- 		},

			-- 	},
			-- },

			["Beanie"] = {
				price = 15,
				Appearance = {

					Pac = "clothingstore_hat2"

				},
			},

			["Beanie 2"] = {
				price = 10,
				Appearance = {

					Pac = "clothingstore_hat3"
				},
			},

			["Flat Cap"] = {
				price = 20,
				Appearance = {

					Pac = "clothingstore_hat5"

				},
			},

			-- ["Cap"] = {
			-- 	price = 15,
			-- 	Appearance = {

			-- 		Pacs = {
			-- 			["clothingstore_hat6"] = true,
			-- 		},

			-- 	},
			-- },

			-- ["Cap 2"] = {
			-- 	price = 15,
			-- 	Appearance = {

			-- 		Pacs = {
			-- 			["clothingstore_hat7"] = true,
			-- 		},

			-- 	},
			-- },

			["Beer Hat"] = {
				price = 10,
				Appearance = {

					Pac = "clothingstore_beer_hat"

				},
			},

		},
	},

	[3] = {
		CategoryName = "Glasses",
		ViewVector = {
			VFor = -25,
			VRight = 5,
			VUp = -20
		},
		ShopItems = {

			["Glasses 1"] = {
				price = 15,
				Appearance = {

					Pac = "clothingstore_glasses01"

				},
			},

			["Glasses 2"] = {
				price = 15,
				Appearance = {

					Pac = "clothingstore_glasses02"

				},
			},


		},
	},

	[4] = {
		CategoryName = "Head",
		ViewVector = {
			VFor = -25,
			VRight = 5,
			VUp = -20
		},
		ShopItems = {

			["Bandana"] = {
				price = 15,
				Appearance = {

					Pac = "clothingstore_bandana"

				},
			},

			["Headphones"] = {
				price = 15,
				Appearance = {

					Pac = "clothingstore_headphones"

				},
			},


		},
	},

	[5] = {
		CategoryName = "Shirts",
		ViewVector = {
			VFor = -25,
			VRight = 5,
			VUp = -10
		},
		ShopItems = {

			["Coat"] = {
				price = 60,
				Gender = "female",
				Appearance = {

					Pac = "clothingstore_female_coat",

					BodyGroups = {
						["body"] = 1,
					}

				},
			},

			["Leather Jacket"] = {
				price = 50,
				Gender = "female",
				Appearance = {

					Pac = "clothingstore_female_jacket",

					BodyGroups = {
						["body"] = 1,
					}

				},
			},

		}
			--[[ ["T-Shirt G Brand"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Body"] = 0,
					},
					Skin = 0,
				}
			},
			["T-Shirt with shirt"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Body"] = 1,
					},
					Skin = 0,
				}
			},
			["Long-Sleeve Top"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Body"] = 2,
					},
					Skin = 0,
				}
			},
			["Red Jacket"] = {
				price = 25,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 3,
					}
				}
			},
			["Red Jacket with Shirt"] = {
				price = 25,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 4,
					}
				}
			},
			["Long-Sleeve Shirt"] = {
				price = 20,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 5,
					}
				}
			},
			["Sweat College Jacket"] = {
				price = 50,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						
						["Body"] = 6,
					}
				}
			},
			["Purple Hoodie"] = {
				price = 50,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 7,
					}
				}
			},
			["Red Hoodie"] = {
				price = 55,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 8,
					}
				}
			},
			["Camo Jacket"] = {
				price = 60,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 9,
					}
				}
			},
			["Russian Jacket"] = {
				price = 45,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 10,
					}
				}
			},
			["White Hoodie"] = {
				price = 50,
				Appearance = {
					Skin = 0,
					BodyGroups = {
						["Body"] = 11,
					}
				}
			},

			////

			["Black T-Shirt"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Body"] = 0,
					},
					Skin = 1,
				}
			},
			["Hawaiian shirt"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Body"] = 1,
					},
					Skin = 1,
				}
			},
			["Long-Sleeve Top 2"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Body"] = 2,
					},
					Skin = 1,
				}
			},
			["Black Jacket"] = {
				price = 25,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 3,
					}
				}
			},
			["Black Jacket with Shirt"] = {
				price = 25,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 4,
					}
				}
			},
			["Branded Cola T-shirt"] = {
				price = 20,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 5,
					}
				}
			},
			["Green College Jacket"] = {
				price = 50,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 6,
					}
				}
			},
			["Gray Hoodie"] = {
				price = 50,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 7,
					}
				}
			},
			["Beige Hoodie"] = {
				price = 55,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 8,
					}
				}
			},
			["Gradient Jacket"] = {
				price = 60,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 9,
					}
				}
			},
			["Russian Jacket 2"] = {
				price = 45,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 10,
					}
				}
			},
			["Red Hoodie with white shirt"] = {
				price = 50,
				Appearance = {
					Skin = 1,
					BodyGroups = {
						["Body"] = 11,
					}
				}
			},

			////


			["Yellow T-Shirt"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Body"] = 0,
					},
					Skin = 2,
				}
			},
			["Hawaiian shirt 2"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Body"] = 1,
					},
					Skin = 2,
				}
			},
			["Long-Sleeve Top 3"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Body"] = 2,
					},
					Skin = 2,
				}
			},
			["Brown Jacket"] = {
				price = 25,
				Appearance = {
					Skin = 2,
					BodyGroups = {
						["Body"] = 3,
					}
				}
			},
			["Brown Jacket with Shirt"] = {
				price = 25,
				Appearance = {
					Skin = 2,
					BodyGroups = {
						["Body"] = 4,
					}
				}
			},
			["Holiday Sweater"] = {
				price = 20,
				Appearance = {
					Skin = 2,
					BodyGroups = {
						["Body"] = 5,
					}
				}
			},
			["Green Sweater"] = {
				price = 20,
				Appearance = {
					Skin = 3,
					BodyGroups = {
						["Body"] = 5,
					}
				}
			},
			["Green College Jacket 2"] = {
				price = 50,
				Appearance = {
					Skin = 2,
					BodyGroups = {
						["Body"] = 6,
					}
				}
			},
			["Patterned sweatshirt"] = {
				price = 50,
				Appearance = {
					Skin = 3,
					BodyGroups = {
						["Body"] = 7,
					}
				}
			},
			["Beige Hoodie 2"] = {
				price = 55,
				Appearance = {
					Skin = 2,
					BodyGroups = {
						["Body"] = 8,
					}
				}
			},
			["Gradient Jacket 2"] = {
				price = 60,
				Appearance = {
					Skin = 2,
					BodyGroups = {
						["Body"] = 9,
					}
				}
			},
			["Patterned Jacket"] = {
				price = 70,
				Appearance = {
					Skin = 3,
					BodyGroups = {
						["Body"] = 9,
					}
				}
			},
			["Russian Jacket 3"] = {
				price = 45,
				Appearance = {
					Skin = 2,
					BodyGroups = {
						["Body"] = 10,
					}
				}
			},
		}--]] 

	},

	[6] = {
		CategoryName = "Pants",
		ViewVector = {
			VFor = -25,
			VRight = 5,
			VUp = 15
		},
		ShopItems = {

			-- ["Jeans"] = {
			-- 	price = 10,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Lowr"] = 0,
			-- 		}
			-- 	}
			-- },
			-- ["Corduroy Pants"] = {
			-- 	price = 15,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Lowr"] = 1,
			-- 		}
			-- 	}
			-- },
			-- ["Dark Jeans"] = {
			-- 	price = 15,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Lowr"] = 2,
			-- 		}
			-- 	}
			-- },
			-- ["White Sweatpants"] = {
			-- 	price = 15,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Lowr"] = 3,
			-- 		}
			-- 	}
			-- },

		}

	},


	[7] = {
		CategoryName = "Shoes",
		ViewVector = {
			VFor = -35,
			VRight = 5,
			VUp = 35
		},
		ShopItems = {

			-- ["Default"] = {
			-- 	price = 10,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Foot"] = 0,
			-- 		}
			-- 	}
			-- },
			-- ["Black"] = {
			-- 	price = 10,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Foot"] = 1,
			-- 		}
			-- 	}
			-- },
			-- ["Sport Shoes"] = {
			-- 	price = 20,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Foot"] = 2,
			-- 		}
			-- 	}
			-- },
			-- ["Red"] = {
			-- 	price = 10,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Foot"] = 3,
			-- 		}
			-- 	}
			-- },
			-- ["Gray"] = {
			-- 	price = 10,
			-- 	Appearance = {
			-- 		BodyGroups = {
			-- 			["Foot"] = 4,
			-- 		}
			-- 	}
			-- },

		}
	},

	[8] = {
		CategoryName = "Extras",
		ViewVector = {
			VFor = -25,
			VRight = 5,
			VUp = -10
		},
		ShopItems = {

			["Backpack"] = {
				price = 15,
				Appearance = {

					Pac = "clothingstore_backpack_1_1"
				},
			},

			["Backpack 2"] = {
				price = 15,
				Appearance = {

					Pac = "clothingstore_backpack_1_2"

				},
			},

			["Gym Bag"] = {
				price = 20,
				Appearance = {

					Pac = "clothingstore_robberbag"

				},
			},

		},
		
	},

}

PLUGIN.Jewelry = {
	[1] = {
		CategoryName = "Neck",
		ViewVector = {
			VFor = -40,
			VRight = 5,
			VUp = -20
		},
		ShopItems = {

			["Neck Chain"] = {
				price = 25000,
				Appearance = {

					Pac = "clothingstore_neck_chain"
				},
			},

			["Double Neck Chain"] = {
				price = 30000,
				Appearance = {

					Pac = "clothingstore_neck_chain_double"
				},
			},

		}
	},
	[2] = {
		CategoryName = "Left Hand",
		ViewVector = {
			VFor = -40,
			VRight = 18,
			VUp = 5
		},
		ShopItems = {

			["Rolex [Left Hand]"] = {
				price = 16000,
				Appearance = {

					Pac = "clothingstore_rolexwatch_l"
				},
			},

			["Bracelet [Left Hand]"] = {
				price = 8000,
				Appearance = {

					Pac = "clothingstore_bracelet_l"
				},
			},
		}
	},
	[3] = {
		CategoryName = "Right Hand",
		ViewVector = {
			VFor = -40,
			VRight = -3,
			VUp = 5
		},
		ShopItems = {

			["Rolex [Right Hand]"] = {
				price = 16000,
				Appearance = {

					Pac = "clothingstore_rolexwatch_r"
				},
			},

			["Bracelet [Right Hand]"] = {
				price = 8000,
				Appearance = {

					Pac = "clothingstore_bracelet_r"
				},
			},

			["Ring"] = {
				price = 4500,
				Appearance = {

					Pac = "clothingstore_ring_r"
				},
			},
		}
	}
}

local tshirts = {
	[1] = {
		TName = "Red-Blue T-shirt",
		TPac = "clothingstore_baseballtee_1",
		TPrice = 15,
	},
	[2] = {
		TName = "White-Blue T-shirt",
		TPac = "clothingstore_baseballtee_2",
		TPrice = 15,
	},
	[3] = {
		TName = "Black T-shirt",
		TPac = "clothingstore_baseballtee_3",
		TPrice = 15,
	},
	[4] = {
		TName = "White-Grey T-shirt",
		TPac = "clothingstore_baseballtee_4",
		TPrice = 15,
	},
}

for ShirtIndex, ShirtData in ipairs(tshirts) do
	
	PLUGIN.Clothes[5].ShopItems[ShirtData.TName] = {
		price = ShirtData.TPrice,
		Gender = "male",
		Appearance = {

			Pac = ShirtData.TPac
			
		}
	}

end

for flaneelVariant = 1, 13 do
	
	PLUGIN.Clothes[5].ShopItems["Flannel Shirt ["..flaneelVariant.."]"] = {
		price = 20,
		Gender = "male",
		Appearance = {

			Pac = "clothingstore_flannel_"..flaneelVariant,

		}
	}

end

for hoodieVariant = 1, 8 do
	
	PLUGIN.Clothes[5].ShopItems["Hoodie ["..hoodieVariant.."]"] = {
		price = 30,
		Gender = "male",
		Appearance = {

			Pac = "clothingstore_hoodie_"..hoodieVariant,

			BodyGroups = {
				["body"] = 1,
				["hands"] = 0,
			}

		}
	}

end

for hoodieVariant = 1, 6 do
	
	PLUGIN.Clothes[5].ShopItems["Hoodie ["..hoodieVariant.."]"] = {
		price = 30,
		Gender = "female",
		Appearance = {

			Pac = "clothingstore_female_hoodie_"..hoodieVariant,

			BodyGroups = {
				["body"] = 1,
			}

		}
	}

end

for hoodieVariant = 1, 6 do
	
	PLUGIN.Clothes[5].ShopItems["Hoodie ["..(hoodieVariant+6).."]"] = {
		price = 30,
		Gender = "female",
		Appearance = {

			Pac = "clothingstore_female_hoodie2_"..hoodieVariant,

			BodyGroups = {
				["body"] = 1,
			}

		}
	}

end

for parkaVariant = 1, 9 do
	
	PLUGIN.Clothes[5].ShopItems["Parka Jeans ["..(parkaVariant).."]"] = {
		price = 40,
		Gender = "female",
		Appearance = {

			Pac = "clothingstore_female_parka_"..parkaVariant,

			BodyGroups = {
				["body"] = 1,
			}

		}
	}

end

for hoodieVariant = 9, 16 do
	
	PLUGIN.Clothes[5].ShopItems["Jacket ["..hoodieVariant.."]"] = {
		price = 50,
		Gender = "male",
		Appearance = {

			Pac = "clothingstore_hoodie_"..hoodieVariant,

			BodyGroups = {
				["body"] = 1,
				["hands"] = 0,
			}

		}
	}

end

for ljacketVariant = 0, 8 do
	
	PLUGIN.Clothes[5].ShopItems["Leather Jacket ["..(ljacketVariant+1).."]"] = {
		price = 55,
		Gender = "male",
		Appearance = {

			Pac = "clothingstore_leatherjacket_"..ljacketVariant,

			BodyGroups = {
				["body"] = 1,
				["hands"] = 0,
			}

		}
	}

end

local baseball_pants = {
	[1] = {
		TName = "Light Jeans",
		TPac = "clothingstore_baseballtee_pants_1",
		TPrice = 15,
	},
	[2] = {
		TName = "Dark Jeans",
		TPac = "clothingstore_baseballtee_pants_2",
		TPrice = 15,
	},
	[3] = {
		TName = "Light Jeans 2",
		TPac = "clothingstore_baseballtee_pants_3",
		TPrice = 15,
	},
	[4] = {
		TName = "Beige Jeans",
		TPac = "clothingstore_baseballtee_pants_4",
		TPrice = 25,
	},
	[5] = {
		TName = "Blue Jeans 2",
		TPac = "clothingstore_baseballtee_pants_5",
		TPrice = 15,
	},
	[6] = {
		TName = "Blue Jeans",
		TPac = "clothingstore_baseballtee_pants_7",
		TPrice = 15,
	},
	[7] = {
		TName = "Skinny Dark Jeans",
		TPac = "clothingstore_baseballtee_pants_8",
		TPrice = 15,
	},
	[8] = {
		TName = "Skinny Dark Jeans 2",
		TPac = "clothingstore_baseballtee_pants_9",
		TPrice = 15,
	},
	[9] = {
		TName = "Skinny Light Jeans",
		TPac = "clothingstore_baseballtee_pants_10",
		TPrice = 15,
	},
	[10] = {
		TName = "Skinny Jeans",
		TPac = "clothingstore_baseballtee_pants_11",
		TPrice = 15,
	},
}

for PantsIndex, PantsData in ipairs(baseball_pants) do
	
	PLUGIN.Clothes[6].ShopItems[PantsData.TName] = {
		price = PantsData.TPrice,
		Gender = "male",
		Appearance = {

			Pac = PantsData.TPac

		}
	}

end

local female_pants1 = {
	[1] = {
		TName = "Skinny Jeans",
		TPac = "clothingstore_female_pants_4",
		TPrice = 15,
	},
	[2] = {
		TName = "Skinny Jeans 2",
		TPac = "clothingstore_female_pants_5",
		TPrice = 15,
	},
	[3] = {
		TName = "Skinny Jeans 3",
		TPac = "clothingstore_female_pants_6",
		TPrice = 15,
	},
	[4] = {
		TName = "Gray Jeans",
		TPac = "clothingstore_female_pants_7",
		TPrice = 15,
	},
	[5] = {
		TName = "Dark Jeans",
		TPac = "clothingstore_female_pants_8",
		TPrice = 25,
	},
	[6] = {
		TName = "Light Jeans",
		TPac = "clothingstore_female_pants_9",
		TPrice = 15,
	},
	[7] = {
		TName = "Dark Jeans 2",
		TPac = "clothingstore_female_pants_10",
		TPrice = 15,
	},
}


for PantsIndex, PantsData in ipairs(female_pants1) do
	
	PLUGIN.Clothes[6].ShopItems[PantsData.TName] = {
		price = PantsData.TPrice,
		Gender = "female",
		Appearance = {

			Pac = PantsData.TPac,

			BodyGroups = {
				["leg"] = 1,
			}
		}
	}

end

local pack1_pants = {
	[1] = {
		TName = "White Sweatpants",
		TPac = "clothingstore_lowers_pack2_1",
		TPrice = 15,
	},
	[2] = {
		TName = "Grey Sweatpants",
		TPac = "clothingstore_lowers_pack2_2",
		TPrice = 15,
	},
	[3] = {
		TName = "Black Sweatpants",
		TPac = "clothingstore_lowers_pack2_3",
		TPrice = 18,
	},
	[4] = {
		TName = "Purple Sweatpants",
		TPac = "clothingstore_lowers_pack2_4",
		TPrice = 14,
	},
}

for PantsIndex, PantsData in pairs(pack1_pants) do
	
	PLUGIN.Clothes[6].ShopItems[PantsData.TName] = {
		price = PantsData.TPrice,
		Gender = "male",
		Appearance = {

			Pac = PantsData.TPac,

			BodyGroups = {
				["leg"] = 1,
				-- ["low"] = 1,
			}

		}
	}

end

for yogapants = 1, 5 do
	
	PLUGIN.Clothes[6].ShopItems["Yoga Pants ["..yogapants.."]"] = {
		price = 15,
		Gender = "female",
		Appearance = {

			Pac = "clothingstore_female_yogapants_"..yogapants,

			BodyGroups = {
				["low"] = 1,
			}

		}
	}

end

for yogapants = 1, 5 do
	
	PLUGIN.Clothes[6].ShopItems["Sweatpants ["..yogapants.."]"] = {
		price = 15,
		Gender = "female",
		Appearance = {

			Pac = "clothingstore_female_sweatpants_"..yogapants,

			BodyGroups = {
				["low"] = 1,
			}

		}
	}

end

local baseball_shoes = {
	[1] = {
		TName = "Black Sports Shoes",
		TPac = "clothingstore_baseballtee_shoes_1",
		TPrice = 15,
	},
	[2] = {
		TName = "White Sports Shoes",
		TPac = "clothingstore_baseballtee_shoes_2",
		TPrice = 15,
	},
	[3] = {
		TName = "Dark Sports Shoes",
		TPac = "clothingstore_baseballtee_shoes_3",
		TPrice = 15,
	},
	[4] = {
		TName = "Bronze Sports Shoes",
		TPac = "clothingstore_baseballtee_shoes_4",
		TPrice = 25,
	},
	[5] = {
		TName = "Blue Sports Shoes",
		TPac = "clothingstore_baseballtee_shoes_5",
		TPrice = 15,
	},
	[6] = {
		TName = "Red Sports Shoes",
		TPac = "clothingstore_baseballtee_shoes_6",
		TPrice = 15,
	},
	[7] = {
		TName = "Race Sports Shoes",
		TPac = "clothingstore_baseballtee_shoes_7",
		TPrice = 15,
	},
	[8] = {
		TName = "Timberland",
		TPac = "clothingstore_baseballtee_shoes_8",
		TPrice = 15,
	},
	[9] = {
		TName = "Timberland 2",
		TPac = "clothingstore_baseballtee_shoes_9",
		TPrice = 15,
	},
	[10] = {
		TName = "Timberland 3",
		TPac = "clothingstore_baseballtee_shoes_10",
		TPrice = 15,
	},
	[11] = {
		TName = "Timberland 4",
		TPac = "clothingstore_baseballtee_shoes_11",
		TPrice = 15,
	},
}

for ShoesIndex, ShoesData in ipairs(baseball_shoes) do
	
	PLUGIN.Clothes[7].ShopItems[ShoesData.TName] = {
		price = ShoesData.TPrice,
		Gender = "male",
		Appearance = {

			Pac = ShoesData.TPac,

			BodyGroups = {
				["foot"] = 1,
			}

		}
	}

end

local female_shoes2 = {
	[1] = {
		TName = "Black Low Top Chucks",
		TPac = "clothingstore_female_shoes2_1",
		TPrice = 15,
	},
	[2] = {
		TName = "White Low Top Chucks",
		TPac = "clothingstore_female_shoes2_2",
		TPrice = 15,
	},
	[3] = {
		TName = "Red Low Top Chucks",
		TPac = "clothingstore_female_shoes2_3",
		TPrice = 15,
	},
	[4] = {
		TName = "Purple Low Top Chucks",
		TPac = "clothingstore_female_shoes2_4",
		TPrice = 20,
	},
	[5] = {
		TName = "Blue Low Top Chucks",
		TPac = "clothingstore_female_shoes2_5",
		TPrice = 15,
	},
	[6] = {
		TName = "Black Sports Shoes",
		TPac = "clothingstore_female_shoes_1",
		TPrice = 15,
	},
	[7] = {
		TName = "White Sports Shoes",
		TPac = "clothingstore_female_shoes_2",
		TPrice = 25,
	},
	[8] = {
		TName = "Beige Sports Shoes",
		TPac = "clothingstore_female_shoes_3",
		TPrice = 20,
	},
	[9] = {
		TName = "Blue Sports Shoes",
		TPac = "clothingstore_female_shoes_4",
		TPrice = 15,
	},
}

for ShoesIndex, ShoesData in ipairs(female_shoes2) do
	
	PLUGIN.Clothes[7].ShopItems[ShoesData.TName] = {
		price = ShoesData.TPrice,
		Gender = "female",
		Appearance = {

			Pac = ShoesData.TPac,

			BodyGroups = {
				["foot"] = 1,
			}

		}
	}

end

local pack2_shoes = {
	[1] = {
		TName = "Sports Flip-Flops 1",
		TPac = "clothingstore_shoes_pack2_1",
		TPrice = 15,
	},
	[2] = {
		TName = "Sports Flip-Flops 2",
		TPac = "clothingstore_shoes_pack2_2",
		TPrice = 15,
	},

}

for ShoesIndex, ShoesData in ipairs(pack2_shoes) do
	
	PLUGIN.Clothes[7].ShopItems[ShoesData.TName] = {
		price = ShoesData.TPrice,
		Appearance = {

			Pac = ShoesData.TPac,

			BodyGroups = {
				["foot"] = 1,
			}

		}
	}

end


for capName, capPac in pairs(cap6) do

	PLUGIN.Clothes[2].ShopItems[capName] = {
		price = 15,
		Appearance = {

			Pac = capPac

		}
	}

end

for capName, capPac in pairs(cap7) do

	PLUGIN.Clothes[2].ShopItems[capName] = {
		price = 15,
		Appearance = {

			Pac = capPac

		}
	}

end

for capName, capPac in pairs(cap1) do

	PLUGIN.Clothes[2].ShopItems[capName] = {
		price = 15,
		Appearance = {

			Pac = capPac

		}
	}

end

for scarfName, scarfPac in pairs(scarfs) do

	PLUGIN.Clothes[8].ShopItems[scarfName] = {
		price = 15,
		Appearance = {

			Pac = scarfPac

		}
	}

end

local suitsColors = {

	[1] = "Black",
	[2] = "Bronze",
	[3] = "Purple",
	[4] = "White",
	[5] = "Light Grey",
	[6] = "Green",
	[7] = "Blue",
	[8] = "Grey",
	[9] = "Beige",
	[10] = "Light Blue",
	[11] = "White"

}

-- local suitsModel = {
-- 	["Coat"] = {
-- 		SModel = "models/player/suits/male_07_closed_coat_tie.mdl",
-- 		SPrice = 60,
-- 	},
-- 	["Closed Tie"] = {
-- 		SModel = "models/player/suits/male_07_closed_tie.mdl",
-- 		SPrice = 50,
-- 	},
-- 	["Open Suit"] = {
-- 		SModel = "models/player/suits/male_07_open.mdl",
-- 		SPrice = 50,
-- 	},
-- 	["Open Tie"] = {
-- 		SModel = "models/player/suits/male_07_open_tie.mdl",
-- 		SPrice = 45,
-- 	},
-- 	["Waistcoat"] = {
-- 		SModel = "models/player/suits/male_07_open_waistcoat.mdl",
-- 		SPrice = 55,
-- 	}
-- }

local suitsModel = {
	["Closed"] = {
		pacName = "closed",
		SPrice = 50,
	},
	["Long Coat"] = {
		pacName = "longcoat",
		SPrice = 60,
	},
	["Open"] = {
		pacName = "open",
		SPrice = 45,
	},
	["Waist Coat"] = {
		pacName = "waistcoat",
		SPrice = 60,
	},
}


for k, v in SortedPairs(suitsModel) do

	for suitVariant = 1, 11 do

		PLUGIN.Clothes[1].ShopItems[ suitsColors[suitVariant] .. " " .. k .. " suit" ] = {
			CompleteOutfit = true,
			Gender = "male",
			price = v.SPrice,
			Appearance = {

				Pac = "clothingstore_suit_"..v.pacName.."_"..suitVariant,

				BodyGroups = {
					["foot"] = 1,
					["body"] = 1,
					["leg"] = 1,
				}

			}
		}
		
	end

end

ix.char.RegisterVar("cachedoutfits", {
	field = "cachedoutfits",
	fieldType = ix.type.text,
	default = {},
	isLocal = true
})

function PLUGIN:AddClothingPac(name, pacTable)

	if (!pac) then
		return
	end

	-- ix.pac.list["clothingstore_"..name] = pacTable
	self.PacDatabase["clothingstore_"..name] = pacTable
	-- print("[Clothing Store] "..name.." has been added to pac data system")

end

function PLUGIN:InitializeClothStoreItems()

	for index,ClothData in pairs(self.Clothes) do
        
		for ClothName, ItemDetails in pairs(ClothData.ShopItems) do

			local uniqueid = string.lower(string.gsub(ClothName, " ", "_"))

	        local ITEM = ix.item.Register("clothingstore_"..uniqueid, "base_store_clothing", false, nil, true)
	        ITEM.name = ClothName
	        ITEM.description = ""
	        ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
	        ITEM.width = 1
	        ITEM.height = 1
	        ITEM.category = "Clothing"
	        ITEM.outfitCategory = ClothData.CategoryName
	        ITEM.price = ItemDetails.price

	        for ApperaType, ApperaData in pairs(ItemDetails.Appearance) do
	        	
	        	if (ApperaType == "Skin") then
	        		ITEM.newSkin = ApperaData
	        	end

	        	if (ApperaType == "BodyGroups") then

	        		ITEM.bodyGroups = {}

	        		for bodyName, bodyValue in pairs(ApperaData) do
	        			ITEM.bodyGroups[bodyName] = bodyValue
	        		end

	        	end

	        	if (ApperaType == "Pac") then
	        		ITEM.pacData = self.PacDatabase[ApperaData]
	        		-- ix.pac.list["clothingstore_"..uniqueid] = self.PacDatabase[ApperaData]
	        		ix.pac.RegisterPart("clothingstore_"..uniqueid,self.PacDatabase[ApperaData])
	        	end

	        end

	    end

    end

    print("[Clothing Store] All cloth items has been created")

    for index,ClothData in pairs(self.Jewelry) do
        
		for ClothName, ItemDetails in pairs(ClothData.ShopItems) do

			local uniqueid = string.lower(string.gsub(ClothName, " ", "_"))

	        local ITEM = ix.item.Register("clothingstore_"..uniqueid, "base_store_clothing", false, nil, true)
	        ITEM.name = ClothName
	        ITEM.description = ""
	        ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
	        ITEM.width = 1
	        ITEM.height = 1
	        ITEM.category = "Clothing"
	        ITEM.outfitCategory = ClothData.CategoryName
	        ITEM.price = ItemDetails.price

	        for ApperaType, ApperaData in pairs(ItemDetails.Appearance) do
	        	
	        	if (ApperaType == "Skin") then
	        		ITEM.newSkin = ApperaData
	        	end

	        	if (ApperaType == "BodyGroups") then

	        		ITEM.bodyGroups = {}

	        		for bodyName, bodyValue in pairs(ApperaData) do
	        			ITEM.bodyGroups[bodyName] = bodyValue
	        		end

	        	end

	        	if (ApperaType == "Pac") then
	        		ITEM.pacData = self.PacDatabase[ApperaData]
	        		-- ix.pac.list["clothingstore_"..uniqueid] = self.PacDatabase[ApperaData]
	        		ix.pac.RegisterPart("clothingstore_"..uniqueid,self.PacDatabase[ApperaData])
	        	end

	        end

	    end

    end

    print("[Clothing Store] All jewelry items has been created")

end

function PLUGIN:InitializedPlugins()

	timer.Simple(1, function()
		self:InitializeClothStoreItems()
	end)

end

function PLUGIN:OnReloaded()
	-- self:InitializeClothStoreItems()
end

local files = file.Find(PLUGIN.folder.."/customoutfits/sh_*.lua", "LUA")

for _, v in ipairs(files) do
	ix.util.Include("customoutfits/"..v, "shared")
end

if (SERVER) then

	util.AddNetworkString("ixClothingShop_BuyCloth")
	util.AddNetworkString("ixClothingShop_BuyJewelry")
	util.AddNetworkString("ixClothingShop_OpenUI")
	util.AddNetworkString("ixJewelryShop_OpenUI")

	util.AddNetworkString("ixClothingShop_SyncPacs")

	-- function PLUGIN:PlayerInitialSpawn(client, trans)

	-- 	net.Start("ixClothingShop_SyncPacs")

	-- 	local json = util.TableToJSON(ix.pac.list)
	-- 	local compressedTable = util.Compress( json )
	-- 	local bytes = #compressedTable

	-- 	net.WriteUInt( bytes, 16 )
	-- 	net.WriteData( compressedTable, bytes )

	-- 	net.Send(client)

	-- end

	function PLUGIN:PlayerInteractItem(client, action, item)

		if (item.pacData) then

			local cachedTbl = client:GetCharacter():GetCachedoutfits()

			if (action == "Equip") then

				cachedTbl[item.uniqueID] = true
				

			elseif (action == "EquipUn" or action == "drop") then

				if (cachedTbl[item.uniqueID]) then
					cachedTbl[item.uniqueID] = nil
				end

			end

			client:GetCharacter():SetCachedoutfits(cachedTbl)

		end

	end

	function PLUGIN:PlayerLoadedCharacter(client, curChar, prevChar)

		local inv = curChar:GetInventory()

		local cachedTbl = client:GetCharacter():GetCachedoutfits()

		for k, v in pairs(inv:GetItems()) do
			
			if (v.pacData) then
				if (v:GetData("equip")) then
					
					if (!cachedTbl[v.uniqueID]) then
						cachedTbl[v.uniqueID] = true
					end

				end
			end
		end

		client:GetCharacter():SetCachedoutfits(cachedTbl)

	end

	net.Receive( "ixClothingShop_BuyCloth", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local cloth = net.ReadString()

		local TableID = net.ReadUInt(8)

		if (!PLUGIN.Clothes[TableID]) then
			client:Notify("Cloth Table doesn't exists")
			return
		end

		local ClothTable = PLUGIN.Clothes[TableID]
		local ClothingTable = ClothTable.ShopItems[cloth]

		if (char:GetMoney() < ClothingTable.price) then
			client:Notify("You can't afford to buy this clothing")
			return
		end

		local uniqueid = string.lower(string.gsub(cloth, " ", "_"))

		local itemID = "clothingstore_"..uniqueid

		local inv = char:GetInventory()

		if (inv:Add(itemID)) then
            
			char:SetMoney(char:GetMoney() - ClothingTable.price)

			client:Notify("You purchased "..cloth.." for $"..ClothingTable.price)

			local item = inv:HasItem(itemID)

			local items = inv:GetItems()

			for _, v in pairs(items) do
				if (v.id != item.id) then
					local itemTable = ix.item.instances[v.id]

					if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
						v:RemoveOutfit(client)
					end
				end
			end

			item:AddOutfit(client)

		else
			client:Notify("You don't have enough space in your inventory")
        end

	end)

	net.Receive( "ixClothingShop_BuyJewelry", function( len, client )

		if (!client:Alive()) then return end

		local char = client:GetCharacter()

		if (!char) then return end

		local cloth = net.ReadString()

		local TableID = net.ReadUInt(8)

		if (!PLUGIN.Jewelry[TableID]) then
			client:Notify("Jewelry Table doesn't exists")
			return
		end

		local ClothTable = PLUGIN.Jewelry[TableID]
		local ClothingTable = ClothTable.ShopItems[cloth]

		if (char:GetMoney() < ClothingTable.price) then
			client:Notify("You can't afford to buy this Jewelry")
			return
		end

		local uniqueid = string.lower(string.gsub(cloth, " ", "_"))
		
		local itemID = "clothingstore_"..uniqueid

		local inv = char:GetInventory()

		if (inv:Add(itemID)) then
            
			char:SetMoney(char:GetMoney() - ClothingTable.price)

			client:Notify("You purchased "..cloth.." for $"..ClothingTable.price)

			local item = inv:HasItem(itemID)

			local items = inv:GetItems()

			for _, v in pairs(items) do
				if (v.id != item.id) then
					local itemTable = ix.item.instances[v.id]

					if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
						v:RemoveOutfit(client)
					end
				end
			end

			item:AddOutfit(client)

		else
			client:Notify("You don't have enough space in your inventory")
        end

    end)

	function PLUGIN:LoadData()
		self:LoadJRClothingStoreNPC()
		self:LoadJRJewelryStoreNPC()
	end

	function PLUGIN:SaveData()
		self:SaveJRClothingStoreNPC()
		self:SaveJRJewelryStoreNPC()
	end

	function PLUGIN:SaveJRJewelryStoreNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_jewelry_shop_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_jewelrystore_npcs", data)
	end

	function PLUGIN:SaveJRClothingStoreNPC()
		local data = {}

		for _, v in ipairs(ents.FindByClass("j_clothing_shop_npc")) do
			data[#data + 1] = {v:GetPos(), v:GetAngles()}
		end

		ix.data.Set("jr_clothstore_npcs", data)

	end

	function PLUGIN:LoadJRClothingStoreNPC()
		for _, v in ipairs(ix.data.Get("jr_clothstore_npcs") or {}) do
			local npc = ents.Create("j_clothing_shop_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:LoadJRJewelryStoreNPC()
		for _, v in ipairs(ix.data.Get("jr_jewelrystore_npcs") or {}) do
			local npc = ents.Create("j_jewelry_shop_npc")

			npc:SetPos(v[1])
			npc:SetAngles(v[2])
			npc:Spawn()
			
		end
	end

	function PLUGIN:PlayerModelChanged(client, model)

		-- local char = client:GetCharacter()

		-- local pacCloth = char:GetData("clothingstore_pacs", {})

		-- for outfitCategory, outfitData in pairs(pacCloth or {}) do

		-- 	for pacName, _ in pairs(outfitData or {}) do

		-- 		client:RemovePart(pacName)

		-- 	end

		-- end

		-- char:SetData("clothingstore_pacs", {})


		-- local groups = char:GetData("groups", {})

		-- local bgtoRemove = {
		-- 	["body"] = true,
		-- 	["hands"] = true,
		-- 	["leg"] = true,
		-- 	["low"] = true,
		-- 	["foot"] = true,
		-- }
			
		-- for bgName, bgV in pairs(bgtoRemove) do

		-- 	local index = client:FindBodygroupByName(bgName)

		-- 	if (index < 0) then continue end

		-- 	client:SetBodygroup( index, 0)
		-- 	groups[index] = 0

		-- end

		-- char:SetData("groups", groups)

	end

	-- function PLUGIN:PlayerLoadedCharacter(client, curChar, prevChar)

	-- 	timer.Simple(0.1, function()

	-- 		if (!IsValid(client)) then return end
	-- 		if (!client:Alive()) then return end
	-- 		if (!curChar) then return end

	-- 		local pacCloth = curChar:GetData("clothingstore_pacs", {})

	-- 		for slotName, Pacs in pairs(pacCloth) do

	-- 			for pacName, _ in pairs(Pacs) do

	-- 				client:AddPart(pacName)
					
	-- 			end

	-- 		end

	-- 	end)

	-- end

	-- function PLUGIN:OnPlayerObserve(client, state)

	-- 	if (!state) then

	-- 		timer.Simple(0.1, function()

	-- 			if (!IsValid(client)) then return end
	-- 			if (!client:Alive()) then return end
			
	-- 			local char = client:GetCharacter()

	-- 			if (!char) then return end

	-- 			local pacCloth = char:GetData("clothingstore_pacs", {})

	-- 			for slotName, Pacs in pairs(pacCloth) do

	-- 				for pacName, _ in pairs(Pacs) do

	-- 					client:AddPart(pacName)
						
	-- 				end

	-- 			end

	-- 		end)


	-- 	end

	-- end

end

if (CLIENT) then

	-- net.Receive( "ixClothingShop_SyncPacs", function( len, client )

	-- 	local tableNet = {}

	-- 	local bytes = net.ReadUInt( 16 )
	-- 	local compressedJson = net.ReadData( bytes )
	-- 	local DecompressJson = util.Decompress( compressedJson )

	-- 	tableNet = util.JSONToTable(DecompressJson)

	-- 	for k, v in pairs(tableNet) do
	-- 		print("dodaje ",k)
	-- 		ix.pac.RegisterPart(k,v)
	-- 	end

	-- end)

	net.Receive( "ixClothingShop_OpenUI", function( len, client )

		local bytes_amount = net.ReadUInt( 16 ) 
		local compressed_message = net.ReadData( bytes_amount )
		local pacsData = util.JSONToTable(util.Decompress( compressed_message ))


		local StoreUI = vgui.Create("ixClotShopUI")
		StoreUI.PlyPacsData = pacsData
		StoreUI:FakePlyModel()
		StoreUI:RenderCategories()

	end)

	net.Receive( "ixJewelryShop_OpenUI", function( len, client )

		local bytes_amount = net.ReadUInt( 16 ) 
		local compressed_message = net.ReadData( bytes_amount )
		local pacsData = util.JSONToTable(util.Decompress( compressed_message ))


		local StoreUI = vgui.Create("ixJeweShopUI")
		StoreUI.PlyPacsData = pacsData
		StoreUI:FakePlyModel()
		StoreUI:RenderCategories()

	end)

	function PLUGIN:CalcView(client, origin, angles, fov)
		-- local view = self.BaseClass:CalcView(client, origin, angles, fov) or {}
	
		if (IsValid(ix.gui.ClothShopUI) and ix.gui.ClothShopUI:IsVisible()) then
			local view = {}

			local newOrigin, newAngles, newFOV, bDrawPlayer = ix.gui.ClothShopUI:GetOverviewInfo(origin, angles, fov)

			view.drawviewer = bDrawPlayer
			view.fov = newFOV
			view.origin = newOrigin
			view.angles = newAngles

			return view
		elseif (IsValid(ix.gui.JewelryShopUI) and ix.gui.JewelryShopUI:IsVisible()) then
			local view = {}

			local newOrigin, newAngles, newFOV, bDrawPlayer = ix.gui.JewelryShopUI:GetOverviewInfo(origin, angles, fov)

			view.drawviewer = bDrawPlayer
			view.fov = newFOV
			view.origin = newOrigin
			view.angles = newAngles

			return view

		end

		
	end

	function PLUGIN:LoadFonts(font, genericFont)

		surface.CreateFont("ClothUI_Font1", {
			font = "BIZ UDGothic",
			size = 26,
			antialias = true,
			weight = 600,
		})


	end

end

-- ix.command.Add("CharResetClothes", {
-- 	description = "Removes purchased clothes from the character",
-- 	arguments = ix.type.character,
-- 	adminOnly = true,
-- 	OnRun = function(self, client, target)

-- 		-- local target = client:GetCharacter()

-- 		if(!target) then
-- 			client:NotifyLocalized("charNoExist")
-- 			return false
-- 		end

-- 		local targetPly = target:GetPlayer()
		
-- 		local pacCloth = target:GetData("clothingstore_pacs", {})

-- 		for outfitCategory, outfitData in pairs(pacCloth or {}) do

-- 			for pacName, _ in pairs(outfitData or {}) do

-- 				client:RemovePart(pacName)

-- 			end

-- 		end

-- 		target:SetData("clothingstore_pacs", {})


-- 		local groups = target:GetData("groups", {})

-- 		local bgtoRemove = {
-- 			["body"] = true,
-- 			["hands"] = true,
-- 			["leg"] = true,
-- 			["low"] = true,
-- 			["foot"] = true,
-- 		}
			
-- 		for bgName, bgV in pairs(bgtoRemove) do

-- 			local index = client:FindBodygroupByName(bgName)

-- 			if (index < 0) then continue end

-- 			client:SetBodygroup( index, 0)
-- 			groups[index] = 0

-- 		end

-- 		target:SetData("groups", groups)
		

-- 		client:Notify("You have removed the purchased clothes from "..target:GetName())
-- 		targetPly:Notify("Your purchased clothes have been removed")


-- 	end
-- })