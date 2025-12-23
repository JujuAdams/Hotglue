// Feather disable all

/// @param job

function ClassModalConfirmJob(_job) constructor
{
    __job = _job;
    
    __loadPending = false;
    __loadSuccessful = true;
    
    
    
    static Build = function()
    {
        var _name = $"##modal_{string(ptr(self))}";
        
        ImGuiOpenPopup(_name);
        ImGuiSetNextWindowSize(0.5*oInterface.context.GetRegion().width, 0.666*oInterface.context.GetRegion().height);
        var _result = ImGuiBeginPopupModal(_name, true);
        if (_result & ImGuiReturnMask.Return)
        {
            if ((not __loadPending) && (not __loadSuccessful))
            {
                ImGuiTextColored("Failed to load release project.", INTERFACE_COLOR_RED_TEXT);
                ImGuiText("Please check the log for more information.");
            }
            else if (__loadPending)
            {
                ImGuiText("Loading release project, please wait...");
            }
            else
            {
                ImGuiText("Please confirm that you would like to make the following changes.");
            }
            
            ImGuiNewLine();
            ImGuiBeginDisabled(__loadPending || (not __loadSuccessful) || (__job == undefined));
            if (ImGuiButton("Confirm"))
            {
                var _success = false;
                try
                {
                    __job.Execute();
                    _success = true;
                }
                catch(_error)
                {
                    LogWarning(json_stringify(_error, true));
                }
                
                if (_success)
                {
                    var _message = "Job completed successfully.";
                }
                else
                {
                    var _message = "Job encountered an error. Please check the log for more information.";
                }
                
                oInterface.popUpStruct = new ClassModalMessage(_message);
            }
            ImGuiEndDisabled();
            
            ImGuiSameLine(undefined, 50);
            if (ImGuiButton("Abort"))
            {
                oInterface.popUpStruct = undefined;
            }
            
            if ((not __loadPending) && __loadSuccessful)
            {
                ImGuiNewLine();
                
                var _func = function(_title, _array)
                {
                    if (ImGuiCollapsingHeader($"{_title} ({array_length(_array)})"))
                    {
                        if (array_length(_array) <= 0)
                        {
                            ImGuiText($"(No {string_lower(_title)})");
                        }
                        else
                        {
                            ImGuiText($"{array_length(_array)} {string_lower(_title)}:");
                            
                            var _i = 0;
                            repeat(array_length(_array))
                            {
                                ImGuiText(_array[_i]);
                                ++_i;
                            }
                        }
                    }
                }
                
                _func("Conflicts",  __job.GetConflictArray());
                _func("Additions",  __job.GetAddArray());
                _func("Overwrites", __job.GetOverwriteArray());
                _func("Deletions",  __job.GetDeleteArray());
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