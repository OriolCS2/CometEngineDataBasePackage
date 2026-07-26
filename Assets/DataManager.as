using namespace CometEngine;

class /*@*/ DataManager : CometBehaviour
{
	private DDBB::DDBBExtension dataBase;

	private string globalDataPath = "global.sav";
	private string sloat1DataPath = "slot1.sav";

	void Awake()
	{
		DataManager::get = this;

		Json::JsonObject globalData = Json::JsonObject::FileToJson(App::GetPersistentPath() + globalDataPath);
		dataBase.LoadGlobal(globalData);

		Json::JsonObject sloatData = Json::JsonObject::FileToJson(App::GetPersistentPath() + sloat1DataPath);
		dataBase.LoadSlot(sloatData);
	}

	void OnDestroy()
	{
		if (Object::Is(DataManager::get, this))
		{
			@DataManager::get = null;
		}
	}
}

namespace DataManager
{
	DataManager get;
}
