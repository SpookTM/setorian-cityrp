
PLUGIN.name = "Food and Drinks"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "."


local foods = {

	// Food Mod

	{
		FName = "Pizza",
		FModel = "models/peppizza02/peppizza02.mdl",
		FDesc = "Large pizza with salami and cheese",
		FHunger = 40,
		FThirst = 10,
		FW = 2,
		FH = 2,
	},
	{
		FName = "Cheese Pizza",
		FModel = "models/peppizza02/peppizza02.mdl",
		FDesc = "Large pizza with four different types of cheese",
		FHunger = 40,
		FW = 2,
		FH = 2,
	},
	{
		FName = "Carne Festa Pizza",
		FModel = "models/cheesepizza02/cheesepizza02.mdl",
		FDesc = "Large pizza with tomato, cheese and red onions",
		FHunger = 40,
		FThirst = 10,
		FW = 2,
		FH = 2,
	},
	{
		FName = "Farmer's Pizza",
		FModel = "models/workspizza01/workspizza01.mdl",
		FDesc = "Pizza with a lots of vegetables",
		FHunger = 40,
		FThirst = 10,
		FW = 2,
		FH = 2,
	},
	{
		FName = "Chicken's Pizza",
		FModel = "models/workspizza02/workspizza02.mdl",
		FDesc = "Pizza with a lots of meats",
		FHunger = 40,
		FThirst = 10,
		FW = 2,
		FH = 2,
	},
	{
		FName = "Roma Pizza",
		FModel = "models/workspizza03/workspizza03.mdl",
		FDesc = "Large pizza with cheese, mushrooms and oregano",
		FHunger = 40,
		FThirst = 10,
		FW = 2,
		FH = 2,
	},
	{
		FName = "Small pizza",
		FModel = "models/peppizza01/peppizza01.mdl",
		FDesc = "Pizza with salami and cheese",
		FHunger = 20,
		FThirst = 5,
	},
	{
		FName = "Alfredo Sauce",
		FModel = "models/alfredo01/alfredo01.mdl",
		FDesc = "Meal made from butter, heavy cream, and parmesan cheese",
		FHunger = 10,
		FThirst = 5,
	},
	{
		FName = "Bacon",
		FModel = "models/bacon01/bacon01.mdl",
		FDesc = "A piece of fried bacon",
		FHunger = 3,
	},
	{
		FName = "Bowl of Spaghetti",
		FModel = "models/bowlofspaghetti01/bowlofspaghetti01.mdl",
		FDesc = "Spaghetti pasta, cheese and tomato sauce",
		FHunger = 20,
		FThirst = 5,
	},
	{
		FName = "Plate with Burger",
		FModel = "models/burgerplate01/burgerplate01.mdl",
		FDesc = "Burger, fries and sauce",
		FHunger = 30,
		FThirst = 5,
		FW = 2,
		FH = 2,
	},
	{
		FName = "Chocolate Shake",
		FModel = "models/chocolateshake01/chocolateshake01.mdl",
		FDesc = "Chocolate shake with whipped cream, crisp tube in a large glass",
		FHunger = 5,
		FThirst = 15,
	},
	{
		FName = "Egg",
		FModel = "models/eggs01/eggs01.mdl",
		FDesc = "A fried egg",
		FHunger = 5,
	},
	{
		FName = "Penne",
		FModel = "models/pennepasta01/pennepasta01.mdl",
		FDesc = "Meal with penne pasta",
		FHunger = 5,
	},
	{
		FName = "Mac & Cheese",
		FModel = "models/macncheese01/macncheese01.mdl",
		FDesc = "A dish of cooked macaroni pasta and a cheese sauce.",
		FHunger = 20,
		FThirst = 5,
	},
	{
		FName = "Spaghetti and Meat Balls",
		FModel = "models/spaghettiandmeatballs01/spaghettiandmeatballs01.mdl",
		FDesc = "Spaghetti with meatballs.",
		FHunger = 20,
		FThirst = 5,
	},
	{
		FName = "Egg Sushi",
		FModel = "models/sushipack/eggsushi01.mdl",
		FDesc = "Tamago Sushi (Japanese Egg Sushi).",
		FHunger = 10,
		FThirst = 5,
	},
	{
		FName = "Egg Sushi",
		FModel = "models/sushipack/fisheggsushi01.mdl",
		FDesc = "Tamago Sushi (Japanese Egg Sushi).",
		FHunger = 15,
		FThirst = 5,
	},
	{
		FName = "Sushi",
		FModel = "models/sushipack/sushi01.mdl",
		FDesc = "A Japanese dish that consists of small cakes of cold rice served with raw fish.",
		FHunger = 15,
		FThirst = 5,
	},
	{
		FName = "Small Sushi",
		FModel = "models/sushipack/sushi03.mdl",
		FDesc = "A Japanese dish that consists of small cakes of cold rice served with raw fish.",
		FHunger = 5,
	},
	{
		FName = "Twinkie",
		FModel = "models/twinkie01/twinkie01.mdl",
		FDesc = "An American snack cake, described as \"golden sponge cake with a creamy filling\".",
		FHunger = 8,
	},

	// Cryt's Food Pack

	{
		FName = "Apple",
		FModel = "models/props/cryts_food/fruit_apple.mdl",
		FDesc = "A fresh red apple.",
		FHunger = 4,
		FThirst = 2,
	},
	{
		FName = "Banana",
		FModel = "models/props/cryts_food/fruit_banana.mdl",
		FDesc = "A ripe banana.",
		FHunger = 4,
		FThirst = 1,
	},
	{
		FName = "Lemon",
		FModel = "models/props/cryts_food/fruit_lemon.mdl",
		FDesc = "A lemon.",
		FHunger = 3,
		FThirst = 3,
	},
	{
		FName = "Lime",
		FModel = "models/props/cryts_food/fruit_lime.mdl",
		FDesc = "A lime.",
		FHunger = 4,
		FThirst = 2,
	},
	{
		FName = "Orange",
		FModel = "models/props/cryts_food/fruit_orange.mdl",
		FDesc = "A fresh orange.",
		FHunger = 3,
		FThirst = 3,
	},
	{
		FName = "Watermelon",
		FModel = "models/props/cryts_food/fruit_watermelon.mdl",
		FDesc = "A big watermelon.",
		FHunger = 15,
		FThirst = 10,
	},
	{
		FName = "Cheburek",
		FModel = "models/props/cryts_food/meal_cheburek.mdl",
		FDesc = "Cheburek are deep-fried turnovers with a filling of ground or minced meat and onions.",
		FHunger = 14,
	},
	{
		FName = "Cheese Wheel",
		FModel = "models/props/cryts_food/meal_cheese01a.mdl",
		FDesc = "Large wheel of yellow cheese.",
		FHunger = 14,
	},
	{
		FName = "Piece of cheese",
		FModel = "models/props/cryts_food/meal_cheese01c.mdl",
		FDesc = "A piece of yellow cheese.",
		FHunger = 4,
	},
	{
		FName = "Doshirak",
		FModel = "models/props/cryts_food/meal_doshirak.mdl",
		FDesc = "It consists of bap (cooked rice) and several banchan (side dishes).",
		FHunger = 7,
		FThirst = 2,
	},
	{
		FName = "Hamburger",
		FModel = "models/props/cryts_food/meal_cheeseburger.mdl",
		FDesc = "Hamburger with cheese, pork meat and sauce",
		FHunger = 25,
		FThirst = 5,
	},
	{
		FName = "Hamburger Extra",
		FModel = "models/props/cryts_food/meal_hamburger.mdl",
		FDesc = "Hamburger with cheese, pork meat and pickles",
		FHunger = 25,
	},
	{
		FName = "Hot-Dog",
		FModel = "models/props/cryts_food/meal_hotdog.mdl",
		FDesc = "A food consisting of a grilled sausage served in the slit of a partially sliced bun",
		FHunger = 25,
	},
	{
		FName = "NFH's Fries",
		FModel = "models/props/cryts_food/meal_nfhfries.mdl",
		FDesc = "A packet of NFH brand fries",
		FHunger = 15,
	},
	{
		FName = "NFH's Nuggets",
		FModel = "models/props/cryts_food/meal_nfhnuggets.mdl",
		FDesc = "A packet of NFH brand nuggets.",
		FHunger = 25,
	},
	{
		FName = "Salami",
		FModel = "models/props/cryts_food/meal_salami.mdl",
		FDesc = "A type of cured sausage that's very common in sandwiches. This slightly spicy, salty meat is almost always served thinly sliced and is rarely heated or cooked",
		FHunger = 10,
	},
	{
		FName = "Samsa",
		FModel = "models/props/cryts_food/meal_samsa.mdl",
		FDesc = "A savoury pastry in Central Asian cuisines. It represents a bun stuffed with meat and sometimes with vegetables.",
		FHunger = 20,
	},
	{
		FName = "Shashlik",
		FModel = "models/props/cryts_food/meal_shashlik.mdl",
		FDesc = "A dish of skewered and grilled cubes of meat, similar to or synonymous with shish kebab",
		FHunger = 13,
	},
	{
		FName = "Shawerma",
		FModel = "models/props/cryts_food/meal_shawerma.mdl",
		FDesc = "A Levantine meat preparation, where thin cuts of lamb, chicken, beef, or mixed meats are stacked in a cone-like shape on a vertical rotisseri",
		FHunger = 21,
	},
	{
		FName = "Candy Cane",
		FModel = "models/props/cryts_food/sweets_candycane.mdl",
		FDesc = "A cylindrical stick of striped sweet rock with a curved end, resembling a walking stick.",
		FHunger = 3,
	},
	{
		FName = "Candy Corn",
		FModel = "models/props/cryts_food/sweets_candycorn.mdl",
		FDesc = "A type of small, pyramid-shaped candy, typically divided into three sections of different colors, with a waxy texture and a flavor based on honey, sugar, butter, and vanilla",
		FHunger = 4,
	},
	{
		FName = "Cookie",
		FModel = "models/props/cryts_food/sweets_chipcookie.mdl",
		FDesc = "A baked or cooked snack or dessert that is typically small, flat and sweet. It contains flour, sugar, egg, and some type of oil, fat, or butter.",
		FHunger = 3,
	},
	{
		FName = "Croissant",
		FModel = "models/props/cryts_food/sweets_croissant.mdl",
		FDesc = "A buttery, crescent-shaped French pastry. Good croissants are light, flaky, and delicately sweet.",
		FHunger = 7,
	},
	{
		FName = "Chocolate",
		FModel = "models/props/cryts_food/sweets_crytschocolate.mdl",
		FDesc = "A sweet hard food made from cocoa beans. It is usually brown in colour and is eaten as a sweet.",
		FHunger = 10,
	},
	{
		FName = "Donut",
		FModel = "models/props/cryts_food/sweets_donut.mdl",
		FDesc = "A bread-like cake made from sweet dough that has been cooked in hot fat.",
		FHunger = 5,

	},

	{
		FName = "Energy Drink",
		FModel = "models/props/cryts_food/drink_energydrink.mdl",
		FDesc = "A beverage that typically contains large amounts of caffeine, added sugars, other additives, and legal stimulants such as guarana, taurine, and L-carnitine",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "NexCola",
		FModel = "models/props/cryts_food/drink_nexcola.mdl",
		FDesc = "A carbonated, sweetened soft drink and is the world's best-selling soda.",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Milk",
		FModel = "models/props/cryts_food/drink_milk.mdl",
		FDesc = "A white liquid food produced by the mammary glands of mammals.",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Mineral Water",
		FModel = "models/props/cryts_food/drink_mineralwater.mdl",
		FDesc = "Water occurring in nature with some dissolved salts present.",
		FThirst = 25,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},

	
	// Food and Household Items

	{
		FName = "Apple Jacks",
		FModel = "models/foodnhouseholditems/applejacks.mdl",
		FDesc = "Crunchy, sweetened multi-grain cereal with apple and cinnamon.",
		FHunger = 15,
	},
	{
		FName = "Cherrios",
		FModel = "models/foodnhouseholditems/cheerios.mdl",
		FDesc = "Simply made whole grain Os sweetened with real honey and natural almond flavor. A kosher, gluten free cereal made with no artificial flavors or colors. Serve this whole grain cereal with milk for a quick kids breakfast or alone as toddler snacks..",
		FHunger = 15,
	},
	{
		FName = "Bagette",
		FModel = "models/foodnhouseholditems/bagette.mdl",
		FDesc = "A long, thin loaf of French bread.",
		FHunger = 12,
	},
	{
		FName = "Bread",
		FModel = "models/foodnhouseholditems/bread-1.mdl",
		FDesc = "A food consisting of flour or meal that is moistened, kneaded into dough, and often fermented using yeast, and it has been a major sustenance since prehistoric times.",
		FHunger = 12,
	},
	{
		FName = "Bread Slice",
		FModel = "models/foodnhouseholditems/bread-1.mdl",
		FDesc = "A small slice of fresh bread",
		FHunger = 4,
	},
	{
		FName = "Long bread",
		FModel = "models/foodnhouseholditems/bread-2.mdl",
		FDesc = "A food consisting of flour or meal that is moistened, kneaded into dough, and often fermented using yeast, and it has been a major sustenance since prehistoric times.",
		FHunger = 13,
	},
	{
		FName = "Dark Bread",
		FModel = "models/foodnhouseholditems/bread-4.mdl",
		FDesc = "A food consisting of flour or meal that is moistened, kneaded into dough, and often fermented using yeast, and it has been a major sustenance since prehistoric times.",
		FHunger = 12,
	},
	{
		FName = "Wholemeal Bread",
		FModel = "models/foodnhouseholditems/bread-3.mdl",
		FDesc = "A food consisting of flour or meal that is moistened, kneaded into dough, and often fermented using yeast, and it has been a major sustenance since prehistoric times.",
		FHunger = 11,
	},
	{
		FName = "Cheeseburger",
		FModel = "models/foodnhouseholditems/burgersims2.mdl",
		FDesc = "Hamburger with pork meat and extra cheese",
		FHunger = 25,
	},
	{
		FName = "Cabbage",
		FModel = "models/foodnhouseholditems/cabbage1.mdl",
		FDesc = "A vegetable with thick, lettuce-like leaves",
		FHunger = 12,
		FThirst = 2
	},
	{
		FName = "A piece of cake",
		FModel = "models/foodnhouseholditems/cake1a.mdl",
		FDesc = "A piece of chocolate cake served on a plate",
		FHunger = 10,
	},
	{
		FName = "Chicken Wrap",
		FModel = "models/foodnhouseholditems/chicken_wrap.mdl",
		FDesc = "A culinary dish made with a soft flatbread rolled around a chicken and vegetables",
		FHunger = 25,
	},
	{
		FName = "Master Chips",
		FModel = "models/foodnhouseholditems/chipsbag3.mdl",
		FDesc = "Strips of skinless potato that are grilled, deep-fried or baked until their outsides are crisp and approaching golden brown in colour",
		FHunger = 10,
	},
	{
		FName = "Lulu Chips",
		FModel = "models/foodnhouseholditems/chipsbag1.mdl",
		FDesc = "Strips of skinless potato that are grilled, deep-fried or baked until their outsides are crisp and approaching golden brown in colour",
		FHunger = 10,
	},
	{
		FName = "Lay's Classic",
		FModel = "models/foodnhouseholditems/chipslays.mdl",
		FDesc = "Strips of skinless potato that are grilled, deep-fried or baked until their outsides are crisp and approaching golden brown in colour",
		FHunger = 10,
	},
	{
		FName = "Doritos - Nacho Cheese",
		FModel = "models/foodnhouseholditems/chipsdoritos.mdl",
		FDesc = "A brand of flavored corn (maize) tortilla chip snack",
		FHunger = 10,
	},
	{
		FName = "Doritos - Diablo",
		FModel = "models/foodnhouseholditems/chipsdoritos4.mdl",
		FDesc = "A brand of flavored corn (maize) tortilla chip snack",
		FHunger = 12,
		FThirst = -5,
	},
	{
		FName = "Choco Rings",
		FModel = "models/foodnhouseholditems/chocorings.mdl",
		FDesc = "Choco Rings is breakfast cereal. It is chocolate flavored. Enjoy this delicious cereal",
		FHunger = 15,
	},
	{
		FName = "Coconut",
		FModel = "models/foodnhouseholditems/coconut.mdl",
		FDesc = "A coconut is the edible fruit of the coconut palm (Cocos nucifera), a tree of the palm family. Coconut flesh is high in fat and can be dried or eaten fresh or processed into coconut milk or coconut oil. The liquid of the nut, known as coconut water, is used in beverages.",
		FHunger = 6,
		FThirst = 4,
	},
	{
		FName = "Half coconut",
		FModel = "models/foodnhouseholditems/coconut_half.mdl",
		FDesc = "A coconut is the edible fruit of the coconut palm (Cocos nucifera), a tree of the palm family. Coconut flesh is high in fat and can be dried or eaten fresh or processed into coconut milk or coconut oil. The liquid of the nut, known as coconut water, is used in beverages.",
		FHunger = 3,
		FThirst = 2,
	},
	{
		FName = "Cookies",
		FModel = "models/foodnhouseholditems/cookies.mdl",
		FDesc = "A baked or cooked snack or dessert that is typically small, flat and sweet. It usually contains flour, sugar, egg, and some type of oil, fat, or butter.",
		FHunger = 10,
	},
	{
		FName = "Chocolate Digestive Biscuits",
		FModel = "models/foodnhouseholditems/digestive.mdl",
		FDesc = "Adigestive biscuit, sometimes described as a sweet-meal biscuit, is a semi-sweet biscuit that originated in Scotland. Chocolate flavored.",
		FHunger = 12,
	},
	{
		FName = "Digestive Biscuits",
		FModel = "models/foodnhouseholditems/digestive2.mdl",
		FDesc = "Adigestive biscuit, sometimes described as a sweet-meal biscuit, is a semi-sweet biscuit that originated in Scotland. The digestive was first developed in 1839 by two Scottish doctors to aid digestion.",
		FHunger = 11,
	},
	{
		FName = "Cola",
		FModel = "models/foodnhouseholditems/cola.mdl",
		FDesc = "A sweet brown non-alcoholic fizzy drink.",
		FThirst = 8,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "JoJo's Cola",
		FModel = "models/foodnhouseholditems/colabig.mdl",
		FDesc = "A sweet brown non-alcoholic fizzy drink.",
		FThirst = 19,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Eggplant",
		FModel = "models/foodnhouseholditems/eggplant.mdl",
		FDesc = "An eggplant is a large, purple-skinned vegetable that is especially delicious breaded, fried, and covered with cheese and red sauce. Eggplants are one of those foods that we think of as a vegetables but are officially considered fruits.",
		FHunger = 7,
	},
	{
		FName = "Eggplant",
		FModel = "models/foodnhouseholditems/eggplant.mdl",
		FDesc = "An eggplant is a large, purple-skinned vegetable that is especially delicious breaded, fried, and covered with cheese and red sauce. Eggplants are one of those foods that we think of as a vegetables but are officially considered fruits.",
		FHunger = 11,
	},
	{
		FName = "Perch Fish",
		FModel = "models/foodnhouseholditems/fishbass.mdl",
		FDesc = "A handsome and bold fish, the perch (Perca fluviatilis) has a greeny-brown back with a series of dark vertical bars across the upper sides",
		FHunger = 16,
		FThirst = 6,
	},
	{
		FName = "CatFish",
		FModel = "models/foodnhouseholditems/fishcatfish.mdl",
		FDesc = "The name catfish refers to the long barbels, or feelers, which are present about the mouth of the fish and resemble cat whiskers. All catfishes have at least one pair of barbels, on the upper jaw; they may also have a pair on the snout and additional pairs on the chin.",
		FHunger = 18,
		FThirst = 3,
	},
	{
		FName = "Fish steak",
		FModel = "models/foodnhouseholditems/fishsteak.mdl",
		FDesc = "A fish steak, alternatively known as a fish cutlet, is a cut of fish which is cut perpendicular to the spine and can either include the bones or be boneless.",
		FHunger = 20,
	},
	{
		FName = "Gourd",
		FModel = "models/foodnhouseholditems/gourd.mdl",
		FDesc = "A gourd is a large round fruit with a hard skin. You can also use gourd to refer to the plant on which this fruit grows. A gourd is a container made from the hard dry skin of a gourd fruit.",
		FHunger = 9,
	},
	{
		FName = "Grapes",
		FModel = "models/foodnhouseholditems/grapes1.mdl",
		FDesc = "Grapes are small green or dark purple fruit which grow in bunches. Grapes can be eaten raw, used for making wine, or dried.",
		FHunger = 8,
	},
	{
		FName = "Honey Jar",
		FModel = "models/foodnhouseholditems/honey_jar.mdl",
		FDesc = "A beautifully crafted glass jar filled with golden, viscous honey. The jar is adorned with intricate floral patterns and sealed with a cork stopper.",
		FHunger = 13,
	},
	{
		FName = "Icecream",
		FModel = "models/foodnhouseholditems/icecream.mdl",
		FDesc = "Two scoops of strawberry ice cream in a wafer",
		FHunger = 6,
		FThirst = 3,
	},
	{
		FName = "Nell's Premium Icecream [Vanilla]",
		FModel = "models/foodnhouseholditems/icecream2.mdl",
		FDesc = "A small bucket of vanilla flavored ice cream",
		FHunger = 12,
		FThirst = 5,
	},
	{
		FName = "Nell's Premium Icecream [Chocolate]",
		FModel = "models/foodnhouseholditems/icecream4.mdl",
		FDesc = "A small bucket of chocolate flavored ice cream",
		FHunger = 12,
		FThirst = 5,
	},
	{
		FName = "Nell's Premium Icecream [Strawberry]",
		FModel = "models/foodnhouseholditems/icecream3.mdl",
		FDesc = "A small bucket of strawberry flavored ice cream",
		FHunger = 12,
		FThirst = 5,
	},
	{
		FName = "Orange Juice",
		FModel = "models/foodnhouseholditems/juice.mdl",
		FDesc = "A drink consisting of the juice from oranges",
		FThirst = 13,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Apple Juice",
		FModel = "models/foodnhouseholditems/juice2.mdl",
		FDesc = "A drink consisting of the juice from apples",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Small Apple Juice",
		FModel = "models/foodnhouseholditems/juicesmall.mdl",
		FDesc = "A drink consisting of the juice from apples",
		FThirst = 7,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Kellog's Corn Flakes",
		FModel = "models/foodnhouseholditems/kellogscornflakes.mdl",
		FDesc = "A packaged cereal product formed from small toasted flakes of corn, usually served cold with milk and sometimes sugar.",
		FHunger = 17,
	},
	{
		FName = "Kinder Suprise",
		FModel = "models/foodnhouseholditems/kindersurprise.mdl",
		FDesc = "Contains the taste of Kinder chocolate, with a surprise and toy in every single egg",
		FHunger = 5,
	},
	{
		FName = "Leek",
		FModel = "models/foodnhouseholditems/leek.mdl",
		FDesc = "Long thin vegetables which smell similar to onions",
		FHunger = 8,
	},
	{
		FName = "Lettuce",
		FModel = "models/foodnhouseholditems/lettuce.mdl",
		FDesc = "A plant with large green leaves that is the basic ingredient of many salads",
		FHunger = 8,
	},
	{
		FName = "Raw Lobster",
		FModel = "models/foodnhouseholditems/lobster.mdl",
		FDesc = "A hard-shelled animal that lives in salt water and has two big front claws, or pincers. People who are familiar with red cooked lobsters might be surprised to see that when they're alive they are brown, gray, or even blue.",
		FHunger = 12,
	},
	{
		FName = "Roasted Lobster",
		FModel = "models/foodnhouseholditems/lobster2.mdl",
		FDesc = "A hard-shelled animal that lives in salt water and has two big front claws, or pincers. People who are familiar with red cooked lobsters might be surprised to see that when they're alive they are brown, gray, or even blue.",
		FHunger = 27,
	},
	{
		FName = "MCD Burger",
		FModel = "models/foodnhouseholditems/mcdburgerbox.mdl",
		FDesc = "Hamburger with double cheese and meat",
		FHunger = 19,
	},
	{
		FName = "MCD French Fries",
		FModel = "models/foodnhouseholditems/mcdfrenchfries.mdl",
		FDesc = "Fries are long, thin pieces of potato fried in oil or fat",
		FHunger = 12,
	},
	{
		FName = "MCD Drink",
		FModel = "models/foodnhouseholditems/mcdfrenchfries.mdl",
		FDesc = "Containing coca-cola, sprite or other fizzy drink",
		FThirst = 12,
	},
	{
		FName = "MCD Fried chicken leg",
		FModel = "models/foodnhouseholditems/mcdfriedchickenleg.mdl",
		FDesc = "A dish consisting of chicken pieces that have been coated with seasoned flour or batter and pan-fried, deep fried, pressure fried, or air fried.",
		FHunger = 12,
	},
	{
		FName = "MCD Big Meal",
		FModel = "models/foodnhouseholditems/mcdmeal.mdl",
		FDesc = "Set including two burgers, four chicken legs, two packets of fries and two drinks",
		FHunger = 100,
		FThirst = 100,
	},
	{
		FName = "MCD Big Meal",
		FModel = "models/foodnhouseholditems/mcdmeal2.mdl",
		FDesc = "Set including a burger, two chicken legs, fries and a drink",
		FHunger = 56,
		FThirst = 25,
	},
	{
		FName = "Raw beef",
		FModel = "models/foodnhouseholditems/meat7.mdl",
		FDesc = "Beef is meat from a cow",
		FHunger = 12,
	},
	{
		FName = "Roasted beef",
		FModel = "models/foodnhouseholditems/meat8.mdl",
		FDesc = "Beef is meat from a cow",
		FHunger = 25,
	},
	{
		FName = "Raw pork",
		FModel = "models/foodnhouseholditems/meat3.mdl",
		FDesc = "Pork is meat from a pig, usually fresh and not smoked or salted",
		FHunger = 12,
	},
	{
		FName = "Roasted pork",
		FModel = "models/foodnhouseholditems/meat4.mdl",
		FDesc = "Pork is meat from a pig, usually fresh and not smoked or salted",
		FHunger = 25,
	},
	{
		FName = "Nutella",
		FModel = "models/foodnhouseholditems/nutella.mdl",
		FDesc = "Nutella is described as a chocolate and hazelnut spread, although it is mostly made of sugar and palm oil. The manufacturing process for this food item is very similar to a generic production of chocolate spread.",
		FHunger = 14,
	},
	{
		FName = "Pancake",
		FModel = "models/foodnhouseholditems/pancake.mdl",
		FDesc = "A thin, flat, round cake made from flour, sugar, milk, and eggs, cooked in a pan and usually eaten with maple syrup for breakfast.",
		FHunger = 14,
	},
	{
		FName = "Pancakes",
		FModel = "models/foodnhouseholditems/pancakes.mdl",
		FDesc = "A thin, flat, round cake made from flour, sugar, milk, and eggs, cooked in a pan and usually eaten with maple syrup for breakfast.",
		FHunger = 30,
	},
	{
		FName = "Peanut Butter",
		FModel = "models/foodnhouseholditems/peanut_butter.mdl",
		FDesc = "A paste made from ground roasted peanuts, used as a spread or in cooking.",
		FHunger = 16,
	},
	{
		FName = "Pear",
		FModel = "models/foodnhouseholditems/pear.mdl",
		FDesc = "A sweet, juicy fruit which is narrow near its stalk, and wider and rounded at the bottom.",
		FHunger = 3,
		FThirst = 3,
	},
	{
		FName = "Red Pepper",
		FModel = "models/foodnhouseholditems/pepper1.mdl",
		FDesc = "A hollow green, red, or yellow vegetable with seed.",
		FHunger = 5,
	},
	{
		FName = "Yellow Pepper",
		FModel = "models/foodnhouseholditems/pepper2.mdl",
		FDesc = "A hollow green, red, or yellow vegetable with seed.",
		FHunger = 5,
	},
	{
		FName = "Green Pepper",
		FModel = "models/foodnhouseholditems/pepper3.mdl",
		FDesc = "A hollow green, red, or yellow vegetable with seed.",
		FHunger = 5,
	},
	{
		FName = "Pickle Jar",
		FModel = "models/foodnhouseholditems/picklejar.mdl",
		FDesc = "A pickle is a food that's made by soaking vegetables in brine or vinegar.",
		FHunger = 15,
		FThirst = 8,
	},
	{
		FName = "Pie",
		FModel = "models/foodnhouseholditems/pie.mdl",
		FDesc = "A type of food made with meat, vegetables, or fruit covered in pastry and baked.",
		FHunger = 22,
	},
	{
		FName = "Pineapple",
		FModel = "models/foodnhouseholditems/pineapple.mdl",
		FDesc = "A sweet tropical fruit with a tough leathery skin and spiky leaves on top.",
		FHunger = 8,
		FThirst = 5,
	},
	{
		FName = "Piranha",
		FModel = "models/foodnhouseholditems/piranha.mdl",
		FDesc = "A piranha is a small, fierce fish which is found in South America",
		FHunger = 16,
		FThirst = 6,
	},
	{
		FName = "Potato",
		FModel = "models/foodnhouseholditems/potato.mdl",
		FDesc = "A vegetable, the Solanum tuberosum. It is a small plant with large leaves. The part of the potato that people eat is a tuber that grows under the ground. Potato cultivars appear in a variety of colors, shapes, and sizes.",
		FHunger = 8,
	},
	{
		FName = "Pretzel",
		FModel = "models/foodnhouseholditems/pretzel.mdl",
		FDesc = "A hard salty biscuit that has been baked in a stick or knot shape.",
		FHunger = 13,
	},
	{
		FName = "Pumpkin",
		FModel = "models/foodnhouseholditems/pumpkin01.mdl",
		FDesc = "A large round vegetable with thick orange skin.",
		FHunger = 13,
	},
	{
		FName = "Piece of Salmon",
		FModel = "models/foodnhouseholditems/salmon.mdl",
		FDesc = "The orangey-pink flesh of a large silver-colored fish which is eaten as food",
		FHunger = 14,
	},
	{
		FName = "Sandwich",
		FModel = "models/foodnhouseholditems/sandwich.mdl",
		FDesc = "A sandwich consists of two slices of bread with a cheese and meat between them",
		FHunger = 16,
	},
	{
		FName = "Coca-Cola",
		FModel = "models/foodnhouseholditems/sodacan01.mdl",
		FDesc = "A carbonated, sweetened soft drink and is the world's best-selling soda.",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Cherry Coca-Cola",
		FModel = "models/foodnhouseholditems/sodacan02.mdl",
		FDesc = "A carbonated, sweetened soft drink and is the world's best-selling soda.",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Pepsi",
		FModel = "models/foodnhouseholditems/sodacan04.mdl",
		FDesc = "Pepsi is a carbonated soft drink manufactured by PepsiCo. The original recipe also included sugar and vanilla.",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Sprite",
		FModel = "models/foodnhouseholditems/sodacan05.mdl",
		FDesc = "Crisp, refreshing and clean-tasting, Sprite is a lemon and lime-flavoured soft drink.",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Monster Energy Drink",
		FModel = "models/foodnhouseholditems/sodacanb01.mdl",
		FDesc = "Great tasting energy drink with energy blend and 160mg caffeine. The Monster Energy blend combined with caffeine gives you the energy you need in a smooth easy drinking flavour",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "RedBull",
		FModel = "models/foodnhouseholditems/sodacanc01.mdl",
		FDesc = "A brand of energy drinks created and owned by the Austrian company Red Bull GmbH",
		FThirst = 15,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Raw steak",
		FModel = "models/foodnhouseholditems/steak1.mdl",
		FDesc = "A thick, flat piece of meat or fish, especially meat from a cow",
		FHunger = 12,
	},
	{
		FName = "Roasted steak",
		FModel = "models/foodnhouseholditems/steak2.mdl",
		FDesc = "A thick, flat piece of meat or fish, especially meat from a cow",
		FHunger = 25,
	},
	{
		FName = "Sprunk",
		FModel = "models/foodnhouseholditems/sprunk1.mdl",
		FDesc = "A sweet lemon and lime-flavoured fizzy drink.",
		FThirst = 19,
		FCategory = "Drinks",
		FunctionName = "Drink"
	},
	{
		FName = "Toast",
		FModel = "models/foodnhouseholditems/toast.mdl",
		FDesc = "Toast is sliced bread that has been browned by radiant heat",
		FHunger = 15,
	},
	{
		FName = "Sweet Roll",
		FModel = "models/foodnhouseholditems/sweetroll.mdl",
		FDesc = "A roll made of sweet dough, often containing spices, raisins, nuts, candied fruit, etc., and sometimes iced on top",
		FHunger = 13,
	},
	{
		FName = "Toblerone",
		FModel = "models/foodnhouseholditems/toblerone.mdl",
		FDesc = "A Swiss chocolate brand owned by Mondelez International (originally Kraft Foods)",
		FHunger = 13,
	},
	{
		FName = "Toffifee",
		FModel = "models/foodnhouseholditems/toffifee.mdl",
		FDesc = "Toffifee are caramel cups containing nougat, caramel and a hazelnut, topped with a chocolate button",
		FHunger = 13,
	},
	{
		FName = "Turkey Leg",
		FModel = "models/foodnhouseholditems/turkeyleg.mdl",
		FDesc = "A large ground-dwelling bird that is 36-44 inches in length",
		FHunger = 12,
	},
	{
		FName = "Turkey",
		FModel = "models/foodnhouseholditems/turkey.mdl",
		FDesc = "A large ground-dwelling bird that is 36-44 inches in length",
		FHunger = 25,
	},
	{
		FName = "Slice of Watermelon",
		FModel = "models/props/cryts_food/fruit_watermelon.mdl",
		FDesc = "A slice of watermelon.",
		FHunger = 10,
		FThirst = 4,
	},
}

local drinks = {
	// Cryt's Food Pack

	{
		FName = "Russian Beer",
		FModel = "models/props/cryts_food/drink_beer01.mdl",
		FDesc = "An alcoholic beverage produced by extracting raw materials with water, boiling (usually with hops), and fermenting",
		FTime = 180,
		FAmount = 0.5
	},
	{
		FName = "Beer Master",
		FModel = "models/foodnhouseholditems/beer_master.mdl",
		FDesc = "An alcoholic beverage produced by extracting raw materials with water, boiling (usually with hops), and fermenting",
		FTime = 180,
		FAmount = 0.25
	},
	{
		FName = "Beer Stoltz",
		FModel = "models/foodnhouseholditems/beer_stoltz.mdl",
		FDesc = "An alcoholic beverage produced by extracting raw materials with water, boiling (usually with hops), and fermenting",
		FTime = 180,
		FAmount = 0.2
	},
	{
		FName = "Russian canned Beer",
		FModel = "models/props/cryts_food/drink_beer03.mdl",
		FDesc = "An alcoholic beverage produced by extracting raw materials with water, boiling (usually with hops), and fermenting",
		FTime = 180,
		FAmount = 0.4
	},
	{
		FName = "Duff canned Beer",
		FModel = "models/props/cryts_food/drink_beer03.mdl",
		FDesc = "An alcoholic beverage produced by extracting raw materials with water, boiling (usually with hops), and fermenting",
		FTime = 180,
		FAmount = 0.3
	},
	{
		FName = "Pißwasser canned Beer",
		FModel = "models/props/cryts_food/drink_beer03.mdl",
		FDesc = "An alcoholic beverage produced by extracting raw materials with water, boiling (usually with hops), and fermenting",
		FTime = 180,
		FAmount = 0.3
	},
	{
		FName = "Hop Knot canned Beer",
		FModel = "models/foodnhouseholditems/beercan03.mdl",
		FDesc = "An alcoholic beverage produced by extracting raw materials with water, boiling (usually with hops), and fermenting",
		FTime = 180,
		FAmount = 0.27
	},
	{
		FName = "Moonshine",
		FModel = "models/props/cryts_food/drink_moonshine.mdl",
		FDesc = "Tradition usually a clear, unaged whiskey, once made with barley mash in Scotland and Ireland",
		FTime = 180,
		FAmount = 0.6
	},
	{
		FName = "Rum",
		FModel = "models/props/cryts_food/drink_rum.mdl",
		FDesc = "An alcoholic liquor or spirit distilled from molasses or some other fermented sugar-cane product.",
		FTime = 180,
		FAmount = 0.6
	},
	{
		FName = "Absolut Vodka",
		FModel = "models/props/cryts_food/drink_vodka02.mdl",
		FDesc = "A clear distilled alcoholic beverage. Vodka is composed mainly of water and ethanol but sometimes with traces of impurities and flavourings.",
		FTime = 240,
		FAmount = 1
	},
	{
		FName = "Jack Daniel's Whiskey",
		FModel = "models/props/cryts_food/drink_whiskey.mdl",
		FDesc = "An amber-colored distilled spirit made out of fermented grain (most often rye, wheat, corn, or barley).",
		FTime = 240,
		FAmount = 1
	},
	{
		FName = "Wine",
		FModel = "models/props/cryts_food/drink_wine.mdl",
		FDesc = "An alcoholic drink which is made from grapes.",
		FTime = 240,
		FAmount = 0.5
	},

	// Food and HouseHold Items

	{
		FName = "Coconut Drink",
		FModel = "models/foodnhouseholditems/coconut_drink.mdl",
		FDesc = "A coconut drink with low alcohol content. Decorated with lemon, straw and small umbrella",
		FTime = 60,
		FAmount = 0.5
	},
	{
		FName = "Rockford Hill Reserve Red Wine",
		FModel = "models/foodnhouseholditems/wine_red1.mdl",
		FDesc = "The wine brand founded in 1808 in the State of San Andreas.",
		FTime = 240,
		FAmount = 0.7
	},
	{
		FName = "Rockford Hill Reserve White Wine",
		FModel = "models/foodnhouseholditems/wine_white1.mdl",
		FDesc = "The wine brand founded in 1808 in the State of San Andreas.",
		FTime = 240,
		FAmount = 0.5
	},
	{
		FName = "Costa Del Perro Wine",
		FModel = "models/foodnhouseholditems/wine_red2.mdl",
		FDesc = "The wine brand founded in the State of San Andreas. The brand's name translates to 'Coast of the Dog' in Spanish.",
		FTime = 240,
		FAmount = 0.65
	},
	{
		FName = "Syrah Wine",
		FModel = "models/foodnhouseholditems/wine_red3.mdl",
		FDesc = "A rich, powerful, and sometimes meaty red wine that originated in the Rhône Valley of France. Syrah is the most planted grape of Australia, where they call it Shiraz.",
		FTime = 210,
		FAmount = 0.75
	},
	{
		FName = "Vinewood Red Red Wine",
		FModel = "models/foodnhouseholditems/wine_rose1.mdl",
		FDesc = "Vinewood was founded in 2008. Two known versions of Vinewood exist; a white wine called Sauvignon Blanc, and a red wine called Red Zinfandel.",
		FTime = 210,
		FAmount = 0.5
	},
	{
		FName = "Vinewood Red White Wine",
		FModel = "models/foodnhouseholditems/wine_white2.mdl",
		FDesc = "Vinewood was founded in 2008. Two known versions of Vinewood exist; a white wine called Sauvignon Blanc, and a red wine called Red Zinfandel.",
		FTime = 220,
		FAmount = 0.65
	},
	{
		FName = "Two Rooasters Wine",
		FModel = "models/foodnhouseholditems/wine_rose2.mdl",
		FDesc = "The wine is made from Grenache grapes and contains 14 percentage alcohol in the 70cl bottle",
		FTime = 210,
		FAmount = 0.5
	},
	{
		FName = "Marlowe White Wine",
		FModel = "models/foodnhouseholditems/wine_white3.mdl",
		FDesc = "A bold and complex red wine, with rich flavors of dark fruits, vanilla, and spices, and a smooth finish that lingers on the palate",
		FTime = 270,
		FAmount = 0.7
	},
	{
		FName = "Old Red Wine",
		FModel = "models/foodnhouseholditems/winebottle1.mdl",
		FDesc = "Old red wine that has aged a good couple of years",
		FTime = 280,
		FAmount = 0.73
	},
	{
		FName = "Old White Wine",
		FModel = "models/foodnhouseholditems/winebottle2.mdl",
		FDesc = "Old white wine that has aged a good couple of years",
		FTime = 280,
		FAmount = 0.63
	},

	// Liquor Prop Pack

	{
		FName = "Baileys",
		FModel = "models/ovcmiscpack/liquor/baileys.mdl",
		FDesc = "An Irish cream liqueur, an alcoholic drink flavoured with cream, cocoa and Irish whiskey",
		FTime = 240,
		FAmount = 1
	},
	{
		FName = "Becherovka",
		FModel = "models/ovcmiscpack/liquor/becherovka.mdl",
		FDesc = "Becherovka is often described as having a gingery or cinnamon flavor. Its alcohol content is 38 percentage ABV (76 proof), and it is usually served chilled.",
		FTime = 190,
		FAmount = 0.85
	},
	{
		FName = "Beefeater",
		FModel = "models/ovcmiscpack/liquor/beefeater_sprite.mdl",
		FDesc = "An amber-colored distilled spirit made out of fermented grain (most often rye, wheat, corn, or barley).",
		FTime = 75,
		FAmount = 0.85
	},
	{
		FName = "Chivas Regal",
		FModel = "models/ovcmiscpack/liquor/chivas.mdl",
		FDesc = "A blended Scotch whisky produced by Pernod Ricard in Scotland.",
		FTime = 250,
		FAmount = 1
	},
	{
		FName = "Cointreau",
		FModel = "models/ovcmiscpack/liquor/cointreau.mdl",
		FDesc = "A brand of orange-flavoured triple sec liqueur produced in Saint-Barthélemy-d'Anjou, France. It is consumed as an apéritif and digestif, and is a component of several well-known cocktails.",
		FTime = 200,
		FAmount = 0.84
	},
	{
		FName = "Crema di limoncino",
		FModel = "models/ovcmiscpack/liquor/crema_di_limoncino.mdl",
		FDesc = "It is a creamy liqueur, pleasantly sweet and with a moderate alcohol content, characterized by an intense aroma of lemon. Sicilian lemon peels are infused in alcohol and, thanks to a slow extraction process, aromatic compounds result in a natural infusion with a strong aroma of lemon.",
		FTime = 180,
		FAmount = 0.84
	},
	{
		FName = "Crema di limoncino",
		FModel = "models/ovcmiscpack/liquor/crema_di_limoncino.mdl",
		FDesc = "It is a creamy liqueur, pleasantly sweet and with a moderate alcohol content, characterized by an intense aroma of lemon. Sicilian lemon peels are infused in alcohol and, thanks to a slow extraction process, aromatic compounds result in a natural infusion with a strong aroma of lemon.",
		FTime = 180,
		FAmount = 0.84
	},
	{
		FName = "Curaçao",
		FModel = "models/ovcmiscpack/liquor/curacao.mdl",
		FDesc = "Curaçao is a Caribbean liqueur made using the dried peel of the Laraha citrus fruit. Blue curaçao is essentially the same thing, but it's doctored with artificial blue coloring, which adds a bold look to cocktails.",
		FTime = 210,
		FAmount = 0.96
	},
	{
		FName = "Havana Club",
		FModel = "models/ovcmiscpack/liquor/havana_club.mdl",
		FDesc = "A brand of rum created in Cuba in 1934. Originally produced in Cárdenas, Cuba, by family-owned José Arechabala S.A",
		FTime = 180,
		FAmount = 0.86
	},
	{
		FName = "Jagermeister",
		FModel = "models/ovcmiscpack/liquor/jagermeister.mdl",
		FDesc = "A popular liqueur, or sweetened, flavored liquor. It's infused with a number of herbs, and a lot of its recipe is kept secret to keep the brand exclusive. However, it's known that Jagermeister contains bitter orange, cloves, and star anise among other ingredients.",
		FTime = 210,
		FAmount = 1
	},
	{
		FName = "Kahlua",
		FModel = "models/ovcmiscpack/liquor/kahlua.mdl",
		FDesc = "A coffee liqueur that's made in Mexico. It's made with rum, sugar, vanilla bean, and coffee. Contrary to what you might think, there's no dairy!",
		FTime = 240,
		FAmount = 0.7
	},
	{
		FName = "Malibu",
		FModel = "models/ovcmiscpack/liquor/malibu.mdl",
		FDesc = "A coconut flavored liqueur, made with Caribbean rum, and possessing an alcohol content by volume of 21.0 percentage (42 proof)",
		FTime = 240,
		FAmount = 0.6
	},
	{
		FName = "Martell",
		FModel = "models/ovcmiscpack/liquor/martel.mdl",
		FDesc = "Martell is the number one international prestige cognac. Founded in 1715, Martell is the oldest of the great cognac houses.",
		FTime = 240,
		FAmount = 0.9
	},
	{
		FName = "Sambuca Molinari",
		FModel = "models/ovcmiscpack/liquor/molinari_sambuka.mdl",
		FDesc = "A sweet and aromatic Italian liqueur, made from star anise seeds, sugar, herbs and rather fine and precious spices",
		FTime = 240,
		FAmount = 0.7
	},
	{
		FName = "Olmeca",
		FModel = "models/ovcmiscpack/liquor/olmeca.mdl",
		FDesc = "It is made from the juice of only the finest blue agave plants, and its ultimate purity is guaranteed by a unique process of double distillation",
		FTime = 240,
		FAmount = 0.7
	},
	{
		FName = "Pernod",
		FModel = "models/ovcmiscpack/liquor/pernod.mdl",
		FDesc = "A pungent, strong anise liqueur that's extremely refreshing to drink with water as the French do (also called a Pastis). It tastes like black licorice",
		FTime = 190,
		FAmount = 0.9
	},
	{
		FName = "Ramazzotti",
		FModel = "models/ovcmiscpack/liquor/ramazzotti.mdl",
		FDesc = "A traditional Italian herbal liqueur. Its blend of 33 aromatic botanicals includes Calabrian oranges, cinchona, rhubarb, gentian and star anise",
		FTime = 260,
		FAmount = 0.9
	},
	{
		FName = "Sortilege",
		FModel = "models/ovcmiscpack/liquor/sortilege.mdl",
		FDesc = "Sortilege Caramel is made with the same authentic ingredients as our liqueur, Canadian whisky, maple syrup and now we have added creamy caramel. Ideal on the rock, it will also add a unique flavour to your coffee and cocktails.",
		FTime = 240,
		FAmount = 0.7
	},
	

	// FZE's Drinks and Cocktails


	{
		FName = "Asylum",
		FModel = "models/asylum/asylum.mdl",
		FDesc = "Seabrook said of this drink, \"look like rosy dawn, taste like the milk of Paradise, and make you plenty crazy.\"",
		FTime = 60,
		FAmount = 0.4
	},
	{
		FName = "Barbotage",
		FModel = "models/barbotage/barbotage.mdl",
		FDesc = "The Barbotage contains sparkling wine, but it's also fortified with cognac (or brandy) and Grand Marnier. The result is festive flavor with a hint of orange. Perfect for toasting. This cocktail may have originated as a hangover cure (no one is sure about its origins).",
		FTime = 60,
		FAmount = 0.5
	},
	{
		FName = "Black Velvet",
		FModel = "models/black velvet/black velvet.mdl",
		FDesc = "A beer cocktail that pairs stout beer with sparkling wine, usually Guinness (Irish stout) and champagne (French sparkling wine)",
		FTime = 160,
		FAmount = 0.3
	},
	{
		FName = "Bloody Mary",
		FModel = "models/bloody mary/bloody mary.mdl",
		FDesc = "A cocktail containing vodka, tomato juice, and other spices and flavorings including Worcestershire sauce, hot sauces, garlic, herbs, horseradish, celery, olives, pickled vegetables, salt, black pepper, lemon juice, lime juice and celery salt.",
		FTime = 120,
		FAmount = 0.45
	},
	{
		FName = "Brandy",
		FModel = "models/brandy/brandy.mdl",
		FDesc = "A fruity and subtly sweet taste. It can also have flavor notes of oak since it is typically aged in wooden casks. The taste of brandy becomes more mellow and complex as it ages—brandy that is less than two years old is considered unaged, while brandies that are more than two years old are considered mature.",
		FTime = 150,
		FAmount = 0.45
	},
	{
		FName = "Brandy Fizz",
		FModel = "models/brandy fizz/brandy fizz.mdl",
		FDesc = "The Brandy Fizz drink is made from Brandy, sugar, fresh lemon juice and club soda, and served in a chilled highball glass.",
		FTime = 200,
		FAmount = 0.35
	},
	{
		FName = "Caipirinha",
		FModel = "models/caipirinha/caipirinha.mdl",
		FDesc = "Caipirinha is Brazil's national cocktail, made with cachaça (sugarcane hard liquor), sugar, and lime",
		FTime = 150,
		FAmount = 0.5
	},
	{
		FName = "Cape Codder",
		FModel = "models/cape codder/cape codder.mdl",
		FDesc = "Basically a \"vodka cranberry\" with a splash of lime, the Cape Codder is named after the Cape Cod resort on the Massachusetts coast.",
		FTime = 150,
		FAmount = 0.6
	},
	{
		FName = "Chicago Fizz",
		FModel = "models/chicago fizz/chicago fizz.mdl",
		FDesc = "A very sophisticated cocktail made with Ruby port and Dark Rum. The rich dried fruit/red wine flavours of the Port combined with the complexity of Dark Rum give this cocktail many layers of flavour. There's a specific act to serving up a Chicago Fizz.",
		FTime = 175,
		FAmount = 0.45
	},
	{
		FName = "Cliquet",
		FModel = "models/cliquet/cliquet.mdl",
		FDesc = "Contains orange juice, Scotch whiskey and dark rum. It is always better to use fresh orange juice to further enhance the taste of this drink.",
		FTime = 145,
		FAmount = 0.4
	},
	{
		FName = "Cosmopolitan",
		FModel = "models/cosmopolitan/cosmopolitan.mdl",
		FDesc = "A cosmopolitan, or simply \"cosmo\" is a vodka cocktail made with triple sec, cranberry juice, and lime juice. The drink was invented in the 1930s, but rose in popularity in the 1990s.",
		FTime = 165,
		FAmount = 0.4
	},
	{
		FName = "Daquiri",
		FModel = "models/daquiri/daquiri.mdl",
		FDesc = "Daiquiris are classic rum cocktails that use three main ingredients to create a perfect balance of sweet and sour: rum, citrus juice (most often lime), and sweetener. They're traditionally served in a cocktail glass without ice",
		FTime = 150,
		FAmount = 0.35
	},
	{
		FName = "Dead man's hand",
		FModel = "models/dead man's hand/dead man's hand.mdl",
		FDesc = "A dead man's handle is a switch or lever, most commonly used on trains, that if released by the driver causes the train to stop. However, in this case, it's a refreshing tequila cocktail punched up with Aperol and sweetened with orgeat",
		FTime = 150,
		FAmount = 0.35
	},
	{
		FName = "Death in the Afternoon",
		FModel = "models/death in the afternoon/death in the afternoon.mdl",
		FDesc = "A cocktail made with absinthe and champagne invented by the writer, Ernest Hemingway. The name comes from his book, Death in the Afternoon, and was first published in a cocktail book in 1935. A key feature of this cocktail its cloudy color.",
		FTime = 150,
		FAmount = 0.5
	},
	{
		FName = "El Presidente",
		FModel = "models/el presidente/el presidente.mdl",
		FDesc = "A Cuban alcoholic drink made of rum, orange curaçao, vermouth, and grenadine.",
		FTime = 150,
		FAmount = 0.35
	},
	{
		FName = "Esquire",
		FModel = "models/esquire/esquire.mdl",
		FDesc = "A drink with vodka, raspberry flavoured vodka, parfait amour liqueur, chilled water and garnish with blackberries",
		FTime = 180,
		FAmount = 0.45
	},
	{
		FName = "Gentleman's Cocktail",
		FModel = "models/gentleman/gentleman.mdl",
		FDesc = "A cocktail made with oour bourbon, brandy, and creme de menthe over ice into highball glass",
		FTime = 120,
		FAmount = 0.35
	},
	{
		FName = "Green Swizzle",
		FModel = "models/green swizzle/green swizzle.mdl",
		FDesc = "an alcohol-containing cocktail of the sour family. It was popular in Trinidad at the beginning of the 20th centur",
		FTime = 180,
		FAmount = 0.4
	},
	{
		FName = "Irish coffee",
		FModel = "models/irish coffee/irish coffee.mdl",
		FDesc = "Irish coffee has four main ingredients: coffee, Irish whiskey, sugar and cream. But there are many variations of this classic coffee drink, some of which include steamed milk.",
		FTime = 150,
		FAmount = 0.3
	},
	{
		FName = "Jarate Toddy",
		FModel = "models/jarate toddy/jarate toddy.mdl",
		FDesc = "A drink that is made by adding hot water and sugar to a strong alcoholic drink such as whisky, rum, or brandy",
		FTime = 150,
		FAmount = 0.3
	},
	{
		FName = "Manhattan",
		FModel = "models/manhattan/manhattan.mdl",
		FDesc = "A classic cocktail of choice for whiskey-lovers. This delightful mix of rye or bourbon whiskey, sweet vermouth, and bitters has been adored for hundreds of years because of its subtle bitterness and herbal undertones.",
		FTime = 180,
		FAmount = 0.5
	},
	{
		FName = "Margarita",
		FModel = "models/margarita/margarita.mdl",
		FDesc = "A cocktail consisting of tequila, triple sec, and lime juice. Some margarita recipes include simple syrup as well and are often served with salt on the rim of the glass",
		FTime = 170,
		FAmount = 0.3
	},
	{
		FName = "Martini",
		FModel = "models/martini/martini.mdl",
		FDesc = "A cocktail made with gin or vodka and dry vermouth, usually served with a green olive or a twist of lemon peel.",
		FTime = 150,
		FAmount = 0.5
	},
	{
		FName = "Mimosa",
		FModel = "models/mimosa/mimosa.mdl",
		FDesc = "A cocktail that is equal parts orange juice and Champagne or sparkling white wine, usually served in a champagne flute.",
		FTime = 180,
		FAmount = 0.5
	},
	{
		FName = "Raspberry Fields",
		FModel = "models/raspberry fields/raspberry fields.mdl",
		FDesc = "an unfiltered light beer with natural raspberry juice, produced using triple fermentation technology. Thanks to her, the product acquires a rich foam and a mild wheat taste with pronounced banana and clove fruit notes",
		FTime = 170,
		FAmount = 0.3
	},
	{
		FName = "Sano Grog",
		FModel = "models/sano grog/sano grog.mdl",
		FDesc = "In Sweden and some subcultures within the English-speaking world, grogg is a common description of drinks not made to a recipe, but by mixing various kinds of alcoholic and soft drinks, fruit juice or similar ingredients",
		FTime = 150,
		FAmount = 0.5
	},
	{
		FName = "Sidecar",
		FModel = "models/sidecar/sidecar.mdl",
		FDesc = "The sidecar is any cocktail traditionally made with cognac, orange liqueur (Cointreau, Grand Marnier, dry curaçao, or a triple sec), plus lemon juice. In its ingredients, the drink is perhaps most closely related to the older brandy crusta, which differs both in presentation and in proportions of its components.",
		FTime = 150,
		FAmount = 0.5
	},
	
}	



function PLUGIN:InitializedPlugins()

    print("[Food & Drinks] Registering food and drinks items...")

    local foodItems = 0

    for k,v in ipairs(foods) do
        local ITEM = ix.item.Register(string.lower(string.Replace(string.Replace(v.FName,"'", "")," ","_")), nil, false, nil, true)
        ITEM.name = v.FName
        ITEM.description = v.FDesc
        ITEM.model = v.FModel
        ITEM.width = v.FW or 1
        ITEM.height = v.FH or 1
        ITEM.category = v.FCategory or "Food"
        ITEM.hunger = v.FHunger or 0
		ITEM.thirst = v.FThirst or 0
        function ITEM:GetDescription()
            return self.description
        end
        ITEM.functions.Consume = {
			name = v.FunctionName or "Eat",
			OnCanRun = function(item)
				if item.thirst != 0 then
					if item.player:GetCharacter():GetData("thirst", 100) >= 100 then
						return false
					end
				end
				if item.hunger != 0 then
					if item.player:GetCharacter():GetData("hunger", 100) >= 100 then
						return false
					end
				end
			end,
			OnRun = function(item)
				local hunger = item.player:GetCharacter():GetData("hunger", 100)
				local thirst = item.player:GetCharacter():GetData("thirst", 100)
				item.player:SetHunger(hunger + item.hunger)
				item.player:SetThirst(thirst + item.thirst)
				item.player:EmitSound("physics/flesh/flesh_impact_hard6.wav")
				if item.empty then
					local inv = item.player:GetCharacter():GetInventory()
					inv:Add(item.empty)
				end
			end
		}

		foodItems = foodItems + 1

    end

    print("[Food & Drinks] Registered "..foodItems.." food and drinks items.")

    print("[Food & Drinks] Registering alcohol items...")

    local drinkItems = 0

    for k,v in ipairs(drinks) do
    	local ITEM = ix.item.Register(string.lower(string.Replace(string.Replace(v.FName,"'", "")," ","_")), "base_alcohol", false, nil, true)
    	ITEM.name = v.FName
        ITEM.description = v.FDesc
        ITEM.model = v.FModel
        ITEM.width = v.FW or 1
        ITEM.height = v.FH or 1
        ITEM.category = "Alcohol"
        ITEM.effectAmount = v.FAmount or 0.2
		ITEM.effectTime = v.FTime or 1
		drinkItems = drinkItems + 1
    end
    print("[Food & Drinks] Registered "..drinkItems.." alcohol items.")
end