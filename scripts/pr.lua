
EditToggle("ModFly", true)

idprov = 928 
delayf = 250 
delayp = 190 

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