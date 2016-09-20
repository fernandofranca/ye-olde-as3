package com.withlasers.patterns
{
	import com.withlasers.patterns.IIterator;
	
	/**
	 * ...
	 * @author Fernando de França
	 */
	public class ArrayIterator implements IIterator
	{
		protected var __elements:Array
		protected var __pointer:int = -1
		
		public function ArrayIterator($array:Array) 
		{
			__elements = $array;
		}
		
		/* INTERFACE com.withlasers.patterns.IIterator */
		
		public function get elements():Array
		{
			return __elements
		}
		
		public function get length():int
		{
			return __elements.length
		}
		
		public function get pointer():int
		{
			return __pointer
		}
		
		public function set pointer($p:int):void
		{
			__pointer = $p
		}
		
		public function hasNext():Boolean
		{
			return __pointer+1<length
		}
		
		public function hasPrevious():Boolean
		{
			return pointer>1
		}
		
		public function next():*
		{
			if (hasNext()) 
			{
				pointer++
			} else 
			{
				pointer = 0;
			}
			
			return currentElement
		}
		
		public function previous():*
		{
			if (hasPrevious()) 
			{
				pointer--
			} else 
			{
				pointer = elements.length - 1;
			}
			
			return currentElement
		}
		
		public function get currentElement():* 
		{
			return elements[pointer]
		}
		
	}

}