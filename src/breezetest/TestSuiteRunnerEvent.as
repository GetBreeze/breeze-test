package breezetest
{
	import breezetest.TestSuiteRunner;
	import breezetest.utils.classinfo.MethodInfo;

	import flash.events.Event;

	public class TestSuiteRunnerEvent extends Event
	{
		public static const TEST_CLASS_START:String = "TEST_CLASS_START";
		public static const TEST_CLASS_END:String = "TEST_CLASS_END";
		public static const TEST_METHOD_START:String = "TEST_METHOD_START";
		public static const TEST_METHOD_END:String = "TEST_METHOD_END";
		public static const TEST_METHOD_ERROR:String = "TEST_METHOD_ERROR";

		private var _testRunner:TestSuiteRunner;
		private var _result:TestResult;

		public function TestSuiteRunnerEvent(type:String, testRunner:TestSuiteRunner, result:TestResult = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_testRunner = testRunner;
			_result = result;

			super(type, bubbles, cancelable);
		}


		public function get testRunner():TestSuiteRunner
		{
			return _testRunner;
		}


		public function get result():TestResult
		{
			return _result;
		}
	}
}
