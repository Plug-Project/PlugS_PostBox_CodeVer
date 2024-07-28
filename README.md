# PlugS_PostBox_CodeVer

## 플레이어 접속 시 우편함에 우편이 있는지 확인 후 알려줍니다.
```lua
-- vrp/modules/player_state.lua

-- line: 5
local PlugS_PostBox = Proxy.getInterface('PlugS_PostBox')

-- line: 84
SetTimeout(15000, function()
    if tmpdata then
        PlugS_PostBox.getCountPostBox({user_id})
        vRPclient.notify(player, {lang.common.welcome({tmpdata.last_login})})
    end
end)
```