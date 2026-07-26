// **************************************************
// ****** DDBB GENERATED FILE - DO NOT MODIFY *******
// **************************************************

using namespace CometEngine;
using namespace CometEngine::Json;

namespace DDBB
{
	mixin class ItemDataDDBB
	{
		uint id;
		string name;

		void Save(JsonObject toSave)
		{
			toSave.SetUint("id", id);
			toSave.SetString("name", name);
		}

		void Load(JsonObject toLoad)
		{
			id = toLoad.GetUint("id");
			name = toLoad.GetString("name");
		}
	}
}