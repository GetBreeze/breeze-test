package tests.testutils
{
	import breezetest.async.Async;

	import flash.utils.setTimeout;

	public class SampleAsyncTestSuite
	{
		public var setupClassCalls:int = 0;
		public var tearDownClassCalls:int = 0;
		public var setupCalls:int = 0;
		public var tearDownCalls:int = 0;
		public var testCalls:int = 0;

		public function setupClass(async:Async):void
		{
			setTimeout(function():void
			{
				setupClassCalls++;
				async.complete();

			}, 50);
		}


		public function tearDownClass(async:Async):void
		{
			setTimeout(function():void
			{
				tearDownClassCalls++;
				async.complete();

			}, 50);

		}


		public function setup(async:Async):void
		{
			setTimeout(function():void
			{
				setupCalls++;
				async.complete();

			}, 50);
		}


		public function tearDown(async:Async):void
		{
			setTimeout(function():void
			{
				tearDownCalls++;
				async.complete();

			}, 50);
		}


		public function testOne(async:Async):void
		{
			setTimeout(function():void
			{
				testCalls++;
				async.complete();

			}, 50);
		}


		public function testTwo(async:Async):void
		{
			setTimeout(function():void
			{
				testCalls++;
				async.complete();

			}, 50);
		}
	}
}
