local PlayerLoaded = false
local FirstSpawn = true
local LastSkin = nil
local CharacterCam = nil
local heading = nil
local zoomOffset = 0.4
local CharacterAngle = 90
local CharacterHeading = 0.75
local CharacterOffset = 0.0
local CharacterSubmitCb = nil
local CharacterCancelCb = nil
local elements = {}

local changeElementsTo0 = {
	["tshirt_1"] = "tshirt_2",
	["torso_1"] = "torso_2",
	["decals_1"] = "decals_2",
	["arms"] = "arms_2",
	["pants_1"] = "pants_2",
	["shoes_1"] = "shoes_2",
	["mask_1"] = "mask_2",
	["bproof_1"] = "bproof_2",
	["chain_1"] = "chain_2",
	["helmet_1"] = "helmet_2",
	["glasses_1"] = "glasses_2",
	["watches_1"] = "watches_2",
	["bracelets_1"] = "bracelets_2",
	["bags_1"] = "bags_2",
	["ears_1"] = "ears_2",
}

local tattoOutfits = {
	male = {
		['torso_1'] = 15,
		['tshirt_1'] = 15,
		['arms'] = 15,
		['pants_1'] = 14,
		['shoes_1'] = 5
	},
	female = {
		['torso_1'] = 15,
		['tshirt_1'] = 15,
		['arms'] = 15,
		['pants_1'] = 15,
		['shoes_1'] = 15
	}
}

local client = {}

local tattooList = {}
local tattooChangeCb = nil
local currentTattooSelection = nil
RegisterNetEvent('esx_skin:openTattooshop', function(elements, changeCb)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local tattooOutfit = tattoOutfits[skin.sex == 0 and 'male' or 'female']
		TriggerEvent('skinchanger:loadClothes', skin, tattooOutfit)
		LastSkin = skin
	end)
	
	tattooList = elements
	tattooChangeCb = changeCb

	SendNUIMessage({
		action = "OpenMenu",
		elements = elements,
		tattooShop = true
	})
	SetNuiFocus(true, true)

	CreateSkinCam()
end)

client.LoadDict = function(dict)
	RequestAnimDict(dict)
	repeat Wait(1)
	until HasAnimDictLoaded(dict)
	return dict
end
local LoadDict = client.LoadDict

client.useClothing = function(data, slot)
	local clothes = exports.ox_inventory:Search('slots', data.name)
	for k, v in pairs(clothes) do
		if v.slot == data.slot then
			client.putOn(data.name, v.metadata.type, v.metadata.type2)
		end
	end
end
exports('useClothing', client.useClothing)
-- no co mam powiedziec skaza zapomial loadera dac pozdro loxi topka
client.putOn = function(action, metadata, metadata2)
	local playerPed = PlayerPedId()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin then
			if action == 'chain' then
				if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
					TaskPlayAnim(playerPed, LoadDict("clothingtie"), "check_out_a", 8.0, -8.0, -1, 48, 0, false, false, false)
				end
				
				Citizen.Wait(3000)
				StopAnimTask(playerPed, "clothingtie", "check_out_a", 1.0)
				RemoveAnimDict('clothingtie')
				if 0 == skin.chain_1 then

					TriggerServerEvent('waves-clothing:removeClothes', 'chain', metadata, metadata2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['chain_1'] = metadata,
						['chain_2'] = metadata2
					})						

				end
			elseif action == 'mask' then
				if 0 == skin.mask_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("mp_masks@on_foot"), "put_on_mask", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(1000)
					StopAnimTask(playerPed, "mp_masks@on_foot", "put_on_mask", 1.0)
					RemoveAnimDict('mp_masks@on_foot')
					TriggerServerEvent('waves-clothing:removeClothes', 'mask', metadata, metadata2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['mask_1'] = metadata,
						['mask_2'] = metadata2
					})						

				end
		  elseif action == 'hat' then
				if -1 == skin.helmet_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("missheistdockssetup1hardhat@"), "put_on_hat", 8.0, -8.0, -1, 32, 0, false, false, false)
					end
					Citizen.Wait(1300)
					StopAnimTask(playerPed, "missheistdockssetup1hardhat@", "put_on_hat", 1.0)
					RemoveAnimDict('missheistdockssetup1hardhat@')
					TriggerServerEvent('waves-clothing:removeClothes', 'hat', metadata, metadata2)
					
					TriggerEvent('skinchanger:loadClothes', skin, {
						['helmet_1'] = metadata,
						['helmet_2'] = metadata2
					})						
				end
			elseif action == 'zegarek' then
				if -1 == skin.watches_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("anim@random@shop_clothes@watches"), "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
					end
					
					Citizen.Wait(1600)
					StopAnimTask(playerPed, "anim@random@shop_clothes@watches", "idle_d", 1.0)
					RemoveAnimDict('anim@random@shop_clothes@watches')
					TriggerServerEvent('waves-clothing:removeClothes', 'zegarek', metadata, metadata2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['watches_1'] = metadata,
						['watches_2'] = metadata2
					})						

				end
			elseif action == 'branzoleta' then
				if -1 == skin.bracelets_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingshoes"), "try_shoes_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end
		
					Citizen.Wait(1600)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_a", 1.0)
					RemoveAnimDict('clothingshoes')
					TriggerServerEvent('waves-clothing:removeClothes', 'branzoleta', metadata, metadata2)

					TriggerEvent('skinchanger:loadClothes', skin, {
						['bracelets_1'] = metadata,
						['bracelets_2'] = metadata2
					})						
				end
			elseif action == 'glasses' then
				if skin.sex == 0 and 0 == skin.glasses_1 or skin.sex == 1 and 5 == skin.glasses_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingspecs"), "try_glasses_negative_b", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(1100)
					StopAnimTask(playerPed, "clothingspecs", "try_glasses_negative_b", 1.0)
					RemoveAnimDict('clothingspecs')
					TriggerServerEvent('waves-clothing:removeClothes', 'glasses', metadata, metadata2)

					TriggerEvent('skinchanger:loadClothes', skin, {
						['glasses_1'] = metadata,
						['glasses_2'] = metadata2
					})						

				end
			elseif action == 'bag' then
				if 0 == skin.bags_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "check_out_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end
	
					Citizen.Wait(1500)
					StopAnimTask(playerPed, "clothingshirt", "check_out_a", 1.0)
					RemoveAnimDict('clothingshirt')
					TriggerServerEvent('waves-clothing:removeClothes', 'bag', metadata, metadata2)

					TriggerEvent('skinchanger:loadClothes', skin, {
						['bags_1'] = metadata,
						['bags_2'] = metadata2
					})						

				end
			elseif action == 'tshirt' then	
				if skin.sex == 0 then
					if 15 == skin.tshirt_1 then
						if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
							TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "try_shirt_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
						end
		
						Wait(2000)
						StopAnimTask(playerPed, "clothingshirt", "try_shirt_positive_a", 1.0)
						RemoveAnimDict('clothingshirt')
						TriggerServerEvent('waves-clothing:removeClothes', 'tshirt', metadata, metadata2)

						TriggerEvent('skinchanger:loadClothes', skin, {
							['tshirt_1'] = metadata,
							['tshirt_2'] = metadata2
						})						

					end
				elseif skin.sex == 1 then
					if 15 == skin.tshirt_1 then
						if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
							TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "try_shirt_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
						end
		
						Wait(2000)
						StopAnimTask(playerPed, "clothingshirt", "try_shirt_positive_a", 1.0)
						RemoveAnimDict('clothingshirt')
						TriggerServerEvent('waves-clothing:removeClothes', 'tshirt', metadata, metadata2)

						TriggerEvent('skinchanger:loadClothes', skin, {
							['tshirt_1'] = metadata,
							['tshirt_2'] = metadata2
							-- ['arms'] = value.arms,
							-- ['arms_2'] = value.arms_2
						})						
					end
				end
			elseif action == 'coat' then

				if skin.sex == 0 then
					if 15 == skin.torso_1 then
						if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
							TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "try_shirt_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
						end
		
						Wait(2000)
						StopAnimTask(playerPed, "clothingshirt", "try_shirt_positive_a", 1.0)
						RemoveAnimDict('clothingshirt')
						TriggerServerEvent('waves-clothing:removeClothes', 'coat', metadata, metadata2)

						TriggerEvent('skinchanger:getSkin', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, {
								['torso_1'] = metadata,
								['torso_2'] = metadata2,
								['arms'] = LocalPlayer.state.armsCached['arms'],
								['arms_2'] = LocalPlayer.state.armsCached['arms_2']
							})
						end)	
					end
				elseif skin.sex == 1 then
					if 15 == skin.torso_1 then
						if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
							TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "try_shirt_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
						end
		
						Wait(2000)
						StopAnimTask(playerPed, "clothingshirt", "try_shirt_positive_a", 1.0)
						RemoveAnimDict('clothingshirt')
						TriggerServerEvent('waves-clothing:removeClothes', 'coat', metadata, metadata2)
						TriggerEvent('skinchanger:loadClothes', skin, {
							['torso_1'] = metadata,
							['torso_2'] = metadata2,
						})	
					end
				end
			elseif action == 'kamizelka' then
				local a = GetPedArmour(playerPed)
				
				if a >= 0 then	
					if 0 == skin.bproof_1 then
						if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
							TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "check_out_c", 8.0, 8.0, -1, 50, 0, false, false, false)
						end
	
						Citizen.Wait(1500)
						StopAnimTask(playerPed, "clothingshirt", "check_out_c", 1.0)
						RemoveAnimDict('clothingshirt')
						TriggerServerEvent('waves-clothing:removeClothes', 'kamizelka', metadata, metadata2)

						TriggerEvent('skinchanger:loadClothes', skin, {
							['bproof_1'] = metadata,
							['bproof_2'] = metadata2
						})						

					end
				else
					ESX.ShowNotification('~r~Nie możesz ściągnąć kamizelki')
				end
			elseif action == 'legs' then	
				if 61 == skin.pants_1 and skin.sex == 0 or 15 == skin.pants_1 and skin.sex == 1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingtrousers"), "try_trousers_neutral_c", 44.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(2500)
					StopAnimTask(playerPed, "clothingtrousers", "try_trousers_neutral_c", 1.0)
					RemoveAnimDict('clothingtrousers')
					TriggerServerEvent('waves-clothing:removeClothes', 'legs', metadata, metadata2)
	
					TriggerEvent('skinchanger:loadClothes', skin, {
						['pants_1'] = metadata,
						['pants_2'] = metadata2
					})						

				end
			elseif action == 'shoes' then
				if 34 == skin.shoes_1 and skin.sex == 0 or 35 == skin.shoes_1 and skin.sex == 1 then
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingshoes"), "try_shoes_positive_d", 44.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(2250)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_d", 1.0)
					RemoveAnimDict('clothingshoes')
					TriggerServerEvent('waves-clothing:removeClothes', 'shoes', metadata, metadata2)
					
					TriggerEvent('skinchanger:loadClothes', skin, {
						['shoes_1'] = metadata,
						['shoes_2'] = metadata2
					})						

				end	
			end
		end
	end)
	Citizen.Wait(3000)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:save', skin)
	end)
end

local canUse = true

RegisterNetEvent('waves-clothing:takeOff', function(action)
	local action = action.what
	if not canUse then
		return
	end
	local playerPed = PlayerPedId()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if (skin) then
			if action == 'chain' then
				if skin.chain ~= -1 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingtie"), "check_out_a", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(3000)
					StopAnimTask(playerPed, "clothingtie", "check_out_a", 1.0)
					RemoveAnimDict('clothingtie')
					TriggerServerEvent('waves-clothing:giveClothes', 'chain', skin.chain_1, skin.chain_2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['chain_1'] = 0,
						['chain_2'] = 0
					})						
					canUse = true

				end
				
				
			elseif action == 'mask' then

				if skin.mask_1 ~= 0 and skin.mask_2 ~= 0 then
					canUse = false
					TriggerServerEvent('waves-clothing:giveClothes', 'mask', skin.mask_1, skin.mask_2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['mask_1'] = 0,
						['mask_2'] = 0
					}, function()
						SetPedHeadBlendData(playerPed, value.face_1, skin['face_2'], skin['face_3'], skin['skin'], skin['skin_2'], skin['skin_3'], skin['blend_face'] / 10, skin['blend_skin'] / 10, skin['blend'] / 10, true)
					end)	
					canUse = true						
						
				end
				
		  elseif action == 'hat' then
				
				if skin.helmet_1 ~= -1 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("missheist_agency2ahelmet"), "take_off_helmet_stand", 8.0, -8.0, -1, 32, 0, false, false, false)
					end
					Citizen.Wait(900)
					StopAnimTask(playerPed, "missheist_agency2ahelmet", "take_off_helmet_stand", 1.0)
					RemoveAnimDict('missheist_agency2ahelmet')
					TriggerServerEvent('waves-clothing:giveClothes', 'hat', skin.helmet_1, skin.helmet_2)
					
					TriggerEvent('skinchanger:loadClothes', skin, {
						['helmet_1'] = -1,
						['helmet_2'] = 0
					}, function()
						SetPedComponentVariation(playerPed, 2, value.hair_1, skin['hair_2'], 2)	
					end)	
					canUse = true														
						
				end
				
			elseif action == 'zegarek' then
				
				if skin.watches_1 ~= -1 then 
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("anim@random@shop_clothes@watches"), "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
					end

					Citizen.Wait(1600)
					StopAnimTask(playerPed, "anim@random@shop_clothes@watches", "idle_d", 1.0)
					RemoveAnimDict('anim@random@shop_clothes@watches')
					TriggerServerEvent('waves-clothing:giveClothes', 'zegarek', skin.watches_1, skin.watches_2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['watches_1'] = -1,
						['watches_2'] = 0
					})
					canUse = true
				end
	
			elseif action == 'branzoleta' then
				
				if skin.bracelets_1 ~= 0 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingshoes"), "try_shoes_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end
					
					Citizen.Wait(1600)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_a", 1.0)
					RemoveAnimDict('clothingshoes')

					TriggerServerEvent('waves-clothing:giveClothes', 'branzoleta', skin.bracelets_1, skin.bracelets_2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['bracelets_1'] = 0,
						['bracelets_2'] = 0
					})
					canUse = true
				end
				
			elseif action == 'glasses' then
				
				if skin.glasses_1 ~= 0 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingspecs"), "take_off", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(1200)
					StopAnimTask(playerPed, "clothingspecs", "take_off", 1.0)
					RemoveAnimDict('clothingspecs')

					TriggerServerEvent('waves-clothing:giveClothes', 'glasses', skin.glasses_1, skin.glasses_2)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, {
							['glasses_1'] = 0,
							['glasses_2'] = 0
						})
					else
						TriggerEvent('skinchanger:loadClothes', skin, {
							['glasses_1'] = 5,
							['glasses_2'] = 0
						})
					end
					canUse = true
				end
				
			elseif action == 'bag' then
				if skin.bags_1 ~= 0 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "check_out_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end

					Citizen.Wait(1500)
					StopAnimTask(playerPed, "clothingshirt", "check_out_a", 1.0)
					RemoveAnimDict('clothingshirt')
					TriggerServerEvent('waves-clothing:giveClothes', 'bag', skin.bags_1, skin.bags_2)
					TriggerEvent('skinchanger:loadClothes', skin, {
						['bags_1'] = 0,
						['bags_1'] = 0
					})
					canUse = true
				end
				
			elseif action == 'tshirt' then

				if skin.tshirt_1 ~= 15 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "try_shirt_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end

					Wait(2000)
					StopAnimTask(playerPed, "clothingshirt", "try_shirt_positive_a", 1.0)
					RemoveAnimDict('clothingshirt')
					if skin.sex == 0 then
						
						TriggerServerEvent('waves-clothing:giveClothes', 'tshirt', skin.tshirt_1, skin.tshirt_2)
						
						TriggerEvent('skinchanger:loadClothes', skin, {
							['tshirt_1'] = 15,
							['tshirt_2'] = 0,
						})
						
					elseif skin.sex == 1 then
						
						TriggerServerEvent('waves-clothing:giveClothes', 'tshirt', skin.tshirt_1, skin.tshirt_2)
						TriggerEvent('skinchanger:loadClothes', skin, {
							['tshirt_1'] = 15,
							['tshirt_2'] = 0,
						})
						
					end
					canUse = true
				end

			elseif action == 'coat' then
				
				if skin.torso_1 ~= 15 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "try_shirt_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end

					Wait(2000)
					StopAnimTask(playerPed, "clothingshirt", "try_shirt_positive_a", 1.0)
					RemoveAnimDict('clothingshirt')
					if skin.sex == 0 then
						
						TriggerServerEvent('waves-clothing:giveClothes', 'coat', skin.torso_1, skin.torso_2)
						LocalPlayer.state:set('armsCached', {arms = skin.arms, arms_2 = skin.arms_2})
						TriggerEvent('skinchanger:loadClothes', skin, {
							['torso_1'] = 15,
							['torso_2'] = 0,
							['arms'] = 15,
							['arms_2'] = 0
						})
						
					elseif skin.sex == 1 then
						
						TriggerServerEvent('waves-clothing:giveClothes', 'coat', skin.torso_1, skin.torso_2)
						LocalPlayer.state:set('armsCached', {arms = skin.arms, arms_2 = skin.arms_2})
						TriggerEvent('skinchanger:loadClothes', skin, {
							['torso_1'] = 15,
							['torso_2'] = 0,
							['arms'] = 15,
							['arms_2'] = 0
						})						


					end
					canUse = true
				end


			elseif action == 'kamizelka' then
				local a = GetPedArmour(playerPed)
				
				if a >= 0 then
					if skin.bproof_1 ~= 0 then
						canUse = false
						if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
							TaskPlayAnim(playerPed, LoadDict('clothingshirt'), "check_out_c", 8.0, 8.0, -1, 50, 0, false, false, false)
						end

						Citizen.Wait(1500)
						StopAnimTask(playerPed, "clothingshirt", "check_out_c", 1.0)
						RemoveAnimDict('clothingshirt')
						
						TriggerServerEvent('waves-clothing:giveClothes', 'kamizelka', skin.bproof_1, skin.bproof_2)
						TriggerEvent('skinchanger:loadClothes', skin, {
							['bproof_1'] = 0,
							['bproof_2'] = 0,
						})
						canUse = true
					end
					
				else
					ESX.ShowNotification('~r~Nie możesz ściągnąć kamizelki')
				end
			elseif action == 'legs' then

				if skin.pants_1 ~= 15 and skin.pants_1 ~= 61 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingtrousers"), "try_trousers_neutral_c", 44.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(2500)
					StopAnimTask(playerPed, "clothingtrousers", "try_trousers_neutral_c", 1.0)
					RemoveAnimDict('clothingtrousers')
					TriggerServerEvent('waves-clothing:giveClothes', 'legs', skin.pants_1, skin.pants_2)
					
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, {
							['pants_1'] = 61,
							['pants_2'] = 1,
						})
					else
						TriggerEvent('skinchanger:loadClothes', skin, {
							['pants_1'] = 15,
							['pants_2'] = 0,
						})
					end
					canUse = true
			end
				
			elseif action == 'shoes' then
				if skin.shoes_1 ~= 34 and skin.shoes_1 ~= 35 then
					canUse = false
					if not IsPedInAnyVehicle(playerPed, false) and not LocalPlayer.state.IsHandcuffed and not LocalPlayer.state.Tied then
						TaskPlayAnim(playerPed, LoadDict("clothingshoes"), "try_shoes_positive_d", 44.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Citizen.Wait(2250)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_d", 1.0)
					RemoveAnimDict('clothingshoes')
					TriggerServerEvent('waves-clothing:giveClothes', 'shoes', skin.shoes_1, skin.shoes_2)
			
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, {
							['shoes_1'] = 34,
							['shoes_2'] = 0,
						})
					else
						TriggerEvent('skinchanger:loadClothes', skin, {
							['shoes_1'] = 35,
							['shoes_2'] = 0,
						})
					end
					canUse = true
				end
				
			elseif action == 'faceundermask' then
				if 0 ~= skin.face and skin.mask_1 ~= 0 then
					SetPedHeadBlendData(playerPed, 0, skin['face_2'], skin['face_3'], skin['skin'], skin['skin_2'], skin['skin_3'], skin['blend_face'] / 10, skin['blend_skin'] / 10, skin['blend'] / 10, true)
				end
			elseif action == 'hairunderhat' then				
				if -1 ~= skin.hair_1 and skin.helmet_1 ~= -1 then
					SetPedComponentVariation(playerPed, 2,	0, skin['hair_2'], 2)	
				end		
			end
			Citizen.Wait(3000)
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerServerEvent('esx_skin:save', skin)
			end)
		end
	end)
end)

OpenMenu = function(submitCb, cancelCb, restrict)
    CharacterSubmitCb = submitCb
    CharacterCancelCb = cancelCb
    local playerPed = PlayerPedId()
    TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
        TriggerEvent('skinchanger:getData', function(components, maxVals)
			elements    = {}
			local _components = {}

			-- Restrict menu
			if restrict == nil then
				for i=1, #components, 1 do
					_components[i] = components[i]
				end
			else
				for i=1, #components, 1 do
					local found = false

					for j=1, #restrict, 1 do
						if components[i].name == restrict[j] then
							found = true
						end
					end

					if found then
						_components[#_components + 1] = components[i]
					end
				end
			end

			-- Insert elements
			for i=1, #_components, 1 do
				local value       = _components[i].value
				
				local componentId = _components[i].componentId
				if componentId == 0 then
					value = GetPedPropIndex(playerPed, _components[i].componentId)
				end

				local data = {
					label     = _components[i].label,
					name      = _components[i].name,
					value     = value,
					min       = _components[i].min,
					restrict  = skin.sex == 0 and _components[i].restrictMale or _components[i].restrictFemale,
					textureof = _components[i].textureof,
					zoomOffset= _components[i].zoomOffset,
					CharacterOffset = _components[i].camOffset,
					type      = 'slider'
				}

				for k,v in pairs(maxVals) do
					if k == _components[i].name then
						data.max = v
					end
				end

				elements[#elements + 1] = data
			end

            while #elements ~= #_components do
                Citizen.Wait(0)
            end

            SendNUIMessage({
                action = "OpenMenu",
                elements = elements
            })
            SetNuiFocus(true, true)

			CreateSkinCam()
        end)
    end)
end

function OpenMenuCreatePed(submitCb, cancelCb, restrict)
	local playerPed = PlayerPedId()

	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin

		TriggerEvent('skinchanger:getData2', function(components, maxVals)
			local elements    = {}
			local _components = {}

			-- Restrict menu
			if restrict == nil then
				for i=1, #components, 1 do
					_components[i] = components[i]
				end
			else
				for i=1, #components, 1 do
					local found = false

					for j=1, #restrict, 1 do
						if components[i].name == restrict[j] then
							found = true
						end
					end

					if found then
						_components[#_components + 1] = components[i]
					end
				end
			end

			-- Insert elements
			for i=1, #_components, 1 do
				local value       = _components[i].value
				local componentId = _components[i].componentId

				if componentId == 0 then
					value = GetPedPropIndex(playerPed, _components[i].componentId)
				end

				local data = {
					label     = _components[i].label,
					name      = _components[i].name,
					value     = value,
					min       = _components[i].min,
					restrict  = (skin.sex == 0 and _components[i].restrictMale or _components[i].restrictFemale),
					textureof = _components[i].textureof,
					zoomOffset= _components[i].zoomOffset,
					camOffset = _components[i].camOffset,
					type      = 'slider'
				}

				for k,v in pairs(maxVals) do
					if k == _components[i].name then
						data.max = v
						break
					end
				end

				elements[#elements + 1] = data
            			SendNUIMessage({
              				action = "OpenMenu",
                			elements = elements
          			})
				SetNuiFocus(true, true)
			end

			CreateSkinCam()
			zoomOffset = _components[1].zoomOffset
			camOffset = _components[1].camOffset

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
				title = 'Skin menu',
				align = 'bottom-right',
				elements = elements
			}, function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz zapisać zmiany?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:getSkin', function(skin)
							LastSkin = skin
						end)
						DeleteSkinCam()
						if submitCb ~= nil then
							submitCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end,
			function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz wyjść bez zapisywania zmian?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:loadSkin', LastSkin)

						DeleteSkinCam()
						if cancelCb ~= nil then
							cancelCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end,
			function(data, menu)
			  TriggerEvent('skinchanger:getSkin', function(skin)
				zoomOffset = data.current.zoomOffset
				camOffset = data.current.camOffset
				if skin[data.current.name] ~= data.current.value then
				  -- Change skin element
				  TriggerEvent('skinchanger:change', data.current.name, data.current.value)

				  -- Update max values
				  TriggerEvent('skinchanger:getData2', function(components, maxVals)
					for i=1, #elements, 1 do
					  local newData = {}

					  newData.max = maxVals[elements[i].name]
					  if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
						newData.value = 0
					  end

					  menu.update({name = elements[i].name}, newData)
					end

					menu.refresh()
				  end)
				end
			  end)
			end, function()
				DeleteSkinCam()
			end)
		end)
	end)
end

CreateSkinCam = function()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    CharacterCam    = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamActive(CharacterCam, true)
	RenderScriptCams(true, true, 500, true, true)

    SetCamRot(CharacterCam, 0.0, 0.0, 270.0, true)
    CharacterAngle = GetEntityHeading(playerPed) - 260
    CharacterOffset = 0
    SendNUIMessage({
        action = "setRot",
        angle = CharacterAngle
    })

    while CharacterCam ~= nil do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        local angle = CharacterAngle * math.pi / 180.0
        
        local theta = {
            x = math.cos(angle),
            y = math.sin(angle)
        }

        local pos = {
            x = coords.x + ((zoomOffset + CharacterHeading) * theta.x),
            y = coords.y + ((zoomOffset + CharacterHeading) * theta.y)
        }

        local angleToLook = CharacterAngle - 180.0
        if angleToLook > 360 then
            angleToLook = angleToLook - 360
        elseif angleToLook < 0 then
            angleToLook = angleToLook + 360
        end

        angleToLook = angleToLook * math.pi / 180.0
        local thetaToLook = {
            x = math.cos(angleToLook),
            y = math.sin(angleToLook)
        }

        local posToLook = {
            x = coords.x + ((zoomOffset + CharacterHeading) * thetaToLook.x),
            y = coords.y + ((zoomOffset + CharacterHeading) * thetaToLook.y)
        }

        SetCamCoord(CharacterCam, pos.x, pos.y, coords.z + CharacterOffset)
        PointCamAtCoord(CharacterCam, posToLook.x, posToLook.y, coords.z + CharacterOffset)
    end
end

DeleteSkinCam = function()
    SetCamActive(CharacterCam, false)
	RenderScriptCams(false, true, 500, true, true)
    CharacterCam = nil
end

RegisterNUICallback("change", function(data, cb)
	if (data.isTattooShop) then
		local ped = PlayerPedId()
		ClearPedDecorations(ped)

		--[[
			{
				name: Zestaw6,
				value: 2
			}
		]]
		currentTattooSelection = {
			name = data.name,
			value = data.value
		}
		tattooChangeCb(data.name, data.value)
	else
		TriggerEvent('skinchanger:change', data.name, data.value)
		TriggerEvent('skinchanger:getData', function(components, maxVals)
			for i=1, #elements, 1 do
				if elements[i].name == data.name then
					local newmin = elements[i].min
					local newmax = maxVals[elements[i].name]
					SendNUIMessage({
						action = "UpdateVals",
						name = elements[i].name,
						max = newmax,
						min = newmin,
						value = -1
					})
				elseif changeElementsTo0[data.name] then
					if elements[i].name == changeElementsTo0[data.name] then
						TriggerEvent('skinchanger:change', elements[i].name, 0)
						elements[i].value = 0
						local newmin = elements[i].min
						local newmax = maxVals[elements[i].name]
						SendNUIMessage({
							action = "UpdateVals",
							name = elements[i].name,
							max = newmax,
							min = newmin,
							value = elements[i].value
						})
					end
				end
			end
		end)
	end

	cb('ok')
end)

RegisterNUICallback("submit", function(data)
	if (tattooChangeCb) then 
		tattooChangeCb = nil
	end
    DeleteSkinCam()
	SetNuiFocus(false, false)

	if (data.isTattooShop) then
		TriggerEvent('skinchanger:loadClothes', LastSkin)
		ESX.TriggerServerCallback('waves-beautyshops:buyTattoo', function(response)
			if (data) then
				ESX.ShowNotification('Zakupiłeś tatuażę!', 'success')
			else
				ESX.ShowNotification('Nie stać cię na to!', 'warn')
			end
			currentTattooSelection = nil
		end, currentTattooSelection)
	end

-- no co mam powiedziec skaza zapomial loadera dac pozdro loxi topka
	TriggerEvent('skinchanger:getSkin', function(skin)
        LastSkin = skin
    end)
	if CharacterSubmitCb then
        CharacterSubmitCb()
    end
end)

RegisterNUICallback("cancel", function(data)
	if (data.isTattooShop) then
		SetTimeout(1000, function()
			TriggerEvent('waves-beautyshops:loadTattoos')
		tattooChangeCb = nil
		end)
	end
    TriggerEvent('skinchanger:loadSkin', LastSkin)
		DeleteSkinCam()
    SetNuiFocus(false, false)
    if CharacterCancelCb then
        CharacterCancelCb()
    end
end)

RegisterNUICallback("rotation", function(data)
    local angle = data.value
    CharacterAngle = angle + 0.0
end)

RegisterNUICallback("heading", function(data)
    local heading = data.value
    CharacterHeading = heading + 0.0
end)

RegisterNUICallback("offset", function(data)
    local offsett = data.value
    CharacterOffset = offsett + 0.0
end)


function OpenSaveableMenu(submitCb, cancelCb, restrict)
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)

	OpenMenu(function()
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
			TriggerEvent('esx_ciuchy:wear')
			if submitCb ~= nil then
				submitCb()
			end
		end)

	end, cancelCb, restrict)
end

function OpenSaveableMenuCreatePed(submitCb, cancelCb, restrict)
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)

	OpenMenuCreatePed(function(data, menu)
		menu.close()
		DeleteSkinCam()
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
			TriggerEvent('esx_ciuchy:wear')
			if submitCb ~= nil then
				submitCb(data, menu)
			end
		end)
	end, cancelCb, restrict)
end
-- no co mam powiedziec skaza zapomial loadera dac pozdro loxi topka
AddEventHandler('skinchanger:save', function(cbs)
    TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:save', skin)
		TriggerEvent('esx_ciuchy:wear')
		if cbs ~= nil then
			cbs()
		end
    end)
end)

local CharacterCreating = false
AddEventHandler('wait_core:loading', function(num)
	if num == 1 then
		CreateThread(function()
			while not PlayerLoaded do
				Citizen.Wait(100)
			end
		
			if FirstSpawn then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					if skin == nil then
						TriggerEvent('skinchanger:loadSkin', {sex = 0})
						CharacterCreating = true
						local essss = true
						OpenSaveableMenu(function()
							essss = false
						end, function()
							essss = false
						end, nil)

						MumbleSetVolumeOverride(PlayerId(), 0.0)
						CreateThread(function()
							local playerPool = {}
							while CharacterCreating do
								local players = GetActivePlayers()
								for i = 1, #players do
									local player = players[i]
									if player ~= PlayerId() and not playerPool[player] then
										playerPool[player] = true
										NetworkConcealPlayer(player, true, true)
									end
								end
								Wait(0)
							end
							for k in pairs(playerPool) do
								NetworkConcealPlayer(k, false, false)
							end
						end)
						CreateThread(function()
							while CharacterCreating do
								DisableAllControlActions(0)
								SetEntityVisible(PlayerPedId(), 0, 0)
								SetLocalPlayerVisibleLocally(1)
								SetPlayerInvincible(PlayerId(), 1)
								Wait(0)
								local vehicles = GetGamePool('CVehicle')
								for i = 1, #vehicles do
									SetEntityLocallyInvisible(vehicles[i])
								end
							end
							local playerId, playerPed = PlayerId(), PlayerPedId()
							MumbleSetVolumeOverride(playerId, -1.0)
							SetEntityVisible(playerPed, 1, 0)
							SetPlayerInvincible(playerId, 0)
						end)

						while essss do
							Wait(0)
						end

						-- exports.waitrp_trailer.start()
						-- Citizen.Wait(77000)
						-- exports.waitrp_trailer.stop()

						CharacterCreating = false

						local playerPed = PlayerPedId()
						SetEntityCoords(playerPed, -1042.575439, -2745.922119, 21.359383)
						SetEntityHeading(playerPed, 323.62954711914)
						TriggerServerEvent("wait_core:addStartItems")

						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
					else
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('esx_ciuchy:wear')
					end
				end)
				
				FirstSpawn = false
			end
		end)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
	cb(LastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
	LastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
	OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
	OpenSaveableMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:responseSatestveSkin', skin)
	end)
end)

RegisterNetEvent('esx_skin:openSaveableMenuPed')
AddEventHandler('esx_skin:openSaveableMenuPed', function(submitCb, cancelCb)
	OpenSaveableMenuCreatePed(submitCb, cancelCb, {'sex'})
end)