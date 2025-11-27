// Feather disable all

/// @param relativePath

function __HotglueDetermineResourceType(_relativePath)
{
    if (string_copy(_relativePath, 1, 8) == "scripts/")
    {
        return "script";
    }
    else
    {
        return "unknown";
    }
}