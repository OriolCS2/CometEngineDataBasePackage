using namespace CometEngine;

enum TableSaveLoadMode
{
	GLOBAL,
	SLOT
}

	[AssetMenu("TableDDBB", "DataManager/TableDDBB")] class /*@*/ TableDDBB : CometObject
{
	[Tooltip("If true, this definition will be automatically added to the root table.")] bool isRoot = false;
	[Tooltip("Global save/load mode is used for global that is the same between game file slots like global volume. Slots save/load mode is for specific in game file slot data like player inventory.")] TableSaveLoadMode saveLoadMode = TableSaveLoadMode::SLOT;
	array<TableDDBBField> fields;

	bool HasFieldWithName(const string&in name, int excludeIndex = -1)
	{
		uint fieldCount = fields.length();
		for (uint i = 0; i < fieldCount; i++)
		{
			if (int(i) == excludeIndex)
			{
				continue;
			}

			if (fields[i].name == name)
			{
				return true;
			}
		}
		return false;
	}
}