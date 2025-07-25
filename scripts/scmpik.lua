EditToggle("ModFly", true)

idprov = 928 -- Science 928 bisa ganti ke provider lain selain science
delayf = 250 -- delay after FindPath / delay setelah teleport
delayp = 190 -- delay after punch / delay setelah pukul

function Punch(x,y)
SendPacketRaw(false, {
        x = GetLocal().posX,
        y = GetLocal().posY,
        px = x,
        py = y,
        type = 3,
        value = 18
    })
end

for _, tile in pairs(GetTiles()) do
    if tile.fg == idprov and tile.readyharvest then

        FindPath(tile.x,tile.y)
        Sleep(delayf)
        if tile.fg ~= 8 then

           while GetTile(tile.x,tile.y).fg == idprov and tile.readyharvest do
                punch(tile.x,tile.y)
                Sleep(delayp)
               end
           end
       end
    end
end


--gtps only