# z_patchs
<br>
<code>
var patchs:Patchs = new Patchs();<br>
patchs.addEventListener(zPathProgressEvent.PROGRESS,onProgressHandler);<br>
patchs.addEventListener(zPathEvent.PATCH_COMPLETE,patchCompleteHandler);<br>
patchs.downloadBreakPoint("http://ldc.layabox.com/download/LayaAirAS3_1.7.6_beta.zip",100000,"","0.11",false,null,true,File.applicationDirectory,false);<br>
function onProgressHandler(event:zPathProgressEvent):void<br>
{<br>
>>trace(event.bytesLoaded+" / "+event.bytesTotal );<br>
}<br>
function patchCompleteHandler(event:zPathEvent):void<br>
{<br>
>>trace(zZIP(event.eventData).stamp+" 更新完毕");<br>
}<br>
</code>
