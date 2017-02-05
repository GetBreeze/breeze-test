/*
 * MIT License
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

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
