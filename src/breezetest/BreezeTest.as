package breezetest
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvents;

	public class BreezeTest extends EventDispatcher
	{
		public static const VERSION:String = "0.3.0";

		private var _testSuites:Array = [];
		private var _index:int = 0;
		private var _runner:TestSuiteRunner;
		private var _result:BreezeTestResult;
		private var _uncaughtErrorEvents:UncaughtErrorEvents;

		// You can override the BreezeTestOutput class to provide your own output format
		public var output:BreezeTestOutput = new BreezeTestOutput();
		
		
		public function BreezeTest(root:DisplayObject = null):void
		{
			super();

			if(root != null)
			{
				_uncaughtErrorEvents = root.loaderInfo.uncaughtErrorEvents;
			}
		}

		public function add(value:*):void
		{
			if(value is Array)
			{
				for each(var obj:* in value)
				{
					add(obj);
				}
			}
			else if(value is Class)
			{
				_testSuites.push(value);
			}
			else
			{
				throw new ArgumentError('Invalid arguments, must be an array of classes or a single class');
			}
		}


		public function run():void
		{
			output.testSuitesStart(this);

			_result = new BreezeTestResult();
			next();
		}


		private function next():void
		{
			if(_index >= _testSuites.length)
			{
				testsComplete();
				return;
			}

			var testClass:Class = _testSuites[_index++] as Class;
			_runner = new TestSuiteRunner(new testClass(), _uncaughtErrorEvents);
			_runner.addEventListener(TestSuiteRunnerEvent.TEST_METHOD_START, testMethodStart);
			_runner.addEventListener(TestSuiteRunnerEvent.TEST_METHOD_END, testMethodEnd);
			_runner.addEventListener(TestSuiteRunnerEvent.TEST_CLASS_END, testSuiteEnd);

			output.testSuiteStart(_runner);

			_runner.run();
		}


		private function testSuiteEnd(event:TestSuiteRunnerEvent):void
		{
			output.testSuiteEnd(event.testRunner);

			_result.testSuiteResults.push(event.testRunner.result);
			next();
		}


		private function testMethodStart(event:TestSuiteRunnerEvent):void
		{
			output.testMethodStart(event.testRunner, event.result);
		}


		private function testMethodEnd(event:TestSuiteRunnerEvent):void
		{
			output.testMethodEnd(event.testRunner, event.result);
		}


		private function testsComplete():void
		{
			output.testSuitesEnd(this);

			dispatchEvent(new BreezeTestEvent(BreezeTestEvent.TESTS_COMPLETE, this));
		}


		public function get result():BreezeTestResult
		{
			return _result;
		}


		public function get success():Boolean
		{
			return _result.passed;
		}


	}
}
