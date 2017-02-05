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

package breezetest.utils.classinfo
{
	import flash.utils.describeType;

	public class ClassInfo
	{
		private var _methods:Array = [];
		private var _currentAsyncVariable:String = null;

		public function ClassInfo(object:*)
		{
			var xml:XML = describeType(object);

			for each(var variable:XML in xml.elements("variable"))
			{
				if(variable.@type == "breezetest.async::Async")
				{
					_currentAsyncVariable = variable.@name;
					break;
				}
			}

			for each(var item:XML in xml.elements("method"))
			{
				var method:MethodInfo = new MethodInfo();
				method.name = item.@name;
				method.returnType = item.@returnType;

				for each(var subItem:XML in item.elements("parameter"))
				{
					var param:ParameterInfo = new ParameterInfo();
					param.type = subItem.@type;
					param.optional = subItem.@optional == "true";

					method.parameters.push(param);
				}

				_methods.push(method);
			}
		}


		public function getMethod(name:String):MethodInfo
		{
			for each(var method:MethodInfo in _methods)
			{
				if(method.name == name)
				{
					return method;
				}
			}

			return null;
		}


		public function hasMethod(name:String):Boolean
		{
			return getMethod(name) != null;
		}


		public function get methods():Array
		{
			return _methods;
		}


		public function get currentAsyncVariable():String
		{
			return _currentAsyncVariable;
		}
	}
}
