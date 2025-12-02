// Feather disable all

HotglueSetTraceHandler(InterfaceTrace);
HotglueSetWarningHandler(InterfaceWarning);
HotglueClearUnzipCache();

//if (debug_mode)
//{
//    HotglueClearReleaseCache();
//}

//var _channel = HotglueEnsureChannel("https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json");
//_channel.Refresh(function(_channel, _success)
//{
//    var _repositoryArray = _channel.GetRepositoryArray();
//    var _i = 0;
//    repeat(array_length(_repositoryArray))
//    {
//        var _repository = _repositoryArray[_i];
//        _repository.GetHotglueJSON();
//        _repository.GetReleases();
//        _repository.SetFinalCallback(function(_repository)
//        {
//            var _latestStable = _repository.GetLatestStable();
//            if (is_struct(_latestStable))
//            {
//                _latestStable.LoadProject(function(_project, _success)
//                {
//                    if (_success && is_struct(_project))
//                    {
//                        InterfaceStatus($"Loaded \"{_project.GetPath()}\"");
//                        execute_shell_simple(filename_dir(_project.GetPath()));
//                    }
//                });
//            }
//        });
//        
//        ++_i;
//    }
//});

//TODO - CLI

instance_destroy();
instance_create_depth(0, 0, 0, oInterface);