package breezetest
{
	public class BreezeTestOutput
	{
		public function BreezeTestOutput()
		{

		}


		/**
		 * Called when the BreezeTest run method is called.
		 *
		 * @param breezeTest
		 */
		public function testSuitesStart(breezeTest:BreezeTest):void
		{

		}


		/**
		 * Called when call BreezeTest suites are finished running.
		 *
		 * @param breezeTest
		 */
		public function testSuitesEnd(breezeTest:BreezeTest):void
		{
			if(breezeTest.success)
			{
				output(breezeTest.result.totalTestSuites + ' suites, ' + breezeTest.result.totalTests + ' tests complete');
				output("TESTS PASSED");
			}
			else
			{

				output(breezeTest.result.totalFailedTestSuites + ' of ' + breezeTest.result.totalTestSuites + ' suites failed, ' +
						breezeTest.result.totalFailedTests + ' of ' + breezeTest.result.totalTests + ' tests failed');

				for each(var testSuiteResult:TestSuiteResult in breezeTest.result.failedTestSuites)
				{
					output('');
					output('');
					output(testSuiteResult.className);

					// Output class setup error if there's one
					if (testSuiteResult.setupResult != null)
					{
						outputTestResult(testSuiteResult.setupResult);
					}
					// Output results for failed tests
					else
					{
						for each(var testResult:TestResult in testSuiteResult.failedTests)
						{
							outputTestResult(testResult);
						}

						// Output class tear down error if there's one
						if (testSuiteResult.tearDownResult != null)
						{
							outputTestResult(testSuiteResult.tearDownResult);
						}
					}
				}

				output('');
				output("TESTS FAILED");
			}
		}


		/**
		 * Called when a new test suite begins to run.
		 *
		 * @param testRunner
		 */
		public function testSuiteStart(testRunner:TestSuiteRunner):void
		{
			output(testRunner.result.className);
		}


		/**
		 * Called when a test suite is complete.
		 *
		 * @param testRunner
		 */
		public function testSuiteEnd(testRunner:TestSuiteRunner):void
		{
			output('');
			output('');
		}


		/**
		 * Called before a test method is run.
		 *
		 * @param testRunner
		 * @param testResult
		 */
		public function testMethodStart(testRunner:TestSuiteRunner, testResult:TestResult):void
		{

		}


		/**
		 * Called when a test method is complete.
		 *
		 * @param testRunner
		 * @param testResult
		 */
		public function testMethodEnd(testRunner:TestSuiteRunner, testResult:TestResult):void
		{
			output(' -' + testResult.name + ' : ' + (testResult.passed ? 'PASS' : 'FAIL'));
		}


		/**
		 * Output method. You can override this method if you wish to output to a different
		 * format other than trace.
		 *
		 * @param value String to output
		 */
		public function output(value:String):void
		{
			trace(value);
		}


		private function outputTestResult(result:TestResult):void
		{
			output('');
			output(' -' + result.name);
			output(result.error.getStackTrace());
			output('');
		}
	}
}
