package com.zb.as3.zlib.patchs.core
{
	import flash.events.Event;
	
	public class zPathEvent extends Event
	{
		/**		补丁下载开始	*/
		public static const PATCH_DOWNLOAD:String = "patch_download";
		/**		补丁下载完毕	*/
		public static const PATCH_DOWNLOAD_COMPLETE:String = "patch_download_complete";
		/**		补丁包(zip)删除完毕	*/
		public static const PATCH_DELETE_COMPLETE:String = "patch_delete_complete";
		/**		补丁包(zip)删除完毕	*/
		public static const PATCH_UNCOMPRESS_COMPLETE:String = "patch_uncompress_complete";
		/**		补丁包(zip)删除完毕	*/
		public static const PATCH_ERROR:String = "patch_error";
		/**		补丁替换文件 存在系统占用	*/
		public static const PATCH_FILE_USED:String = "patch_file_used";
		/**		打补丁完毕(即:解压完毕)	*/
		public static const PATCH_COMPLETE:String = "patch_complete";
		
		public var eventData:*;
		public function zPathEvent(type:String,data:*=null)
		{
			eventData = data;
			super(type);
		}
	}
}