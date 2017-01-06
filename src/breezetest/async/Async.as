package breezetest.async
{
	import breezetest.errors.AsyncTimeoutError;

	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	public class Async extends EventDispatcher
	{
		private var _testObject:Object;
		private var _proxyHandlers:Array = [];
		private var _isComplete:Boolean = false;
		private var _timeout:int = -1;
		private var _timer:uint;

		public function Async(testObject:Object)
		{
			_testObject = testObject;
		}


		public function createProxy(callback:Function, timeout:int = -1, completeAfterRun:Boolean = false):Function
		{
			var handler:AsyncProxyHandler = createProxyHandler(callback, timeout);

			if(completeAfterRun)
			{
				handler.addEventListener(AsyncProxyHandlerEvent.COMPLETE, function (event:AsyncProxyHandlerEvent):void
				{
					event.handler.asyncFactory.complete();
				});
			}

			return handler.proxy;
		}


		public function createProxyHandler(callback:Function, timeout:int = -1):AsyncProxyHandler
		{
			var handler:AsyncProxyHandler = new AsyncProxyHandler(this, callback, timeout);
			handler.addEventListener(AsyncProxyHandlerEvent.ERROR, handlerError);
			_proxyHandlers.push(handler);

			return handler;
		}


		public function run(callback:Function):void
		{
			createProxy(callback)();
		}


		public function complete():void
		{
			if(_isComplete)
			{
				return;
			}

			_isComplete = true;
			clearInterval(_timer);
			dispatchEvent(new AsyncEvent(AsyncEvent.COMPLETE, this));
		}


		private function handlerError(event:AsyncProxyHandlerEvent):void
		{
			dispatchEvent(new AsyncEvent(event.type, this, event.error));
			complete();
		}


		private function timeExpired():void
		{
			dispatchEvent(new AsyncEvent(AsyncEvent.ERROR, this, new AsyncTimeoutError('Test did not complete in required ' + _timeout + ' ms')));
			complete();
		}


		public function get timeout():int
		{
			return _timeout;
		}


		public function set timeout(value:int):void
		{
			if(_isComplete)
			{
				return;
			}

			_timeout = value;
			_timer = setTimeout(timeExpired, value);
		}


		public function get isComplete():Boolean
		{
			return _isComplete;
		}


		public function get testObject():Object
		{
			return _testObject;
		}

	}
}
