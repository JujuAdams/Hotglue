// Feather disable all

/// @param channel

function ClassInterfaceChannelView(_channel) constructor
{
    __channel = _channel;
    
    __searchString = "";
    __selectedRepository = undefined;
    
    __ngram = new NgramStringFuzzy(1, 4, 10, false);
    __ngram.train(__channel.GetRepositoryNameArray());
    
    
    
    static BuildForImport = function()
    {
        if (ImGuiBeginTabItem(__channel.GetName()))
        {
            ImGuiBeginChild("leftPane", undefined, undefined, ImGuiChildFlags.Border);
            
            if (ImGuiBeginCombo($"##combo_{ptr(self)}", (__selectedRepository == undefined)? "No repository selected" : __selectedRepository.GetName(), ImGuiComboFlags.None))
            {
                var _newString = ImGuiInputTextWithHint($"##channelSearch_{ptr(self)}", "Search", __searchString);
                if (_newString != __searchString)
                {
                    __searchString = _newString;
                    __ngram.search(_newString);
                }
                
                ImGuiSameLine();
                
                if (ImGuiButton("Clear"))
                {
                    __searchString = "";
                }
                
                ImGuiSeparator();
                ImGuiBeginChild($"searchPane_{ptr(self)}", undefined, 100);
                
                if (__searchString != "")
                {
                    var _searchResultArray = __ngram.get_value_array();
                    var _i = 0;
                    repeat(array_length(_searchResultArray))
                    {
                        var _repositoryName = _searchResultArray[_i];
                        if (ImGuiSelectable(_searchResultArray[_i], (__selectedRepository == _repositoryName)))
                        {
                            //__selectedRepository = _repository;
                        }
                        
                        ++_i;
                    }
                }
                else
                {
                    var _repositoryArray = __channel.GetRepositoryArray();
                    var _i = 0;
                    repeat(array_length(_repositoryArray))
                    {
                        var _repository = _repositoryArray[_i];
                        if (ImGuiSelectable($"{_repository.GetName()}##{ptr(_repository)}", (__selectedRepository == _repository)))
                        {
                            __selectedRepository = _repository;
                        }
                        
                        ++_i;
                    }
                }
                
                ImGuiEndChild();
                ImGuiEndCombo();
            }
            
            ImGuiNewLine();
            
            if (__selectedRepository != undefined)
            {
                InterfaceEnsureRepositoryView(__selectedRepository).BuildForProjectTab();
            }
            
            ImGuiEndChild();
            ImGuiEndTabItem();
            
            return true;
        }
        else
        {
            return false;
        }
    }
    
    static BuildForExplore = function()
    {
        if (ImGuiBeginTabItem(__channel.GetName()))
        {
            if (__channel.__isRemote)
            {
                if (ImGuiButton("Refresh"))
                {
                    __channel.Refresh();
                }
                
                ImGuiSameLine();
                ImGuiDummy(20, 0);
                ImGuiSameLine();
                ImGuiText(__channel.GetURL());
            }
            
            ImGuiBeginChild("leftPaneOuter", 300, undefined, ImGuiChildFlags.Border);
            
            __searchString = ImGuiInputTextWithHint($"##channelSearch_{ptr(self)}", "Search", __searchString);
            ImGuiSameLine();
            
            if (ImGuiButton("Clear"))
            {
                __searchString = "";
            }
            
            ImGuiSeparator();
            
            if ((not __channel.__isRemote) && (not __channel.__isFavorites))
            {
                if (ImGuiButton("Add content..."))
                {
                    var _path = get_open_filename("*.*", "");
                    if (_path != "")
                    {
                        var _extension = filename_ext(_path);
                        if ((_extension == ".yyp")
                        ||  (_extension == ".yymps")
                        ||  (_extension == ".yyz"))
                        {
                            var _repository = __channel.AddRepository(_path);
                            
                            if (__channel.GetRepositoryCount() == 1)
                            {
                                __selectedRepository = _repository;
                            }
                            else
                            {
                                __channel.SortArray();
                            }
                            
                            InterfaceSettingsSave();
                        }
                        else
                        {
                            LogTraceAndStatus($"File extension \"{_extension}\" unsupported ({_path})");
                        }
                    }
                }
            }
            
            ImGuiBeginChild("leftPaneInner");
        
            var _repositoryArray = __channel.GetRepositoryArray();
            if (array_length(_repositoryArray) <= 0)
            {
                ImGuiTextWrapped("No content has been added.");
                
                if (__channel.__isFavorites)
                {
                    ImGuiNewLine();
                    ImGuiTextWrapped("You can add favourites by toggling the \"Favourite\" checkbox for a repository or local project.");
                }
            }
            else
            {
                var _channelIsLocal = not __channel.__isRemote;
                var _deleteIndex = undefined;
                
                var _i = 0;
                repeat(array_length(_repositoryArray))
                {
                    var _repository = _repositoryArray[_i];
                    
                    if (_channelIsLocal)
                    {
                        if (ImGuiSmallButton($"X##{string(ptr(_repository))}"))
                        {
                            _deleteIndex = _i;
                        }
                        
                        ImGuiSameLine();
                    }
                    
                    if (ImGuiSelectable(_repository.GetName(), __selectedRepository == _repository))
                    {
                        __selectedRepository = _repository;
                    }
                    
                    ++_i;
                }
                
                if (_deleteIndex != undefined)
                {
                    __channel.DeleteRepository(_repositoryArray[_deleteIndex].GetURL());
                    InterfaceSettingsSave();
                }
            }
            
            ImGuiEndChild();
            ImGuiEndChild();
            
            ImGuiSameLine();
            ImGuiBeginChild("rightPane");
            
            if (__selectedRepository == undefined)
            {
                ImGuiText("No content selected.");
            }
            else
            {
                if (__selectedRepository != undefined)
                {
                    InterfaceEnsureRepositoryView(__selectedRepository).BuildForChannelTab();
                }
            }
            
            ImGuiEndChild();
            ImGuiEndTabItem();
        }
    }
}