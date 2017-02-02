/*
 * MIT License
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

package tests
{
	import breezetest.*;
	import breezetest.errors.AssertionError;
	import flash.events.ErrorEvent;

	public class TestAssert
	{
		public function testAssertIsTrue():void
		{
			Assert.isTrue(true);

			// Error
			Assert.throwsError(function():void
			{
				Assert.isTrue(false);

			}, AssertionError);
		}


		public function testAssertIsFalse():void
		{
			Assert.isFalse(false);

			// Error
			Assert.throwsError(function():void
			{
				Assert.isFalse(true);

			}, AssertionError);
		}


		public function testAssertIsNull():void
		{
			Assert.isNull(null);

			// Error
			Assert.throwsError(function():void
			{
				Assert.isNull("test");

			}, AssertionError);
		}


		public function testAssertIsNotNull():void
		{
			Assert.isNotNull("test");

			// Error
			Assert.throwsError(function():void
			{
				Assert.isNotNull(null);

			}, AssertionError);
		}


		public function testAssertEquals():void
		{
			Assert.equals("Hello", "Hello");
			Assert.equals(123, 123);
			Assert.equals(null, null);
			Assert.equals(true, true);

			// Errors
			Assert.throwsError(function():void
			{
				Assert.equals("Hello", "World");
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.equals(123, 456);
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.equals("Hello", null);
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.equals(true, false);
			}, AssertionError);
		}


		public function testAssertNotEquals():void
		{
			Assert.notEquals("Hello", "World");
			Assert.notEquals(123, 456);
			Assert.notEquals("Hello", null);
			Assert.notEquals(true, false);

			// Errors
			Assert.throwsError(function():void
			{
				Assert.notEquals("Hello", "Hello")
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.notEquals(123, 123);
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.notEquals(null, null);
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.notEquals(true, true);
			}, AssertionError);
		}


		public function testIsUndefined():void
		{
			var tmpVar:Object = undefined;
			Assert.isUndefined(tmpVar);

			// Error
			Assert.throwsError(function():void
			{
				Assert.isUndefined({});
			}, AssertionError);
		}


		public function testIsNotUndefined():void
		{
			Assert.isNotUndefined({});

			// Error
			Assert.throwsError(function():void
			{
				var tmpVar:Object = undefined;
				Assert.isNotUndefined(tmpVar);
			}, AssertionError);
		}


		public function testArrayEquals():void
		{
			var tmpObj:Object = {};

			Assert.arrayEquals([1, "hello", true, tmpObj, null], [1, "hello", true, tmpObj, null]);

			// Errors
			Assert.throwsError(function():void
			{
				Assert.arrayEquals([1, 2], [1]);
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.arrayEquals([tmpObj], [{}]);
			}, AssertionError);
		}


		public function testArrayNotEquals():void
		{
			var tmpObj:Object = {};

			Assert.arrayNotEquals([1], []);
			Assert.arrayNotEquals([1, "hello"], [1, "world"]);
			Assert.arrayNotEquals([tmpObj], [{}]);

			// Errors
			Assert.throwsError(function():void
			{
				Assert.arrayNotEquals([1, 2, 3], [1, 2, 3]);
			}, AssertionError);
		}


		public function testSame():void
		{
			var tmpObj:Object = {};
			Assert.same(tmpObj, tmpObj);

			Assert.throwsError(function():void
			{
				Assert.same(tmpObj, {});
			}, AssertionError);
		}


		public function testNotSame():void
		{
			var tmpObj:Object = {};
			Assert.notSame(tmpObj, {});

			Assert.throwsError(function():void
			{
				Assert.notSame(tmpObj, tmpObj);
			}, AssertionError);
		}


		public function testIsType():void
		{
			Assert.isType({}, Object);
			Assert.isType(15, int);
			Assert.isType("Hello", String);
			Assert.isType("Hello", Object);

			Assert.throwsError(function():void
			{
				Assert.isType("Hello", int);
			}, AssertionError);
		}


		public function testThrowsError():void
		{
			Assert.throwsError(function():void
			{
				throw new Error('This is an error');
			});

			Assert.throwsError(function():void
			{
				throw new ArgumentError(ErrorEvent.ERROR);
			}, ArgumentError);

			// ------------------
			// Error should be returned after assertion
			// ------------------
			var error:Error = new Error();

			var error2:Error = Assert.throwsError(function():void
			{
				throw error;
			});

			Assert.same(error, error2);

			// ------------------
			// Errors
			// ------------------
			Assert.throwsError(function():void
			{
				Assert.throwsError(function():void
				{
					// No error here
				});
			}, AssertionError);

			Assert.throwsError(function():void
			{
				Assert.throwsError(function():void
				{
					// Wrong error type
					throw Error('');

				}, ArgumentError);

			}, AssertionError);
		}


		public function testFail():void
		{
			var error:Error = Assert.throwsError(function():void
			{
				Assert.fail("Test");

			}, AssertionError);

			Assert.equals(error.message, "Test");


			error = Assert.throwsError(function():void
			{
				Assert.fail("Test", "Message");

			}, AssertionError);

			Assert.equals(error.message, "Message: Test");
		}

	}
}
