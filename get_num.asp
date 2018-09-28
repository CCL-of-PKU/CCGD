<!-- #include file = "common/function.asp"-->
<!-- #include file = "common/connect.asp"-->
<!-- #include file = "common/json.asp"-->

<%
'***修改常/变项数量，by Dreamer on 2014-12-01***

		'动态定义数组
		Dim variable_data()
		Dim constant_data()

		'首先要同时查出常项、变项数量
		sql = "SELECT count(constants) as cons_num, constants FROM construction WHERE deleted is null GROUP BY constants ORDER BY constants asc"
		set rs_const = Server.CreateObject("adodb.recordset")
		rs_const.CursorLocation = 3
		rs_const.open sql,Conn,1,1

		sql = "SELECT count(variables) as vari_num, variables FROM construction WHERE deleted is null GROUP BY variables ORDER BY variables asc"
		set rs_var = Server.CreateObject("adodb.recordset")
		rs_var.CursorLocation = 3
		rs_var.open sql,Conn,1,1
		
		'其次要找出最大项数
		rs_const.MoveLast
		rs_var.MoveLast
		max_con = rs_const("constants")
		max_var = rs_var("variables")
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
				If i < max_con Then
					rs_const.MoveNext
				End If
			Else
				constant_data(i) = 0
			End If
			If rs_var("variables") = i Then
				variable_data(i) = rs_var("vari_num")
				If i < max_var Then
					rs_var.MoveNext
				End If
			Else
				variable_data(i) = 0
			End If
		Next

		'***End 修改常/变项数量***

Dim a
Set a = jsArray()

Sub AddMember(name, data)
    Set a(Null) = jsObject()
    a(Null)("name") = name
    a(Null)("data") = data
End Sub

call AddMember("常项数量", constant_data)
call AddMember("变项数量", variable_data)

a.Flush
%>