using namespace CometEngine;

namespace DDBB
{
	class /*@*/ PlayerDataExtensionDDBB : PlayerDataDDBB
	{
		bool CanBuy(int value)
		{
			return money >= value;
		}
	}
}
