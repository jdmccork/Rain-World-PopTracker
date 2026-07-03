Tracker:AddLayouts("layouts/components/campaign_tabs.jsonc")

function CampaignChange()
    local scug = Tracker:FindObjectForCode("scug").CurrentStage

    local campagin_layout = 
    {
        [0] = "layouts/components/campaigns/%smonk.jsonc",
        [1] = "layouts/components/campaigns/%ssurvivor.jsonc",
        [2] = "layouts/components/campaigns/%shunter.jsonc",
        [3] = "layouts/components/campaigns/gormand.jsonc",
        [4] = "layouts/components/campaigns/artificer.jsonc",
        [5] = "layouts/components/campaigns/rivulet.jsonc",
        [6] = "layouts/components/campaigns/spearmaster.jsonc",
        [7] = "layouts/components/campaigns/saint.jsonc",
        [8] = "layouts/components/campaigns/inv.jsonc",
        [9] = "layouts/components/campaigns/watcher.jsonc",
    }
    
    if scug <= 2 then
        Tracker:AddLayouts(string.format(campagin_layout[scug], Tracker:FindObjectForCode("MSC").Active and "msc_" or ""))
    else
        Tracker:AddLayouts(campagin_layout[scug])
    end
end

CampaignChange()
ScriptHost:AddWatchForCode('campaignchange_scug', 'scug', CampaignChange)
ScriptHost:AddWatchForCode('campaignchange_MSC', 'MSC', CampaignChange)