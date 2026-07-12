// Feather disable all

/// @param repository

function ClassInterfaceRepositoryView(_repository) constructor
{
    static _channelArray = __HotglueSystem().__channelArray;
    
    __repository = _repository;
    
    __selectedRelease = __repository.GetLatestRelease();
    __selectedProject = undefined;
    __projectView = undefined;
    
    ___forceFirstTabSelected = false;
    
    
    
    static BuildRepositoryHeader = function()
    {
        var _favoritesChannel = HotglueGetChannelByURL(HOTGLUE_FAVORITES_CHANNEL);
        var _url = __repository.GetURL();
        
        ImGuiText(__repository.GetName());
        ImGuiSameLine(undefined, 20);
        InterfaceLinkText(_url);
        
        var _oldValue = _favoritesChannel.GetRepositoryExists(_url);
        var _newValue = ImGuiCheckbox("Favourite", _oldValue);
        if (_oldValue != _newValue)
        {
            if (_newValue)
            {
                _favoritesChannel.AddRepository(_url);
                LogTraceAndStatus($"Favourited \"{_url}\"");
            }
            else
            {
                _favoritesChannel.DeleteRepository(_url);
                LogTraceAndStatus($"Unfavourited \"{_url}\"");
            }
            
            _favoritesChannel.SortArray();
            InterfaceSettingsSave();
        }
        
        if (__repository.__isRemote)
        {
            ImGuiSameLine(undefined, 20);
            if (ImGuiButton("Refresh###repositoryView"))
            {
                __repository.Refresh();
            }
            
            ImGuiSameLine(undefined, 20);
            if (ImGuiButton("Copy URI link"))
            {
                clipboard_set_text($"https://jujuadams.github.io/hotglue?url={__HotglueEncodeURI(_url)}");
                LogTraceAndStatus($"Copied \"{_url}\" to clipboard");
            }
            
            if (ImGuiBeginItemTooltip())
            {
                ImGuiText($"https://jujuadams.github.io/hotglue?url={_url}");
                ImGuiEndTooltip();
            }
        }
        
        if ((__selectedRelease != undefined) && (array_length(__selectedRelease.__dependenciesArray) > 0))
        {
            ImGuiPushStyleColor(ImGuiCol.Text, INTERFACE_COLOR_RED_TEXT, 1);
            ImGuiTextWrapped("Dependencies will not be automatically added to your project. ");
            ImGuiPopStyleColor();
        }
        else
        {
            ImGuiNewLine();
        }
    }
    
    static BuildRepositoryDescription = function()
    {
        if (__repository.__isRemote)
        {
            var _readme = __repository.GetReadme();
            if (_readme == undefined)
            {
                ImGuiText("Fetching, please wait...");
            }
            else
            {
                ImGuiTextWrapped(_readme);
            }
        }
        else
        {
            if ((__selectedRelease != undefined) && (__projectView == undefined))
            {
                __selectedRelease.LoadContent(function(_struct, _success)
                {
                    if (_success)
                    {
                        if (is_instanceof(_struct, __HotglueProject))
                        {
                            if (_struct.GetLoadedSuccessfully())
                            {
                                LogTraceAndStatus($"Loaded project successfully for release \"{__selectedRelease.GetWebURL()}\"");
                                __selectedProject = _struct;
                                __projectView = new ClassInterfaceProjectView(_struct);
                            }
                            else
                            {
                                LogWarning($"Failed to load content for release \"{__selectedRelease.GetWebURL()}\"");
                                __selectedProject = undefined;
                                __projectView = undefined;
                            }
                        }
                        else
                        {
                            LogWarning($"\"{__selectedRelease.GetWebURL()}\" loaded successfully but was not a project ({instanceof(_struct)})");
                            __selectedProject = undefined;
                            __projectView = undefined;
                        }
                    }
                    else
                    {
                        LogWarning($"Failed to load content for release \"{__selectedRelease.GetWebURL()}\"");
                        __selectedProject = undefined;
                        __projectView = undefined;
                    }
                });
            }
            
            if (__projectView != undefined)
            {
                ImGuiBeginChild("projectPreview");
                ImGuiBeginTabBar("projectPreviewTabBar");
                
                if (ImGuiBeginTabItem("Overview"))
                {
                    BuildRepositoryHeader();
                    ImGuiNewLine();
                    __projectView.BuildOverview();
                    ImGuiEndTabItem();
                }
                
                if (ImGuiBeginTabItem("Resources"))
                {
                    __projectView.BuildTreeAsDestination();
                    ImGuiEndTabItem();
                }
                
                ImGuiEndTabBar();
                ImGuiEndChild();
            }
            else
            {
                BuildRepositoryHeader();
                ImGuiNewLine();
                ImGuiText("Loading project...");
            }
        }
    }
    
    static BuildReleaseDownloadButton = function()
    {
        if (__repository.__isRemote)
        {
            var _releaseArray = __repository.GetReleases();
            ImGuiBeginDisabled((not is_array(_releaseArray)) || (array_length(_releaseArray) <= 0));
            
            if (ImGuiButton("Manual download"))
            {
                LogTraceAndStatus($"Downloading release \"{__selectedRelease.GetDownloadURL()}\"");
                __selectedRelease.Download(function(_release, _success, _localURL)
                {
                    if (_success)
                    {
                        LogTraceAndStatus($"Downloaded \"{_release.GetDownloadURL()}\" successfully");
                        
                        var _filename = get_save_filename($"{filename_ext(_localURL)}|{filename_ext(_localURL)}", filename_name(__selectedRelease.GetPrimaryAssetURL()));
                        if (_filename != "")
                        {
                            file_copy(_localURL, _filename);
                            LogTraceAndStatus($"Copied \"{_localURL}\" to \"{_filename}\"");
                        }
                    }
                });
            }
            
            ImGuiEndDisabled();
        }
    }
    
    static BuildReleaseDescription = function(_showDownloadButton)
    {
        if (__repository.__isRemote)
        {
            var _releaseArray = __repository.GetReleases();
            if (_releaseArray == undefined)
            {
                ImGuiText("Fetching, please wait...");
            }
            else
            {
                if (__selectedRelease == undefined)
                {
                    __selectedRelease = array_first(_releaseArray);
                }
                
                if (is_instanceof(__repository, __HotglueRepositoryGitHub))
                {
                    ImGuiText($"Found {array_length(_releaseArray)} releases (max {HOTGLUE_MAX_GITHUB_RELEASES})");
                }
                else
                {
                    ImGuiText($"Found {array_length(_releaseArray)} downloads");
                }
                
                ImGuiSameLine();
                ImGuiSetNextItemWidth(ImGuiGetWindowWidth()/3);
                if (ImGuiBeginCombo($"##combo_{ptr(self)}", (__selectedRelease == undefined)? "No release selected" : __selectedRelease.GetName(), ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_releaseArray))
                    {
                        var _release = _releaseArray[_i];
                        if (ImGuiSelectable($"{_release.GetName()}##{ptr(_release)}", (__selectedRelease == _release)))
                        {
                            __selectedRelease = _release;
                        }
                    
                        ++_i;
                    }
                    
                    ImGuiEndCombo();
                }
                
                if ((__selectedRelease != undefined) && (not __selectedRelease.GetStable()))
                {
                    ImGuiSameLine();
                    ImGuiTextColored("Pre-release", INTERFACE_COLOR_RED_TEXT);
                }
                
                ImGuiBeginDisabled(__selectedRelease == undefined);
                
                if (_showDownloadButton)
                {
                    ImGuiSameLine();
                    BuildReleaseDownloadButton();
                }
                
                if (oInterface.settingsTab.__advanced)
                {
                    ImGuiSameLine();
                    if (ImGuiButton("Test Load"))
                    {
                        __selectedRelease.LoadContent();
                    }
                }
                
                ImGuiEndDisabled();
                
                ImGuiNewLine();
                
                ImGuiBeginChild("releaseDecriptionPane");
                if (__selectedRelease == undefined)
                {
                    ImGuiText("No release selected.");
                }
                else
                {
                    var _description = __selectedRelease.GetDescription();
                    if ((_description == undefined) || (_description == ""))
                    {
                        ImGuiText("No release description found or description empty.");
                    }
                    else
                    {
                        ImGuiTextWrapped(_description);
                    }
                }
                
                ImGuiEndChild();
            }
        }
    }
    
    static BuildReleaseDependencies = function()
    {
        if (__selectedRelease == undefined)
        {
            ImGuiTextWrapped("Please select a release from the \"NPM Package\" tab.");
            return;
        }
        
        var _dependenciesArray = __selectedRelease.__dependenciesArray;
        if (array_length(_dependenciesArray) <= 0)
        {
            ImGuiTextWrapped("No dependencies.");
            return;
        }
        
        ImGuiTextWrapped($"Showing dependencies for release \"{__selectedRelease.GetName()}\".");
        ImGuiNewLine();
        
        ImGuiTextWrapped("These dependencies will not be automatically added to your project. You should add these dependencies yourself manually.");
        ImGuiNewLine();
        
        ImGuiBeginTable("dependenciesTable", 2, ImGuiTableFlags.BordersInner | ImGuiTableFlags.BordersOuter);
        
        ImGuiTableSetupColumn("Name");
        ImGuiTableSetupColumn("Version");
        ImGuiTableHeadersRow();
        
        var _i = 0;
        repeat(array_length(_dependenciesArray))
        {
            var _dependencyReference = _dependenciesArray[_i];
            var _dependencyName = _dependencyReference.__name;
            
            ImGuiTableNextRow();
            
            ImGuiTableNextColumn();
            
            var _repository = HotglueGetRepositoryFromName(_dependencyName);
            if (_repository != undefined)
            {
                ImGuiTextLink(_dependencyName);
                var _clicked = ImGuiIsItemClicked();
                
                if (ImGuiBeginItemTooltip())
                {
                    ImGuiText("Click to show this dependency");
                    ImGuiEndTooltip();
                }
                
                if (_clicked)
                {
                    with(oInterface.projectTab)
                    {
                        __importMode = "channels";
                        
                        var _channelArray = __HotglueSystem().__channelArray;
                        __selectedChannel = array_get_index(_channelArray, _repository.__channel);
                        
                        var _channelView = InterfaceEnsureChannelView(_repository.__channel);
                        if (_channelView != undefined)
                        {
                            _channelView.__selectedRepository = _repository;
                        }
                        
                        var _repositoryView = InterfaceEnsureRepositoryView(_repository);
                        if (_repositoryView)
                        {
                            _repositoryView.___forceFirstTabSelected = true;
                        }
                    }
                }
            }
            else
            {
                ImGuiTextColored(_dependencyName, INTERFACE_COLOR_RED_TEXT);
                if (ImGuiBeginItemTooltip())
                {
                    ImGuiText("This dependency could not be found in Hotglue.");
                    ImGuiEndTooltip();
                }
            }
            
            ImGuiTableNextColumn();
            ImGuiText(_dependencyReference.__versionPattern);
            
            ++_i;
        }
        
        ImGuiEndTable();
    }
    
    static Build = function(_showDownloadButton)
    {
        BuildRepositoryHeader();
        ImGuiNewLine();
        
        if (__repository.__isRemote)
        {
            var _firstTabFlags = ___forceFirstTabSelected? ImGuiTabItemFlags.SetSelected : undefined;
            ___forceFirstTabSelected = false;
            
            ImGuiBeginTabBar("repoTabBar");
            
            if (is_instanceof(__repository, __HotglueRepositoryGitHub))
            {
                if (ImGuiBeginTabItem("README", undefined, _firstTabFlags))
                {
                    BuildRepositoryDescription();
                    ImGuiEndTabItem();
                }
                
                if (ImGuiBeginTabItem("Releases"))
                {
                    BuildReleaseDescription(_showDownloadButton);
                    ImGuiEndTabItem();
                }
            }
            else if (is_instanceof(__repository, __HotglueRepositoryGist))
            {
                if (ImGuiBeginTabItem("Description", undefined, _firstTabFlags))
                {
                    if (_showDownloadButton)
                    {
                        BuildReleaseDownloadButton();
                        ImGuiNewLine();
                    }
                    
                    BuildRepositoryDescription();
                    
                    ImGuiEndTabItem();
                }
            }
            else if (is_instanceof(__repository, __HotglueRepositoryVerdaccio))
            {
                if (ImGuiBeginTabItem("NPM Package", undefined, _firstTabFlags))
                {
                    BuildReleaseDescription(_showDownloadButton);
                    ImGuiEndTabItem();
                }
                
                if ((__selectedRelease != undefined) && (array_length(__selectedRelease.__dependenciesArray) > 0))
                {
                    if (ImGuiBeginTabItem("Dependencies"))
                    {
                        BuildReleaseDependencies();
                        ImGuiEndTabItem();
                    }
                }
            }
            else
            {
                if (ImGuiBeginTabItem("Description", undefined, _firstTabFlags))
                {
                    BuildRepositoryDescription();
                    ImGuiEndTabItem();
                }
                
                if (ImGuiBeginTabItem("Downloads"))
                {
                    BuildReleaseDescription(_showDownloadButton);
                    ImGuiEndTabItem();
                }
            }
            
            ImGuiEndTabBar();
        }
        else
        {
            ImGuiBeginChild("##repoDescriptionPane");
            BuildRepositoryDescription();
            ImGuiEndChild();
        }
    }
}