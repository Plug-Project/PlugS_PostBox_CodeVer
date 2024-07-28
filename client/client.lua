vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())

postBoxC = {}
Tunnel.bindInterface(GetCurrentResourceName(), postBoxC)
Proxy.addInterface(GetCurrentResourceName(), postBoxC)
postBoxS = Tunnel.getInterface(GetCurrentResourceName(), GetCurrentResourceName())

RegisterCommand("우편함", function()
    postBoxS.getPostBox({}, function(postData, user_id, userName)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'open',
            postData = postData,
            user_id = user_id,
            userName = GetPlayerName(PlayerId()),
        })
    end)
end, false)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
	cb(true)
end)

RegisterNUICallback('getPostData', function(data, cb)
    postBoxS.getPostContents({data.post_id}, function(postData)
        SendNUIMessage({
            type = 'openModal',
            postData = postData
        })
    end)
	cb(true)
end)

RegisterNUICallback('itemReward', function(data, cb)
    postBoxS.itemReward({data.post_id})
	cb(true)
end)

function postBoxC.deleteMailBox(post_id)
    SendNUIMessage({
        type = 'deleteMailBox',
        post_id = post_id
    })
end