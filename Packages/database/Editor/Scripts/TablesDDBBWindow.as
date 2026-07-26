using namespace CometEngine;
using namespace CometEditor;

[MainMenuItemWindow("DDBB/Tables Viewer", "DDBB")] class /*@*/ TablesDDBBWindow : EditorWindow
{
	private array<string> allTables;
	array<TableDDBB @> openedTables;
	private int focusTable = -1;
	string filterText;

	void Awake()
	{
		LoadAllTables();
		if (!openedTables.isEmpty())
		{
			int count = int(openedTables.length());
			for (int i = 0; i < count; ++i)
			{
				if (!Object::IsValid(openedTables[i]))
				{
					openedTables.removeAt(i);
					--i;
					--count;
				}
			}
		}
	}

	private void LoadAllTables()
	{
		allTables.resize(0);

		array<string> directoriesToCheck;
		directoriesToCheck.insertLast(GeneratorDDBB::initialTablesDirectoryDDBB);

		while (!directoriesToCheck.isEmpty())
		{
			string currentDirectory = directoriesToCheck[0];
			directoriesToCheck.removeAt(0);

			array<string> files = FileSystem::GetFilesAt(currentDirectory);
			uint filesCount = files.length();
			for (uint i = 0; i < filesCount; ++i)
			{
				string file = files[i];
				if (IsValidTablePath(file))
				{
					allTables.insertLast(currentDirectory + file);
				}
			}

			array<string> subDirs = FileSystem::GetDirectoriesAt(currentDirectory);
			uint subDirsCount = subDirs.length();
			for (uint j = 0; j < subDirsCount; ++j)
			{
				directoriesToCheck.insertLast(currentDirectory + subDirs[j] + "/");
			}
		}

		allTables.sortDesc();
	}

	private bool IsValidTablePath(const string&in path)
	{
		int dotIndex = path.findLastOf(".");
		return dotIndex != -1 && path.substr(dotIndex) == ".cometObject";
	}

	void OnGUI()
	{
		ShowMenuBar();
		int tableFlags = GUI::TableFlags::Resizable | GUI::TableFlags::BordersOuterV | GUI::TableFlags::SizingFixedFit;
		if (GUI::BeginTable("##mainLayout", 2, tableFlags, Vector2(0, 0)))
		{
			GUI::TableSetupColumn("List", GUI::TableColumnFlags::None, 125.0f);
			GUI::TableSetupColumn("Tabs", GUI::TableColumnFlags::WidthStretch);

			GUI::TableNextRow();

			ShowTableList();
			ShowTabs();

			GUI::EndTable();
		}
	}

	private void ShowMenuBar()
	{
		if (GUI::BeginMenuBar())
		{
			if (GUI::MenuItem("Generate"))
			{
				TableDDBBViewer::get.RegenerateDDBB();
			}
			if (GUI::MenuItem("New Table"))
			{
				TableDDBB newDefinition = TableDDBB();
				AssetDataBase::AddCometObject(newDefinition, GeneratorDDBB::RemoveAssetsFromPath(GeneratorDDBB::initialTablesDirectoryDDBB + "NewTable"), true, true);
				allTables.insertLast(GeneratorDDBB::initialTablesDirectoryDDBB + newDefinition.name + ".cometObject");
				OpenTable(GeneratorDDBB::initialTablesDirectoryDDBB + newDefinition.name + ".cometObject");
				allTables.sortDesc();
			}
			if (GUI::MenuItem("Refresh"))
			{
				Awake();
			}
			GUI::EndMenuBar();
		}
	}

	private void ShowTableList()
	{
		GUI::TableSetColumnIndex(0);
		if (GUI::BeginChild("##tableList"))
		{
			GUI::AlignTextToFramePadding();
			GUI::Text(RawIcon::Search);
			GUI::SameLine();
			GUI::SetNextItemFullWidth();
			filterText = GUI::InputText("##tableSearch", filterText, GUI::InputTextFlags::AutoSelectAll);
			CometEditor::GUI::TextFilter tableFilter(filterText);
			GUI::Separator();

			uint tableCount = allTables.length();
			for (uint i = 0; i < tableCount; ++i)
			{
				string path = allTables[i];
				if (!FileSystem::Exists(path))
				{
					continue;
				}

				string tableName = FileSystem::GetFileName(path);
				if (!filterText.isEmpty() && !tableFilter.Pass(tableName))
				{
					continue;
				}

				if (GUI::MenuItem(" " + RawIcon::Table + "  " + tableName, false))
				{
					OpenTable(allTables[i]);
				}
			}
		}
		GUI::EndChild();
	}

	private void ShowTabs()
	{
		GUI::TableSetColumnIndex(1);
		if (GUI::BeginChild("##tableTabs", 0, 0, GUI::ChildFlags::None, GUI::WindowFlags::None))
		{
			if (!openedTables.isEmpty() && GUI::BeginTabBar("##openedTablesBar", GUI::TabBarFlags::Reorderable | GUI::TabBarFlags::TabListPopupButton))
			{
				int closeIndex = -1;
				uint openedCount = openedTables.length();
				for (uint i = 0; i < openedCount; ++i)
				{
					if (!Object::IsValid(openedTables[i]))
					{
						continue;
					}

					int tabFlags = 0;
					if (int(i) == focusTable)
					{
						tabFlags |= GUI::TabItemFlags::SetSelected;
						focusTable = -1;
					}
					bool closed = false;
					if (GUI::BeginTabItemWithStatus(RawIcon::Table + "  " + openedTables[i].name, closed, tabFlags))
					{
						if (GUI::BeginChild("##tableInspector" + i, 0, 0, GUI::ChildFlags::None, GUI::WindowFlags::None))
						{
							GUI::ShowResourceInspector(openedTables[i]);

							GUI::PushStyleColor(GUI::Col::Button, Color(0.45f, 0.20f, 0.20f));
							GUI::PushStyleColor(GUI::Col::ButtonHovered, Color(0.55f, 0.25f, 0.25f));
							GUI::PushStyleColor(GUI::Col::ButtonActive, Color(0.35f, 0.15f, 0.15f));
							if (GUI::Button("Remove", Vector2(GUI::GetContentRegionAvail().x, 0)))
							{
								AssetDataBase::Destroy(openedTables[i], true);
							}
							GUI::PopStyleColor(3);
						}
						GUI::EndChild();
						GUI::EndTabItem();
					}

					if (closed)
					{
						closeIndex = int(i);
					}
				}
				GUI::EndTabBar();

				if (closeIndex >= 0)
				{
					AssetDataBase::Unload(openedTables[closeIndex]);
					openedTables.removeAt(closeIndex);
				}
			}
		}
		GUI::EndChild();
	}

	private bool IsTableOpen(const string&in name)
	{
		uint count = openedTables.length();
		for (uint i = 0; i < count; ++i)
		{
			if (Object::IsValid(openedTables[i]) && openedTables[i].name == name)
			{
				return true;
			}
		}
		return false;
	}

	private void OpenTable(const string&in path)
	{
		string tableName = FileSystem::GetFileName(path);
		if (!IsTableOpen(tableName))
		{
			TableDDBB @table = cast<TableDDBB>(AssetDataBase::Load(GeneratorDDBB::RemoveAssetsFromPath(path), ResourceType::COMET_OBJECT));
			if (Object::IsValid(table))
			{
				openedTables.insertLast(table);
				focusTable = int(openedTables.length()) - 1;
			}
		}
		else
		{
			uint count = openedTables.length();
			for (uint i = 0; i < count; ++i)
			{
				if (Object::IsValid(openedTables[i]) && openedTables[i].name == tableName)
				{
					focusTable = int(i);
					break;
				}
			}
		}
	}

	WindowConfig OnGetWindowConfig()
	{
		WindowConfig config;
		config.iconRaw = RawIcon::Database;
		config.hasMenuBar = true;
		return config;
	}
}