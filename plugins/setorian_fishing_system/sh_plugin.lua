local PLUGIN = PLUGIN
PLUGIN.name = "Fishing"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "Catch and sell fish"


PLUGIN.fishes = {

	{
		FName = "Anchovy",
		FModel = "models/tsbb/fishes/anchovy.mdl",
		FDesc = "A small shoaling fish of commercial importance as a food fish and as bait. It is strongly flavoured and is usually preserved in salt and oil.",
		FChance = 0.5
	},
	{
		FName = "Angel",
		FModel = "models/tsbb/fishes/angelfish.mdl",
		FDesc = "A black and silver laterally compressed South American cichlid fish.",
		FChance = 0.35
	},
	{
		FName = "Ayu",
		FModel = "models/tsbb/fishes/ayu.mdl",
		FDesc = "A small salmonlike anadromous fish of Japan that is highly esteemed as a food fish. called also sweetfish.",
		FChance = 0.2
	},
	{
		FName = "Arowana",
		FModel = "models/tsbb/fishes/arowana.mdl",
		FDesc = "Arowanas are freshwater bony fish of the subfamily Osteoglossinae, also known as bony tongues.",
		FChance = 0.8
	},
	{
		FName = "Bass",
		FModel = "models/tsbb/fishes/bass.mdl",
		FDesc = "A small European freshwater bony fish.",
		FChance = 0.7
	},
	{
		FName = "Betta",
		FModel = "models/tsbb/fishes/betta.mdl",
		FDesc = "A small brilliantly colored long-finned freshwater bony fishes.",
		FChance = 0.65
	},
	{
		FName = "Barracuda",
		FModel = "models/tsbb/fishes/barracuda.mdl",
		FDesc = "A elongated, predaceous, tropical and subtropical marine fishes of the genus Sphyraena, certain species of which are used for food.",
		FChance = 0.45
	},
	{
		FName = "Barramundi",
		FModel = "models/tsbb/fishes/barramundi.mdl",
		FDesc = "A catadromous bony fish with a greenish-bronze back and silvery sides.",
		FChance = 0.5
	},
	{
		FName = "Betta",
		FModel = "models/tsbb/fishes/betta.mdl",
		FDesc = "A small brilliantly colored long-finned freshwater bony fishes.",
		FChance = 0.76
	},
	{
		FName = "Bitterling",
		FModel = "models/tsbb/fishes/bitterling.mdl",
		FDesc = "A small brightly coloured European freshwater cyprinid fish.",
		FChance = 0.5
	},
	{
		FName = "Blob",
		FModel = "models/tsbb/fishes/blobfish.mdl",
		FDesc = "A foot-long pink fish. It has soft bones and few muscles and lacks a swim bladder, the gas-filled internal organ that allows most bony fish to control their ability to stay afloat in water.",
		FChance = 0.35
	},
	{
		FName = "Carp",
		FModel = "models/tsbb/fishes/carp.mdl",
		FDesc = "An oily freshwater fish from various species of the family Cyprinidae, a very large group of fish native to Europe and Asia.",
		FChance = 0.8
	},
	{
		FName = "Cat",
		FModel = "models/tsbb/fishes/catfish.mdl",
		FDesc = "An extremely diverse group of ray-finned fish that get their nickname from their feline-looking whiskers.",
		FChance = 0.65
	},
	{
		FName = "Cod",
		FModel = "models/tsbb/fishes/cod.mdl",
		FDesc = "A dark-spotted fish with three dorsal fins, two anal fins, and a chin barbel.",
		FChance = 0.65
	},
	{
		FName = "Fangtooth",
		FModel = "models/tsbb/fishes/fangtooth.mdl",
		FDesc = "Small fish with laterally compressed body. Head and mouth are very large and mouth is full of very large (relative to body size), pointed sharp teeth. Light coloured grooved lateral line curves upwards towards the relatively small eyes. A single dorsal fin is present and the tail is deeply forked.",
		FChance = 0.25
	},
	{
		FName = "Flying",
		FModel = "models/tsbb/fishes/flying_fish.mdl",
		FDesc = "Small, attaining a maximum length of about 18 inches, and have winglike, rigid fins and an unevenly forked tail.",
		FChance = 0.45
	},
	{
		FName = "Frog",
		FModel = "models/tsbb/fishes/frogfish.mdl",
		FDesc = "Robust, rather lumpy fishes with large mouths and, often, prickly skins.",
		FChance = 0.55
	},
	{
		FName = "Goby",
		FModel = "models/tsbb/fishes/goby.mdl",
		FDesc = "These are typically elongated, sometimes scaleless fishes found along shores and among reefs in tropical and temperate seas.",
		FChance = 0.75
	},
	{
		FName = "Gold",
		FModel = "models/tsbb/fishes/goldfish.mdl",
		FDesc = "Goldfish have two sets of paired fins and three sets of single fins. They don't have barbels, sensory organs some fish have that act like taste buds.",
		FChance = 0.15
	},
	{
		FName = "Grouper",
		FModel = "models/tsbb/fishes/grouper.mdl",
		FDesc = "Groupers are teleosts, typically having a stout body and a large mouth.",
		FChance = 0.35
	},
	{
		FName = "Guppy",
		FModel = "models/tsbb/fishes/guppy.mdl",
		FDesc = "The guppy is hardy, energetic, easily kept, and prolific.",
		FChance = 0.5
	},
	{
		FName = "Halibut",
		FModel = "models/tsbb/fishes/halibut.mdl",
		FDesc = "Halibut are demersal fish and are highly regarded as a food fish as well as a sport fish.",
		FChance = 0.5
	},
	{
		FName = "Humphead Wrasse",
		FModel = "models/tsbb/fishes/humphead_wrasse.mdl",
		FDesc = "The humphead wrasse is an enormous coral reef fish—growing over six feet long—with a prominent bulge on its forehead.",
		FChance = 0.4
	},
	{
		FName = "Japanese Perch",
		FModel = "models/tsbb/fishes/japanese_perch.mdl",
		FDesc = "Japanese perch are greenish with red pelvic, anal and caudal fins. They have five to eight dark vertical bars on their sides",
		FChance = 0.7
	},
	{
		FName = "Loach",
		FModel = "models/tsbb/fishes/loach.mdl",
		FDesc = "Loaches are small with a long slender body. They always have more than two pairs of barbels around an underslung mouth (4 in the front and 2 at the corners).",
		FChance = 0.8
	},
	{
		FName = "Lung",
		FModel = "models/tsbb/fishes/lungfish.mdl",
		FDesc = "Lungfish have a long, narrow body, and certain species can survive periods of drought inside a mucus-lined cocoon in the mud..",
		FChance = 0.7
	},
	{
		FName = "Mackerel",
		FModel = "models/tsbb/fishes/mackerel.mdl",
		FDesc = "Mackerels are rounded and torpedo-shaped, with a slender, keeled tail base, a forked tail, and a row of small finlets behind the dorsal and anal fins.",
		FChance = 0.75
	},
	{
		FName = "Minnow",
		FModel = "models/tsbb/fishes/minnow.mdl",
		FDesc = "A small fish that is found in freshwater streams and rivers and, less frequently, in lakes.",
		FChance = 0.9
	},
	{
		FName = "Mullet",
		FModel = "models/tsbb/fishes/mullet.mdl",
		FDesc = "Mullets are torpedo-shaped fishes with horizontal mouths. They have two well-separated dorsal fins. The first dorsal has 4 spines.",
		FChance = 0.7
	},
	{
		FName = "Neon Tetra",
		FModel = "models/tsbb/fishes/neon_tetra.mdl",
		FDesc = "A slender fish that is very popular with aquarium owners. It grows to a length of 1.5 inches, its hind parts are coloured a gleaming red, and its sides have a neonlike blue-green stripe..",
		FChance = 0.7
	},
	{
		FName = "Parrot",
		FModel = "models/tsbb/fishes/parrot_fish.mdl",
		FDesc = "Parrot fishes are elongated, usually rather blunt-headed and deep-bodied, and often very brightly coloured. They have large scales and a characteristic birdlike beak formed by the fused teeth of the jaws.",
		FChance = 0.6
	},
	{
		FName = "Pollock",
		FModel = "models/tsbb/fishes/pollock.mdl",
		FDesc = "an elongated fish, deep green with a pale lateral line and a pale belly. It has a small chin barbel and, like the cod, has three dorsal and two anal fins.",
		FChance = 0.5
	},
	{
		FName = "Sardine",
		FModel = "models/tsbb/fishes/sardine.mdl",
		FDesc = "Sardines are small, silvery, elongated fishes with a single short dorsal fin, no lateral line, and no scales on the head.",
		FChance = 0.8
	},
	{
		FName = "Siamese tiger",
		FModel = "models/tsbb/fishes/siamese_tigerfish.mdl",
		FDesc = "It has vertical yellow and black stripes running the length of its body. The dorsal fin has a spiny appearance.",
		FChance = 0.7
	},
	{
		FName = "Snail",
		FModel = "models/tsbb/fishes/snailfish.mdl",
		FDesc = "An elongated, tadpole-like shape. Their heads are large in comparison to their body and they have small eyes.",
		FChance = 0.55
	},
	{
		FName = "Snapper",
		FModel = "models/tsbb/fishes/snapper.mdl",
		FDesc = "Active, schooling fishes with elongated bodies, large mouths, sharp canine teeth, and blunt or forked tails, snappers are usually rather large, many attaining a length of 2–3 feet. They are carnivores and prey on crustaceans and other fishes.",
		FChance = 0.5
	},
	{
		FName = "Stickleback",
		FModel = "models/tsbb/fishes/stickleback.mdl",
		FDesc = "Sticklebacks are small, scaleless fishes. They have 2-10 stout, unconnected dorsal spines followed by a soft dorsal fin. The caudal peduncle is narrow, and the tail fin is rounded to slightly concave. The pelvic fins are thoracic.",
		FChance = 0.45
	},
	{
		FName = "Surgeon",
		FModel = "models/tsbb/fishes/surgeon_fish.mdl",
		FDesc = "Surgeonfishes are small-scaled, with a single dorsal fin and one or more distinctive, sharp spines that are located on either side of the tail base and can produce deep cuts.",
		FChance = 0.45
	},
	{
		FName = "Trout",
		FModel = "models/tsbb/fishes/trout.mdl",
		FDesc = "Trout is the common name given to a number of species of freshwater fish belonging to the salmon family, Salmonidae. Trout are usually found in cool, clear streams and lakes, although many of the species have anadromous strains, as well.",
		FChance = 0.8
	},
	{
		FName = "Tuna",
		FModel = "models/tsbb/fishes/tuna.mdl",
		FDesc = "Tunas are elongated, robust, and streamlined fishes; they have a rounded body that tapers to a slender tail base and a forked or crescent-shaped tail. In colour, tunas are generally dark above and silvery below, often with an iridescent shine.",
		FChance = 0.75
	},
	
}

function PLUGIN:InitializedPlugins()

    print("[Setorian Fishing System] Registering fishes items...")

    local fishItems = 0

    for k,v in ipairs(PLUGIN.fishes) do
        local ITEM = ix.item.Register(string.lower(string.Replace(string.Replace(v.FName,"'", "")," ","_")) .. "_fish", nil, false, nil, true)
        ITEM.name = v.FName .. " Fish"
        ITEM.description = v.FDesc
        ITEM.model = v.FModel
        ITEM.width = 1
        ITEM.height = 1
        ITEM.category = "Fishes"
        

		fishItems = fishItems + 1

    end

    print("[Setorian Fishing System] Registered "..fishItems.." fishes items.")
end