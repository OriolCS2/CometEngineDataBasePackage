using namespace CometEngine;
using namespace Json;

class /*@*/ DataManager : CometBehaviour
{
	private DDBB::DDBBExtension dataBase = DDBB::DDBBExtension();

	private string globalDataPath = "global.sav";
	private string sloat1DataPath = "slot1.sav";

	void Awake()
	{
		DataManager::get = this;

		JsonObject globalData = JsonObject::FileToJson(App::GetPersistentPath() + globalDataPath);
		dataBase.LoadGlobal(globalData);

		JsonObject sloatData = JsonObject::FileToJson(App::GetPersistentPath() + sloat1DataPath);
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
