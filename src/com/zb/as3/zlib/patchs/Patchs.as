package com.zb.as3.zlib.patchs
{
	import com.zb.as3.zlib.patchs.core.zPathEvent;
	import com.zb.as3.zlib.patchs.core.zPathProgressEvent;
	import com.zb.as3.zlib.patchs.util.sixuu.DownloadFile;
	import com.zb.as3.zlib.patchs.util.sixuu.events.SErrorEvent;
	import com.zb.as3.zlib.patchs.util.sixuu.events.SEvent;
	import com.zb.as3.zlib.patchs.util.sixuu.events.SProgressEvent;
	import com.zb.as3.zlib.zip.core.zZipEvent;
	import com.zb.as3.zlib.zip.core.zZipProgressEvent;
	import com.zb.as3.zlib.zip.zZIP;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.text.AutoCapitalize;	
	
	[Event(name = "progress",type = "com.zb.as3.zlib.patchs.core.zPathProgressEvent")]
	[Event(name = "patch_download",type = "com.zb.as3.zlib.patchs.core.zPathEvent")]
	[Event(name = "patch_download_complete",type = "com.zb.as3.zlib.patchs.core.zPathEvent")]
	[Event(name = "patch_delete_complete",type = "com.zb.as3.zlib.patchs.core.zPathEvent")]
	[Event(name = "patch_uncompress_complete",type = "com.zb.as3.zlib.patchs.core.zPathEvent")]
	[Event(name = "patch_error",type = "com.zb.as3.zlib.patchs.core.zPathEvent")]
	[Event(name = "patch_file_used",type = "com.zb.as3.zlib.patchs.core.zPathEvent")]
	[Event(name = "patch_complete",type = "com.zb.as3.zlib.patchs.core.zPathEvent")]
	/**
	 * 更新包 补丁类
	 */
	public class Patchs extends EventDispatcher
	{
		/**		更新包名称	**/
		public var _patchsName:String;
		
		/**		文件解压目录	**/
		private var _uncompressFileName:String;
		
		public var _block:int;
		/**		下载完毕,自动解压缩 */
		public var _autoUncompress:Boolean = true;
		/**		解压缩完毕,自动删除 */
		public var _autoDelete:Boolean = true;
		
		public function Patchs()
		{
		}
		/**
		 * 断点下载
		 * @param url 压缩包地址;
		 * @param block 断点块 大小(单位:B(字节)) 默认:10000(10KB);
		 * @param stamp 补丁标记(例:模块一期) 补丁更新完毕,会返回stamp;<br>默认:空(更新包名称[zipName])
		 * @param zipName 下载保存的文件名( 不需要[.zip]后缀);
		 * @param cover 覆盖式下载( 若本地存在: true删除>进行下载.  false:不下载,直接使用);
		 * @param downFilePath 文件夹:下载文件的保存位置.(例:F:/download); <br>默认null(保存在 应用程序目录/patchs);
		 * @param autoUncompress 下载完毕是否自动解压缩;
		 * @param uncompressFilePath 文件夹 解压地址(默认:空 (保存文件的目录));
		 * @param autoDelete 解压缩完毕是否自动删除.zip文件;
		 */
		public function downloadBreakPoint(url:String,block:int=10000,stamp:String="",zipName:String="patchs",cover:Boolean=false,downFilePath:File=null,autoUncompress:Boolean=true,uncompressFilePath:File=null,autoDelete:Boolean=true):void
		{
			if( !stamp ) stamp = zipName;
			_autoUncompress = autoUncompress;
			_autoDelete = autoDelete;
			_block = block;
			zipName = zipName+".zip";
			
			var downloadFile:DownloadFile = creatDownload(
				{	"file":File( downFilePath?downFilePath:DownloadFile.applicationDirectory.resolvePath("patchs") ).resolvePath(zipName).nativePath,
					"autoUncompress":autoUncompress,
					"autoDelete":autoDelete,
					"stamp":stamp
				});
			downloadFile.downloadFileByStream(url,_block,cover);
		}
		protected function fileExistsHandler(event:SErrorEvent):void
		{
			trace("file has been downloaded : "+ event.file.nativePath);
			if(_autoUncompress){
				uncompress( DownloadFile( event.file ) );
			}
			dispatchEvent(event);
		}
		/**
		 * 下载更新包 
		 * @param url 需要下载的zip文件的地址;
		 * @param stamp 补丁标记(例:模块一期) 补丁更新完毕,会返回stamp;<br>默认:空(更新包名称[zipName])
		 * @param zipName 下载保存的文件名;
		 * @param cover 覆盖式下载( 若本地存在: true删除>进行下载.  false:不下载,直接使用);
		 * @param downFilePath 文件夹:下载文件的保存位置.(例:F:/download); <br>默认null(保存在 应用程序目录/patchs);
		 * @param autoUncompress 下载完毕是否自动解压缩;
		 * @param uncompressFilePath 文件夹 解压地址(默认:空 (保存文件的目录));
		 * @param autoDelete 解压缩完毕是否自动删除.zip文件;
		 */
		public function download(url:String,stamp:String="",zipName:String="patchs",cover:Boolean=false,downFilePath:File = null,autoUncompress:Boolean=true,uncompressFilePath:File=null,autoDelete:Boolean=true):void
		{
			if( !stamp ) stamp = zipName;
			zipName = zipName+".zip";
			
			var downloadFile:DownloadFile = creatDownload(
				{	"file":File( downFilePath?downFilePath:DownloadFile.applicationDirectory.resolvePath("patchs") ).resolvePath(zipName).nativePath,
					"autoUncompress":autoUncompress,
					"autoDelete":autoDelete,
					"stamp":stamp
				});
			downloadFile.downloadFile(url,cover);
		}
		/** 创建DownloadFile模式 */
		private function creatDownload(o:Object):DownloadFile
		{
			var downloadFile:DownloadFile = new DownloadFile(o["file"]);
			downloadFile.autoUncompress = o["autoUncompress"];
			downloadFile.autoDelete = o["autoDelete"];
			downloadFile.stamp = o["stamp"];//标记
			downloadFile.addEventListener(SErrorEvent.ERROR,onError);
			downloadFile.addEventListener(SProgressEvent.FILE_DOWN_PROGRESS,onProgress);
			downloadFile.addEventListener("exists",fileExistsHandler);
			downloadFile.addEventListener(SEvent.FILE_DOWN_COMPLETE,onComplete);
			return downloadFile;
		}
		public function onError(e:SErrorEvent):void
		{
			dispatchEvent( new zPathEvent( zPathEvent.PATCH_ERROR,e.file ) );
		}
		public function onProgress(e:SProgressEvent):void
		{
			dispatchEvent( new zPathProgressEvent( zPathProgressEvent.PROGRESS,e.bytesLoaded,e.bytesTotal));
		}
		public function onComplete(e:SEvent):void
		{
			var $target:DownloadFile = DownloadFile( e.target );
			if($target.autoUncompress)
			{
				uncompress( $target );
			}
			dispatchEvent( new zPathEvent( zPathEvent.PATCH_DOWNLOAD_COMPLETE,$target));
		}
		/**
		 *解压zip到本机 
		 * 默认目录为应用程序根目录下 data文件夹
		 */		
		public function uncompress(zipFile:DownloadFile):void
		{
			if( !zipFile ) return;
			var zip:zZIP = new zZIP();
			zip.addEventListener(zZipEvent.UNCOMPRESS_ERROR,uncompressErrorHandler);
			zip.addEventListener(zZipEvent.UNCOMPRESS_FILE_USED,uncompressFileUsedHandler);
			zip.addEventListener(zZipEvent.UNCOMPRESS_COMPLETE,uncompressHandler);
			zip.addEventListener(zZipEvent.UNCOMPRESS_PASSWORD_NOT_MATCH,uncompressPasswordNotMatchHandler);
			zip.addEventListener(zZipEvent.DELETE_COMPLETE,deleteCompleteHandler);
			zip.autoDelete = zipFile.autoDelete;
			zip.stamp = zipFile.stamp;//标记
			zip.uncompress( zipFile ,zipFile.uncompressFilePath?File(zipFile.uncompressFilePath).nativePath : "",false);
		}

		protected function deleteCompleteHandler(event:zZipEvent):void
		{
			trace("delete complete");
			this.dispatchEvent( new zPathEvent( zPathEvent.PATCH_DELETE_COMPLETE,zZIP(event.target)) );
		}
		protected function uncompressPasswordNotMatchHandler(event:zZipEvent):void
		{
			trace("uncompress password not match");
			dispatchEvent( new zPathEvent( zPathEvent.PATCH_ERROR,event.eventData ) );
		}
		protected function uncompressErrorHandler(event:zZipEvent):void
		{
			trace("uncompress error : "+event.eventData);
			dispatchEvent( new zPathEvent( zPathEvent.PATCH_ERROR,event.eventData ) );
		}
		protected function uncompressFileUsedHandler(event:zZipEvent):void
		{
			trace("uncompress file used : "+event.eventData);
			dispatchEvent( new zPathEvent( zPathEvent.PATCH_ERROR,event.eventData ) );
		}
		protected function uncompressHandler(event:zZipEvent):void
		{
			trace("uncompress complete : "+event.target);
			var $target:zZIP = zZIP(event.target);
			if($target.autoDelete)
			{
				delZip( $target );
			}
			dispatchEvent( new zPathEvent( zPathEvent.PATCH_COMPLETE,$target ) );
		}
		/**
		 * 删除补丁包
		 * @param zipFile [zZip类型] <br>通过zPathEvent.PATCH_COMPLETE 获取
		 * 
		 */		
		public function delZip(zipFile:zZIP):void
		{
			zZIP( zipFile ).delZip();
		}
	}
}