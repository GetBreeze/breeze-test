package tests.testutils
{
	import breezetest.async.Async;

	import flash.utils.setTimeout;

	public class SampleErrorTestSuite
	{
		public function testNoProxyAsyncError(async:Async):void
		{
			setTimeout(function():void {
				throw new Error("Uncaught async error.");
			}, 50);
		}

		public function testSyncError():void
		{
			throw new Error("Uncaught sync error.");
		}


		public function testAsyncSuccess(async:Async):void
		{
			async.complete();
		}
	}
}
