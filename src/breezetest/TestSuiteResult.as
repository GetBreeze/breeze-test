package breezetest
{
	public class TestSuiteResult
	{
		public var className:String;

		public var testResults:Vector.<TestResult> = new Vector.<TestResult>();

		public var setupResult:TestResult;

		public var tearDownResult:TestResult;


		public function get passed():Boolean
		{
			return (totalFailedTests == 0) && (setupResult == null) && (tearDownResult == null);
		}


		public function get failedTests():Vector.<TestResult>
		{
			var failedTests:Vector.<TestResult> = new <TestResult>[];

			for each(var result:TestResult in testResults)
			{
				if(!result.passed)
				{
					failedTests.push(result);
				}
			}

			return failedTests;
		}


		public function get totalTests():int
		{
			return testResults.length;
		}


		public function get totalFailedTests():int
		{
			return failedTests.length;
		}
	}
}
