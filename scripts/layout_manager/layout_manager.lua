Tracker:AddLayouts("layouts/components/campaigns/vanilla_monk.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/vanilla_survivor.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/vanilla_hunter.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/msc_monk.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/msc_survivor.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/msc_hunter.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/gormand.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/artificer.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/rivulet.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/spearmaster.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/saint.jsonc")
Tracker:AddLayouts("layouts/components/campaigns/inv.jsonc")

function CampaignChange()
    local scug = Tracker:FindObjectForCode("scug").CurrentStage

    local tab_layout = 
    {
        [0] = "layouts/components/campaign_tabs_monk.jsonc",
        [1] = "layouts/components/campaign_tabs_survivor.jsonc",
        [2] = "layouts/components/campaign_tabs_hunter.jsonc",
        [3] = "layouts/components/campaign_tabs_gormand.jsonc",
        [4] = "layouts/components/campaign_tabs_artificer.jsonc",
        [5] = "layouts/components/campaign_tabs_rivulet.jsonc",
        [6] = "layouts/components/campaign_tabs_spearmaster.jsonc",
        [7] = "layouts/components/campaign_tabs_saint.jsonc",
        [8] = "layouts/components/campaign_tabs_inv.jsonc",
        [9] = "layouts/components/campaign_tabs_watcher.jsonc",
    }

    Tracker:AddLayouts(tab_layout[scug])

    local dlc_layout = 
    {
        [0] = "layouts/components/campaigns/%smonk.jsonc",
        [1] = "layouts/components/campaigns/%ssurvivor.jsonc",
        [2] = "layouts/components/campaigns/%shunter.jsonc",
    }

    if scug <= 2 and Tracker:FindObjectForCode("MSC").Active then
        Tracker:AddLayouts(string.format(dlc_layout[scug], "msc_"))
    else
        Tracker:AddLayouts(string.format(dlc_layout[scug], ""))
    end
    

    print("test2")
    print(scug)
end


print("test1")
CampaignChange()
ScriptHost:AddWatchForCode('campaignchange_scug', 'scug', CampaignChange)
ScriptHost:AddWatchForCode('campaignchange_MSC', 'MSC', CampaignChange)