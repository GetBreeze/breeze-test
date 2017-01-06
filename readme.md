# Breeze Test

Breeze Test is a library for unit testing Adobe AIR applications. It is designed to be simple and intuitive while providing support for asynchronous testing.

## Getting Started

You can download the latest SWC file from the ```bin``` directory of the releases section of this repo.

Alternatively you can compile the SWC yourself using the included ANT script in the ```build``` directory.

The repo includes automated tests in the ```test``` directory that allow BreezeTest to test itself.

## Test Suites

Testing requires one or more test suites. A test suite is a generic class containing methods that run tests. Test methods must be public methods that begin with the word ```test``` and generally should have descriptive names. Any uncaught exception that occurs within test methods will cause that test to fail.

```
public class TestUsers
{
	public function testUserCreated():void
	{
		// Add tests here
		Assert.isTrue(true);
	}
	
	public function testUserPasswordReset():void
	{
		// More tests here
		Assert.isFalse(false);
	}
	
	public function helperMethod():void
	{
		// This won't be run as a test since it does not start with "test"
	}
}
```

If you need to run code at the beginning or end of a test suite add the methods ```setupClass``` and ```tearDownClass```. Alternatively the methods ```setup``` and ```tearDown``` will run before/after every test method is run.

```
public class TestUsers
{
	public function setupClass():void
	{
		// Called before tests are run
	}
	
	public function tearDownClass():void
	{
		// Called after all tests are run
	}
	
	public function setup():void
	{
		// Called before each test method
	}
	
	public function tearDown():void
	{
		// Called after each test method
	}
}
```

## Running Tests

You can run a single or multiple test suites using the ```BreezeTest``` class. Add test suites using the ```add``` method and begin running tests using the ```run``` method. You should also listen for the event ```BreezeTestEvent.TESTS_COMPLETE``` so you know when the tests are done.

```
var breezeTest:BreezeTest = new BreezeTest();
breezeTest.addEventListener(BreezeTestEvent.TESTS_COMPLETE, onTestsComplete);

// Add a single test suite
breezeTest.add(TestUsers);

// Or add multiple tests suites
breezeTest.add([TestUploads, TestEmails]);

// Begin running tests
breezeTest.run();
```

## Checking Results

BreezeTest was designed to be run using the AIR Debug Launcher so any trace output will automatically be printed to the console. You can extend the ```BreezeTestOutput``` class to handle different output formats.

```
var breezeTest:BreezeTest = new BreezeTest();
breezeTest.output = new MyCustomOutputClass();
```

The ```run``` method will run each test suite and trace out the results. After all test suites have been run, the output will print either ```TESTS FAILED``` or ```TESTS PASSED```.

When running tests with a build script you should exit the application with a non-zero output if a test fails.

```
private function onTestsComplete(event:BreezeTestEvent):void
{
	NativeApplication.nativeApplication.exit(_breezeTest.success ? 0 : 1);
}
```

## Asynchronous Tests

A powerful feature of BreezeTest is the ability to test asynchronous methods using callback functions or event listeners.

Signal that a test method is asynchronous by adding a parameter with type ```Async```. You must call the ```complete``` method when the test is complete.

```
function testAsync(async:Async):void
{
	async.complete();
}
```

### Test Timeout

You can limit the amount of time an asynchronous method can run by setting the ```timeout``` property. If the ```complete``` method is not called within the specified time then the test will fail.

```
// Allow the test to run for 2000 milliseconds
async.timeout = 2000;
```

### Async Proxy

When testing callback functions or event listeners you must proxy the function using the ```createProxy``` method. This is required so that any thrown exceptions will be automatically caught and handled as a failure.

The ```createProxy``` method also has an optional timeout property. The test will fail if the function is not proxied within the amount of time specified.

```
// The callback function must be called in 2000 milliseconds
var callback:Function = async.createProxy(function():void
{
	Assert.isTrue(true);
	async.complete();
	
}, 2000);

// Run the callback in 1000 milliseconds
setTimeout(callback, 1000);
```

If you are running a single callback or event listener and you don't want to have to call the ```complete``` method, you can pass ```true``` in for the ```completeAfterRun``` parameter.

```
// The callback function has no time limit and will automatically call the 
// complete method when finished
var callback:Function = async.createProxy(function():void
{
	Assert.isTrue(true);
	
}, -1, true);
```

### Proxy Parameters

The ```createProxy``` method requires that proxied functions that have parameters begin with an ```Async``` object. Note this is true for event listeners as well.

```
var callback:Function = async.createProxy(function(async:Async, word:String):void
{
	async.complete();
	
});
```

### Testing Event Listeners

You can use the ```createProxy``` method to test event listeners as well. Just remember that the ```Async``` object must be the first parameter in a proxied event handler.

```
function handleEvent(async:Async, event:Event):void
{
	Assert.isNotNull(event);
	async.complete();
}

function testEventListener(async:Async):void
{
	var obj:MyTestObject = new MyTestObject();
	obj.addEventListener(Event.COMPLETE, async.createProxy(handleEvent));
}
```


## Assertions

Test methods can utilize the ```Assert``` class to verify values conform to expected values. A failed assert call will throw an exception and cause the test to fail.

```
public function testAssertIsTrue():void
{
	var myVariable:Boolean = true;
	Assert.isTrue(myVariable);
}
```

Each assert can also provide an optional message to give more context to the assertion.

```
Assert.isTrue(myVariable, "The myVariable variable should be true");
```

### True / False

```
Assert.isTrue(value);
Assert.isFalse(value);
```

### Null / Not Null

```
Assert.isNull(value);
Assert.isNotNull(value);
```

### Equals / Not Equals

```
Assert.equals(expectedValue, actualValue);
Assert.notEquals(expectedValue, actualValue);
```

### Undefined / Not Undefined

```
Assert.isUndefined(value);
Assert.isNotUndefined(value);
```

### Array Equals / Array Not Equals

These methods compare the contents of two arrays using a simple equality test (e.g. ```==```) for each value within the array. Note that this does not compare if the two arrays or the array contents are comprised of the same objects (e.g. ```===```).

```
Assert.arrayEquals(expectedArray, actualArray);
Assert.arrayNotEquals(expectedArray, actualArray);
```

### Same / Not Same

These methods compare if two objects are identical (e.g. ```===```).

```
Assert.same(expectedValue, actualValue);
Assert.notSame(expectedValue, actualValue);
```

### Object Type

You can check if an object is of a specific type using this method.

```
Assert.isType(object, classType);
```

For example:

```
var myObject:String = "Hello, world";
Assert.isType(myObject, "String");
```

### Throws Error

You can verify that a function will throw an exception using the ```throwsError``` method. This method will catch the exception and verify the error type.

```
Assert.throwsError(function, errorType);
```

For example:

```
Assert.throwsError(function():void
{
	throw new Error("My Error");
	
}, Error);
```

You can also ignore the exception type and only verify that any exception was thrown:

```
Assert.throwsError(function():void
{
	throw new Error("My Error");
});
```

### Fail

You can force a test to fail by calling ```fail``` method:

```
Assert.fail(message);
```
