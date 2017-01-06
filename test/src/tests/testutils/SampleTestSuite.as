package tests.testutils
{
	public class SampleTestSuite
	{
		public var setupClassCalls:int = 0;
		public var tearDownClassCalls:int = 0;
		public var setupCalls:int = 0;
		public var tearDownCalls:int = 0;
		public var testCalls:int = 0;

		public function setupClass():void
		{
			setupClassCalls++;
		}

		public function tearDownClass():void
		{
			tearDownClassCalls++;
		}

		public function setup():void
		{
			setupCalls++;
		}

		public function tearDown():void
		{
			tearDownCalls++;
		}

		public function testOne():void
		{
			testCalls++;
		}

		public function testTwo():void
		{
			testCalls++;
		}
	}
}
