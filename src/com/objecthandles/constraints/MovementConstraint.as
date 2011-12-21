/**
 *  Latest information on this project can be found at http://www.rogue-development.com/objectHandles.html
 * 
 *  Copyright (c) 2009 Marc Hughes 
 * 
 *  Permission is hereby granted, free of charge, to any person obtaining a 
 *  copy of this software and associated documentation files (the "Software"), 
 *  to deal in the Software without restriction, including without limitation 
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 *  and/or sell copies of the Software, and to permit persons to whom the Software 
 *  is furnished to do so, subject to the following conditions:
 * 
 *  The above copyright notice and this permission notice shall be included in all 
 *  copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 *  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 * 
 *  See README for more information.
 * 
 **/
 
package com.objecthandles.constraints
{
	import com.objecthandles.DragGeometry;
	import com.objecthandles.HandleRoles;
	import com.objecthandles.IConstraint;
	
	/**
	 * This is a constraint that makes an object stay within a certain bounds.
	 * 
	 * This isn't really done yet.  It doesn't handle rotated objects well
	 **/
	public class MovementConstraint implements IConstraint
	{
		public var minX:Number;
		public var minY:Number;
		public var maxX:Number;
		public var maxY:Number;
		
		private function cos(angle:Number):Number {
			return Math.cos((angle/180)*Math.PI);
		}
		
		private function sin(angle:Number):Number {
			return Math.sin((angle/180)*Math.PI);
		}
		
		private function acos(angle:Number):Number {
			return Math.acos((angle/180)*Math.PI);
		}
		
		public function applyConstraint( original:DragGeometry, translation:DragGeometry, resizeHandleRole:uint ) : void
		{
			var delta:Number;
			var angle:Number = translation.rotation + original.rotation;
			if(!isNaN(maxX))
			{
				angle = translation.rotation + original.rotation;
				if (angle < -90)
					delta = (original.height + translation.height)*cos(270 - angle);
				else if (angle < 0)
					delta = (original.height + translation.height)*cos(270 - angle) + (original.width + translation.width)*cos(angle);
				else if (angle < 90)
					delta = (original.width + translation.width)*cos(angle);
				else if (angle < 180)
					delta = 0;
				if((original.x + translation.x + delta) > maxX)
				{
					if(HandleRoles.isMove(resizeHandleRole))
					{
						translation.x = maxX - (original.x + delta);
					}
					else if(HandleRoles.isResizeRight(resizeHandleRole))
					{
						translation.width = (maxX - original.x - translation.x - (original.width)*cos(angle))/cos(angle);
					} else if (HandleRoles.isRotate(resizeHandleRole)) {
						//trace("rotate role");
					}
				}
			}
			
			if(!isNaN(maxY))
			{
				angle = translation.rotation + original.rotation;
				
				if (angle < -90)
					delta = 0;
				else if (angle < 0)
					delta = (original.height + translation.height)*sin(90 - angle);
				else if (angle < 90)
					delta = (original.width + translation.width)*sin(angle) + (original.height + translation.height)*sin(90 - angle);
				else if (angle < 180)
					delta = (original.width + translation.width)*sin(angle);
				if((original.y + translation.y + delta) > maxY)
				{
					if(HandleRoles.isMove(resizeHandleRole))
					{
						translation.y = maxY - (original.y + delta);
					}
					else if(HandleRoles.isResizeDown(resizeHandleRole))
					{
						translation.height = maxY - (original.y + translation.y +
							original.height);
						
					} else if (HandleRoles.isRotate(resizeHandleRole)) {
						//trace("rotate role");
					}
				}
			}
			
			if(!isNaN(minX))
			{
				angle = translation.rotation + original.rotation;
				if (angle < -90) 
					delta = (original.width + translation.width)*sin(270 - angle);
				else if (angle < 0)
					delta = 0;
				else if (angle < 90) 
					delta = sin(angle)*(original.height + translation.height);
				else if (angle < 180)
					delta = (original.width + translation.width)*sin(270 - angle) + (original.height + translation.height)*sin(angle);
				
				
				if((original.x + translation.x - delta) < minX)
				{
					translation.x = minX - original.x + delta;
				}
				if(HandleRoles.isResizeLeft(resizeHandleRole) && original.x -
					translation.width < minX)
				{
					translation.width = (original.x - minX)*sin(original.rotation);
				} else if (HandleRoles.isRotate(resizeHandleRole)) {
					//trace("rotate role");
				}
			}
			
			if(!isNaN(minY))
			{
				angle = translation.rotation + original.rotation;	
				if (angle < -90)
					delta = sin(angle + 180)*(original.width + translation.width) + sin(angle + 270)*(original.height + translation.height);
				else if (angle < 0)
					delta = sin(angle + 180)*(original.width + translation.width);
				else if (angle < 90)
					delta = 0;
				else if (angle < 180)
					delta = sin(angle - 90)*(original.height + translation.height);
				if((original.y + translation.y - delta) < minY)
				{
					translation.y = minY - original.y + delta;
				}
				if(HandleRoles.isResizeUp(resizeHandleRole) && original.y -
					translation.height < minY)
				{
					translation.height = - minY + original.y;
				}  else if (HandleRoles.isRotate(resizeHandleRole)) {
					//trace("rotate role");
				}
				
			}
		}

	}
}