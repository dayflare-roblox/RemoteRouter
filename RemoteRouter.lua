local RemoteRouter = {}

--[[
¦¦¦¦¦¦+¦¦¦¦¦¦¦+¦¦¦+¦¦¦¦¦+¦¦¦¦¦¦¦+¦¦+¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦¦¦¦+¦¦¦¦¦¦¦¦+
¦¦+--¦¦+¦¦+--¦¦++¦¦+¦¦¦++¦¦+----+¦¦¦¦¦¦¦¦¦¦+--¦¦+¦¦+--¦¦+¦¦+----+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦++¦¦¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦++¦¦¦¦¦+¦¦
¦¦¦¦¦¦¦¦¦¦+--¦¦¦¦¦+¦¦++¦¦¦¦+--+¦¦¦¦¦¦¦¦¦¦¦¦+--¦¦¦¦¦+--¦¦+¦¦+--+¦¦
¦¦¦¦¦¦++¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦+
+-----+¦+-+¦¦+-+¦¦¦+-+¦¦¦+-+¦¦¦¦¦+------++-+¦¦+-++-+¦¦+-++------+
]]

local Storage = game.ReplicatedStorage:FindFirstChild("RemoteRouterStorage") or Instance.new("Folder", game.ReplicatedStorage)
Storage.Name = "RemoteRouterStorage"

RemoteRouter.LogAllPass = false

function RemoteRouter.new(TypeOfRemote: string, RemoteName: string, Log: boolean)
	local EventOrFunction = nil
	
	if Storage:FindFirstChild(RemoteName, true) then
		warn("Supplied RemoteName already exists.")
		return EventOrFunction
	end
	
	local success, err = pcall(function()
		if TypeOfRemote ~= "RemoteEvent" and TypeOfRemote ~= "RemoteFunction" then
			return error("Supplied TypeOfRemote is not a valid instance.")
		end
		EventOrFunction = Instance.new(TypeOfRemote, Storage)
	end)
	
	if err then
		warn("Supplied TypeOfRemote is not a valid instance.")
		return EventOrFunction
	end
	
	EventOrFunction.Name = RemoteName
	
	if Log then
		if EventOrFunction:IsA("RemoteEvent") then
			if game.Players.LocalPlayer then
				EventOrFunction.OnClientEvent:Connect(function(...)
					print("Server called the client "..EventOrFunction.Name.." with", ...)
				end)
				return
			end
			
			EventOrFunction.OnServerEvent:Connect(function(Player, ...)
				print(Player.Name.." ("..Player.UserId..") called event "..EventOrFunction.Name.." with parameters ", ...)
			end)
		elseif EventOrFunction:IsA("RemoteFunction") then
			if game.Players.LocalPlayer then
				EventOrFunction.OnClientInvoke = function(...)
					print("Server called the client function "..EventOrFunction.Name.." with", ...)
				end
				return
			end
			
			EventOrFunction.OnServerInvoke = function(Player, ...)
				print(Player.Name.." ("..Player.UserId..") invoked function "..EventOrFunction.Name.." with parameters ", ...)
			end
		end
	end
	
	return EventOrFunction
end

function RemoteRouter.get(RemoteName: string)
	return Storage:FindFirstChild(RemoteName, true)
end

return RemoteRouter
