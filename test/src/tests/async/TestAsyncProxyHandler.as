package tests.async
{
	import breezetest.Assert;
	import breezetest.async.Async;
	import breezetest.async.AsyncProxyHandler;
	import breezetest.async.AsyncProxyHandlerEvent;
	import breezetest.errors.AssertionError;
	import breezetest.errors.AsyncTimeoutError;

	import flash.utils.setTimeout;

	public class TestAsyncProxyHandler
	{
		public function testTimeoutErrorEvent(async:Async):void
		{
			var handler:AsyncProxyHandler = new AsyncProxyHandler(new Async(this), function():void{}, 1000);

			// Watch for error
			handler.addEventListener(AsyncProxyHandlerEvent.ERROR, function(event:AsyncProxyHandlerEvent):void
			{
				async.run(function():void
				{
					Assert.equals(AsyncProxyHandlerEvent.ERROR, event.type);
					Assert.isNotNull(event.error);
					Assert.isType(event.error, AsyncTimeoutError);

					async.complete();
				});

			});

			// Fail if the timeout event is not called in 2000 ms
			async.timeout = 2000;
			Assert.equals(2000, async.timeout);
		}


		public function testAssertionErrorEvent(async:Async):void
		{
			var handler:AsyncProxyHandler = new AsyncProxyHandler(new Async(this), function():void
			{
				// Throw an error to make sure it's caught
				Assert.isTrue(false);

			}, 2000);

			// Watch for error event
			handler.addEventListener(AsyncProxyHandlerEvent.ERROR, function(event:AsyncProxyHandlerEvent):void
			{
				async.run(function():void
				{
					Assert.isNotNull(event);
					Assert.same(event.handler, handler);
					Assert.isNotNull(event.error);
					Assert.isType(event.error, AssertionError);

					async.complete();
				});
			});

			// Fail if the error event is not called in 2000 ms
			async.timeout = 2000;

			// Call the async handler
			setTimeout(function():void
			{
				handler.proxy();
			}, 1000);

		}


		public function testCompleteEvent(async:Async):void
		{
			var handler:AsyncProxyHandler = new AsyncProxyHandler(new Async(this), function():void{}, 1000);

			// Watch for complete event
			handler.addEventListener(AsyncProxyHandlerEvent.COMPLETE, function(event:AsyncProxyHandlerEvent):void
			{
				async.run(function():void
				{
					Assert.equals(AsyncProxyHandlerEvent.COMPLETE, event.type);
					Assert.isNull(event.error);

					async.complete();
				});
			});

			handler.proxy();
		}


		public function testProxyNoArguments(async:Async):void
		{
			var factory:Async = new Async(this);

			// Async method with no arguments
			var handler:AsyncProxyHandler = new AsyncProxyHandler(factory, function():void
			{
				async.complete();
			});

			// Fail if proxy isn't called in 2000 ms
			async.timeout = 2000;

			// Call the async handler
			setTimeout(function():void
			{
				handler.proxy();
			}, 1000);
		}


		public function testProxyOneArgument(async:Async):void
		{
			var factory:Async = new Async(this);

			// Async method with single factory argument
			var handler:AsyncProxyHandler = new AsyncProxyHandler(factory, function(_factory:Async):void
			{
				async.run(function():void
				{
					Assert.same(factory, _factory);
					async.complete();
				});
			});

			// Fail if proxy isn't called in 2000 ms
			async.timeout = 2000;

			// Call the async handler
			setTimeout(function():void
			{
				handler.proxy();
			}, 1000);
		}


		public function testProxyMultipleArguments(async:Async):void
		{
			var factory:Async = new Async(this);
			var testObj:Object = {};

			// Async method with multiple arguments
			var handler:AsyncProxyHandler = new AsyncProxyHandler(factory, function(_factory:Async, arg1:String, arg2:int, arg3:Object):void
			{
				async.run(function():void
				{
					Assert.same(factory, _factory);
					Assert.equals(arg1, "Hello");
					Assert.equals(arg2, 123);
					Assert.same(arg3, testObj);

					async.complete();
				});
			});

			// Fail if proxy isn't called in 2000 ms
			async.timeout = 2000;

			// Call the async handler
			setTimeout(function():void
			{
				handler.proxy("Hello", 123, testObj);
			}, 1000);
		}

	}
}
