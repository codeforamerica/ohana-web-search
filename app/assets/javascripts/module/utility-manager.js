define(['util'],function(util) {
  'use strict';
	
	var aboutLnk;
	var aboutContent;
	var aboutArrow;
	var container;

	function init()
	{
		// get references to the dom elements 
		aboutLnk = document.getElementById("about-btn");
		aboutContent = document.getElementById("about-box");
		container = aboutContent.parentNode;
		aboutArrow = container.children[0];
		
		aboutLnk.addEventListener( "click" , _aboutClickedHandler, false );
	}

	function show()
	{
		// get the window dimensions
		var winDim = util.getWindowRect();
		
		// 
		var offset = util.getOffset(aboutLnk);
		var offsetY = (offset.top+aboutLnk.offsetHeight);
		var offsetX = (offset.left);


		aboutArrow.style.top = (offsetY)+"px";
		aboutArrow.style.left = (offsetX-10+(aboutLnk.offsetWidth/2))+"px";

		aboutContent.style.top = (offsetY+10)+"px";

		var cssWidth = util.getStyle(aboutContent,"width");
		if ( (offsetX+Number(cssWidth.substring(0,cssWidth.length-2))) > winDim.width)
		{
			aboutContent.style.right = "10px";
		}
		else
		{
			aboutContent.style.left = (offsetX)+"px";
		}

		container.classList.remove("hide");
		container.style.zIndex = "10000";
		aboutContent.style.zIndex = "9999";
		aboutArrow.style.zIndex = "10000";
	}

	function _aboutClickedHandler(evt)
	{
		evt.preventDefault();

		show();
		return false;
	}

	return {
		init:init
	};
});