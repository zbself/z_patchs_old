package com.zb.as3.zlib.patchs.util.sixuu.events
{
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class SProgressEvent extends Event
	{
		static public const PROGRESS:String = "progress";
		static public const FILE_DOWN_PROGRESS:String="fileDownProgress"
		public var bytesLoaded:Number;
		public var bytesTotal:Number;
		public var file
		public function SProgressEvent(type:String)
		{
			super(type);

		}
		

	}

}