local posdotp4 = {x=33487, y=32780, z=13}

function MoveStone4() --creates wall back
local criistal4 = getTileItemById(posdotp4, 1353)
if not criistal4 then 
doCreateItem(1353,1,posdotp4)-- Stone pos
else 
doCreateItem(1353,1,posdotp4)
end 
return true
end

function RemoveStone4()
    local cristal4 = getTileItemById(posdotp4, 1353) -- Id of the blue crystal that disappears to give place to tp
    if cristal4 then
        doRemoveItem(cristal4.uid, 1)
    end
    return true
end

function onKill(cid, target, damage, flags, corpse)
	if(isMonster(target)) then
		if(string.lower(getCreatureName(target)) == "shulgrax") then
		    addEvent(RemoveStone4, 5 * 1000)
     	    addEvent(MoveStone4, 300 * 1000)
		end
	end
	return true
end



