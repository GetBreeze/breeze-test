package breezetest
{
	import breezetest.async.Async;
	import breezetest.async.AsyncEvent;
	import breezetest.errors.AssertionError;
	import breezetest.utils.classinfo.ClassInfo;
	import breezetest.utils.classinfo.MethodInfo;

	import flash.events.EventDispatcher;

	import flash.utils.getQualifiedClassName;

	public class TestSuiteRunner extends EventDispatcher
	{
		private var _testObject:*;
		private var _classData:ClassInfo;
		private var _methodsToTest:Array = [];
		private var _result:TestResult;
		private var _runnerResult:TestSuiteResult;

		public function TestSuiteRunner(testObject:*)
		{
			_testObject = testObject;
			_classData = new ClassInfo(testObject);

			_runnerResult = new TestSuiteResult();
			_runnerResult.className = getQualifiedClassName(_testObject);
		}


		public function run():void
		{
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_CLASS_START, this));

			setupClass();
			setUpTests();
			runNextTest();
		}
		
		
		private function runNextTest():void
		{
			if(_methodsToTest.length > 0)
			{
				var methodData:MethodInfo = _methodsToTest.pop();

				// Create test result for this method
				_result = new TestResult();
				_result.name = methodData.name;
				_result.className = getQualifiedClassName(_testObject);
				_runnerResult.testResults.push(_result);

				dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_START, this, _result));

				// Setup the test
				setup();

				// Run the test
				var asyncFactory:Async;
				try
				{
					// Async
					if(methodData.parameters.length > 0)
					{
						if(methodData.parameters.length == 1 && methodData.parameters[0].type == 'breezetest.async::Async')
						{
							asyncFactory = new Async(_testObject);
							asyncFactory.addEventListener(AsyncEvent.COMPLETE, asyncTestComplete);
							asyncFactory.addEventListener(AsyncEvent.ERROR, asyncError);

							_testObject[methodData.name](asyncFactory);
						}
						else
						{
							throw new Error('Invalid test method arguments');
						}
					}
					// Sync
					else
					{
						_testObject[methodData.name]();
					}
				}
				catch (error:AssertionError)
				{
					_result.error = error;
					dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_ERROR, this, _result));
				}

				// Sync test
				if(asyncFactory == null)
				{
					finishTest();
				}
			}
			else
			{
				tearDownClass();
			}
		}


		private function asyncError(event:AsyncEvent):void
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

			tearDown();
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_METHOD_END, this, _result));
			runNextTest();
		}


		private function setUpTests():void
		{
			for each(var method:MethodInfo in _classData.methods)
			{
				if(method.name.indexOf("test") == 0)
				{
					_methodsToTest.push(method);
				}
			}
		}

		
		private function setupClass():void
		{
			callMethodIfExists("setupClass", _testObject);
		}


		private function tearDownClass():void
		{
			callMethodIfExists("tearDownClass", _testObject);
			dispatchEvent(new TestSuiteRunnerEvent(TestSuiteRunnerEvent.TEST_CLASS_END, this));
		}


		private function setup():void
		{
			callMethodIfExists("setup", _testObject);
		}


		private function tearDown():void
		{
			callMethodIfExists("tearDown", _testObject);
		}


		private function callMethodIfExists(methodName:String, obj:*):void
		{
			if(methodName in obj)
			{
				obj[methodName]();
			}
		}


		public function get result():TestSuiteResult
		{
			return _runnerResult;
		}

	}
}
