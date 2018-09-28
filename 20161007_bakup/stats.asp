<!-- #include file = "common/function.asp"-->
<!-- #include file = "common/connect.asp"-->

<%
stat = request("stat") 'stat = {"feature","variable","constant"}
cstype = request("cons_type")
rank_type = request("rank_type") 'rank_type = {("freq"),"dic"}

If stat = "feature" Then

	CELL_WIDTH = 70
	If cstype <> "" Then
	  sql = "select feature, count(feature) as sum_feature from construction where deleted is null and type = '" & cstype & "' group by feature"
	Else
	  sql = "select feature, count(feature) as sum_feature from construction where deleted is null group by feature"
	End If

	set rs_feature = Server.CreateObject("adodb.recordset")
	rs_feature.CursorLocation = 3
	rs_feature.open sql,Conn,1,1
	
	fea_num = ubound(FEATURE_VALUE_ARRAY) '目前共六个特征，再多就要考虑布局了
	Dim basic_fea_num()
	Redim basic_fea_num(fea_num)
	total = 0
	fealess = 0
	For i = 0 to fea_num
	  basic_fea_num(i) = 0
	  rs_feature.MoveFirst
	  while not rs_feature.EOF
	    if InStr(rs_feature("feature"),FEATURE_VALUE_ARRAY(i)) > 0 then
		  basic_fea_num(i) = basic_fea_num(i) + rs_feature("sum_feature")
		end if
		if i = 0 then
	      total = total + rs_feature("sum_feature")
		  if rs_feature("feature") = "" then
		    fealess = rs_feature("sum_feature")
		  end if
		end if
	    rs_feature.MoveNext
	  wend  
	Next		
	%>
	  <center><div style="width:560px"><p align="left"><br>
	  　　构式总数为 <%=total%> 条。<br>
	  　　注：一个构式可能有多个特征，故基本特征总数相加大于构式总数。例如，带有“错配”特征的构式包含带有“错配and省略”特征的构式，而后者又包含“错配and省略and复现”特征的构式。
	  </p></div></center>
	  <h4 align="center">基本特征</h4>
	  <table align="center" class="table table-bordered table-hover" style="width:<%=(fea_num+3)*CELL_WIDTH%>px">
		<thead>
		  <th></th>
		  <th>(特征暂缺)</th>
		  <%for i = 0 to fea_num%>
		  <th><%=FEATURE_VALUE_ARRAY(i)%></th>
		  <%Next%>
		</thead>
		<tbody>
		  <tr>
		  <td>构式数量</td>
		  <td><a href="search.asp?action=do&cons_feature=-1&cons_type=<%=cstype%>">
		  <%=fealess%> (<%=FormatPercent(fealess/total)%>)</td>
		  <%For i = 0 To fea_num%>
		    <td><a href="search.asp?action=do&cons_feature=<%=FEATURE_VALUE_ARRAY(i)%>&cons_type=<%=cstype%>">
			<%=basic_fea_num(i)%> (<%=FormatPercent(basic_fea_num(i)/total)%>)
			</td>
		  <%Next%>
		  </tr>
		</tbody>
	  </table>
	  <h4 align="center">组合特征</h4>
	<%
	Dim feaName(100)
	Dim feaNum(100)
	For i = 0 to fea_num
	  rs_feature.MoveFirst
	  j = 0
	  total = 0
	  while not rs_feature.EOF
		if InStr(rs_feature("feature"),FEATURE_VALUE_ARRAY(i)) > 0 And rs_feature("feature")<>FEATURE_VALUE_ARRAY(i) then
		  feaName(j) = rs_feature("feature")
		  feaNum(j) = rs_feature("sum_feature")
		  total = total + feaNum(j)
		  j = j + 1
		end if
		rs_feature.MoveNext	
	  wend
	%>
  <h5 align="center">包含“<%=FEATURE_VALUE_ARRAY(i)%>”的特征</h4>
  <table align="center" class="table table-bordered table-hover" style="width:<%=(j+2)*CELL_WIDTH%>px">
    <thead>
	  <th style="width:80px;overflow:hidden"></th>
	<%For k = 0 To j-1%>		
	  <th style="width:80px;overflow:hidden"><%=feaName(k)%></th>
	<%Next%>	  
	  <th style="width:80px;overflow:hidden">总数</th>
	</thead>
	<tbody>
	  <tr>
		<td style="width:80px;overflow:hidden">构式数量</td>
	<%For k = 0 To j-1%>
		<td style="width:80px;overflow:hidden"><a href="search.asp?action=do&cons_feature=<%=feaName(k)%>&cons_type=<%=cstype%>"><%=feaNum(k)%> (<%=FormatPercent(feaNum(k)/total)%>)</a></td>
	<%Next%>
		<td style="width:80px;overflow:hidden"><%=total%></td>
	  </tr>
	</tbody>
  </table>
  <%Next

ElseIf stat = "variable" Then

	  Dim VarName(50)
	  Dim VarVal(50)
	  For i = 0 To 50
	    VarName(i) = ""
	    VarVal(i) = 0
	  Next
	  
	  If cstype <> "" Then
	  sql = "select vstr, count(vstr) as sum_vstr from construction where deleted is null and type = '" & cstype & "' group by vstr"
	  Else
	  sql = "select vstr, count(vstr) as sum_vstr from construction where deleted is null group by vstr"
	  End If
	  Set rs = Server.CreateObject("adodb.recordset")
	  rs.CursorLocation = 3
	  rs.open sql,Conn,1,1
	  rs.MoveFirst
	  maxindex = -1 '有效最大下标
	  While Not rs.EOF
	    v = Split(rs("vstr"))
		For vi = 0 To Ubound(v)
		  i = 0
		  Do While VarName(i) <> v(vi) And VarVal(i) > 0
		    i = i + 1
		  Loop
		  If VarName(i) = "" Then
		    VarName(i) = v(vi)
			VarVal(i) = rs("sum_vstr")
			maxindex = i
		  Else
		    VarVal(i) = VarVal(i) + rs("sum_vstr")
		  End If
		Next
	    rs.MoveNext
	  Wend
	  rs.Close
	  total = 0
	  For i = 0 To maxindex
	    total = total + VarVal(i)
	  Next
	  ' 排序
	If rank_type = "dic" Then
      tempName = ""
	  tempVal = 0
	  For i = 0 To maxindex
	    For j = i+1 To maxindex
		  If VarName(i) > VarName(j) Or (VarVal(i) < VarVal(j) And VarName(i) = VarName(j)) Then
		    tempVal = VarVal(i)
			VarVal(i) = VarVal(j)
			VarVal(j) = tempVal
			tempName = VarName(i)
			VarName(i) = VarName(j)
			VarName(j) = tempName
		  End If
		Next
	  Next
	Else
	  tempName = ""
	  tempVal = 0
	  For i = 0 To maxindex
	    For j = i+1 To maxindex
		  If VarVal(i) < VarVal(j) Or (VarVal(i) = VarVal(j) And VarName(i) > VarName(j)) Then
		    tempVal = VarVal(i)
			VarVal(i) = VarVal(j)
			VarVal(j) = tempVal
			tempName = VarName(i)
			VarName(i) = VarName(j)
			VarName(j) = tempName
		  End If
		Next
	  Next
	End If
	  ' 分3列呈现
	  rownum = (maxindex + 1)\3
	  %>
	  <center><div style="width:560px"><p align="left"><br>
	  　　共统计到不同的变项 <%=maxindex+1%> 项，总计出现 <%=total%> 次。<br>
	  　　注：该数量为该变项出现的总次数，点击链接以查看包含该变项的构式及构式数量。
	  </p></div></center>  
	  <table align="center" class="table table-bordered table-hover" style="width:500px">
	  <thead>
	  <th width="30px"></th>
	  <th width="80px">数量</th>
	  <th width="30px"></th>
	  <th width="80px">数量</th>
	  <th width="30px"></th>
	  <th width="80px">数量</th>
	  </thead>
	  <tbody>
	  <%For i = 0 To rownum%>
		<tr>
		  <th><%=VarName(i)%></th>
		  <td><a href='search.asp?action=do&cons_form=<%=VarName(i)%>&cons_type=<%=cstype%>'><%=VarVal(i)%>(<%=FormatPercent(VarVal(i)/total)%>)</a></td>
		  <th><%=VarName(i+rownum+1)%></th>
		  <td><a href='search.asp?action=do&cons_form=<%=VarName(i+rownum+1)%>&cons_type=<%=cstype%>'><%=VarVal(i+rownum+1)%>(<%=FormatPercent(VarVal(i+rownum+1)/total)%>)</a></td>
		<%If i+rownum*2+2 <= maxindex Then%>
		  <th><%=VarName(i+rownum*2+2)%></th>
		  <td><a href='search.asp?action=do&cons_form=<%=VarName(i+rownum*2+2)%>&cons_type=<%=cstype%>'><%=VarVal(i+rownum*2+2)%>(<%=FormatPercent(VarVal(i+rownum*2+2)/total)%>)</a></td>
		<%Else%>
		  <td></td>
		  <td></td>
		<%End If%>
		</tr>
	  <%Next%>
	  </tbody>
	  </table>
<%
ElseIf stat = "constant" Then

	  Dim ConName(),ConVal(),ConPY()
	  
	  sql = "select constant.cstring as cstr, constant.py as py, count(constant.cstring) as sum from construction " &_
	  "inner join constant on construction.id = constant.construction_id where construction.deleted is null "
	  
	  If cstype <> "" Then
	    sql = sql & "and type = '" & cstype & "' group by constant.cstring, constant.py "
	  Else
	    sql = sql & "group by constant.cstring, constant.py "
	  End If

	  If rank_type = "dic" Then
	    sql = sql & "order by py asc"
	  Else
	    sql = sql & "order by count(constant.cstring) desc"
	  End If
	  
	  Set rs = Server.CreateObject("adodb.recordset")
	  rs.CursorLocation = 3
	  rs.open sql,Conn,1,1
	  
	  rownum = rs.RecordCount\3
	  ReDim ConName(rs.RecordCount)
	  ReDim ConVal(rs.RecordCount)
	  ReDim ConPY(rs.RecordCount)

	  total = 0
	  rs.MoveFirst
	  items = 0
	  While Not rs.EOF
		ConName(items) = rs("cstr")
		ConVal(items) = rs("sum")
		ConPY(items) = rs("py")
	    total = total + rs("sum")
		rs.MoveNext
		items = items + 1
	  Wend
	  rs.Close
	  %>
	  <center><div style="width:560px"><p align="left"><br>
	  　　共统计到不同的常项 <%=items%> 项，总计出现 <%=total%> 次。<br>
	  　　注：该数量为该常项出现的总次数，请注意，“不”与“不但”是不同的常项，“不但”出现的次数不计入“不”。点击链接以查看包含该常项的构式及构式数量。
	  </p></div></center>
	  <table align="center" class="table table-bordered table-hover" style="width:500px">
	  <thead>
	  <th width="30px"></th>
	  <th width="80px">数量</th>
	  <th width="30px"></th>
	  <th width="80px">数量</th>
	  <th width="30px"></th>
	  <th width="80px">数量</th>
	  </thead>
	  <tbody>
	  <%For i = 0 To rownum%>
		<tr>
		  <th><%=ConName(i)%></th>
		  <td><a href='search.asp?action=do&c_str=<%=ConName(i)%>&cons_type=<%=cstype%>'><%=ConVal(i)%>(<%=FormatPercent(ConVal(i)/total)%>)</a></td>
		  <th><%=ConName(i+rownum+1)%></th>
		  <td><a href='search.asp?action=do&c_str=<%=ConName(i+rownum+1)%>&cons_type=<%=cstype%>'><%=ConVal(i+rownum+1)%>(<%=FormatPercent(ConVal(i+rownum+1)/total)%>)</a></td>
		<%If i+rownum*2+2 < items Then%>
		  <th><%=ConName(i+rownum*2+2)%></th>
		  <td><a href='search.asp?action=do&c_str=<%=ConName(i+rownum*2+2)%>&cons_type=<%=cstype%>'><%=ConVal(i+rownum*2+2)%>(<%=FormatPercent(ConVal(i+rownum*2+2)/total)%>)</a></td>
		<%Else%>
		  <td></td>
		  <td></td>
		<%End If%>
		</tr>
	  <%Next%>
	  </tbody>
	  </table>
<%
End If
%>