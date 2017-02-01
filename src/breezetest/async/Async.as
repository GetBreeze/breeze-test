package breezetest.async
{
	import breezetest.errors.AsyncTimeoutError;
	
	import flash.events.ErrorEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvent;
	import flash.events.UncaughtErrorEvents;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	public class Async extends EventDispatcher
	{
		private var _testObject:Object;
		private var _proxyHandlers:Array = [];
		private var _isComplete:Boolean = false;
		private var _timeout:int = -1;
		private var _timer:uint;
		private var _uncaughtErrorEvents:UncaughtErrorEvents;
		private static var sUncaughtErrorPriority:int;

		public function Async(testObject:Object, uncaughtErrorEvents:UncaughtErrorEvents = null)
		{
			_testObject = testObject;
			_uncaughtErrorEvents = uncaughtErrorEvents;

			// Handle asynchronous uncaught errors
			if(_uncaughtErrorEvents != null)
			{
				_uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, asyncUncaughtError, false, sUncaughtErrorPriority++);
			}
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
			if(_uncaughtErrorEvents != null)
			{
				_uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, asyncUncaughtError);
				_uncaughtErrorEvents = null;
			}
			dispatchEvent(new AsyncEvent(AsyncEvent.COMPLETE, this));
		}


		private function handlerError(event:AsyncProxyHandlerEvent):void
		{
			dispatchEvent(new AsyncEvent(event.type, this, event.error));
			complete();
		}


		private function timeExpired():void
		{
			dispatchError(new AsyncTimeoutError('Test did not complete in required ' + _timeout + ' ms'));
		}


		private function asyncUncaughtError(event:UncaughtErrorEvent):void
		{
			event.preventDefault();
			event.stopPropagation();
			event.stopImmediatePropagation();

			var error:* = event.error;

			if(error == null)
			{
				dispatchError(new Error("Unknown asynchronous error."));
			}
			else if(error is Error)
			{
				dispatchError(error);
			}
			else if(error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = ErrorEvent(error);
				dispatchError(new Error(errorEvent.text, errorEvent.errorID))
			}
			else
			{
				dispatchError(new Error("Custom error - " + error));
			}
		}
		
		
		private function dispatchError(error:Error):void
		{
			dispatchEvent(new AsyncEvent(AsyncEvent.ERROR, this, error));
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
