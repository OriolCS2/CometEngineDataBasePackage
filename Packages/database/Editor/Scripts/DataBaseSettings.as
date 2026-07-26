using namespace CometEngine;

class /*@*/ DataBaseSettings : ProjectSetting
{
	[Serialize] private string initialDirectoryDDBB = "DDBB/DDBB/";
	[Serialize] private string initialTablesDirectoryDDBB = "DDBB/Editor/Tables/";

	string InitialDirectoryDDBB
	{
		get
		{
			string path = "Assets/" + initialDirectoryDDBB;
			if (path.at(path.length() - 1) != "/")
			{
				path += "/";
			}
			return path;
		}
	}

	string InitialTablesDirectoryDDBB
	{
		get
		{
			string path = "Assets/" + initialTablesDirectoryDDBB;
			if (path.at(path.length() - 1) != "/")
			{
				path += "/";
			}
			return path;
		}
	}

#ifdef COMET_EDITOR
	ProjectSettingInfo GetInfo()
	{
		ProjectSettingInfo info;
		info.name = "DataBase";
		info.documentationLink = "https://github.com/OriolCS2/CometEngineDataBasePackage";
		info.icon = CometEditor::RawIcon::Database;
		return info;
	}
#endif
}

namespace DataBaseSettings
{
	DataBaseSettings@ Get()
	{
		return cast<DataBaseSettings>(ProjectSetting::Get("DataBaseSettings"));
	}
}
