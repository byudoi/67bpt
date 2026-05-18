return {
	["Minify"] = {
		LuaVersion = "Lua51", VarNamePrefix = "", NameGenerator = "MangledShuffled",
		PrettyPrint = false, Seed = 0, Steps = {},
	},
	["Weak"] = {
		LuaVersion = "Lua51", VarNamePrefix = "", NameGenerator = "MangledShuffled",
		PrettyPrint = false, Seed = 0,
		Steps = {
			{ Name = "Vmify", Settings = {} },
			{ Name = "ConstantArray", Settings = { Threshold = 1, StringsOnly = true } },
			{ Name = "WrapInFunction", Settings = {} },
		},
	},
	["Medium"] = {
		LuaVersion = "Lua51", VarNamePrefix = "", NameGenerator = "MangledShuffled",
		PrettyPrint = false, Seed = 0,
		Steps = {
			{ Name = "EncryptStrings", Settings = {} },
			{ Name = "AntiTamper", Settings = { UseDebug = false } },
			{ Name = "Vmify", Settings = {} },
			{ Name = "ConstantArray", Settings = { Threshold = 1, StringsOnly = true, Shuffle = true, Rotate = true, LocalWrapperThreshold = 0 } },
			{ Name = "NumbersToExpressions", Settings = {} },
			{ Name = "WrapInFunction", Settings = {} },
		},
	},
	["Strong"] = {
		LuaVersion = "Lua51", VarNamePrefix = "", NameGenerator = "MangledShuffled",
		PrettyPrint = false, Seed = 0,
		Steps = {
			{ Name = "Vmify", Settings = {} },
			{ Name = "EncryptStrings", Settings = {} },
			{ Name = "AntiTamper", Settings = { UseDebug = false } },
			{ Name = "Vmify", Settings = {} },
			{ Name = "ConstantArray", Settings = { Threshold = 1, StringsOnly = true, Shuffle = true, Rotate = true, LocalWrapperThreshold = 0 } },
			{ Name = "NumbersToExpressions", Settings = { NumberRepresentationMutation = true } },
			{ Name = "WrapInFunction", Settings = {} },
		},
	},
}
