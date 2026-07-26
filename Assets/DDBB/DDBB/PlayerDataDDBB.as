// **************************************************
// ****** DDBB GENERATED FILE - DO NOT MODIFY *******
// **************************************************

using namespace CometEngine;
using namespace CometEngine::Json;

namespace DDBB
{
	mixin class PlayerDataDDBB
	{
		ItemDataExtensionDDBB mainWeapon = ItemDataExtensionDDBB();
		int money;
		string name;
		int stars;

		void Save(JsonObject toSave)
		{
			mainWeapon.Save(toSave.AddObject("mainWeapon"));
			toSave.SetInt("money", money);
			toSave.SetString("name", name);
			toSave.SetInt("stars", stars);
		}

		void Load(JsonObject toLoad)
		{
			JsonObject mainWeapon_obj = toLoad.GetObject("mainWeapon"); if (mainWeapon_obj !is null) { mainWeapon.Load(mainWeapon_obj); }
			money = toLoad.GetInt("money");
			name = toLoad.GetString("name");
			stars = toLoad.GetInt("stars");
		}
	}
}