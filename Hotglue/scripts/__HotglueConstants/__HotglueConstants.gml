// Feather disable all

#macro HOTGLUE_VERSION  "0.2.0"
#macro HOTGLUE_DATE  "2025-12-23"

#macro HOTGLUE_RUNNING_FROM_IDE  (GM_build_type == "run")

// As per `https://docs.github.com/en/rest/releases/releases`
#macro HOTGLUE_MAX_GITHUB_RELEASES  100

#macro HOTGLUE_AUTH_CACHE_DIRECTORY   (game_save_id + "auth/")
#macro HOTGLUE_UNZIP_CACHE_DIRECTORY  (HotglueGetCachePath() + "unzip/")
#macro HOTGLUE_HTTP_CACHE_DIRECTORY   (HotglueGetCachePath() + "http/")
#macro HOTGLUE_TEMP_CACHE_DIRECTORY   (HotglueGetCachePath() + "temp/")

#macro HOTGLUE_GITHUB_AUTH_SCOPE  "repo"

#macro HOTGLUE_FAVORITES_CHANNEL  "@favorites"
#macro HOTGLUE_CUSTOM_CHANNEL     "@custom"

#macro HOTGLUE_CHANNEL_JSON              "JSON"
#macro HOTGLUE_CHANNEL_DIRECTORY         "Directory"
#macro HOTGLUE_CHANNEL_GMK               "GameMaker Kitchen"
#macro HOTGLUE_CHANNEL_GITHUB_USER       "GitHub User"
#macro HOTGLUE_CHANNEL_GITHUB_ORG        "GitHub Organization"
#macro HOTGLUE_CHANNEL_GITHUB_AUTH_USER  "GitHub Auth User"

#macro HOTGLUE_REPOSITORY_LOCAL   "local"
#macro HOTGLUE_REPOSITORY_GITHUB  "github"
#macro HOTGLUE_REPOSITORY_GIST    "gist"
#macro HOTGLUE_REPOSITORY_ITCH    "itch"

#macro HOTGLUE_DEFAULT_PATH_CACHE        game_save_id + "cache/"
#macro HOTGLUE_DEFAULT_PATH_PROJECTTOOL  "C:/Program Files/GameMaker/packages/project-tool-win-x64/ProjectTool.exe"