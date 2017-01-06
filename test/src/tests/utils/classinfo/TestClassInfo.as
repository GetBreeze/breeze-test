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
