local ModelFolder = workspace.OriginalBase.Items
local ItemConfigs = {
	floor = {
		ItemId = "floor",
		Price = 50,
		Unlocks = {
			"chair",
			"table",
			"lamp",
		},
	},
	chair = {
		ItemId = "chair",
		Price = 50,
	},
	table = {
		ItemId = "table",
		Price = 50,
	},
	lamp = {
		ItemId = "lamp",
		Price = 50,
	},
}

local PlayerData = {
	Cash = 400,
	UnlockedItems = {
		["floor"] = true,
	},
	OwnedItems = {},
}

return {
	ItemConfigs = ItemConfigs,
	ModelFolder = ModelFolder,
	PlayerData = PlayerData,
	OriginalBase = workspace.OriginalBase,
	GetModelFromItemId = function(self, ItemId: string)
		local model = ModelFolder:FindFirstChild(ItemId)
		warn("Getting", ItemId)
		return model and model:Clone() or workspace.Error:Clone()
	end,
	GetButton = function()
		return workspace.Button:Clone()
	end,
}
