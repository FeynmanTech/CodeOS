
--# Main
-- Project Tab Separator

-- Use this function to perform your initial setup
function setup()
    sep("CodeOS")
    sep("CodeOS_Programs")
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end


--# Separate
function sep(proj)
    local main = readProjectTab(proj .. ":Main")
    local p = {}
    for m in main:gmatch("--# [A-Za-z0-9]+\n") do
        table.insert(p, m)
    end
    for tab = 1, #p - 1 do
        local tn = main:find(p[tab])
        saveProjectTab(proj .. ":" .. (p[tab]):sub(5, -2), main:sub(tn, main:find(p[tab + 1]) - 1))
    end
end
