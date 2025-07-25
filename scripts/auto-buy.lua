local list_drop = {3044, 3004, 5522, 2914, 3002, 2912}
local set = {
delay = 200,
pack = "fishin_pack"
}
local drop_x = GetLocal().posX // 32
local drop_y = GetLocal().posY // 32
local need_reset = false  -- Flag buat stop drop sementara

function inv(ids)
    for _, inv in pairs(getInventory()) do
        if inv.id == ids then
            return (inv.amount > 0 and inv.amount) or 0
        end
    end
    return 0
end

function ovlay(txt)
    SendVariant({v1 = "OnTextOverlay", v2 = txt, v3 = 0, v4 = 0, v5 = 0, v6 = 0, v7 = 0})
end

function move(a, b)
    SendPacketRaw(false, {type = 0, state = 48, x = a * 32, y = b * 32})
end

function drop(id, amount)
    SendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|" .. id .. "|\ncount|" .. amount .. "\n")
end

function buy(name)
    SendPacket(2, "action|buy\nitem|" .. name .. "\n")
end

-- Hook: Detect “emptier” ➔ set flag ➔ geser posisi
AddHook(function(v)
    if v.v1 == "OnTextOverlay" and v.v2:lower():find("emptier") then
        need_reset = true
        drop_x = drop_x + 1  -- Geser posisi X
        ovlay("Tile penuh : Pindah drop_x = " .. drop_x)
        return true
    end
end, "OnVariant")

function main()
    while true do
        -- Step 1: Buy 20x
        for i = 1, 20 do
            buy(set.pack)
            Sleep(set.delay)
        end

        -- Step 2: Loop drop sampai semua kebuang bersih
        local all_dropped = false
        while not all_dropped do
            all_dropped = true  -- Asumsi awal: semua sudah ke-drop

            for index, id in ipairs(list_drop) do
                local amount = inv(id)
                if amount > 0 then
                    if need_reset then
                        -- Stop drop ➔ tunggu posisi udah digeser
                        need_reset = false  -- Reset flag ➔ siap drop lagi
                        all_dropped = false -- Tetap false biar loop lagi
                        break
                    end

                    local move_y = drop_y - index
                    move(drop_x, move_y)
                    Sleep(set.delay)
                    drop(id, amount)
                    all_dropped = false  -- Masih ada item, jadi loop lagi
                end
            end

            Sleep(100)  -- Biar gak kecepatan looping
        end
    end
end

main()