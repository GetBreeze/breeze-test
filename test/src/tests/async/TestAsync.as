package tests.async
{
	import breezetest.Assert;
	import breezetest.async.Async;
	import breezetest.async.AsyncEvent;
	import breezetest.errors.AssertionError;
	import breezetest.errors.AsyncTimeoutError;

	import flash.utils.setTimeout;

	public class TestAsync
	{
		public function testTimeoutError(async:Async):void
		{
			var factory:Async = new Async(this);
			factory.addEventListener(AsyncEvent.ERROR, function(event:AsyncEvent):void
			{
				async.run(function():void
				{
					Assert.equals(AsyncEvent.ERROR, event.type);
					Assert.isType(event.error, AsyncTimeoutError);
					Assert.same(factory, event.factory);

					async.complete();
				});
			});

			factory.timeout = 1000;

			// Fail if timeout event is not called in 2000 ms
			async.timeout = 2000;
		}


		public function testCompleteEvent(async:Async):void
		{
			var factory:Async = new Async(this);
			factory.addEventListener(AsyncEvent.COMPLETE, function(event:AsyncEvent):void
			{
				// Run assertions in async block so we can catch errors
				async.run(function():void
				{
					Assert.equals(AsyncEvent.COMPLETE, event.type);
					Assert.same(factory, event.factory);

					async.complete();
				});
			});

			// Fail if complete event is not called in 2000 ms
			async.timeout = 2000;

			// Call the async handler
			setTimeout(function():void
			{
				factory.complete();
			}, 500);
		}


		public function testAssertionError(async:Async):void
		{
			var factory:Async = new Async(this);
			factory.addEventListener(AsyncEvent.ERROR, function(event:AsyncEvent):void
			{
				// Run assertions in async block so we can catch errors
				async.run(function():void
				{
					Assert.equals(AsyncEvent.ERROR, event.type);
					Assert.isType(event.error, AssertionError);
					Assert.same(factory, event.factory);

					async.complete();
				});
			});

			// Fail if error event is not called in 2000 ms
			async.timeout = 2000;

			// Force an error
			setTimeout(function():void
			{
				factory.run(function():void
				{
					Assert.isTrue(false);
				});

			}, 1000);
		}


		public function testRunMethod(async:Async):void
		{
			var factory:Async = new Async(this);

			// Fail in 1000 ms
			async.timeout = 1000;

			// Run async code now
			factory.run(function():void
			{
				async.complete();
			});
		}


		public function testCreateProxyMethod(async:Async):void
		{
			// Fail in 1000 ms
			async.timeout = 1000;

			// Create async proxy
			var proxyFunction:Function = async.createProxy(function():void
			{
				// This will automatically call the complete method when finished

			}, -1, true);

			// Run the proxy
			proxyFunction();
		}

	}
}
