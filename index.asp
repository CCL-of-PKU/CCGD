<!-- #include file = "header.asp"-->

<%
'=================================
' 网站首页——显示构式各项统计信息
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>

<div class="content">
	<!--vc type data-->
    <div class="row data-show" style="width:900px">
      <h3 style="margin-left:100px">构式常项、变项数量统计</h3>
      <div class="span6 num-chart" style="width:400px;margin-top:20px;position:relative;z-index:1"><img src="img/loading.gif"/></div>
      <div class="span4 num-table" style="width:460px">
      	<%
		'***修改常/变项数量，by Dreamer on 2014-12-01***

		'动态定义数组
		Dim variable_data()
		Dim constant_data()

		'首先要同时查出常项、变项数量
		sql = "SELECT count(constants) as cons_num, constants FROM construction where deleted is null GROUP BY constants ORDER BY constants asc"
		set rs_const = Server.CreateObject("adodb.recordset")
		rs_const.CursorLocation = 3
		rs_const.open sql,Conn,1,1

		sql = "SELECT count(variables) as vari_num, variables FROM construction where deleted is null GROUP BY variables ORDER BY variables asc"
		set rs_var = Server.CreateObject("adodb.recordset")
		rs_var.CursorLocation = 3
		rs_var.open sql,Conn,1,1
		
		'其次要找出最大项数
		rs_const.MoveLast
		rs_var.MoveLast
		max_con = rs_const("constants")
		max_var = rs_var("variables")
		sum_con = 0
		sum_var = 0
		If rs_const("constants") > rs_var("variables") Then
			max_num = rs_const("constants")
		Else
			max_num = rs_var("variables")
		End If
		
		'根据该项数动态定义数组长度（要考虑0的情况）
		ReDim constant_data(max_num)
		ReDim variable_data(max_num)

		'然后从0开始逐个填充数组
		rs_const.MoveFirst
		rs_var.MoveFirst

		For i = 0 To max_num
			If rs_const("constants") = i Then
				constant_data(i) = rs_const("cons_num")
				sum_con = sum_con + constant_data(i)
				If i < max_con Then
					rs_const.MoveNext
				End If
			Else
				constant_data(i) = 0
			End If

			If rs_var("variables") = i Then
				variable_data(i) = rs_var("vari_num")
				sum_var = sum_var + variable_data(i)
				If i < max_var Then
					rs_var.MoveNext
				End If
			Else
				variable_data(i) = 0

			End If
		Next
		'***End 修改常/变项数量***
		%>
		<!--常项数目-->
        <table class="table table-bordered table-hover" style="margin-top:-50px">
          <thead>
            <tr>
              <th style="width:75px">常项数目</th>
			<%For i = 0 To CInt(max_num/2)%>
              <th style="width:60px"><%=i%></th>
			<%Next%>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>构式条数</td>
			<%For i = 0 To CInt(max_num/2)%>
              <td><a href="search.asp?constant_num_min=<%=i%>&constant_num_max=<%=i%>&action=do"><%=constant_data(i)%><br>(<%= FormatPercent((constant_data(i)/sum_con)) %>)</a></td>
			<%Next%>
            </tr>
          </tbody>
		  <thead>
            <tr>
              <th style="width:75px">常项数目</th>
			<%For i = CInt(max_num/2)+1 To max_num%>
              <th style="width:60px"><%=i%></th>
			<%Next%>
	          <th style="width:60px">合计</th>	
			<%If max_num mod 2 > 0 Then %>
			  <th></th>
			<%End if%>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>构式条数</td>
			<%For i = CInt(max_num/2)+1 To max_num%>
              <td><a href="search.asp?constant_num_min=<%=i%>&constant_num_max=<%=i%>&action=do"><%=constant_data(i)%><br>(<%= FormatPercent((constant_data(i)/sum_con)) %>)</a></td>
			<%Next%>			
	          <td><%=sum_con%></td>
			<%If max_num mod 2 > 0 Then %>
			  <td></td>
			<%End if%>
            </tr>
          </tbody>
        </table>
		<table class="table table-bordered table-hover">
          <thead>
            <tr>
              <th style="width:75px">变项数目</th>
			<%For i = 0 To CInt(max_num/2)%>
              <th style="width:60px"><%=i%></th>
			<%Next%>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>构式条数</td>
			<%For i = 0 To CInt(max_num/2)%>
              <td><a href="search.asp?variable_num_min=<%=i%>&variable_num_max=<%=i%>&action=do"><%=variable_data(i)%><br>(<%= FormatPercent((variable_data(i)/sum_var)) %>)</a></td>
			<%Next%>
            </tr>
          </tbody>
		  <thead>
            <tr>
              <th>变项数目</th>
			<%For i = CInt(max_num/2)+1 To max_num%>
              <th style="width:60px"><%=i%></th>
			<%Next%>
	          <th style="width:60px">合计</th>	
			<%If max_num mod 2 > 0 Then %>
			  <th></th>
			<%End if%>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>构式条数</td>
			<%For i = CInt(max_num/2)+1 To max_num%>
              <td><a href="search.asp?variable_num_min=<%=i%>&variable_num_max=<%=i%>&action=do"><%=variable_data(i)%><br>(<%= FormatPercent((variable_data(i)/sum_var)) %>)</a></td>
			<%Next%>
	          <td><%=sum_var%></td>
			<%If max_num mod 2 > 0 Then %>
			  <td></td>
			<%End if%>
            </tr>
          </tbody>
        </table>
		
      </div>
    </div>
	<hr  style="position:relative;z-index:2"/>
	<!--构式类型数量统计，by Dreamer on 2014-12-04-->
	<div class="row type-show" style="width:900px;height:220px;margin-top:30px">
	  <h3 style="margin-left:520px">构式类型数量统计</h3>	  
	  <div class="span6 type-pie" style="width:400px;height:200px;margin-top:-50px"><img src="img/loading.gif" style="width:250px"/></div>
	  <div class="span4 type-table" style="width:460px;margin-top:30px">
	    <%
		Dim type_data()
		Dim type_name()
		sql = "select type,count(type) as sum_type from construction where deleted is null group by type order by count(type) desc"
		set rs_type = Server.CreateObject("adodb.recordset")
		rs_type.CursorLocation = 3
		rs_type.open sql,Conn,1,1
		type_size = rs_type.RecordCount
		ReDim type_data(type_size-1)
		ReDim type_name(type_size-1)
		sum_type = 0
		For i = 0 to type_size-1		 
		  type_data(i) = rs_type("sum_type")
		 If rs_type("type") = "" Then
		  type_name(i) = "(类型暂缺)"
		 Else
		  type_name(i) = rs_type("type")
		 End If
		  sum_type = sum_type + type_data(i)
		  rs_type.MoveNext()
		Next		
		%>
		<table class="table table-bordered table-hover">
		<thead>
		  <th style="width:75px"></th>
		<%For i = 0 to type_size-1%>
		  <th style="width:60px"><%=type_name(i)%></th>
		<%Next%>
		  <th style="width:60px">合计</th>
		</thead>		
		<tbody>
		  <td>构式条数</td>
		<%For i = 0 to type_size-1
		  If type_name(i) = "(类型暂缺)" Then
		    url = "search.asp?cons_type=NULL&action=do"
		  Else
		    url = "search.asp?cons_type=" & type_name(i) & "&action=do"
		  End If%>
		  <td style="width:60px"><a href="<%=url%>"><%=type_data(i)%><br>(<%= FormatPercent((type_data(i)/sum_type)) %>)</a></td>
		<%Next%>
		  <td style="width:60px"><%=sum_type%></td>
		</tbody>
		</table>
	  </div>
	</div>
	<!--End 构式类型数量统计-->
	<div align="right" style="margin-top:30px;margin-right:10px">
	<button class="btn" onclick="window.location.href='stat.asp'">查看更多统计</button>
	</div>
</div>

<script src="js/highcharts.js" type="text/javascript"></script>
<script src="js/show-data.js" type="text/javascript"></script>
<script type="text/javascript">
  var max = "<%=max_num%>"
  $("#menu_home").addClass("active");  
  showFormNumChart(max);
  //添加构式类型统计饼图，by Dreamer on 2014-12-04
  $(".type-pie img").remove();
  $(function(){
  $(".type-pie").highcharts({
    chart: {
	  plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false
    },
	title: {
	  text: ''
	},
	tooltip: {
      pointFormat: '{series.name}: <b>{point.y}</b>',
      percentageDecimals: 1
    },
	plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          color: '#000000',
          connectorColor: '#000000',
          formatter: function() {
            return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %';
          }
        }
      }
    },
    series: [{
        type: 'pie',
        name: '数量',
        data: [
		<%For i = 0 To type_size-1%>
		['<%=type_name(i)%>',<%=type_data(i)%>]
		<%If i < type_size-1 Then %>,<% End If %>
		<%Next%>
		]
    }]
  });
});
  //end 添加构式类型统计饼图
</script>
<!-- #include file = "footer.asp"-->