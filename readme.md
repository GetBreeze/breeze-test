# Breeze Test [![Build Status](https://travis-ci.org/GetBreeze/breeze-test.svg?branch=master)](https://travis-ci.org/GetBreeze/breeze-test)

Breeze Test is a library for unit testing Adobe AIR applications. It is designed to be simple and intuitive while providing support for asynchronous testing.

## Getting Started

You can download the latest SWC file from the [releases section](https://github.com/GetBreeze/breeze-test/releases) of this repo.

Alternatively you can compile the SWC yourself using the included ANT script in the ```build``` directory.

The repo includes automated tests in the ```test``` directory that allow BreezeTest to test itself.

## Test Suites

Testing requires one or more test suites. A test suite is a generic class containing methods that run tests. Test methods must be public methods that begin with the word ```test``` and generally should have descriptive names. Any uncaught exception that occurs within test methods will cause that test to fail.

```as3
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

```as3
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

If you need to run an asynchronous operation in the `setup` / `tearDown` methods, add a parameter with type `Async`. Once the asynchronous operation finishes, call the `complete` method of the `Async` object.

Furthermore, you can define a public member variable of type `Async` which will automatically reference the current `Async` object (i.e. the one passed to the asynchronous method via parameter). This allows you to complete the asynchronous operation outside of the `setup` / `tearDown` methods without having to manually store the reference to the `Async` object.

```as3
public class TestUsers
{
	// Automatically set by Breeze Test during each async method call
	public var currentAsync:Async;

	public function setupClass(async:Async):void
	{
		// Asynchronous class setup
		// ...

		setTimeout(asyncClassSetupComplete, 100);
	}

	private function asyncClassSetupComplete():void
	{
		// Calling 'complete' method of the public variable will finish the class setup
		currentAsync.complete();
	}
	
	public function tearDownClass(async:Async):void
	{
		// Asynchronous class tear down
		// ...

		async.complete();
	}
	
	public function setup(async:Async):void
	{
		// Asynchronous test setup
		// ...

		async.complete();
	}
	
	public function tearDown(async:Async):void
	{
		// Asynchronous test tear down
		// ...

		async.complete();
	}
}
```

## Running Tests

You can run a single or multiple test suites using the ```BreezeTest``` class. Add test suites using the ```add``` method and begin running tests using the ```run``` method. You should also listen for the event ```BreezeTestEvent.TESTS_COMPLETE``` so you know when the tests are done.

Note you must provide a reference to your root `DisplayObject` (i.e. instance of your document class) when creating `BreezeTest` object. This is required so that Breeze Test is able to catch any uncaught errors occurring in asynchronous functions.

```as3
// 'this' refers to the root DisplayObject
var breezeTest:BreezeTest = new BreezeTest(this);
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

```as3
var breezeTest:BreezeTest = new BreezeTest();
breezeTest.output = new MyCustomOutputClass();
```

The ```run``` method will run each test suite and trace out the results. After all test suites have been run, the output will print either ```TESTS FAILED``` or ```TESTS PASSED```.

When running tests with a build script you should exit the application with a non-zero output if a test fails.

```as3
private function onTestsComplete(event:BreezeTestEvent):void
{
	NativeApplication.nativeApplication.exit(_breezeTest.success ? 0 : 1);
}
```

## Asynchronous Tests

A powerful feature of BreezeTest is the ability to test asynchronous methods using callback functions or event listeners.

Signal that a test method is asynchronous by adding a parameter with type ```Async```. You must call the ```complete``` method when the test is complete.

```as3
function testAsync(async:Async):void
{
	async.complete();
}
```

### Test Timeout

You can limit the amount of time an asynchronous method can run by setting the ```timeout``` property. If the ```complete``` method is not called within the specified time then the test will fail.

```as3
// Allow the test to run for 2000 milliseconds
async.timeout = 2000;
```

### Testing Event Listeners

When testing event listeners, you will usually create event handlers outside of your test methods where you no longer have a reference to the `Async` object. You can however define a public member variable of type `Async` which will automatically reference the current `Async` object (i.e. the one passed to the test method via parameter). This allows you to complete the asynchronous test outside of the test method without having to manually store the reference to the `Async` object.

```as3
// Automatically set by Breeze Test during each async method call
public var currentAsync:Async;

private function handleEvent(event:Event):void
{
	Assert.isNotNull(event);

	// Calling 'complete' method of the public variable will finish the test
	currentAsync.complete();
}

public function testEventListener(async:Async):void
{
	var obj:MyTestObject = new MyTestObject();
	obj.addEventListener(Event.COMPLETE, handleEvent);
}
```


## Assertions

Test methods can utilize the ```Assert``` class to verify values conform to expected values. A failed assert call will throw an exception and cause the test to fail.

```as3
public function testAssertIsTrue():void
{
	var myVariable:Boolean = true;
	Assert.isTrue(myVariable);
}
```

Each assert can also provide an optional message to give more context to the assertion.

```as3
Assert.isTrue(myVariable, "The myVariable variable should be true");
```

### True / False

```as3
Assert.isTrue(value);
Assert.isFalse(value);
```

### Null / Not Null

```as3
Assert.isNull(value);
Assert.isNotNull(value);
```

### Equals / Not Equals

```as3
Assert.equals(expectedValue, actualValue);
Assert.notEquals(expectedValue, actualValue);
```

### Undefined / Not Undefined

```as3
Assert.isUndefined(value);
Assert.isNotUndefined(value);
```

### Array Equals / Array Not Equals

These methods compare the contents of two arrays using a simple equality test (e.g. ```==```) for each value within the array. Note that this does not compare if the two arrays or the array contents are comprised of the same objects (e.g. ```===```).

```as3
Assert.arrayEquals(expectedArray, actualArray);
Assert.arrayNotEquals(expectedArray, actualArray);
```

### Same / Not Same

These methods compare if two objects are identical (e.g. ```===```).

```as3
Assert.same(expectedValue, actualValue);
Assert.notSame(expectedValue, actualValue);
```

### Object Type

You can check if an object is of a specific type using this method.

```as3
Assert.isType(object, classType);
```

For example:

```as3
var myObject:String = "Hello, world";
Assert.isType(myObject, "String");
```

### Throws Error

You can verify that a function will throw an exception using the ```throwsError``` method. This method will catch the exception and verify the error type.

```as3
Assert.throwsError(function, errorType);
```

For example:

```as3
Assert.throwsError(function():void
{
	throw new Error("My Error");
	
}, Error);
```

You can also ignore the exception type and only verify that any exception was thrown:

```as3
Assert.throwsError(function():void
{
	throw new Error("My Error");
});
```

### Fail

You can force a test to fail by calling ```fail``` method:

```as3
Assert.fail(message);
```
