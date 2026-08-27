ServerCountdown = ServerCountdown or {}

ServerCountdown.IsRunning = false
ServerCountdown.CurrentTime = 0

function ServerCountdown.Start(duration)
    duration = duration or Config.CountdownDuration or 20
    ServerCountdown.IsRunning = true
    ServerCountdown.CurrentTime = duration

    CreateThread(function()
        while ServerCountdown.IsRunning and ServerCountdown.CurrentTime >= 0 do
            TriggerClientEvent("battleground:cl:syncCountdown", -1, ServerCountdown.CurrentTime)

            if ServerCountdown.CurrentTime == 0 then
                ServerCountdown.IsRunning = false
                Wait(1000)
                -- Transition to DROPPING plane sequence
                ServerState.SetMatchState(Constants.MatchState.DROPPING)
                if ServerPlane and ServerPlane.StartSequence then
                    ServerPlane.StartSequence()
                end
                break
            end

            Wait(1000)
            ServerCountdown.CurrentTime = ServerCountdown.CurrentTime - 1
        end
    end)
end

function ServerCountdown.Stop()
    ServerCountdown.IsRunning = false
    ServerCountdown.CurrentTime = 0
    TriggerClientEvent("battleground:cl:syncCountdown", -1, -1)
end
