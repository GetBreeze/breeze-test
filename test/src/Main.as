package
{
	import breezetest.BreezeTest;
	import breezetest.BreezeTestEvent;

	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;

	import tests.TestAssert;
	import tests.TestTestSuiteRunner;
	import tests.async.TestAsync;
	import tests.async.TestAsyncProxyHandler;
	import tests.utils.classinfo.TestClassInfo;

	public class Main extends Sprite
	{
		private var _breezeTest:BreezeTest;
		public static var root:DisplayObject;

		public function Main()
		{
			var textField:TextField = new TextField();
			textField.text = "Running tests...";
			addChild(textField);

			// To be able to access uncaughtErrorEvents within test suites
			Main.root = this;

			_breezeTest = new BreezeTest(this);
			_breezeTest.addEventListener(BreezeTestEvent.TESTS_COMPLETE, onTestsComplete);
			_breezeTest.add([TestAssert, TestTestSuiteRunner, TestClassInfo, TestAsync, TestAsyncProxyHandler]);
			_breezeTest.run();
		}


		private function onTestsComplete(event:BreezeTestEvent):void
		{
			// Return error if tests failed
			NativeApplication.nativeApplication.exit(_breezeTest.success ? 0 : 1);
		}
	}
}
