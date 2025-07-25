local id = 5640  -- Seed ID (adjust as needed)
local delay = 190
local platform = 32  -- Platform block ID (adjust as needed)

local width = 100  -- Farm width
local height = 100 -- Farm height

-- Function to place a block
function place(blockID, offsetX, offsetY)
    local packet = {
        type = 3,  -- Place block packet
        int_data = blockID,
        pos_x = GetLocal().pos_x,
        pos_y = GetLocal().pos_y,
        int_x = math.floor((GetLocal().pos_x // 32) + offsetX),
        int_y = math.floor((GetLocal().pos_y // 32) + offsetY)
    }
    SendPacketRaw(packet)
end

-- Main planting loop
local function autoPlant()
    for y = 0, height do
        for x = 0, width do
            local tile = GetTile(x, y)
            local tileBelow = GetTile(x, y + 1)
            
            -- Check if tile and tileBelow are not nil
            if tile and tileBelow then
                -- Check if tile is empty and tile below is a platform
                if (tile.fg == 0) and (tileBelow.fg == platform) then
                    FindPath(x, y)  -- Move to the position
                    if Sleep then
                        Sleep(delay)  -- Wait for a specified time
                    else
                        os.execute("sleep " .. delay / 1000)  -- Fallback if Sleep isn't available
                    end
                    place(id, 0, 0)  -- Plant the seed
                    if Sleep then
                        Sleep(delay)  -- Wait again for the next action
                    else
                        os.execute("sleep " .. delay / 1000)  -- Fallback if Sleep isn't available
                    end
                end
            else
                -- Handle nil values if GetTile fails
                log("Warning: GetTile returned nil for position (" .. x .. ", " .. y .. ")")
            end
        end
    end
end

-- Run the script
autoPlant()


--Gak work anjing