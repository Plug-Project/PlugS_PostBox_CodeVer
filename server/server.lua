local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())

postBoxS = {}
Proxy.addInterface("PlugS_PostBox", postBoxS)
Tunnel.bindInterface(GetCurrentResourceName(), postBoxS)
postBoxC = Tunnel.getInterface(GetCurrentResourceName(), GetCurrentResourceName())


AddEventHandler("vRP:playerSpawn", function(user_id, source)
    getCountPostBox(user_id)
end)

Citizen.CreateThread(function()
    while true do
        for _, source in ipairs(GetPlayers()) do
            local user_id = vRP.getUserId({source})
            getCountPostBox(user_id)
        end
        Citizen.Wait(10000)
    end
end)

function getCountPostBox(user_id)
    local source = vRP.getUserSource({user_id})
    local user_id = vRP.getUserId({source})
    
    if user_id == nil then return end
    
    local count = MySQL.query.await("SELECT COUNT(*) AS user_count FROM seechxn_postbox WHERE user_id = ?", {user_id})
    if not count or count[1].user_count > 0 then
        vRPclient.notify(source, {count[1].user_count.."개의 우편이 있습니다. <br>'/우편함'명령어를 사용하여 확인 해 주세요."})
        return count[1].user_count
    else
        return false
    end
end

function postBoxS.getCountPostBox()
    local source = source
    local user_id = vRP.getUserId({source})

    if user_id == nil then return end
    
    local count = MySQL.query.await("SELECT COUNT(*) AS user_count FROM seechxn_postbox WHERE user_id = ?", {user_id})
    if not count or #count <= 0 then
        vRPclient.notify(source, {count.."개의 우편이 있습니다. <br>'/우편함'명령어를 사용하여 확인 해 주세요."})
        return count
    else
        return false
    end
end

function postBoxS.getCountPostBox()
    local source = source
    local user_id = vRP.getUserId({source})

    if user_id == nil then return end
    
    local count = MySQL.query.await("SELECT COUNT(*) AS user_count FROM seechxn_postbox WHERE user_id = ?", {user_id})
    if not count or #count <= 0 then
        vRPclient.notify(source, {count.."개의 우편이 있습니다. <br>'/우편함'명령어를 사용하여 확인 해 주세요."})
        return count
    else
        return false
    end
end

function postBoxS.getPostBox()
    local source = source
    local user_id = vRP.getUserId({source})
    
    if user_id == nil then return end

    local rows = MySQL.query.await("SELECT * FROM seechxn_postbox WHERE user_id = ?", {user_id})

    if not rows or #rows <= 0 then
        return nil, vRP.getUserId({source})
    end

    return rows, user_id
end

function postBoxS.getPostContents(post_id)
    local source = source

    local rows = MySQL.query.await("SELECT * FROM seechxn_postbox WHERE post_id = ?", {post_id})

    if not rows or #rows <= 0 then
        return 
    end

    return rows[1].post_data
end

function postBoxS.itemReward(post_id)
    local source = source
    local user_id = vRP.getUserId({source})

    if user_id == nil then return end

    local rows = MySQL.query.await("SELECT * FROM seechxn_postbox WHERE post_id = ?", {post_id})
    
    if rows[1] then
        local jsonData = rows[1].post_data
        local postData = json.decode(jsonData)

        for _, item in ipairs(postData.itemList) do
            vRP.giveInventoryItem({user_id, tostring(item.itemCode), tonumber(item.itemAmount), true})
        end
        MySQL.query.await("DELETE FROM seechxn_postbox WHERE post_id = ?", {post_id})
        postBoxC.deleteMailBox(source, {post_id})
    else
        vRPclient.notify(source, {"~r~이미 보상을 받았습니다."})
    end
end