//show data in index page

//Created on 2013-9-23
//Copyright:  MT(matengneo@gmail.com)

function showFormNumChart(max_num){
  //修改数组长度，by Dreamer on 2014-12-01
  var word_lever = ['0'];
  for(var i=1;i<=max_num;i++)
	  word_lever.push(i.toString())
  console.log("yes")
  $.ajax({
    type: "POST",
    contentType: "application/json",
    url: "get_num.asp",
    dataType: 'json',
    success: function(data) {
    	$(".num-chart img").remove()
    	$('.num-chart').highcharts({
    	  chart: {
    	    type: 'column',
    	    height: 300
    	  },
    	  title: {
    	    text: ''
    	  },
    	  xAxis: {
    	    categories: word_lever
    	  },
    	  yAxis: {
    	    min: 0,
    	    title: {
    	      text: '数量'
    	    }
    	  },
    	  tooltip: {
    	    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
    	    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
    	        '<td style="padding:0"><b>{point.y} </b></td></tr>',
    	    footerFormat: '</table>',
    	    shared: true,
    	    useHTML: true
    	  },
    	  plotOptions: {
    	    column: {
    	      pointPadding: 0.2,
    	      borderWidth: 0
    	    }
    	  },
    	  series: data
    	});
    }
  });
}

