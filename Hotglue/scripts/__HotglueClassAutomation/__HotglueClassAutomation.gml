// Feather disable all

/// @param json

function __HotglueClassAutomation(_json) constructor
{
    __rootIndex = 0;
    __finished  = false;
    __error     = false;
    __operation = undefined;
    
    if (is_struct(_json))
    {
        _json = [_json];
    }
    else if (not is_array(_json))
    {
        __HotglueWarning($"Invalid automation root input (typeof={typeof(_json)}), aborting");
        __finished = true;
        __error = true;
    }
    
    __json = _json;
    
    __project = undefined;
    __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, function()
    {
        if (__finished)
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
            return;
        }
        
        if (__rootIndex >= array_length(__json))
        {
            __finished = true;
            return;
        }
        
        if (__operation != undefined)
        {
            if (__operation())
            {
                ++__rootIndex;
            }
        }
        else
        {
            var _input = __json[__rootIndex];
            if (not is_struct(_input))
            {
                __HotglueWarning($"Invalid automation step (index={__rootIndex}, typeof={typeof(_json)}), aborting");
                __finished = true;
                __error = true;
                return;
            }
            
            if (struct_exists(_input, "destination"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["destination"])) return;
                
                var _value = _input.destination
                if (not is_string(_value))
                {
                    __Error($".destination must be a string (typeof={typeof(_value)})");
                    return;
                }
                
                var _project = HotglueProjectLocalEnsure(_value);
                if (_project == undefined)
                {
                    __Error($"Failed to load \"{_value}\"");
                    return;
                }
                
                __project = _project;
                ++__rootIndex;
            }
            else if (struct_exists(_input, "suppressGitAssert"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["suppressGitAssert"])) return;
                
                var _value = _input.suppressGitAssert
                if (not is_bool(_value))
                {
                    __Error($".suppressGitAssert must be true or false (typeof={typeof(_value)})");
                    return;
                }
                
                HotglueSetSuppressGitAssert(_value);
                ++__rootIndex;
            }
            else if (struct_exists(_input, "itchApiKey"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n(itch.io API key hidden for security)");
                if (not __CheckClean(_input, ["itchApiKey"])) return;
                
                var _value = _input.itchApiKey
                if (not is_bool(_value))
                {
                    __Error($".itchApiKey must be a string (typeof={typeof(_value)})");
                    return;
                }
                
                HotglueSetItchAPIKey(_value);
                ++__rootIndex;
            }
            else if (struct_exists(_input, "import"))
            {
                __HotglueTrace($"Automation step {__rootIndex}\n{json_stringify(_input, true)}");
                if (not __CheckClean(_input, ["import", "assets", "subfolder", "packageName", "packageVersion"])) return;
                
                var _import = _input.import
                if (not is_string(_import))
                {
                    __Error($".import must be a string (typeof={typeof(_import)})");
                    return;
                }
                
                if (InterfaceGuessURLIsRemote(_import))
                {
                    __Error($"Cannot directly import a remote file");
                    return;
                }
                
                var _project = HotglueProjectLocalEnsure(_import);
                if (_project == undefined)
                {
                    __Error($"Failed to load \"{_import}\"");
                    return;
                }
                
                var _job = __project.JobImportAllFrom(_project);
                _job.BuildReport();
                _job.Execute();
                
                ++__rootIndex;
            }
            else
            {
                __Error($"Invalid automation step (index={__rootIndex}), aborting");
                __HotglueWarning(json_stringify(_input, true));
                return;
            }
        }
    },
    [], -1);
    
    time_source_start(__timeSource);
    
    
    
    static GetFinished = function()
    {
        return __finished;
    }
    
    static GetError = function()
    {
        return __error;
    }
    
    static __Error = function(_message)
    {
        __HotglueWarning(_message);
        __finished = true;
        __error = true;
    }
    
    static __CheckClean = function(_struct, _permittedNameArray)
    {
        var _namesArray = struct_get_names(_struct);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            
            if (array_get_index(_permittedNameArray, _name) < 0)
            {
                __Error($"Member variable \"{_name}\" not permitted in automation step (permitted={_permittedNameArray})");
                return false;
            }
            
            ++_i;
        }
        
        return true;
    }
}