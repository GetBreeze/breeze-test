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

package tests
{
	import breezetest.Assert;
	import breezetest.TestResult;
	import breezetest.TestSuiteRunner;
	import breezetest.TestSuiteRunnerEvent;
	import breezetest.async.Async;

	import tests.testutils.SampleAsyncTestSuite;
	import tests.testutils.SampleErrorTestSuite;
	import tests.testutils.SampleTestSuite;

	public class TestTestSuiteRunner
	{
		private var _runner:TestSuiteRunner;

		public function testSyncTestSuite(async:Async):void
		{
			var testSuite:SampleTestSuite = new SampleTestSuite();

			_runner = new TestSuiteRunner(testSuite);
			_runner.addEventListener(TestSuiteRunnerEvent.TEST_CLASS_END, async.createProxy(function(async:Async, event:TestSuiteRunnerEvent):void
			{
				Assert.equals(1, testSuite.setupClassCalls, 'setupClass should be called once');
				Assert.equals(1, testSuite.tearDownClassCalls, 'tearDownClass should be called once');
				Assert.equals(2, testSuite.setupCalls, 'setup should be called twice');
				Assert.equals(2, testSuite.tearDownCalls, 'tearDown should be called twice');
				Assert.equals(2, testSuite.testCalls, 'Tests should be called twice');

				async.complete();
			}));

			_runner.run();
		}


		public function testAsyncTestSuite(async:Async):void
		{
			var testSuite:SampleAsyncTestSuite = new SampleAsyncTestSuite();

			_runner = new TestSuiteRunner(testSuite);
			_runner.addEventListener(TestSuiteRunnerEvent.TEST_CLASS_END, async.createProxy(function(async:Async, event:TestSuiteRunnerEvent):void
			{
				Assert.equals(1, testSuite.setupClassCalls, 'setupClass should be called once');
				Assert.equals(1, testSuite.tearDownClassCalls, 'tearDownClass should be called once');
				Assert.equals(2, testSuite.setupCalls, 'setup should be called twice');
				Assert.equals(2, testSuite.tearDownCalls, 'tearDown should be called twice');
				Assert.equals(2, testSuite.testCalls, 'Tests should be called twice');

				async.complete();
			}));

			_runner.run();
		}


		public function testAsyncErrorTestSuite(async:Async):void
		{
			if (Main.root == null)
			{
				throw new Error("Root DisplayObject must be set.");
			}

			var testSuite:SampleErrorTestSuite = new SampleErrorTestSuite();

			_runner = new TestSuiteRunner(testSuite, Main.root.loaderInfo.uncaughtErrorEvents);
			_runner.addEventListener(TestSuiteRunnerEvent.TEST_CLASS_END, async.createProxy(function(async:Async, event:TestSuiteRunnerEvent):void
			{
				Assert.equals(2, _runner.result.failedTests.length, 'Two tests should fail');
				for each(var result:TestResult in _runner.result.failedTests)
				{
					Assert.isTrue(result.name == 'testNoProxyAsyncError' || result.name == 'testSyncError', 'Test method ' + result.name + ' should not fail.');
				}

				async.complete();
			}));

			_runner.run();
		}

	}
}
