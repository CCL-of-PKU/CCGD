
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

	// 句法信息编辑页面设计
	let syntax = ['as_subject', 'as_predicate', 'as_object', 'as_attribute', 'as_adverbial',
				  'as_complement', 'as_preposition', 'with_object', 'with_complement', 'with_de1',
				  'with_de2', 'joint_preceding', 'joint_consequent', 'lianwei_preceding', 
				  'lianwei_consequent', 'be_sentence', 'bound']
	syntax.forEach(function(attr) {
		$('select#' + attr).css('width', '15%');
		$('input#' + attr + '_sample').css({
			'width': '68.5%',
			'position': 'relative',
			'left': '16%'
		});
		$('div.control-group#' + attr + '_sample').css('margin-top', '-3.55em');
	})
})
