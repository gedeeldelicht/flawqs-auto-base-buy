local teleportDelay = 2 -- seconden

local function teleportOutOfBase()
    -- Veronderstel dat je speler object een tag of naam heeft, bijvoorbeeld "Player"
    local player = GameObject.FindWithTag("Player")
    local baseClosed = true -- Je moet hier je eigen logica implementeren om te checken of de base gesloten is

    if baseClosed then
        -- Wacht 2 seconden voordat teleport
        coroutine.wait(teleportDelay)
        if player then
            -- Teleporteer de speler bijvoorbeeld naar een andere locatie
            local targetPosition = Vector3.New(0, 0, 0) -- pas dit aan naar gewenste locatie
            player.transform.position = targetPosition
        end
    end
end

-- Script gekoppeld aan de knop
function OnTPButtonClicked()
    coroutine.start(teleportOutOfBase)
end
