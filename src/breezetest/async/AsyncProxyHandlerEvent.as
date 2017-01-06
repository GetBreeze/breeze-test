package breezetest.async
{
	import breezetest.async.AsyncProxyHandler;

	import flash.events.Event;

	public class AsyncProxyHandlerEvent extends Event
	{
		public static const ERROR:String = "ERROR";
		public static const COMPLETE:String = "COMPLETE";

		private var _handler:AsyncProxyHandler;
		private var _error:Error;

		public function AsyncProxyHandlerEvent(type:String, handler:AsyncProxyHandler, error:Error = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_handler = handler;
			_error = error;

			super(type, bubbles, cancelable);
		}

		public function get handler():AsyncProxyHandler
		{
			return _handler;
		}

		public function get error():Error
		{
			return _error;
		}
	}
}
