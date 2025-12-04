// Feather disable all

function HotglueClearTempCache()
{
    __HotglueTrace($"Clearing temp cache at \"{HOTGLUE_UNZIP_CACHE_DIRECTORY}\"");
    directory_destroy(HOTGLUE_UNZIP_CACHE_DIRECTORY);
}