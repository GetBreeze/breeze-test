package breezetest.utils.classinfo
{
	import flash.utils.describeType;

	public class ClassInfo
	{
		private var _methods:Array = [];

		public function ClassInfo(object:*)
		{
			var xml:XML = describeType(object);

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
	}
}
