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
