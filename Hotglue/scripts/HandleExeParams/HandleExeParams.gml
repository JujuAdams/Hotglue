// Feather disable all

/// @param paramArray

function HandleExeParams(_paramArray = undefined)
{
    return new (function(_paramArray = undefined) constructor
    {
        state = 0;
        automation = undefined;
        
        if (_paramArray == undefined)
        {
            __paramArray = array_create(parameter_count(), "");
        
            var _i = 0;
            repeat(parameter_count())
            {
                __paramArray[@ _i] = parameter_string(_i);
                ++_i;
            }
        }
        else
        {
            __paramArray = _paramArray;
        }
        
        __paramCount = array_length(__paramArray);
        __index = 1;
        
        while(__TryRoot()) {}
        
        
        
        static __TryRoot = function()
        {
            if (state != 0) return false;
            if (__index >= __paramCount) return false;
            
            if (__TryRun()) return true;
            if (__TryGame()) return true;
            
            if (__index < __paramCount)
            {
                __HotglueWarning($"Parameter {__index} \"{__paramArray[__index]}\" not supported or encountered an error");
            }
            
            state = -1;
            ++__index;
            
            return true;
        }
        
        static __TryRun = function()
        {
            if (__index >= __paramCount) return false;
            
            if (__paramArray[__index] != "-run") return false;
            
            __HotglueTrace($"Parameter {__index} is `{__paramArray[__index]}`");
            ++__index;
            
            var _path = __TryPath();
            if (_path == undefined)
            {
                __HotglueWarning("Could not find path for `-run` parameter");
                return false;
            }
            
            var _json = undefined;
            try
            {
                var _jsonBuffer = buffer_load(_path);
                var _jsonString = buffer_read(_jsonBuffer, buffer_text);
                buffer_delete(_jsonBuffer);
                var _json = json_parse(_jsonString);
            }
            catch(_error)
            {
                __HotglueWarning($"Failed load and parse \"{_path}\" as JSON");
            }
            
            if (_json == undefined)
            {
                state = -1;
                return false;
            }
            
            state = 1;
            automation = new __HotglueClassAutomation(_json);
            
            return true;
        }
        
        static __TryPath = function()
        {
            if (__index >= __paramCount) return undefined;
            
            var _path = __paramArray[__index];
            
            if (not file_exists(_path))
            {
                __HotglueTrace($"File does not exist \"{_path}\"");
                return undefined;
            }
            
            ++__index;
            
            return _path;
        }
        
        static __TryGame = function()
        {
            return false;
            
            //Test code:
            if (__index >= __paramCount) return false;
            
            if (__paramArray[__index] != "-game") return false;
            
            __HotglueTrace($"Parameter {__index} is `{__paramArray[__index]}`");
            ++__index;
            
            var _path = __TryPath();
            if (_path == undefined)
            {
                __HotglueWarning("Could not find path for `-game` parameter");
                return false;
            }
            
            return true;
        }
    })(_paramArray);
}