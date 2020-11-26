jQuery(function($) {

	//子元素选择器
	$(".sidebar-dropdown > a").click(function() {
		//以滑动方式隐藏元素
		$(".sidebar-submenu").slideUp(250);
		if ($(this).parent().hasClass("active")) {
			$(".sidebar-dropdown").removeClass("active");
			$(this).parent().removeClass("active");
		} else {
			$(".sidebar-dropdown").removeClass("active");
			//以滑动方式显示隐藏的元素
			$(this).next(".sidebar-submenu").slideDown(250);
			$(this).parent().addClass("active");
		}

	});

	$(".sidebar-dropdown2 > a").click(function() {
		$(".sidebar-submenu2").slideUp(250);
		if ($(this).parent().hasClass("active")) {
			$(".sidebar-dropdown2").removeClass("active");
			$(this).parent().removeClass("active");
		} else {
			$(".sidebar-dropdown2").removeClass("active");
			$(this).next(".sidebar-submenu2").slideDown(250);
			$(this).parent().addClass("active");
		}

	});

	$("#toggle-sidebar").click(function() {
		//切换样式
		$(".page-wrapper").toggleClass("toggled");
	});

	if (!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i
			.test(navigator.userAgent)) {
		$(".sidebar-content").mCustomScrollbar({
			axis : "y",
			autoHideScrollbar : true,
			scrollInertia : 300
		});
		$(".sidebar-content").addClass("desktop");

	}
});