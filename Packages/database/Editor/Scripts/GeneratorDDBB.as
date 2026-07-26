namespace DataBaseEditor
{
	class TableData
	{
		string path;
		TableDDBB table;
	}

	namespace GeneratorDDBB
	{
		string RemoveAssetsFromPath(const string&in path)
		{
			return path.substr(7);
		}
	}

	class GeneratorDDBB
	{
		private string generateFileHeader = "// **************************************************\n// ****** DDBB GENERATED FILE - DO NOT MODIFY *******\n// **************************************************\n\nusing namespace CometEngine;\nusing namespace CometEngine::Json;\n\nnamespace DDBB\n{\n";

		void Generate()
		{
			string initialDirectoryDDBB = DataBaseSettings::Get().InitialDirectoryDDBB;
			if (!FileSystem::IsDirectory(initialDirectoryDDBB))
			{
				FileSystem::CreateDir(initialDirectoryDDBB);
			}

			string initialTablesDirectoryDDBB = DataBaseSettings::Get().InitialTablesDirectoryDDBB;
			if (FileSystem::IsDirectory(initialTablesDirectoryDDBB))
			{
				array<string> existingExtensionPaths = GetAllExtensionDDBBPaths();
				DeleteGeneratedDDBBFiles();

				array<TableData@> tablesData;
				array<string> tablesPath = GetAllTablesPath();
				uint tablesCount = tablesPath.length();
				for (uint i = 0; i < tablesCount; i++)
				{
					TableDDBB table = cast<TableDDBB>(AssetDataBase::Load(GeneratorDDBB::RemoveAssetsFromPath(tablesPath[i]), ResourceType::COMET_OBJECT));
					if (Object::IsValid(table))
					{
						TableData@tableData = TableData();
						tableData.path = initialDirectoryDDBB + tablesPath[i].substr(initialTablesDirectoryDDBB.length());
						tableData.table = table;
						tablesData.insertLast(tableData);
					}
				}

				string globalDDBBfileData = generateFileHeader;
				globalDDBBfileData += "\tmixin class DDBB\n\t{\n";

				string loadGlobalMethodData = "\t\tvoid LoadGlobal(JsonObject toLoad)\n\t\t{\n";
				string saveGlobalMethodData = "\t\tvoid SaveGlobal(JsonObject toSave)\n\t\t{\n";

				string loadSlotMethodData = "\t\tvoid LoadSlot(JsonObject toLoad)\n\t\t{\n";
				string saveSlotMethodData = "\t\tvoid SaveSlot(JsonObject toSave)\n\t\t{\n";

				if (!tablesData.isEmpty())
				{
					uint tablesDataCount = tablesData.length();
					for (uint i = 0; i < tablesDataCount; i++)
					{
						TableData@tableData = tablesData[i];
						GenerateData(tableData, existingExtensionPaths);
						if (tableData.table.isRoot)
						{
							globalDDBBfileData += "\t\t" + tableData.table.name + "ExtensionDDBB " + tableData.table.name + " = " + tableData.table.name + "ExtensionDDBB();\n";

							string loadObjectName = tableData.table.name + "JsonObj";
							string loadObjectString = "\t\t\tJsonObject " + loadObjectName + " = toLoad.GetObject(\"" + tableData.table.name + "\");\n\t\t\tif (" + loadObjectName + " !is null)\n\t\t\t{\n\t\t\t\t" + tableData.table.name + ".Load(" + loadObjectName + ");\n\t\t\t}\n";
							string saveObjectString = "\t\t\t" + tableData.table.name + ".Save(toSave.AddObject(\"" + tableData.table.name + "\"));\n";

							switch (tableData.table.saveLoadMode)
							{
								case TableSaveLoadMode::GLOBAL:
								loadGlobalMethodData += loadObjectString;
								saveGlobalMethodData += saveObjectString;
								break;
								case TableSaveLoadMode::SLOT:
								loadSlotMethodData += loadObjectString;
								saveSlotMethodData += saveObjectString;
								break;
							}
						}
						AssetDataBase::Unload(tableData.table);
					}
				}

				saveGlobalMethodData += "\t\t}\n";
				globalDDBBfileData += "\n" + saveGlobalMethodData;

				loadGlobalMethodData += "\t\t}\n";
				globalDDBBfileData += "\n" + loadGlobalMethodData;

				saveSlotMethodData += "\t\t}\n";
				globalDDBBfileData += "\n" + saveSlotMethodData;

				loadSlotMethodData += "\t\t}\n";
				globalDDBBfileData += "\n" + loadSlotMethodData;

				globalDDBBfileData += "\t}\n}";
				FileSystem::Save(initialDirectoryDDBB + "DDBB.as", globalDDBBfileData);

				string globalDDBBExtensionFilePath = initialDirectoryDDBB + "DDBBExtension.as";
				if (!FileSystem::Exists(globalDDBBExtensionFilePath))
				{
					string globalDDBBExtensionFileData = "using namespace CometEngine;\n\nnamespace DDBB\n{\n\tclass /*@*/ DDBBExtension : DDBB\n\t{\n\n\t}\n}";
					FileSystem::Save(globalDDBBExtensionFilePath, globalDDBBExtensionFileData);
				}

				uint remainingCount = existingExtensionPaths.length();
				for (uint i = 0; i < remainingCount; i++)
				{
					FileSystem::Remove(existingExtensionPaths[i]);
				}
			}
		}

		private void GenerateData(TableData@tableData, array<string>&inout existingExtensionPaths)
		{
			string dir = GetDirectoryFromPath(tableData.path);
			if (!FileSystem::IsDirectory(dir))
			{
				FileSystem::CreateDir(dir);
			}

			string fileData = generateFileHeader;
			fileData += "\tmixin class " + tableData.table.name + "DDBB" + "\n\t{\n";

			string loadMethodData = "\t\tvoid Load(JsonObject toLoad)\n\t\t{\n";
			string saveMethodData = "\t\tvoid Save(JsonObject toSave)\n\t\t{\n";

			uint fieldsCount = tableData.table.fields.length();
			for (uint i = 0; i < fieldsCount; i++)
			{
				TableDDBBField def = tableData.table.fields[i];
				if ((def.type != TableDDBBFieldType::DATA_DEFINITION && def.type != TableDDBBFieldType::ARRAY_DATA_DEFINITION && def.type != TableDDBBFieldType::DICT_DATA_DEFINITION) || (Object::IsValid(def.TableDDBBType) && !Object::Is(def.TableDDBBType, tableData.table)))
				{
					fileData += "\t\t" + def.GetDeclaration() + "\n";

					loadMethodData += "\t\t\t" + def.GetLoadString() + "\n";
					saveMethodData += "\t\t\t" + def.GetSaveString() + "\n";
				}
				else if (Object::IsValid(def.TableDDBBType))
				{
					Debug::Log("Skipping field " + def.name + " in table " + tableData.table.name + " because it references its own table.");
				}
				else
				{
					Debug::Log("Skipping field " + def.name + " in table " + tableData.table.name + " because it is a TableDDBB field without a valid reference.");
				}
			}

			saveMethodData += "\t\t}\n";
			fileData += "\n" + saveMethodData;

			loadMethodData += "\t\t}\n";
			fileData += "\n" + loadMethodData;

			fileData += "\t}\n}";
			FileSystem::Save(dir + tableData.table.name + "DDBB" + ".as", fileData);

			string extensionFileName = tableData.table.name + "ExtensionDDBB" + ".as";
			string extensionFilePath = dir + extensionFileName;

			int foundIndex = -1;
			uint existingCount = existingExtensionPaths.length();
			for (uint i = 0; i < existingCount; i++)
			{
				int lastSlash = existingExtensionPaths[i].findLastOf("/");
				string existingFileName = existingExtensionPaths[i].substr(lastSlash + 1);
				if (existingFileName == extensionFileName)
				{
					foundIndex = int(i);
					break;
				}
			}

			if (foundIndex != -1)
			{
				if (existingExtensionPaths[foundIndex] != extensionFilePath)
				{
					FileSystem::Rename(existingExtensionPaths[foundIndex], extensionFilePath);
				}
				existingExtensionPaths.removeAt(foundIndex);
			}
			else if (!FileSystem::Exists(extensionFilePath))
			{
				string extensionFileData = "using namespace CometEngine;\n\nnamespace DDBB\n{\n\tclass /*@*/ " + tableData.table.name + "ExtensionDDBB : " + tableData.table.name + "DDBB\n\t{\n\n\t}\n}";
				FileSystem::Save(extensionFilePath, extensionFileData);
			}
		}

		private array<string> GetAllExtensionDDBBPaths()
		{
			array<string> extensionPaths;

			string initialDirectoryDDBB = DataBaseSettings::Get().InitialDirectoryDDBB;
			if (!FileSystem::IsDirectory(initialDirectoryDDBB))
			{
				return extensionPaths;
			}

			array<string> directoriesToCheck;
			directoriesToCheck.insertLast(initialDirectoryDDBB);
			while (!directoriesToCheck.isEmpty())
			{
				string currentDirectory = directoriesToCheck[0];
				directoriesToCheck.removeAt(0);

				array<string> files = FileSystem::GetFilesAt(currentDirectory);
				uint filesCount = files.length();
				for (uint i = 0; i < filesCount; i++)
				{
					if (IsExtensionDDBBFile(files[i]))
					{
						extensionPaths.insertLast(currentDirectory + files[i]);
					}
				}

				array<string> subDirectories = FileSystem::GetDirectoriesAt(currentDirectory);
				uint subDirectoriesCount = subDirectories.length();
				for (uint j = 0; j < subDirectoriesCount; j++)
				{
					directoriesToCheck.insertLast(currentDirectory + subDirectories[j] + "/");
				}
			}

			return extensionPaths;
		}

		private void DeleteGeneratedDDBBFiles()
		{
			string initialDirectoryDDBB = DataBaseSettings::Get().InitialDirectoryDDBB;
			if (!FileSystem::IsDirectory(initialDirectoryDDBB))
			{
				return;
			}

			array<string> directoriesToCheck;
			directoriesToCheck.insertLast(initialDirectoryDDBB);
			while (!directoriesToCheck.isEmpty())
			{
				string currentDirectory = directoriesToCheck[0];
				directoriesToCheck.removeAt(0);

				array<string> files = FileSystem::GetFilesAt(currentDirectory);
				uint filesCount = files.length();
				for (uint i = 0; i < filesCount; i++)
				{
					if (IsGeneratedDDBBFile(files[i]))
					{
						FileSystem::Remove(currentDirectory + files[i]);
					}
				}

				array<string> subDirectories = FileSystem::GetDirectoriesAt(currentDirectory);
				uint subDirectoriesCount = subDirectories.length();
				for (uint j = 0; j < subDirectoriesCount; j++)
				{
					directoriesToCheck.insertLast(currentDirectory + subDirectories[j] + "/");
				}
			}
		}

		private bool IsExtensionDDBBFile(const string&in filename)
		{
			string suffix = "ExtensionDDBB.as";
			if (filename.length() < suffix.length())
			{
				return false;
			}
			return filename.substr(filename.length() - suffix.length()) == suffix;
		}

		private bool IsGeneratedDDBBFile(const string&in filename)
		{
			string suffix = "DDBB.as";
			if (filename.length() < suffix.length())
			{
				return false;
			}
			return filename.substr(filename.length() - suffix.length()) == suffix && !IsExtensionDDBBFile(filename);
		}

		private array<string> GetAllTablesPath()
		{
			array<string> tablesPath;

			array<string> directoriesToCheck;
			string initialTablesDirectoryDDBB = DataBaseSettings::Get().InitialTablesDirectoryDDBB;
			directoriesToCheck.insertLast(initialTablesDirectoryDDBB);
			while (!directoriesToCheck.isEmpty())
			{
				string currentDirectory = directoriesToCheck[0];
				directoriesToCheck.removeAt(0);

				array<string> files = FileSystem::GetFilesAt(currentDirectory);
				uint filesCount = files.length();
				for (uint i = 0; i < filesCount; i++)
				{
					string file = files[i];
					if (IsValidTablePath(file))
					{
						tablesPath.insertLast(currentDirectory + file);
					}
				}

				array<string> subDirectories = FileSystem::GetDirectoriesAt(currentDirectory);
				uint subDirectoriesCount = subDirectories.length();
				for (uint j = 0; j < subDirectoriesCount; j++)
				{
					string fullDir = currentDirectory + subDirectories[j] + "/";
					directoriesToCheck.insertLast(fullDir);
				}
			}

			return tablesPath;
		}

		private bool IsValidTablePath(const string&in path)
		{
			int dotIndex = path.findLastOf(".");
			return dotIndex != -1 && path.substr(dotIndex) == ".cometObject";
		}

		private string GetDirectoryFromPath(const string&in path)
		{
			int lastSlashIndex = path.findLastOf("/");
			return path.substr(0, lastSlashIndex + 1);
		}
	}
}
