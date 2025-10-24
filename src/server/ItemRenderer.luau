local React = require(game.ReplicatedStorage.Packages.React)
local e = React.createElement
local useEffect = React.useEffect
local useState = React.useState

local Dummies = require(script.Parent.Dummies)
local ICDummies = Dummies.ItemConfigs
local PDDummy = Dummies.PlayerData

local function Item(props: {
	Owned: boolean,
	ItemId: string,
	RootArea: Part,
	BuyButton: (ItemId: string) -> nil,
})
	useEffect(function()
		local button: Model, model: Model
		if props.Owned then
			model = Dummies:GetModelFromItemId(props.ItemId)
			local cf = props.RootArea
				:GetPivot()
				:ToWorldSpace(workspace.OriginalBase.RootArea:GetPivot():ToObjectSpace(model:GetPivot()))
			model:PivotTo(cf)
			model.Parent = workspace
		else
			model = Dummies:GetModelFromItemId(props.ItemId)
			button = Dummies:GetButton()
			local cf = props.RootArea
				:GetPivot()
				:ToWorldSpace(workspace.OriginalBase.RootArea:GetPivot():ToObjectSpace(model:GetPivot()))
			button:PivotTo(cf)
			button.Parent = workspace;
			(button.Part.BillboardGui.TextLabel :: TextLabel).Text = props.ItemId
			local touched = false
			button.PrimaryPart.Touched:Connect(function(part: Part)
				if not part.Name == "HumanoidRootPart" and part.Parent:FindFirstChild("Humanoid") or touched then
					return
				end

				touched = true

				props.BuyButton(props.ItemId)
				local Debris = game:GetService("Debris")
				local pemitter = (function()
					local clone = workspace.ParticlePart:Clone()
					clone:PivotTo(cf)
					clone.Parent = workspace
					return clone
				end)()
				Debris:AddItem(pemitter, 3)
				task.wait(1 / 30)
				pemitter.ParticleEmitter:Emit()
			end)
		end
		return function()
			if model then
				model:Destroy()
			end
			if button then
				button:Destroy()
			end
		end
	end, { props.Owned })
	return e("Folder")
end

local function ItemRenderer()
	local players, setPlayers = useState(nil)
	local cashes, setCashes = useState(nil)
	local PlayerData, setPlayerData = useState(PDDummy)
	local children = {}

	useEffect(function()
		game.Players.PlayerAdded:Connect(function(player)
			setPlayers(game.Players:GetPlayers())
		end)
	end, {})

	useEffect(function()
		local cashesx = {}
		for i, player in players do
			local leaderstats = player:FindFirstChild("leaderstats")
				or pcall(function()
					local folder = Instance.new("Folder", player)
					folder.Name = "leaderstats"
					return folder
				end)
			local Cash = leaderstats:FindFirstChild("Cash")
				or pcall(function()
					local cashValue = Instance.new("IntValue", player)
					cashValue.Name = "Cash"
					return cashValue
				end)
			table.insert(cashesx)
		end
		setCashes(cashesx)
		return
	end, { players })

	local function BuyButton(ItemId: string)
		setPlayerData(function(prev)
			PDDummy.Cash -= ICDummies[ItemId].Price
			PDDummy.OwnedItems[ItemId] = true
			for i, unlockedItemId in ICDummies[ItemId].Unlocks or {} do
				PDDummy.UnlockedItems[unlockedItemId] = true
			end
			local clone = table.clone(PDDummy)
			return clone
		end)
	end

	local unowned = 0
	for i, itemConfig in ipairs(ICDummies) do
		warn(itemConfig.ItemId)
		local unlocked = PlayerData.UnlockedItems[itemConfig.ItemId]
		if not unlocked then
			continue
		end

		local owned = PlayerData.OwnedItems[itemConfig.ItemId]
		if not owned then
			unowned += 1
		end
		if (unowned > 3) and not owned then
			continue
		end
		children[itemConfig.ItemId] = e(Item, {
			key = itemConfig.ItemId,
			Owned = owned,
			ItemId = itemConfig.ItemId,
			RootArea = workspace.EmptyBase.RootArea,
			BuyButton = BuyButton,
		})
	end
	return e("Folder", {
		Name = "ItemRenderer",
	}, children)
end

return ItemRenderer
