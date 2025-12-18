// Feather disable all

function ClassTabSettings() : ClassTab() constructor
{
    static __name = "Settings";
    
    __advanced = false;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem(__name, undefined, (oInterface.forceSelectedTab == __name)? ImGuiTabItemFlags.SetSelected : undefined))
        {
            ImGuiNewLine();
            
            ImGuiText("Library Channels:");
            ImGuiIndent();
            ImGuiBeginChild("channelsPane", undefined, 170, ImGuiChildFlags.Border);
            
            ImGuiBeginTable("channelsTable", 3, ImGuiTableFlags.RowBg);
            
            ImGuiTableSetupColumn("button", ImGuiTableColumnFlags.WidthFixed, 20);
            ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthStretch, 1);
            ImGuiTableSetupColumn("url", ImGuiTableColumnFlags.WidthStretch, 3);
            
            var _deleteIndex = undefined;
            var _i = 0;
            repeat(HotglueGetChannelCount())
            {
                var _channel = HotglueGetChannelByIndex(_i);
                
                ImGuiTableNextRow();
                ImGuiTableNextColumn();
                
                if (_channel.__protected)
                {
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetName());
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetURL());
                }
                else
                {
                    if (ImGuiSmallButton($"X##{string(ptr(_channel))}"))
                    {
                        _deleteIndex = _i;
                    }
                    
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetName());
                    ImGuiTableNextColumn();
                    ImGuiText(_channel.GetURL());
                }
                
                ++_i;
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiTableNextColumn();
            if (ImGuiButton("+ Add new channel..."))
            {
                oInterface.popUpStruct = new ClassModalNewChannel();
            }
            
            if (_deleteIndex != undefined)
            {
                HotglueDeleteChannel(_deleteIndex);
                InterfaceSettingsSave();
            }
            
            ImGuiEndTable();
            ImGuiEndChild();
            ImGuiUnindent();
            
            ImGuiNewLine();
            
            ImGuiText("Boot Behaviour:");
            ImGuiIndent();
            
            ImGuiText("Open on tab");
            ImGuiSameLine();
            if (ImGuiBeginCombo("##bootTab", InterfaceSettingGet("openOnTab", "Welcome"), ImGuiComboFlags.None))
            {
                if (ImGuiSelectable("Welcome"))
                {
                    InterfaceSettingSet("openOnTab", "Welcome");
                    InterfaceSettingsSave();
                }
                
                if (ImGuiSelectable("Import"))
                {
                    InterfaceSettingSet("openOnTab", "Import");
                    InterfaceSettingsSave();
                }
                
                if (ImGuiSelectable("Library Channels"))
                {
                    InterfaceSettingSet("openOnTab", "Library Channels");
                    InterfaceSettingsSave();
                }
                
                if (ImGuiSelectable("Project Inspector"))
                {
                    InterfaceSettingSet("openOnTab", "Project Inspector");
                    InterfaceSettingsSave();
                }
                
                if (ImGuiSelectable("Settings"))
                {
                    InterfaceSettingSet("openOnTab", "Settings");
                    InterfaceSettingsSave();
                }
                
                if (ImGuiSelectable("Log"))
                {
                    InterfaceSettingSet("openOnTab", "Log");
                    InterfaceSettingsSave();
                }
                
                ImGuiEndCombo();
            }
            
            ImGuiUnindent();
            ImGuiNewLine();
            
            ImGuiText("Caches:");
            ImGuiIndent();
            InterfaceLinkText(HotglueGetCachePath());
            
            if (ImGuiButton("Clear release cache"))
            {
                HotglueClearReleaseCache();
                LogTraceAndStatus("Cleared release cache");
            }
            
            ImGuiSameLine(undefined, 20);
            
            if (ImGuiButton("Clear unzip cache"))
            {
                HotglueClearUnzipCache();
                LogTraceAndStatus("Cleared unzip cache");
            }
            ImGuiUnindent();
            
            ImGuiNewLine();
            
            ImGuiText("GitHub:");
            ImGuiIndent();
            if ((HOTGLUE_GITHUB_CLIENT_ID == "") || (HOTGLUE_GITHUB_CLIENT_SECRET == ""))
            {
                ImGuiTextColored("Client ID and/or client secret not set (please see `__HotglueConfig`).\nAccess token not available.", INTERFACE_COLOR_ORANGE_TEXT);
            }
            else
            {
                if (HotglueGetGitHubAccessTokenAvailable())
                {
                    ImGuiText("Access token acquired.");
                }
                else
                {
                    ImGuiTextColored("GitHub access token unavailable. Please click the button below to acquire an access token from GitHub.", INTERFACE_COLOR_ORANGE_TEXT);
                    if (ImGuiButton("Authorize GitHub..."))
                    {
                        InterfaceGitHubAuthFlow();
                    }
                }
            }
            
            ImGuiUnindent();
            ImGuiNewLine();
            
            ///////
            // Paths
            ///////
            
            ImGuiText("Paths:");
            ImGuiIndent();
            
            ImGuiBeginTable("pathsTable", 5, ImGuiTableFlags.RowBg);
            ImGuiTableSetupColumn("name", ImGuiTableColumnFlags.WidthFixed, 160);
            ImGuiTableSetupColumn("path");
            ImGuiTableSetupColumn("browse", ImGuiTableColumnFlags.WidthFixed, 70);
            ImGuiTableSetupColumn("test", ImGuiTableColumnFlags.WidthFixed, 40);
            ImGuiTableSetupColumn("reset", ImGuiTableColumnFlags.WidthFixed, 50);
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Cache Directory");
            
            ImGuiTableNextColumn();
            var _oldString = HotglueGetCachePath();
            var _newString = ImGuiInputText("###cachePathInput", _oldString);
            if (ImGuiIsItemDeactivatedAfterEdit() && (_oldString != _newString))
            {
                HotglueSetCachePath(_newString);
                InterfaceSettingsSave();
            }
            
            ImGuiTableNextColumn();
            if (HotglueGetExecuteShellAvailable())
            {
                if (ImGuiButton("Open...##cachePath"))
                {
                    InterfaceOpenURL(HotglueGetCachePath());
                }
            }
            
            ImGuiTableNextColumn();
            
            ImGuiTableNextColumn();
            if (ImGuiButton("Reset##cachePath"))
            {
                HotglueSetCachePath(HOTGLUE_DEFAULT_PATH_CACHE);
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("Savedata Directory");
            
            ImGuiTableNextColumn();
            var _oldString = InterfaceSettingGet("savedataPath", "");
            var _newString = ImGuiInputText("###savedataPathInput", _oldString);
            if (ImGuiIsItemDeactivatedAfterEdit() && (_oldString != _newString))
            {
                InterfaceSettingSet("savedataPath", _newString);
                InterfaceSettingsSave();
            }
            
            ImGuiTableNextColumn();
            if (HotglueGetExecuteShellAvailable())
            {
                if (ImGuiButton("Open...##savedataPath"))
                {
                    InterfaceOpenURL(HotglueGetCachePath());
                }
            }
            
            ImGuiTableNextColumn();
            
            ImGuiTableNextColumn();
            if (ImGuiButton("Reset##savedataPath"))
            {
                InterfaceSettingSet("savedataPath", INTERACE_DEFAULT_PATH_SAVEDATA);
            }
            
            ImGuiTableNextRow();
            ImGuiTableNextColumn();
            ImGuiText("ProjectTool.exe");
            
            ImGuiTableNextColumn();
            InterfaceLinkText(HotglueGetProjectToolPath());
            
            ImGuiTableNextColumn();
            if (ImGuiButton("Browse..."))
            {
                var _newPath = get_open_filename("*.*", "");
                if (_newPath != "")
                {
                    if (HotglueSetProjectToolPath(_newPath))
                    {
                        InterfaceSettingsSave();
                    }
                }
            }
            
            ImGuiTableNextColumn();
            if (ImGuiButton("Test"))
            {
                oInterface.popUpStruct = new ClassModalMessage(HotglueProjectToolTest()? "Test successful." : "Test failed. Please check the log for more information.");
            }
            
            ImGuiTableNextColumn();
            if (ImGuiButton("Reset##projectToolPath"))
            {
                HotglueSetProjectToolPath(HOTGLUE_DEFAULT_PATH_PROJECTTOOL, false);
            }
            
            ImGuiEndTable();
            ImGuiUnindent();
            
            ///////
            // Here be dragons
            ///////
            
            ImGuiNewLine();
            
            ImGuiTextColored("Here be dragons:", INTERFACE_COLOR_RED_TEXT);
            ImGuiIndent();
            
            __advanced = ImGuiCheckbox("I know what I'm doing", __advanced);
            if (__advanced)
            {
                HotglueSetSuppressGitAssert(ImGuiCheckbox("Suppress .git directory assert", HotglueGetSuppressGitAssert()));
                HotglueSetDestructiveCopy(ImGuiCheckbox("Resource copy is destructive", HotglueGetDestructiveCopy()));
            }
            
            ImGuiUnindent();
            ImGuiEndTabItem();
        }
    }
}