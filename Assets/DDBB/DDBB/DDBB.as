// **************************************************
// ****** DDBB GENERATED FILE - DO NOT MODIFY *******
// **************************************************

using namespace CometEngine;
using namespace CometEngine::Json;

namespace DDBB
{
	mixin class DDBB
	{
		PlayerDataExtensionDDBB PlayerData = PlayerDataExtensionDDBB();

		void SaveGlobal(JsonObject toSave)
		{
		}

		void LoadGlobal(JsonObject toLoad)
		{
		}

		void SaveSlot(JsonObject toSave)
		{
			PlayerData.Save(toSave.AddObject("PlayerData"));
		}

		void LoadSlot(JsonObject toLoad)
		{
			JsonObject PlayerDataJsonObj = toLoad.GetObject("PlayerData");
			if (PlayerDataJsonObj !is null)
			{
				PlayerData.Load(PlayerDataJsonObj);
			}
		}
	}
}