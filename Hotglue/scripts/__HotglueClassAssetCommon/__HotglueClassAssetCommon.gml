// Feather disable all

function __HotglueClassAssetCommon() constructor
{    
    static __RemoveFromYYP = function(_project)
    {
        var _yypString = _project.__yypString;
        
        var _insertString = __GetYYPInsertString();
        var _pos = string_pos(_insertString, _yypString);
        
        if (_pos > 0)
        {
            _project.__yypString = string_delete(_yypString, _pos, string_length(_insertString));
            
            //TODO - Rooms need to be removed from the room order
            //TOFO - RoomUI has weird special rules too I think?
        }
        else
        {
            //TODO - Error handling?
        }
    }
}