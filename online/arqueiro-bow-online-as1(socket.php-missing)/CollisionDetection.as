﻿/**
* CollisionDetection by Grant Skinner. August 1, 2005
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
* You may distribute this class freely, provided it is not modified in any way (including
* removing this header or changing the package path).
*
* Please contact info@gskinner.com prior to distributing modified versions of this class.
*/


import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

class CollisionDetection {
	static public function checkForCollision(p_clip1:MovieClip,p_clip2:MovieClip,p_alphaTolerance:Number,p_scope:MovieClip):Rectangle {
		
		// set up default params:
		if (p_alphaTolerance == undefined) { p_alphaTolerance = 255; }
		if (p_scope == undefined) { p_scope = _root; }
		
		// get bounds:
		var bounds1:Object = p_clip1.getBounds(p_scope);
		var bounds2:Object = p_clip2.getBounds(p_scope);
		
		// rule out anything that we know can't collide:
		if (((bounds1.xMax < bounds2.xMin) || (bounds2.xMax < bounds1.xMin)) || ((bounds1.yMax < bounds2.yMin) || (bounds2.yMax < bounds1.yMin)) ) {
			return null;
		}
		
		// determine test area boundaries:
		var bounds:Object = {};
		bounds.xMin = Math.max(bounds1.xMin,bounds2.xMin);
		bounds.xMax = Math.min(bounds1.xMax,bounds2.xMax);
		bounds.yMin = Math.max(bounds1.yMin,bounds2.yMin);
		bounds.yMax = Math.min(bounds1.yMax,bounds2.yMax);
		
		// set up the image to use:
		var img:BitmapData = new BitmapData(bounds.xMax-bounds.xMin,bounds.yMax-bounds.yMin,false);
		
		// draw in the first image:
		var mat:Matrix = p_clip1.transform.matrix;
		mat.tx = p_clip1._x-bounds.xMin;
		mat.ty = p_clip1._y-bounds.yMin;
		img.draw(p_clip1,mat, new ColorTransform(1,1,1,1,255,-255,-255,p_alphaTolerance));
		
		// overlay the second image:
		mat = p_clip2.transform.matrix;
		mat.tx = p_clip2._x-bounds.xMin;
		mat.ty = p_clip2._y-bounds.yMin;
		img.draw(p_clip2,mat, new ColorTransform(1,1,1,1,255,255,255,p_alphaTolerance),"difference");
		
		// find the intersection:
		var intersection:Rectangle = img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);
		
		// if there is no intersection, return null:
		if (intersection.width == 0) { return null; }
		
		// translate the intersection to the appropriate coordinate space:
		intersection.x += bounds.xMin;
		intersection.y += bounds.yMin;
		
		return intersection;
	}
	
	
}