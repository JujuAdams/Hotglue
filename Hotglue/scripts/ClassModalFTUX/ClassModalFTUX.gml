// Feather disable all

function ClassModalFTUX() constructor
{
    __page = 0;
    __registeredURI = false;
    
    
    
    static Build = function()
    {
        var _name = $"First-Time Setup##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(oInterface.context.GetRegion().width/2, oInterface.context.GetRegion().height/2);
        var _result = ImGuiBeginPopupModal(_name);
        if (_result & ImGuiReturnMask.Return)
        {
            if (__page == 0)
            {
                ImGuiTextWrapped($"Welcome to Hotglue by Juju Adams! This is version {HOTGLUE_VERSION}, {HOTGLUE_DATE}.");
                ImGuiNewLine();
                InterfaceBuildCredits();
                ImGuiNewLine();
                ImGuiTextWrapped("Please follow the instructions on subsequent pages to prepare Hotglue for use.");
                ImGuiNewLine();
                
                if (HOTGLUE_RUNNING_FROM_IDE)
                {
                    ImGuiTextColored("URI registration requires Hotglue to be run from an executable.", INTERFACE_COLOR_RED_TEXT, 1);
                    ImGuiNewLine();
                }
                
                if (ImGuiButton("Next"))
                {
                    ++__page;
                }
            }
            else if (__page == 1)
            {
                ImGuiTextWrapped("Hotglue uses URI activation so that Hotglue can be started if you click on a link in a web browser. This allows you to easily install packages without needing to configure access. URI activation is further required for Hotglue's GitHub integration.");
                ImGuiNewLine();
                ImGuiTextWrapped("Hotglue links look like this:");
                ImGuiTextLink("hotglue://add=https://www.github.com/jujuadams/scribble");
                ImGuiTextWrapped("or");
                ImGuiTextLink("https://www.jujuadams.com/hotglue?add=https://www.github.com/jujuadams/scribble");
                ImGuiNewLine();
                ImGuiTextColored("Please note that Hotglue will never open or modify files without your authorization.", INTERFACE_COLOR_GREEN_TEXT);
                ImGuiNewLine();
                if (os_type == os_windows)
                {
                    ImGuiTextWrapped("Please click the button below to enable URI activation. It will open up a confirmation window asking for you to make changes to the Windows registry.");
                }
                else
                {
                    //TODO
                }
                
                ImGuiBeginDisabled(HOTGLUE_RUNNING_FROM_IDE);
                if (ImGuiButton("Register URI"))
                {
                    HotglueURIRegister();
                    __registeredURI = true;
                }
                
                ImGuiSameLine();
                ImGuiBeginDisabled(not __registeredURI);
                if (ImGuiButton("Test URI"))
                {
                    HotglueURITest();
                }
                ImGuiEndDisabled();
                ImGuiEndDisabled();
                
                if (HOTGLUE_RUNNING_FROM_IDE)
                {
                    ImGuiSameLine();
                    ImGuiTextColored("Please compile and run from an executable!", INTERFACE_COLOR_RED_TEXT);
                }
                
                ImGuiNewLine();
                if (ImGuiButton("Back"))
                {
                    --__page;
                }
                ImGuiSameLine(undefined, 20);
                if (ImGuiButton(__registeredURI? "Next" : "Skip"))
                {
                    ++__page;
                }
            }
            else if (__page == 2)
            {
                if (__registeredURI)
                {
                    ImGuiTextWrapped("Hotglue has a GitHub integration that allows more reliable repository access. Hotglue can also read private repositories that you have access to. You can then import private repositories and packages into your projects.");
                    ImGuiNewLine();
                    ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_GREEN_TEXT, 1);
                    ImGuiTextWrapped("Please note that Hotglue will not (and cannot) share any private information. Anything that Hotglue access will only ever be stored locally on this machine.");
                    ImGuiPopStyleColor();
                    ImGuiNewLine();
                    if (ImGuiButton("Authorize GitHub..."))
                    {
                        ImGuiTextWrapped("Please click the button below to authorize Hotglue to read information using your GitHub account. Please follow the instructions in the web browser that pops up. Make sure to allow the browser to open the Hotglue link.");
                        InterfaceGitHubAuthFlow();
                    }
                }
                else
                {
                    ImGuiTextWrapped("Hotglue has a GitHub integration that allows more reliable repository access. However, this feature is only available if Hotglue has been registered for URI activation.");
                    ImGuiNewLine();
                    ImGuiTextWrapped("Please click the \"Back\" button below and follow the instructions on the previous page to set up URI activation.");
                }
                
                ImGuiNewLine();
                if (ImGuiButton("Back"))
                {
                    --__page;
                }
                ImGuiSameLine(undefined, 20);
                if (ImGuiButton(HotglueGitHubGetAccessTokenAvailable()? "Next" : "Skip"))
                {
                    ++__page;
                }
            }
            else if (__page == 3)
            {
                ImGuiTextWrapped("Setup complete. You may adjust how Hotglue is configured by click the \"Settings\" button in the menu bar. If you run into any problems, please open a GitHub issue by clicking the \"Report Bug\" button in the menu bar.");
                ImGuiNewLine();
                ImGuiTextWrapped("Thank you for using Hotglue.\n - Juju");
                ImGuiNewLine();
                
                if (ImGuiButton("Back"))
                {
                    --__page;
                }
                ImGuiSameLine(undefined, 20);
                if (ImGuiButton("Close"))
                {
                    ++__page;
                }
            }
            else
            {
                InterfaceSettingSet("completedFTUX", true);
                InterfaceSettingsSave();
                
                oInterface.popUpStruct = undefined;
            }
            
            ImGuiEndPopup();
            
            return true;
        }
        else
        {
            return false;
        }
    }
}