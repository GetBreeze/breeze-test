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

	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	public class AsyncProxyHandler extends EventDispatcher
	{
		private var _asyncFactory:Async;
		private var _callback:Function;
		private var _timeout:int;
		private var _timer:uint;
		private var _isComplete:Boolean = false;

		public function AsyncProxyHandler(asyncFactory:Async, callback:Function, timeout:int = -1)
		{
			_asyncFactory = asyncFactory;
			_callback = callback;
			_timeout = timeout;

			if(_timeout > -1)
			{
				_timeout = setTimeout(timeExpired, timeout);
			}
		}


		private function timeExpired():void
		{
			_isComplete = true;
			dispatchEvent(new AsyncProxyHandlerEvent(AsyncProxyHandlerEvent.ERROR, this, new AsyncTimeoutError('Async method was not called in required ' + _timeout + ' ms')));
		}


		public function proxy(...args):void
		{
			if(_isComplete || _asyncFactory.isComplete)
			{
				return;
			}

			try
			{
				_isComplete = true;

				// No arguments
				if(_callback.length == 0)
				{
					_callback.call(_asyncFactory.testObject);
				}
				// Async factory argument
				else if(_callback.length == 1)
				{
					_callback.call(_asyncFactory.testObject, _asyncFactory);
				}
				// Forward async factory argument along with original arguments
				else
				{
					_callback.apply(_asyncFactory.testObject, [_asyncFactory].concat(args));
				}

				dispatchEvent(new AsyncProxyHandlerEvent(AsyncProxyHandlerEvent.COMPLETE, this));
			}
			catch(e:Error)
			{
				dispatchEvent(new AsyncProxyHandlerEvent(AsyncProxyHandlerEvent.ERROR, this, e));
			}
		}


		public function get timeout():int
		{
			return _timeout;
		}


		public function get asyncFactory():Async
		{
			return _asyncFactory;
		}


	}
}
