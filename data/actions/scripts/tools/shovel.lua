local config = {
    swampId = {20230, 18589, 18584, 18141}, -- Swamp tiles ids that can be used to shovel
    itemGain = {{itemId = 2818, quantGain = 1}, -- Itemid winning, and msm maximum amount.
                {itemId = 2145, quantGain = 3},
                {itemId = 20138, quantGain = 1}
                }
}

local exhausth = 3600 -- In how many seconds can you use it again




local holes = {468, 481, 483, 7932, 23712}
local pools = {2016, 2017, 2018, 2019, 2020, 2021, 2025, 2026, 2027, 2028, 2029, 2030}
function onUse(cid, item, fromPosition, itemEx, toPosition)
    if(isInArray(config.swampId, itemEx.itemid)) then
        if (getPlayerStorageValue(cid, 32901) <= os.time()) then
        if math.random(0,500) > 255 then
            local posGain = math.random(1, #config.itemGain)
            local quantGain = math.random(1,config.itemGain[posGain].quantGain)
            doPlayerAddItem(cid, config.itemGain[posGain].itemId, quantGain)
            doSendMagicEffect(toPosition, 8)
            doCreatureSay(cid,  "You dug up ".. quantGain .." ".. getItemName(config.itemGain[posGain].itemId) ..".", TALKTYPE_ORANGE_1)  
            setPlayerStorageValue(cid, 32901, os.time()+exhausth)  
        end
    else
            doPlayerSendCancel(cid, "You are exhausted, use again in 1 hour.")
        end
    else
        return shovelNormal(cid, item, fromPosition, itemEx, toPosition)
    end
    return true
end



function shovelNormal(cid, item, fromPosition, itemEx, toPosition)
local target = itemEx
    local player = Player(cid)
    local iEx = Item(itemEx.uid)
    if isInArray(holes, itemEx.itemid) then
        iEx:transform(itemEx.itemid + 1)
        iEx:decay()
 elseif isInArray(pools, target.itemid) then
        local hole = 0
        for i = 1, #holes do
            local tile = Tile(target:getPosition()):getItemById(holes[i])
            if tile then
                hole = tile
            end
        end
        if hole ~= 0 then
            hole:transform(hole:getId() + 1)
            hole:decay()
        else
            return false
        end   
    elseif itemEx.itemid == 231 or itemEx.itemid == 9059 then
        local rand = math.random(1, 100)
        if(itemEx.actionid  == 100 and rand <= 20) then
        iEx:transform(489)
        iEx:decay()
        elseif rand == 1 then
            Game.createItem(2159, 1, toPosition)
        elseif rand > 95 then
            Game.createMonster("Rat", toPosition)
        end
        toPosition:sendMagicEffect(CONST_ME_POFF)
    elseif itemEx.actionid == 4654 and player:getStorageValue(9925) == 1 and player:getStorageValue(9926) < 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found a piece of the scroll. You pocket it quickly.')
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:addItem(21250, 1)
        player:setStorageValue(9926, 1)
    elseif itemEx.actionid == 4668 and player:getStorageValue(12902) == 1 and player:getStorageValue(12903) < 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'A torn scroll piece emerges. Probably gnawed off by rats.')
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:addItem(21250, 1)
        player:setStorageValue(12903, 1)
    else
        return false
    end
    return true
end