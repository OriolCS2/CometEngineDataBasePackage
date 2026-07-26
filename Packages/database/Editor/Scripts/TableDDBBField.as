namespace DataBaseEditor
{
	enum TableDDBBFieldType
	{
		UINT,
		INT,
		FLOAT,
		STRING,
		VECTOR2,
		VECTOR2I,
		VECTOR3,
		VECTOR3I,
		COLOR,
		BOOL,
		ENUM,
		DATA_DEFINITION,
		ARRAY_UINT,
		ARRAY_INT,
		ARRAY_FLOAT,
		ARRAY_STRING,
		ARRAY_VECTOR2,
		ARRAY_VECTOR2I,
		ARRAY_VECTOR3,
		ARRAY_VECTOR3I,
		ARRAY_COLOR,
		ARRAY_BOOL,
		ARRAY_ENUM,
		ARRAY_DATA_DEFINITION,
		DICT_UINT,
		DICT_INT,
		DICT_FLOAT,
		DICT_STRING,
		DICT_VECTOR2,
		DICT_VECTOR2I,
		DICT_VECTOR3,
		DICT_VECTOR3I,
		DICT_COLOR,
		DICT_BOOL,
		DICT_ENUM,
		DICT_DATA_DEFINITION
	}

	class /*@*/ TableDDBBField
	{
		string name;
		TableDDBBFieldType type;
		string enumTypeName;
		TableDDBB TableDDBBType;

		string GetDeclaration() const
		{
			string declaration;
			switch (type)
			{
				case TableDDBBFieldType::UINT:
				declaration = "uint";
				break;
				case TableDDBBFieldType::INT:
				declaration = "int";
				break;
				case TableDDBBFieldType::FLOAT:
				declaration = "float";
				break;
				case TableDDBBFieldType::STRING:
				declaration = "string";
				break;
				case TableDDBBFieldType::VECTOR2:
				declaration = "Vector2";
				break;
				case TableDDBBFieldType::VECTOR2I:
				declaration = "Vector2i";
				break;
				case TableDDBBFieldType::VECTOR3:
				declaration = "Vector3";
				break;
				case TableDDBBFieldType::VECTOR3I:
				declaration = "Vector3i";
				break;
				case TableDDBBFieldType::COLOR:
				declaration = "Color";
				break;
				case TableDDBBFieldType::BOOL:
				declaration = "bool";
				break;
				case TableDDBBFieldType::ENUM:
				declaration = enumTypeName;
				break;
				case TableDDBBFieldType::DATA_DEFINITION:
				if (Object::IsValid(TableDDBBType))
				{
					declaration = TableDDBBType.name + "ExtensionDDBB";
				}
				else
				{
					Debug::LogWarning("TableDDBB for field " + name + " is not valid.");
					declaration = "DefinitionForField" + name + "WasNull";
				}
				break;
				case TableDDBBFieldType::ARRAY_INT:
				declaration = "array<int>";
				break;
				case TableDDBBFieldType::ARRAY_UINT:
				declaration = "array<uint>";
				break;
				case TableDDBBFieldType::ARRAY_FLOAT:
				declaration = "array<float>";
				break;
				case TableDDBBFieldType::ARRAY_STRING:
				declaration = "array<string>";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR2:
				declaration = "array<Vector2>";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR2I:
				declaration = "array<Vector2i>";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR3:
				declaration = "array<Vector3>";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR3I:
				declaration = "array<Vector3i>";
				break;
				case TableDDBBFieldType::ARRAY_COLOR:
				declaration = "array<Color>";
				break;
				case TableDDBBFieldType::ARRAY_BOOL:
				declaration = "array<bool>";
				break;
				case TableDDBBFieldType::ARRAY_ENUM:
				declaration = "array<" + enumTypeName + ">";
				break;
				case TableDDBBFieldType::ARRAY_DATA_DEFINITION:
				if (Object::IsValid(TableDDBBType))
				{
					declaration = "array<" + TableDDBBType.name + "ExtensionDDBB>";
				}
				else
				{
					Debug::LogWarning("TableDDBB for field " + name + " is not valid.");
					declaration = "array<DefinitionForField" + name + "WasNull>";
				}
				break;
				case TableDDBBFieldType::DICT_UINT:
				case TableDDBBFieldType::DICT_INT:
				case TableDDBBFieldType::DICT_FLOAT:
				case TableDDBBFieldType::DICT_STRING:
				case TableDDBBFieldType::DICT_VECTOR2:
				case TableDDBBFieldType::DICT_VECTOR2I:
				case TableDDBBFieldType::DICT_VECTOR3:
				case TableDDBBFieldType::DICT_VECTOR3I:
				case TableDDBBFieldType::DICT_COLOR:
				case TableDDBBFieldType::DICT_BOOL:
				case TableDDBBFieldType::DICT_ENUM:
				case TableDDBBFieldType::DICT_DATA_DEFINITION:
				declaration = "dictionary";
				break;
				default:
				Debug::LogWarning("Unknown type for field " + name + ". Setting int as default.");
				declaration = "int";
				break;
			}
			declaration += " " + name;
			if (type == TableDDBBFieldType::DATA_DEFINITION && Object::IsValid(TableDDBBType))
			{
				declaration += " = " + TableDDBBType.name + "ExtensionDDBB()";
			}
			declaration += ";";
			return declaration;
		}

		string GetSaveString() const
		{
			string saveCode;
			switch (type)
			{
				case TableDDBBFieldType::UINT:
				saveCode = "toSave.SetUint(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::INT:
				saveCode = "toSave.SetInt(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::FLOAT:
				saveCode = "toSave.SetFloat(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::STRING:
				saveCode = "toSave.SetString(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::BOOL:
				saveCode = "toSave.SetBool(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ENUM:
				saveCode = "toSave.SetInt(\"" + name + "\", int(" + name + "));";
				break;
				case TableDDBBFieldType::VECTOR2:
				saveCode = "toSave.SetVector2(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::VECTOR2I:
				saveCode = "toSave.SetVector2i(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::VECTOR3:
				saveCode = "toSave.SetVector3(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::VECTOR3I:
				saveCode = "toSave.SetVector3i(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::COLOR:
				saveCode = "toSave.SetColor(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_INT:
				saveCode = "toSave.SetIntArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_UINT:
				saveCode = "toSave.SetUintArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_FLOAT:
				saveCode = "toSave.SetFloatArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_STRING:
				saveCode = "toSave.SetStringArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR2:
				saveCode = "toSave.SetVector2Array(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR2I:
				saveCode = "toSave.SetVector2iArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR3:
				saveCode = "toSave.SetVector3Array(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR3I:
				saveCode = "toSave.SetVector3iArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_COLOR:
				saveCode = "toSave.SetColorArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_BOOL:
				saveCode = "toSave.SetBoolArray(\"" + name + "\", " + name + ");";
				break;
				case TableDDBBFieldType::ARRAY_ENUM:
				saveCode = "array<int> " + name + "_intArr; for (uint i = 0; i < " + name + ".length(); i++) { " + name + "_intArr.insertLast(int(" + name + "[i])); } toSave.SetIntArray(\"" + name + "\", " + name + "_intArr);";
				break;
				case TableDDBBFieldType::DATA_DEFINITION:
				saveCode = name + ".Save(toSave.AddObject(\"" + name + "\"));";
				break;
				case TableDDBBFieldType::ARRAY_DATA_DEFINITION:
				saveCode = "JsonArray " + name + "_arr = toSave.AddArray(\"" + name + "\"); for (uint i = 0; i < " + name + ".length(); i++) { " + name + "[i].Save(" + name + "_arr.AddObject()); }";
				break;
				case TableDDBBFieldType::DICT_UINT:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { uint " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetUint(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_INT:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { int " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetInt(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_FLOAT:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { float " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetFloat(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_STRING:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { string " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetString(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_VECTOR2:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { Vector2 " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetVector2(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_VECTOR2I:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { Vector2i " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetVector2i(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_VECTOR3:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { Vector3 " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetVector3(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_VECTOR3I:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { Vector3i " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetVector3i(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_COLOR:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { Color " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetColor(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_BOOL:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { bool " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetBool(" + name + "_keys[i], " + name + "_val); }";
				break;
				case TableDDBBFieldType::DICT_ENUM:
				saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + enumTypeName + " " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_dictObj.SetInt(" + name + "_keys[i], int(" + name + "_val)); }";
				break;
				case TableDDBBFieldType::DICT_DATA_DEFINITION:
				if (Object::IsValid(TableDDBBType))
				{
					saveCode = "JsonObject " + name + "_dictObj = toSave.AddObject(\"" + name + "\"); array<string> " + name + "_keys = " + name + ".getKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + TableDDBBType.name + "ExtensionDDBB " + name + "_val; " + name + ".get(" + name + "_keys[i], " + name + "_val); " + name + "_val.Save(" + name + "_dictObj.AddObject(" + name + "_keys[i])); }";
				}
				break;
				default:
				Debug::LogWarning("DDBB: Save for type " + type + " not implemented yet.");
				break;
			}
			return saveCode;
		}

		string GetLoadString() const
		{
			string loadCode;
			switch (type)
			{
				case TableDDBBFieldType::UINT:
				loadCode = name + " = toLoad.GetUint(\"" + name + "\");";
				break;
				case TableDDBBFieldType::INT:
				loadCode = name + " = toLoad.GetInt(\"" + name + "\");";
				break;
				case TableDDBBFieldType::FLOAT:
				loadCode = name + " = toLoad.GetFloat(\"" + name + "\");";
				break;
				case TableDDBBFieldType::STRING:
				loadCode = name + " = toLoad.GetString(\"" + name + "\");";
				break;
				case TableDDBBFieldType::BOOL:
				loadCode = name + " = toLoad.GetBool(\"" + name + "\");";
				break;
				case TableDDBBFieldType::ENUM:
				loadCode = name + " = " + enumTypeName + "(toLoad.GetInt(\"" + name + "\"));";
				break;
				case TableDDBBFieldType::VECTOR2:
				loadCode = name + " = toLoad.GetVector2(\"" + name + "\");";
				break;
				case TableDDBBFieldType::VECTOR2I:
				loadCode = name + " = toLoad.GetVector2i(\"" + name + "\");";
				break;
				case TableDDBBFieldType::VECTOR3:
				loadCode = name + " = toLoad.GetVector3(\"" + name + "\");";
				break;
				case TableDDBBFieldType::VECTOR3I:
				loadCode = name + " = toLoad.GetVector3i(\"" + name + "\");";
				break;
				case TableDDBBFieldType::COLOR:
				loadCode = name + " = toLoad.GetColor(\"" + name + "\");";
				break;
				case TableDDBBFieldType::ARRAY_INT:
				loadCode = "array<int>@ " + name + "_arr = toLoad.GetIntArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_UINT:
				loadCode = "array<uint>@ " + name + "_arr = toLoad.GetUintArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_FLOAT:
				loadCode = "array<float>@ " + name + "_arr = toLoad.GetFloatArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_STRING:
				loadCode = "array<string>@ " + name + "_arr = toLoad.GetStringArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR2:
				loadCode = "array<Vector2>@ " + name + "_arr = toLoad.GetVector2Array(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR2I:
				loadCode = "array<Vector2i>@ " + name + "_arr = toLoad.GetVector2iArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR3:
				loadCode = "array<Vector3>@ " + name + "_arr = toLoad.GetVector3Array(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_VECTOR3I:
				loadCode = "array<Vector3i>@ " + name + "_arr = toLoad.GetVector3iArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_COLOR:
				loadCode = "array<Color>@ " + name + "_arr = toLoad.GetColorArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_BOOL:
				loadCode = "array<bool>@ " + name + "_arr = toLoad.GetBoolArray(\"" + name + "\"); if (" + name + "_arr !is null) " + name + " = " + name + "_arr;";
				break;
				case TableDDBBFieldType::ARRAY_ENUM:
				loadCode = "array<int>@ " + name + "_intArr = toLoad.GetIntArray(\"" + name + "\"); if (" + name + "_intArr !is null) { for (uint i = 0; i < " + name + "_intArr.length(); i++) { " + name + ".insertLast(" + enumTypeName + "(" + name + "_intArr[i])); } }";
				break;
				case TableDDBBFieldType::DATA_DEFINITION:
				loadCode = "JsonObject " + name + "_obj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_obj !is null) { " + name + ".Load(" + name + "_obj); }";
				break;
				case TableDDBBFieldType::ARRAY_DATA_DEFINITION:
				if (Object::IsValid(TableDDBBType))
				{
					loadCode = "JsonArray " + name + "_jsonArr = toLoad.GetArray(\"" + name + "\"); if (" + name + "_jsonArr !is null) { for (uint i = 0; i < " + name + "_jsonArr.length(); i++) { " + TableDDBBType.name + "ExtensionDDBB obj = " + TableDDBBType.name + "ExtensionDDBB(); obj.Load(" + name + "_jsonArr.GetObject(i)); " + name + ".insertLast(obj); } }";
				}
				break;
				case TableDDBBFieldType::DICT_UINT:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetUint(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_INT:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetInt(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_FLOAT:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetFloat(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_STRING:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetString(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_VECTOR2:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetVector2(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_VECTOR2I:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetVector2i(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_VECTOR3:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetVector3(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_VECTOR3I:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetVector3i(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_COLOR:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetColor(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_BOOL:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + name + "_dictObj.GetBool(" + name + "_keys[i].key)); } }";
				break;
				case TableDDBBFieldType::DICT_ENUM:
				loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { " + name + ".set(" + name + "_keys[i].key, " + enumTypeName + "(" + name + "_dictObj.GetInt(" + name + "_keys[i].key))); } }";
				break;
				case TableDDBBFieldType::DICT_DATA_DEFINITION:
				if (Object::IsValid(TableDDBBType))
				{
					loadCode = "JsonObject " + name + "_dictObj = toLoad.GetObject(\"" + name + "\"); if (" + name + "_dictObj !is null) { array<JsonKey> " + name + "_keys = " + name + "_dictObj.GetKeys(); for (uint i = 0; i < " + name + "_keys.length(); i++) { JsonObject " + name + "_entryObj = " + name + "_dictObj.GetObject(" + name + "_keys[i].key); if (" + name + "_entryObj !is null) { " + TableDDBBType.name + "ExtensionDDBB " + name + "_val; " + name + "_val.Load(" + name + "_entryObj); " + name + ".set(" + name + "_keys[i].key, " + name + "_val); } } }";
				}
				break;
				default:
				Debug::LogWarning("DDBB: Load for type " + type + " not implemented yet.");
				break;
			}
			return loadCode;
		}

		int opCmp(const TableDDBBField@other) const
		{
			return name.opCmp(other.name);
		}
	}
}
