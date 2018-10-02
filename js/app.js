
/**
 * Page Controllers
 *
 * Created on 2018-09-21
 * Author: Hybin Hwang
 */

$(document).ready(function () {
	$('a.back-to-list').click(function () {
		window.history.back();
	});

	$('tr.syntax-func').click(function () {
		if ($('tr.syntax-sample').css('display') == 'none')
			$('tr.syntax-sample').show();
		else
			$('tr.syntax-sample').hide();
	});
})
