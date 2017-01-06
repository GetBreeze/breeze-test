package tests.testutils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	public class SampleEventDispatcher extends EventDispatcher
	{
		public function SampleEventDispatcher(event:Event, timeout:int)
		{
			setTimeout(function():void
			{
				dispatchEvent(event);
			}, timeout);
		}
	}
}
