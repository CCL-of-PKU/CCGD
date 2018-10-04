
/**
 * Page Controllers
 *
 * Created on 2018-09-21
 * Author: Hybin Hwang
 */

$(document).ready(function () {
	// 详细页面返回上层
	let prev = document.referer;
	$('a.back-to-list').click(function () {
		// window.history.back();
		alert(prev);
	});

	// 显示或隐藏句法信息中的实例
	$('tr.syntax-func').click(function () {
		let id = $(this).attr('id');

		if ($('tr.syntax-sample#' + id).css('display') == 'none')
			$('tr.syntax-sample#' + id).show();
		else
			$('tr.syntax-sample#' + id).hide();
	});
})
