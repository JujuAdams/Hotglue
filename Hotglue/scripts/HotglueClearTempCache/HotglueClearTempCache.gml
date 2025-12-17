// Feather disable all

function HotglueClearTempCache()
{
    __HotglueTrace($"Clearing temp cache at \"{HOTGLUE_TEMP_CACHE_DIRECTORY}\"");
    directory_destroy(HOTGLUE_TEMP_CACHE_DIRECTORY);
}