

ix.currency.Set("$", "Dollar", "Dollars", "models/kek1ch/money_usa.mdl")
ix.config.Set("intro", false)
ix.config.SetDefault("intro", false)
ix.config.SetDefault("music", "")
ix.config.SetDefault("maxAttributes", 60)
ix.config.Add("minNameLength", 2, "The minimum number of characters in a name.", nil, {data = {min = 2, max = 32}, category = "characters"})
