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

package breezetest
{
	import breezetest.errors.AssertionError;
	import flash.utils.getQualifiedClassName;

	public class Assert
	{

		public static function isTrue(condition:Boolean, message:String = null):void
		{
			if(!condition)
			{
				fail('Expected TRUE but was <FALSE>', message);
			}
		}


		public static function isFalse(condition:Boolean, message:String = null):void
		{
			if(condition)
			{
				fail('Expected FALSE but was <TRUE>', message);
			}
		}


		public static function isNull(condition:*, message:String = null):void
		{
			if(condition != null)
			{
				fail('Expected NULL but was <' + condition + '>', message);
			}
		}


		public static function isNotNull(condition:*, message:String = null):void
		{
			if(condition == null)
			{
				fail('Expected NOT NULL but was <' + condition + '>', message);
			}
		}


		public static function equals(expected:*, actual:*, message:String = null):void
		{
			if(expected == null && actual == null)
			{
				return;
			}

			if(expected != actual)
			{
				fail('Value <' + actual + '> was not equal to the expected value <' + expected + '> ', message);
			}
		}


		public static function notEquals(expected:*, actual:*, message:String = null):void
		{
			if(expected == actual || (expected == null && actual == null))
			{
				fail('Value <' + actual + '> was equal to the value <' + expected + '>', message);
			}
		}


		public static function isUndefined(condition:*, message:String = null):void
		{
			if(condition != undefined)
			{
				fail('Expected UNDEFINED but was <' + condition + '>', message);
			}
		}


		public static function isNotUndefined(condition:*, message:String = null):void
		{
			if(condition == undefined)
			{
				fail('Expected NOT UNDEFINED but was <' + condition + '>', message);
			}
		}


		public static function arrayEquals(expected:Array, actual:Array, message:String = null):void
		{
			if(!isArrayEqual(expected, actual))
			{
				fail('Array <' + JSON.stringify(actual) + '> was not equal to expected array value <' + JSON.stringify(expected) + '>', message);
			}
		}


		public static function arrayNotEquals(expected:Array, actual:Array, message:String = null):void
		{
			if(isArrayEqual(expected, actual))
			{
				fail('Array <' + JSON.stringify(actual) + '> was equal to the value <' + JSON.stringify(expected) + '>', message);
			}
		}


		private static function isArrayEqual(array1:Array, array2:Array):Boolean
		{
			if(array1 == null && array2 == null)
			{
				return true;
			}

			if(array1.length != array2.length)
			{
				return false;
			}

			for(var key:String in array1)
			{
				if(!(key in array2) || array1[key] != array2[key])
				{
					return false;
				}
			}

			return true;
		}


		public static function same(expected:*, actual:*, message:String = null):void
		{
			if(expected !== actual)
			{
				fail('Expected <' + expected + '> to be the same as <' + actual + '>', message);
			}
		}


		public static function notSame(expected:*, actual:*, message:String = null):void
		{
			if(expected === actual)
			{
				fail('Expected <' + expected + '> to not be the same as <' + actual + '>', message);
			}
		}


		public static function isType(object:*, classType:Class):void
		{
			if(!(object is classType))
			{
				fail('Class type <' + getQualifiedClassName(classType) + '> was not equal to the expected class type <' + getQualifiedClassName(object) + '>');
			}
		}


		public static function throwsError(method:Function, errorType:Class = null, message:String = null):Error
		{
			try
			{
				method.call();
			}
			catch(e:Error)
			{
				if(errorType != null && !(e is errorType))
				{
					fail('Expected error to be type <' + getQualifiedClassName(errorType) + '> but was <' + getQualifiedClassName(e) + '>', message);
				}

				return e;
			}

			fail('Expected error was not thrown', message);

			return null;
		}


		public static function fail(message:String, customMessage:String = null):void
		{
			if(customMessage != null)
			{
				message = customMessage + ": " + message;
			}

			throw new AssertionError(message);
		}


	}
}
