package breezetest
{
	import flash.events.Event;

	public class BreezeTestEvent extends Event
	{
		public static const TESTS_COMPLETE:String = "TESTS_COMPLETE";

		private var _astestObj:BreezeTest;

		public function BreezeTestEvent(type:String, astest:BreezeTest, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_astestObj = astest;

			super(type, bubbles, cancelable);
		}


		public function get astestObj():BreezeTest
		{
			return _astestObj;
		}

	}
}
