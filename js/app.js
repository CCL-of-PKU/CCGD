
/**
 * Page Controllers
 *
 * Created on 2018-09-21
 * Author: Hybin Hwang
 */

$(document).ready(function () {
	// 详细页面返回上层
	let prev = document.referrer;
	$('a.back-to-list').click(function () {
		if (prev.match('confirm') == 'confirm' || prev.match('base') == 'base')
			$(this).attr('href', 'view.asp');
		else
			window.history.back();
	});

})
