package breezetest.async
{
	import flash.events.Event;

	public class AsyncEvent extends Event
	{
		public static const COMPLETE:String = "COMPLETE";
		public static const ERROR:String = "ERROR";

		private var _factory:Async;
		private var _error:Error;

		public function AsyncEvent(type:String, factory:Async, error:Error = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_factory = factory;
			_error = error;
			super(type, bubbles, cancelable);
		}


		public function get factory():Async
		{
			return _factory;
		}


		public function get error():Error
		{
			return _error;
		}
	}
}
