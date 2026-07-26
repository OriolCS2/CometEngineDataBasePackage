using namespace CometEngine;
using namespace CometEditor;

[CustomInspector("TableDDBB")] class /*@*/ TableDDBBViewer : EditorBehaviour
{
	string currentNewFieldName;
	string enumTypeName;
	TableDDBBFieldType currentNewFieldType = TableDDBBFieldType::INT;
	TableDDBB currentDefinitionVar;
	private bool focusNew = false;

	void Init()
	{
		TableDDBBViewer::get = this;
	}

	void OnCustomInspector(TableDDBB @definition)
	{
		GUI::ShowProperty("isRoot");
		if (definition.isRoot)
		{
			GUI::ShowProperty("saveLoadMode");
		}

		GUI::Spacing();
		GUI::Separator();
		GUI::Spacing();

		int deleteIndex = -1;

		int tableFlags = GUI::TableFlags::Borders | GUI::TableFlags::SizingStretchSame;
		if (GUI::BeginTable("##fieldsTable", 2, tableFlags))
		{
			GUI::TableSetupColumn("Name", GUI::TableColumnFlags::WidthStretch);
			GUI::TableSetupColumn("Type", GUI::TableColumnFlags::WidthStretch);
			GUI::TableHeadersRow();

			uint fieldCount = definition.fields.length();
			for (uint i = 0; i < fieldCount; i++)
			{
				GUI::PushIDNum(i);
				GUI::TableNextRow();

				GUI::TableSetColumnIndex(0);
				GUI::TableSetColumnIndex(0);
				GUI::SetCursorPosY(GUI::GetCursorPosY() + 4.0f);
				GUI::SetNextItemWidth(-1);
				bool hasMoreInfo = definition.fields[i].type == TableDDBBFieldType::ENUM || definition.fields[i].type == TableDDBBFieldType::ARRAY_ENUM || definition.fields[i].type == TableDDBBFieldType::DATA_DEFINITION || definition.fields[i].type == TableDDBBFieldType::ARRAY_DATA_DEFINITION || definition.fields[i].type == TableDDBBFieldType::DICT_ENUM || definition.fields[i].type == TableDDBBFieldType::DICT_DATA_DEFINITION;
				if (hasMoreInfo)
				{
					GUI::SetCursorPosY(GUI::GetCursorPosY() + 13.0f);
				}
				bool nameEdited = false;
				string newName = GUI::InputText("##name", definition.fields[i].name, nameEdited, GUI::InputTextFlags::AutoSelectAll | GUI::InputTextFlags::EnterToAccept);
				if (nameEdited)
				{
					string cleaned = StripSpaces(newName);
					if (cleaned.length() > 0 && !definition.HasFieldWithName(cleaned, i))
					{
						GUI::SaveState();
						definition.fields[i].name = cleaned;
						AssetDataBase::SetDirty(definition);
					}
				}
				if (deleteIndex == -1)
				{
					deleteIndex = RemoveFieldPopup(i, "name");
				}

				GUI::TableSetColumnIndex(1);
				GUI::SetCursorPosY(GUI::GetCursorPosY() + 4.0f);
				GUI::SetNextItemWidth(-1);
				TableDDBBFieldType selectedType;
				if (DrawTypeCombo("##type", definition.fields[i].type, selectedType))
				{
					GUI::SaveState();
					definition.fields[i].type = selectedType;
					if (selectedType != TableDDBBFieldType::ENUM && selectedType != TableDDBBFieldType::ARRAY_ENUM && selectedType != TableDDBBFieldType::DICT_ENUM)
					{
						definition.fields[i].enumTypeName.resize(0);
					}
					AssetDataBase::SetDirty(definition);
				}
				if (deleteIndex == -1)
				{
					deleteIndex = RemoveFieldPopup(i, "type");
				}

				if (definition.fields[i].type == TableDDBBFieldType::ENUM || definition.fields[i].type == TableDDBBFieldType::ARRAY_ENUM || definition.fields[i].type == TableDDBBFieldType::DICT_ENUM)
				{
					GUI::SetNextItemWidth(-1);
					bool edited = false;
					string newEnumTypeName = GUI::InputText("##enumTypeNameT", definition.fields[i].enumTypeName, edited, GUI::InputTextFlags::AutoSelectAll | GUI::InputTextFlags::EnterToAccept);
					if (edited)
					{
						GUI::SaveState();
						definition.fields[i].enumTypeName = newEnumTypeName;
						AssetDataBase::SetDirty(definition);
					}
					if (deleteIndex == -1)
					{
						deleteIndex = RemoveFieldPopup(i, "enumTypeNameP");
					}
				}
				else if (definition.fields[i].type == TableDDBBFieldType::DATA_DEFINITION || definition.fields[i].type == TableDDBBFieldType::ARRAY_DATA_DEFINITION || definition.fields[i].type == TableDDBBFieldType::DICT_DATA_DEFINITION)
				{
					bool edited = false;
					GUI::SetNextItemFullWidth();
					TableDDBB def = cast<TableDDBB>(GUI::ShowCometObjectProperty(definition.fields[i].TableDDBBType, "TableDDBB", edited));
					if (edited)
					{
						GUI::SaveState();
						definition.fields[i].TableDDBBType = def;
						AssetDataBase::SetDirty(definition);
					}
				}

				GUI::PopID();
			}

			GUI::EndTable();
		}

		GUI::Spacing();
		GUI::Separator();
		GUI::Spacing();

		if (GUI::BeginChild("##addFieldChild", -1, 0, GUI::ChildFlags::Borders | GUI::ChildFlags::AutoResizeY, GUI::WindowFlags::None))
		{
			string titleText = "New Field";
			float titleWidth = GUI::CalcTextSize(titleText).x;
			GUI::SetCursorPosX((GUI::GetContentRegionAvail().x - titleWidth) * 0.5f + GUI::GetCursorPosX());
			GUI::Text(titleText);
			GUI::Separator();
			GUI::Spacing();

			GUI::StandardFieldName("Name");
			if (focusNew)
			{
				GUI::SetKeyboardFocusHere();
				focusNew = false;
			}
			GUI::SetCursorAtStandardPropertyWidgetPosition();
			GUI::SetNextItemWidthToStandardPropertyWidget();
			currentNewFieldName = GUI::InputText("##newFieldName", currentNewFieldName, GUI::InputTextFlags::AutoSelectAll);

			GUI::StandardFieldName("Type");
			GUI::SetCursorAtStandardPropertyWidgetPosition();
			GUI::SetNextItemWidthToStandardPropertyWidget();
			TableDDBBFieldType selectedNewType;
			if (DrawTypeCombo("##newFieldType", currentNewFieldType, selectedNewType))
			{
				currentNewFieldType = selectedNewType;
				if (currentNewFieldType != TableDDBBFieldType::ENUM && currentNewFieldType != TableDDBBFieldType::ARRAY_ENUM && currentNewFieldType != TableDDBBFieldType::DICT_ENUM)
				{
					enumTypeName.resize(0);
				}
				else if (currentNewFieldType != TableDDBBFieldType::DATA_DEFINITION && currentNewFieldType != TableDDBBFieldType::ARRAY_DATA_DEFINITION && currentNewFieldType != TableDDBBFieldType::DICT_DATA_DEFINITION)
				{
					if (Object::IsValid(currentDefinitionVar))
					{
						AssetDataBase::Unload(currentDefinitionVar);
					}
					currentDefinitionVar = null;
				}
			}

			if (currentNewFieldType == TableDDBBFieldType::ENUM || currentNewFieldType == TableDDBBFieldType::ARRAY_ENUM || currentNewFieldType == TableDDBBFieldType::DICT_ENUM)
			{
				GUI::StandardFieldName("Enum Type");
				GUI::SetCursorAtStandardPropertyWidgetPosition();
				GUI::SetNextItemWidthToStandardPropertyWidget();
				enumTypeName = GUI::InputText("##enumTypeName", enumTypeName, GUI::InputTextFlags::AutoSelectAll);
			}
			else if (currentNewFieldType == TableDDBBFieldType::DATA_DEFINITION || currentNewFieldType == TableDDBBFieldType::ARRAY_DATA_DEFINITION || currentNewFieldType == TableDDBBFieldType::DICT_DATA_DEFINITION)
			{
				GUI::StandardFieldName("TableDDBB");
				GUI::SetCursorAtStandardPropertyWidgetPosition();
				GUI::SetNextItemWidthToStandardPropertyWidget();
				bool edited = false;
				currentDefinitionVar = cast<TableDDBB>(GUI::ShowCometObjectProperty(currentDefinitionVar, "TableDDBB", edited));
			}

			bool isNewNameValid = currentNewFieldName.length() > 0 && !definition.HasFieldWithName(currentNewFieldName);
			GUI::BeginDisabled(!isNewNameValid);
			if (GUI::Button("Add", Vector2(-1, 0.0f)))
			{
				GUI::SaveState();
				TableDDBBField newField = TableDDBBField();
				newField.name = currentNewFieldName;
				newField.type = currentNewFieldType;
				newField.enumTypeName = enumTypeName;
				newField.TableDDBBType = currentDefinitionVar;
				definition.fields.insertLast(newField);
				definition.fields.sortAsc();
				currentNewFieldName.resize(0);
				if (Object::IsValid(currentDefinitionVar))
				{
					AssetDataBase::Unload(currentDefinitionVar);
				}
				currentDefinitionVar = null;
				enumTypeName.resize(0);
				focusNew = true;
				AssetDataBase::SetDirty(definition);
			}
			GUI::EndDisabled();
			if (!isNewNameValid && currentNewFieldName.length() > 0)
			{
				string errorText = RawIcon::Exclamation + "  Field name must be unique.";
				float errorWidth = GUI::CalcTextSize(errorText).x;
				GUI::SetCursorPosX((GUI::GetContentRegionAvail().x - errorWidth) * 0.5f + GUI::GetCursorPosX());
				GUI::PushStyleColor(GUI::Col::Text, Color(1.0f, 0.4f, 0.4f, 1.0f));
				GUI::Text(errorText);
				GUI::PopStyleColor();
			}
		}
		GUI::EndChild();

		if (deleteIndex >= 0)
		{
			GUI::SaveState();
			definition.fields.removeAt(deleteIndex);
			AssetDataBase::SetDirty(definition);
		}

		if (GUI::Button("Generate", Vector2(GUI::GetContentRegionAvail().x, 0.0f)))
		{
			RegenerateDDBB();
		}
	}

	[MainMenuItem("DDBB/Generate")] void RegenerateDDBB() {
		PopupManager::OpenActionInProgressPopupWithCallback("Generating DDBB", "", CometDelegate(RegenerateInternal));
	}

		[MainMenuItem("DDBB/Create Table")] void CreateNewTable()
	{
		TableDDBB newDefinition = TableDDBB();
		AssetDataBase::AddCometObject(newDefinition, GeneratorDDBB::RemoveAssetsFromPath(GeneratorDDBB::initialTablesDirectoryDDBB + "NewTable"), true, true);
	}

	private void RegenerateInternal()
	{
		GeneratorDDBB generator;
		generator.Generate();
	}

	int RemoveFieldPopup(int i, const string&in id)
	{
		int removeIndex = -1;
		if (GUI::BeginPopupContextItem("##rowctx" + id))
		{
			if (GUI::MenuItem("Remove"))
			{
				removeIndex = i;
			}
			GUI::EndPopup();
		}
		return removeIndex;
	}

	private bool DrawTypeCombo(const string&in label, TableDDBBFieldType currentType, TableDDBBFieldType&out selected)
	{
		selected = currentType;
		bool changed = false;

		if (GUI::BeginCombo(label, GetTypeName(currentType), GUI::ComboFlags::HeightLargest))
		{
			for (int t = int(TableDDBBFieldType::UINT); t <= int(TableDDBBFieldType::DATA_DEFINITION); t++)
			{
				TableDDBBFieldType ft = TableDDBBFieldType(t);
				if (GUI::Selectable(GetTypeName(ft), currentType == ft))
				{
					selected = ft;
					changed = true;
				}
			}

			if (GUI::BeginMenu("Array"))
			{
				for (int t = int(TableDDBBFieldType::ARRAY_UINT); t <= int(TableDDBBFieldType::ARRAY_DATA_DEFINITION); t++)
				{
					TableDDBBFieldType ft = TableDDBBFieldType(t);
					TableDDBBFieldType baseType = TableDDBBFieldType(t - int(TableDDBBFieldType::ARRAY_UINT));
					if (GUI::Selectable(GetTypeName(baseType), currentType == ft))
					{
						selected = ft;
						changed = true;
					}
				}
				GUI::EndMenu();
			}

			if (GUI::BeginMenu("Dictionary"))
			{
				for (int t = int(TableDDBBFieldType::DICT_UINT); t <= int(TableDDBBFieldType::DICT_DATA_DEFINITION); t++)
				{
					TableDDBBFieldType ft = TableDDBBFieldType(t);
					TableDDBBFieldType baseType = TableDDBBFieldType(t - int(TableDDBBFieldType::DICT_UINT));
					if (GUI::Selectable(GetTypeName(baseType), currentType == ft))
					{
						selected = ft;
						changed = true;
					}
				}
				GUI::EndMenu();
			}

			GUI::EndCombo();
		}

		return changed;
	}

	string GetTypeName(TableDDBBFieldType type)
	{
		switch (type)
		{
			case TableDDBBFieldType::UINT:
				return "Uint";
			case TableDDBBFieldType::INT:
				return "Int";
			case TableDDBBFieldType::FLOAT:
				return "Float";
			case TableDDBBFieldType::STRING:
				return "String";
			case TableDDBBFieldType::VECTOR2:
				return "Vector2";
			case TableDDBBFieldType::VECTOR2I:
				return "Vector2I";
			case TableDDBBFieldType::VECTOR3:
				return "Vector3";
			case TableDDBBFieldType::VECTOR3I:
				return "Vector3I";
			case TableDDBBFieldType::COLOR:
				return "Color";
			case TableDDBBFieldType::BOOL:
				return "Bool";
			case TableDDBBFieldType::ENUM:
				return "Enum";
			case TableDDBBFieldType::DATA_DEFINITION:
				return "TableDDBB";
			case TableDDBBFieldType::ARRAY_UINT:
				return "Array<Uint>";
			case TableDDBBFieldType::ARRAY_INT:
				return "Array<Int>";
			case TableDDBBFieldType::ARRAY_FLOAT:
				return "Array<Float>";
			case TableDDBBFieldType::ARRAY_STRING:
				return "Array<String>";
			case TableDDBBFieldType::ARRAY_VECTOR2:
				return "Array<Vector2>";
			case TableDDBBFieldType::ARRAY_VECTOR2I:
				return "Array<Vector2I>";
			case TableDDBBFieldType::ARRAY_VECTOR3:
				return "Array<Vector3>";
			case TableDDBBFieldType::ARRAY_VECTOR3I:
				return "Array<Vector3I>";
			case TableDDBBFieldType::ARRAY_COLOR:
				return "Array<Color>";
			case TableDDBBFieldType::ARRAY_BOOL:
				return "Array<Bool>";
			case TableDDBBFieldType::ARRAY_ENUM:
				return "Array<Enum>";
			case TableDDBBFieldType::ARRAY_DATA_DEFINITION:
				return "Array<TableDDBB>";
			case TableDDBBFieldType::DICT_UINT:
				return "Dict<Uint>";
			case TableDDBBFieldType::DICT_INT:
				return "Dict<Int>";
			case TableDDBBFieldType::DICT_FLOAT:
				return "Dict<Float>";
			case TableDDBBFieldType::DICT_STRING:
				return "Dict<String>";
			case TableDDBBFieldType::DICT_VECTOR2:
				return "Dict<Vector2>";
			case TableDDBBFieldType::DICT_VECTOR2I:
				return "Dict<Vector2I>";
			case TableDDBBFieldType::DICT_VECTOR3:
				return "Dict<Vector3>";
			case TableDDBBFieldType::DICT_VECTOR3I:
				return "Dict<Vector3I>";
			case TableDDBBFieldType::DICT_COLOR:
				return "Dict<Color>";
			case TableDDBBFieldType::DICT_BOOL:
				return "Dict<Bool>";
			case TableDDBBFieldType::DICT_ENUM:
				return "Dict<Enum>";
			case TableDDBBFieldType::DICT_DATA_DEFINITION:
				return "Dict<TableDDBB>";
		}
		return "Unknown";
	}

	string StripSpaces(const string&in s)
	{
		string result;
		for (uint i = 0; i < s.length(); i++)
		{
			string character = s.at(i);
			if (character != " ")
			{
				result += character;
			}
		}
		return result;
	}
}

namespace TableDDBBViewer
{
	TableDDBBViewer get;
}