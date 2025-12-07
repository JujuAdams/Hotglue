// Feather disable all

/// @param channel

function ClassInterfaceChannelView(_channel) constructor
{
    __channel = _channel;
    
    __selectedRepository = undefined;
    
    
    
    static BuildHalfViewTab = function()
    {
        if (ImGuiBeginTabItem(__channel.GetName()))
        {
            ImGuiBeginChild("leftPane", undefined, undefined, ImGuiChildFlags.Border);
            
            if (ImGuiBeginCombo($"##combo_{ptr(self)}", (__selectedRepository == undefined)? "None selected" : __selectedRepository.GetName(), ImGuiComboFlags.None))
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
                
                ImGuiEndCombo();
            }
            
            ImGuiNewLine();
            
            if (__selectedRepository != undefined)
            {
                InterfaceEnsureRepositoryView(__selectedRepository).Build();
            }
            
            ImGuiEndChild();
            ImGuiEndTabItem();
        }
    }
    
    static BuildFullViewTab = function()
    {
        if (ImGuiBeginTabItem(__channel.GetName()))
        {
            if (is_instanceof(__channel, __HotglueChannelGitHub))
            {
                if (ImGuiButton("Refresh"))
                {
                    Refresh();
                }
                
                ImGuiSameLine();
                ImGuiDummy(20, 0);
                ImGuiSameLine();
                ImGuiText(__channel.GetURL());
            }
            
            ImGuiBeginChild("leftPaneOuter", 250, undefined, ImGuiChildFlags.Border);
            
            if (is_instanceof(__channel, __HotglueChannelFavorites))
            {
                
            }
            else if (is_instanceof(__channel, __HotglueChannelLocal))
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
            }
            else
            {
                var _i = 0;
                repeat(array_length(_repositoryArray))
                {
                    var _repository = _repositoryArray[_i];
                    if (ImGuiSelectable(_repository.GetName(), __selectedRepository == _repository))
                    {
                        __selectedRepository = _repository;
                    }
                    
                    ++_i;
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
                    InterfaceEnsureRepositoryView(__selectedRepository).Build();
                }
            }
            
            ImGuiEndChild();
            ImGuiEndTabItem();
        }
    }
}