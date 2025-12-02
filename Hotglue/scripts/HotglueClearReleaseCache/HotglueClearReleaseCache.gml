// Feather disable all

function HotglueClearReleaseCache()
{
    __HotglueTrace($"Clearing release cache at \"{HOTGLUE_RELEASE_CACHE_DIRECTORY}\"");
    directory_destroy(HOTGLUE_RELEASE_CACHE_DIRECTORY);
}