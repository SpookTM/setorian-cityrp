local PLUGIN = PLUGIN
PLUGIN.name = "Clothing Shop System"
PLUGIN.description = "Adds modern clothing store UI"
PLUGIN.author = "JohnyReaper"

PLUGIN.ShopPos = Vector( 355.84, 246.71, -12287.85 )

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
					Pacs = {    -- Here are the PAC items a player will receive after purchasing an item
						["clothingstore_hat1"] = true, // pac outfit unique id
					},
					

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

		ShopItems = {

			["No Suit"] = {
				price = 10,
				Appearance = {
					ModelData = {
						PModel = "models/player/citizen_v2/male_07.mdl",
						ModelReplace = "male_0",
					},
				},
			},
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

			["No Hat"] = {
				price = 0,
				Appearance = {
					Pacs = {
					},
				},
			},

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

					Pacs = {
						["clothingstore_hat2"] = true,
					},

				},
			},

			["Beanie 2"] = {
				price = 10,
				Appearance = {

					Pacs = {
						["clothingstore_hat3"] = true,
					},

				},
			},

			["Flat Cap"] = {
				price = 20,
				Appearance = {

					Pacs = {
						["clothingstore_hat5"] = true,
					},

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

					Pacs = {
						["clothingstore_beer_hat"] = true,
					},

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

			["No Glasses"] = {
				price = 0,
				Appearance = {
					Pacs = {
					},
				},
			},

			["Glasses 1"] = {
				price = 15,
				Appearance = {

					Pacs = {
						["clothingstore_glasses01"] = true,
					},

				},
			},

			["Glasses 2"] = {
				price = 15,
				Appearance = {

					Pacs = {
						["clothingstore_glasses02"] = true,
					},

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

			["No Extras"] = {
				price = 0,
				Appearance = {
					Pacs = {
					},
				},
			},

			["Bandana"] = {
				price = 15,
				Appearance = {

					Pacs = {
						["clothingstore_bandana"] = true,
					},

				},
			},

			["Headphones"] = {
				price = 15,
				Appearance = {

					Pacs = {
						["clothingstore_headphones"] = true,
					},

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
			["T-Shirt G Brand"] = {
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
		}

	},

	[6] = {
		CategoryName = "Pants",
		ViewVector = {
			VFor = -25,
			VRight = 5,
			VUp = 15
		},
		ShopItems = {

			["Jeans"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Lowr"] = 0,
					}
				}
			},
			["Corduroy Pants"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Lowr"] = 1,
					}
				}
			},
			["Dark Jeans"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Lowr"] = 2,
					}
				}
			},
			["White Sweatpants"] = {
				price = 15,
				Appearance = {
					BodyGroups = {
						["Lowr"] = 3,
					}
				}
			},

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

			["Default"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Foot"] = 0,
					}
				}
			},
			["Black"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Foot"] = 1,
					}
				}
			},
			["Sport Shoes"] = {
				price = 20,
				Appearance = {
					BodyGroups = {
						["Foot"] = 2,
					}
				}
			},
			["Red"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Foot"] = 3,
					}
				}
			},
			["Gray"] = {
				price = 10,
				Appearance = {
					BodyGroups = {
						["Foot"] = 4,
					}
				}
			},

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

			["No Extras"] = {
				price = 0,
				Appearance = {
					Pacs = {
					},
				},
			},

			["Backpack"] = {
				price = 15,
				Appearance = {

					Pacs = {
						["clothingstore_backpack_1_1"] = true,
					},

				},
			},

			["Backpack 2"] = {
				price = 15,
				Appearance = {

					Pacs = {
						["clothingstore_backpack_1_2"] = true,
					},

				},
			},

		},
		
	},

}

for capName, capPac in pairs(cap6) do

	PLUGIN.Clothes[2].ShopItems[capName] = {
		price = 15,
		Appearance = {

			Pacs = {
				[capPac] = true
			}

		}
	}

end

for capName, capPac in pairs(cap7) do

	PLUGIN.Clothes[2].ShopItems[capName] = {
		price = 15,
		Appearance = {

			Pacs = {
				[capPac] = true
			}

		}
	}

end

for capName, capPac in pairs(cap1) do

	PLUGIN.Clothes[2].ShopItems[capName] = {
		price = 15,
		Appearance = {

			Pacs = {
				[capPac] = true
			}

		}
	}

end

for scarfName, scarfPac in pairs(scarfs) do

	PLUGIN.Clothes[8].ShopItems[scarfName] = {
		price = 15,
		Appearance = {

			Pacs = {
				[scarfPac] = true
			}

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

local suitsModel = {
	["Coat"] = {
		SModel = "models/player/suits/male_07_closed_coat_tie.mdl",
		SPrice = 60,
	},
	["Closed Tie"] = {
		SModel = "models/player/suits/male_07_closed_tie.mdl",
		SPrice = 50,
	},
	["Open Suit"] = {
		SModel = "models/player/suits/male_07_open.mdl",
		SPrice = 50,
	},
	["Open Tie"] = {
		SModel = "models/player/suits/male_07_open_tie.mdl",
		SPrice = 45,
	},
	["Waistcoat"] = {
		SModel = "models/player/suits/male_07_open_waistcoat.mdl",
		SPrice = 55,
	}
}


for k, v in SortedPairs(suitsModel) do

	for suitVariant = 1, 11 do

		PLUGIN.Clothes[1].ShopItems[suitsColors[suitVariant] .. " " .. k] = {
			price = v.SPrice,
			Appearance = {
				ModelData = {
					PModel = v.SModel,
					ModelReplace = "male_0",
				},
				Skin = suitVariant
			}
		}
		
	end

end

function PLUGIN:AddClothingPac(name, pacTable)

	if (!pac) then
		return
	end

	ix.pac.list["clothingstore_"..name] = pacTable
	print("[Clothing Store] "..name.." has been added to pac data system")

end

local files = file.Find(PLUGIN.folder.."/customoutfits/sh_*.lua", "LUA")

for _, v in ipairs(files) do
	ix.util.Include("customoutfits/"..v, "shared")
end

if (SERVER) then

	util.AddNetworkString("ixClothingShop_BuyCloth")
	util.AddNetworkString("ixClothingShop_OpenUI")

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

		local ClothApperance = ClothingTable.Appearance

		if (ClothApperance.BodyGroups) then

			local groups = char:GetData("groups", {})
			
			for bgName, bgV in pairs(ClothApperance.BodyGroups) do

				local index = client:FindBodygroupByName(bgName)

				if (index < 0) then continue end

				client:SetBodygroup( index, bgV)
				groups[index] = bgV

			end

			char:SetData("groups", groups)

		end

		if (ClothApperance.ModelData) then

			if (ClothApperance.ModelData.ModelReplace) then

				local ModelToReplace = ClothApperance.ModelData.PModel

				if (string.find(client:GetModel(), ClothApperance.ModelData.ModelReplace)) then

					local ModelNumber = string.match( client:GetModel(), ClothApperance.ModelData.ModelReplace.."%d" )

					local StartPos, EndPos = string.find(ClothApperance.ModelData.PModel, ClothApperance.ModelData.ModelReplace)

					ModelToReplace = string.sub( ClothApperance.ModelData.PModel, 1, StartPos - 1 ) .. ModelNumber .. string.sub( ClothApperance.ModelData.PModel, EndPos + 2 )

				end

				char:SetModel(ModelToReplace)

			else
				char:SetModel(ClothApperance.ModelData.PModel)
			end

			client:SetupHands()
			client:SetSkin(0)

		end

		if (ClothApperance.Pacs) then

			local pacCloth = char:GetData("clothingstore_pacs", {})

			for pacName, _ in pairs(pacCloth[PLUGIN.Clothes[TableID].CategoryName] or {}) do

				client:RemovePart(pacName)

			end

			pacCloth[PLUGIN.Clothes[TableID].CategoryName] = {}

			for pacName, _ in pairs(ClothApperance.Pacs) do

				client:AddPart(pacName)
				
			end

			pacCloth[PLUGIN.Clothes[TableID].CategoryName] = ClothApperance.Pacs

			char:SetData("clothingstore_pacs", pacCloth)

		end

		if (ClothApperance.Skin) then
			char:SetData("skin", ClothApperance.Skin)
			client:SetSkin(ClothApperance.Skin)
		end

		char:SetMoney(char:GetMoney() - ClothingTable.price)

		client:Notify("You purchased "..cloth.." for $"..ClothingTable.price)

	end)

	function PLUGIN:LoadData()
		self:LoadJRClothingStoreNPC()
	end

	function PLUGIN:SaveData()
		self:SaveJRClothingStoreNPC()
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

	function PLUGIN:PlayerLoadedCharacter(client, curChar, prevChar)

		timer.Simple(0.1, function()

			if (!IsValid(client)) then return end
			if (!client:Alive()) then return end
			if (!curChar) then return end

			local pacCloth = curChar:GetData("clothingstore_pacs", {})

			for slotName, Pacs in pairs(pacCloth) do

				for pacName, _ in pairs(Pacs) do

					client:AddPart(pacName)
					
				end

			end

		end)

	end

	function PLUGIN:OnPlayerObserve(client, state)

		if (!state) then

			timer.Simple(0.1, function()

				if (!IsValid(client)) then return end
				if (!client:Alive()) then return end
			
				local char = client:GetCharacter()

				if (!char) then return end

				local pacCloth = char:GetData("clothingstore_pacs", {})

				for slotName, Pacs in pairs(pacCloth) do

					for pacName, _ in pairs(Pacs) do

						client:AddPart(pacName)
						
					end

				end

			end)


		end

	end

end

if (CLIENT) then


	net.Receive( "ixClothingShop_OpenUI", function( len, client )

		local bytes_amount = net.ReadUInt( 16 ) 
		local compressed_message = net.ReadData( bytes_amount )
		local pacsData = util.JSONToTable(util.Decompress( compressed_message ))



		local StoreUI = vgui.Create("ixClotShopUI")
		StoreUI.PlyPacsData = pacsData
		StoreUI:FakePlyModel()
		StoreUI:RenderCategories()

	end)

	function PLUGIN:CalcView(client, origin, angles, fov)
		-- local view = self.BaseClass:CalcView(client, origin, angles, fov) or {}

		local shopMenu = ix.gui.ClothShopUI
	
		if (IsValid(shopMenu) and shopMenu:IsVisible()) then
			local view = {}

			local newOrigin, newAngles, newFOV, bDrawPlayer = shopMenu:GetOverviewInfo(origin, angles, fov)

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