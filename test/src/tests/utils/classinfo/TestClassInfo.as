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

package tests.utils.classinfo
{
	import breezetest.utils.classinfo.*;
	import breezetest.Assert;
	import breezetest.errors.AssertionError;

	import tests.testutils.SampleClass;

	public class TestClassInfo
	{
		private var classinfo:ClassInfo;

		public function setupClass():void
		{
			classinfo = new ClassInfo(new SampleClass());
		}


		public function testGetMethod():void
		{
			Assert.isNotNull(classinfo);

			var method:MethodInfo = classinfo.getMethod("method1");
			Assert.isNotNull(method);
			Assert.equals(method.name, "method1");
			Assert.arrayEquals(method.parameters, []);
			Assert.equals(method.returnType, "void");

			method = classinfo.getMethod("method2");
			Assert.isNotNull(method);
			Assert.equals(method.name, "method2");
			Assert.equals(method.parameters.length, 2);
			Assert.equals(method.returnType, "int");

			var param:ParameterInfo = method.parameters[0];
			Assert.equals(param.type, "int");
			Assert.isFalse(param.optional);

			param = method.parameters[1];
			Assert.equals(param.type, "String");
			Assert.isTrue(param.optional);
		}


		public function testHasMethod():void
		{
			Assert.isNotNull(classinfo);
			Assert.isTrue(classinfo.hasMethod("method1"));

			Assert.throwsError(function():void
			{
				Assert.isTrue(classinfo.hasMethod("method3"));
			}, AssertionError);

		}

	}
}
