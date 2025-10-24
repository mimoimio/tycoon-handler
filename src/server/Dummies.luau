local ModelFolder = workspace.OriginalBase.Items
local ItemConfigs = {
	{
		ItemId = "floor",
		Price = 50,
		Unlocks = {
			"door",
			"chair",
			"table",
			"lamp",
			"floor2",
			"wall",
			"wall2",
			"wall3",
		},
	},
	{
		ItemId = "chair",
		Price = 50,
	},
	{
		ItemId = "table",
		Price = 50,
	},
	{
		ItemId = "lamp",
		Price = 50,
	},
	{
		ItemId = "door",
		Price = 50,
	},
	{
		ItemId = "wall",
		Price = 50,
	},
	{
		ItemId = "wall2",
		Price = 50,
	},
	{
		ItemId = "wall3",
		Price = 50,
	},

	{
		ItemId = "floor2",
		Price = 50,
		Unlocks = {
			"wall4",
			"wall5",
			"wall6",
			"floor3",
		},
	},
	{
		ItemId = "wall4",
		Price = 50,
	},
	{
		ItemId = "wall5",
		Price = 50,
	},
	{
		ItemId = "wall6",
		Price = 50,
	},

	{
		ItemId = "floor3",
		Price = 50,
		Unlocks = {
			"wall7",
			"wall8",
			"wall9",
			"floor3",
		},
	},
	{
		ItemId = "wall7",
		Price = 50,
	},
	{
		ItemId = "wall8",
		Price = 50,
	},
	{
		ItemId = "wall9",
		Price = 50,
	},
}
for i, itemConfig in ItemConfigs do
	ItemConfigs[itemConfig.ItemId] = itemConfig
end

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
		if model then
			warn("Done")
			return model:Clone(), true
		else
			task.spawn(function()
				warn("Fuck.")
				error("!!!NO MODEL FOUND!!!")
			end)
			return workspace.Error:Clone(), false
		end
	end,
	GetButton = function()
		return workspace.Button:Clone()
	end,
	GetItemFromItemId = function(self, ItemId: string)
		for i, itemConfig in ItemConfigs do
			if itemConfig.ItemId ~= ItemId then
				continue
			end
			return itemConfig
		end
	end,
}
