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
	import tests.async.TestPublicAsync;
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
			_breezeTest.add([TestAssert, TestTestSuiteRunner, TestClassInfo, TestAsync, TestPublicAsync]);
			_breezeTest.run();
		}


		private function onTestsComplete(event:BreezeTestEvent):void
		{
			// Return error if tests failed
			NativeApplication.nativeApplication.exit(_breezeTest.success ? 0 : 1);
		}
	}
}
