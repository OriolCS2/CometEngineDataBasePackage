using namespace CometEngine;

namespace DataBaseEditor
{
	class /*@*/ DataBaseSettings : ProjectSetting
	{
		[Serialize] private string initialDirectoryDDBB = "DDBB/DDBB/";
		[Serialize] private string initialTablesDirectoryDDBB = "DDBB/Editor/";

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

		[ShowButton("Create Directories")]
		void CreateFolders()
		{
			CometEditor::AssetDataBase::CreateDirectory(initialDirectoryDDBB);
			CometEditor::AssetDataBase::CreateDirectory(initialTablesDirectoryDDBB);
		}

		ProjectSettingInfo GetInfo()
		{
			ProjectSettingInfo info;
			info.name = "DataBase";
			info.documentationLink = "https://github.com/OriolCS2/CometEngineDataBasePackage";
			info.icon = CometEditor::RawIcon::Database;
			return info;
		}
	}

	namespace DataBaseSettings
	{
		DataBaseSettings@ Get()
		{
			return cast<DataBaseSettings>(ProjectSetting::Get("DataBaseSettings"));
		}
	}
}
