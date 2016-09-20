/**
 * Created with IntelliJ IDEA.
 * User: fernandodefranca
 * Date: 27/4/14
 * Time: 5:54 PM
 * To change this template use File | Settings | File Templates.
 */
package com.withlasers.file
{
import flash.filesystem.File;
import flash.utils.clearInterval;
import flash.utils.setInterval;

import org.osflash.signals.Signal;

public class SimpleFileMonitor
{
	private var fileModDate:Number;

	private var file:File;

	private var interval:uint;

	public var fileChangedSignal:Signal = new Signal();

	public function SimpleFileMonitor(filePath:String, interval:Number = 1000)
	{
		file = SimpleFile.getFile(filePath);

		if (file.exists==false)
		{
			throw new Error("File doesnt exists. File:"+filePath);
		} else
		{
			fileModDate = file.modificationDate.getTime();
		}
	}

	public function start():void
	{
		if (file.exists)
		{
			interval = setInterval(loopCheck, interval);
		}
	}

	public function stop():void
	{
		if (interval) clearInterval(interval);
	}

	private function loopCheck():void
	{
		if(file.modificationDate.getTime() != fileModDate)
		{
			fileModDate = file.modificationDate.getTime();
			fileChangedSignal.dispatch();
		}
	}
}
}
