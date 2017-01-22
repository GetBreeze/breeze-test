package breezetest
{
	public class BreezeTestResult
	{
		public var testSuiteResults:Vector.<TestSuiteResult> = new Vector.<TestSuiteResult>();


		public function get passed():Boolean
		{
			for each(var result:TestSuiteResult in testSuiteResults)
			{
				if(!result.passed)
				{
					return false;
				}
			}

			return true;
		}


		public function get totalTestSuites():int
		{
			return testSuiteResults.length;
		}


		public function get totalFailedTestSuites():int
		{
			return failedTestSuites.length;
		}


		public function get failedTestSuites():Vector.<TestSuiteResult>
		{
			var failedTestSuites:Vector.<TestSuiteResult> = new <TestSuiteResult>[];

			for each(var result:TestSuiteResult in testSuiteResults)
			{
				if(!result.passed)
				{
					failedTestSuites.push(result);
				}
			}

			return failedTestSuites;
		}


		public function get totalTests():int
		{
			var tests:int = 0;

			for each(var result:TestSuiteResult in testSuiteResults)
			{
				tests += result.totalTests;
			}

			return tests;
		}


		public function get totalFailedTests():int
		{
			var failedTests:int = 0;
			for each(var result:TestSuiteResult in testSuiteResults)
			{
				failedTests += result.failedTests.length;
			}
			return failedTests;
		}

	}
}
