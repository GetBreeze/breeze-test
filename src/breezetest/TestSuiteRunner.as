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

package breezetest
{
	import breezetest.async.Async;
	import breezetest.async.AsyncEvent;
	import breezetest.utils.classinfo.ClassInfo;
	import breezetest.utils.classinfo.MethodInfo;

	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvents;

	import flash.utils.getQualifiedClassName;

	public class TestSuiteRunner extends EventDispatcher
	{
		private var _testObject:*;
		private var _classData:ClassInfo;
		private var _methodsToTest:Vector.<MethodInfo>;
		private var _setupMethods:Vector.<MethodInfo>;
		private var _tearDownMethods:Vector.<MethodInfo>;
		private var _currentTestMethod:MethodInfo;
		private var _result:TestResult;
		private var _runnerResult:TestSuiteResult;
		private var _asyncCompleteCallback:Function;
		private var _asyncErrorCallback:Function;
		private var _uncaughtErrorEvents:UncaughtErrorEvents;

		public function TestSuiteRunner(testObject:*, uncaughtErrorEvents:UncaughtErrorEvents = null)
		{
			_testObject = testObject;
			_uncaughtErrorEvents = uncaughtErrorEvents;

			_classData = new ClassInfo(testObject);

			_methodsToTest = new <MethodInfo>[];
			_setupMethods = new <MethodInfo>[];
			_tearDownMethods = new <MethodInfo>[];

			_runnerResult = new TestSuiteResult();
			_runnerResult.className = getQualifiedClassName(_testObject);
		}


		public function run():void
		{
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_CLASS_START, this));

			initClassMethods();

			setupClass();
		}
		
		
		private function runNextTest():void
		{
			if(_methodsToTest.length > 0)
			{
				_currentTestMethod = _methodsToTest.pop();

				// Create test result for this method
				_result = new TestResult();
				_result.name = _currentTestMethod.name;
				_result.className = getQualifiedClassName(_testObject);
				_runnerResult.testResults.push(_result);

				dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_START, this, _result));

				// Setup the test
				setupTest();
			}
			else
			{
				tearDownClass();
			}
		}


		private function callTestMethod():void
		{
			var asyncFactory:Async = null;
			try
			{
				// Async
				if (_currentTestMethod.parameters.length > 0)
				{
					if (isMethodAsync(_currentTestMethod))
					{
						asyncFactory = new Async(_testObject, _uncaughtErrorEvents);
						asyncFactory.addEventListener(AsyncEvent.COMPLETE, asyncTestComplete);
						asyncFactory.addEventListener(AsyncEvent.ERROR, asyncTestError);

						_testObject[_currentTestMethod.name](asyncFactory);
					}
					else
					{
						throw new Error('Test method \'' + _currentTestMethod.name + '\' has invalid parameters.');
					}
				}
				// Sync
				else
				{
					_testObject[_currentTestMethod.name]();
				}
			}
			catch (error:Error)
			{
				_result.error = error;
				dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_ERROR, this, _result));

				if (asyncFactory != null)
				{
					asyncFactory.removeEventListener(AsyncEvent.COMPLETE, asyncTestComplete);
					asyncFactory.removeEventListener(AsyncEvent.ERROR, asyncTestError);
					asyncFactory = null;
				}
			}

			// Sync test
			if (asyncFactory == null)
			{
				finishTest();
			}
		}


		private function asyncTestError(event:AsyncEvent):void
		{
			_result.error = event.error;
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_ERROR, this, _result));
		}


		private function asyncTestComplete(event:AsyncEvent):void
		{
			finishTest();
		}


		private function finishTest():void
		{
			if(_result.error == null)
			{
				_result.passed = true;
			}

			tearDownTest();
		}


		private function initClassMethods():void
		{
			for each(var method:MethodInfo in _classData.methods)
			{
				// Test methods
				if(method.name.indexOf('test') == 0)
				{
					_methodsToTest.push(method);
				}
				// Setup methods
				else if(method.name.indexOf('setup') == 0)
				{
					_setupMethods.push(method);
				}
				// Tear down methods
				else if(method.name.indexOf('tearDown') == 0)
				{
					_tearDownMethods.push(method);
				}
			}
		}


		/**
		 *
		 * Class setup
		 *
		 */


		private function setupClass():void
		{
			var method:MethodInfo = getMethod('setupClass', _setupMethods);
			var error:Error = callMethodIfExists(method, onClassSetupSuccess, onClassSetupFailed);
			if (error != null)
			{
				failClassSetup(error);
			}
		}

		
		private function onClassSetupSuccess():void
		{
			runNextTest();
		}


		private function onClassSetupFailed(event:AsyncEvent):void
		{
			failClassSetup(event.error);
		}


		private function failClassSetup(error:Error):void
		{
			var result:TestResult = new TestResult();
			result.name = 'setupClass';
			result.className = getQualifiedClassName(_testObject);
			result.error = error;
			result.passed = false;
			_runnerResult.setupResult = result;
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_CLASS_END, this));
		}


		/**
		 *
		 * Class tear down
		 *
		 */


		private function tearDownClass():void
		{
			var method:MethodInfo = getMethod('tearDownClass', _tearDownMethods);
			var error:Error = callMethodIfExists(method, onClassTearDownSuccess, onClassTearDownFailed);
			if (error != null)
			{
				failClassTearDown(error);
			}
		}


		private function onClassTearDownSuccess():void
		{
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_CLASS_END, this));
		}


		private function onClassTearDownFailed(event:AsyncEvent):void
		{
			failClassTearDown(event.error);
		}


		private function failClassTearDown(error:Error):void
		{
			var result:TestResult = new TestResult();
			result.name = 'tearDownClass';
			result.className = getQualifiedClassName(_testObject);
			result.error = error;
			result.passed = false;
			_runnerResult.tearDownResult = result;
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_CLASS_END, this));
		}


		/**
		 *
		 * Test setup
		 *
		 */


		private function setupTest():void
		{
			var method:MethodInfo = getMethod('setup', _setupMethods);
			var error:Error = callMethodIfExists(method, onTestSetupSuccess, onTestSetupFailed);
			if (error != null)
			{
				failTestSetup(error);
			}
		}


		private function onTestSetupSuccess():void
		{
			callTestMethod();
		}


		private function onTestSetupFailed(event:AsyncEvent):void
		{
			failTestSetup(event.error);
		}


		private function failTestSetup(error:Error):void
		{
			_result.name += ' :: setup';
			_result.error = error;
			_result.passed = false;
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_ERROR, this, _result));
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_END, this, _result));
			runNextTest();
		}


		/**
		 *
		 * Test tear down
		 *
		 */


		private function tearDownTest():void
		{
			var method:MethodInfo = getMethod('tearDown', _tearDownMethods);
			var error:Error = callMethodIfExists(method, onTestTearDownSuccess, onTestTearDownFailed);
			if (error != null)
			{
				failTestTearDown(error);
			}
		}


		private function onTestTearDownSuccess():void
		{
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_END, this, _result));
			runNextTest();
		}


		private function onTestTearDownFailed(event:AsyncEvent):void
		{
			failTestTearDown(event.error);
		}


		private function failTestTearDown(error:Error):void
		{
			_result.name += ' :: tearDown';
			_result.error = error;
			_result.passed = false;
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_ERROR, this, _result));
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_END, this, _result));
			runNextTest();
		}


		/**
		 *
		 * Helpers
		 *
		 */


		private function callMethodIfExists(method:MethodInfo, onSuccess:Function, onError:Function):Error
		{
			if(method == null)
			{
				onSuccess();
			}
			else
			{
				// Sync
				if(method.parameters.length == 0)
				{
					try
					{
						_testObject[method.name]();
						onSuccess();
					}
					catch(e:Error)
					{
						return e;
					}
				}
				// Async
				else if(isMethodAsync(method))
				{
					_asyncCompleteCallback = onSuccess;
					_asyncErrorCallback = onError;
					var async:Async = new Async(null, _uncaughtErrorEvents);
					async.addEventListener(AsyncEvent.COMPLETE, onAsyncProcessCompleted);
					async.addEventListener(AsyncEvent.ERROR, onAsyncProcessFailed);
					try
					{
						_testObject[method.name](async);
					}
					catch(e:Error)
					{
						return e;
					}
				}
				else
				{
					throw new Error('Method \'' + method.name + '\' has invalid parameters.');
				}
			}
			return null;
		}


		private function onAsyncProcessCompleted(event:AsyncEvent):void
		{
			var async:Async = event.currentTarget as Async;
			async.removeEventListener(AsyncEvent.COMPLETE, onAsyncProcessCompleted);
			async.removeEventListener(AsyncEvent.ERROR, onAsyncProcessFailed);
			var callback:Function = _asyncCompleteCallback;
			_asyncCompleteCallback = null;
			_asyncErrorCallback = null;
			callback();
		}


		private function onAsyncProcessFailed(event:AsyncEvent):void
		{
			var async:Async = event.currentTarget as Async;
			async.removeEventListener(AsyncEvent.COMPLETE, onAsyncProcessCompleted);
			async.removeEventListener(AsyncEvent.ERROR, onAsyncProcessFailed);
			var callback:Function = _asyncErrorCallback;
			_asyncCompleteCallback = null;
			_asyncErrorCallback = null;
			callback(event);
		}


		private function getMethod(name:String, methods:Vector.<MethodInfo>):MethodInfo
		{
			for each(var value:MethodInfo in methods)
			{
				if(value.name == name)
				{
					return value;
				}
			}
			return null;
		}


		private function isMethodAsync(method:MethodInfo):Boolean
		{
			return method.parameters.length == 1 && method.parameters[0].type == 'breezetest.async::Async';
		}


		/**
		 *
		 * Getters / Setters
		 *
		 */


		public function get result():TestSuiteResult
		{
			return _runnerResult;
		}

	}
}
