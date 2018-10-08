<!-- #include file = "header.asp"-->

<%
'=================================
' 搜索页面——表格
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>

<%
' Only the log in user can search
if not isLogin then
  response.redirect "login.asp?error=lever"
end if

response.write "<div class='content'>"

if request("action") = "do" then
  call doSearch
else
  call showForm
end if

response.write "</div>"
%>

<% sub showForm %>
	<form class="form-horizontal search-form" action="search.asp" method="post">
	  <h2 class="text-center">简单查询</h2>
	  <div class="control-group">
	    <label class="control-label">构式形式</label>
	    <div class="controls">
	      <input type="text" placeholder="支持模糊查询" name="cons_form" value=""/>
	    </div>
	  </div>
	  <!--增加常项查询，by Dreamer on 2014-04-11-->
	  <div class="control-group">
	    <label class="control-label">构式常项</label>
	    <div class="controls">
	      <input type="text" placeholder="仅支持精确查询！“不”≠“不但”" name="c_str" value=""/>
	    </div>
	  </div>
	  <div class="control-group">
	    <label class="control-label">构式特征</label>
		<div class="controls">
		    <%
			Dim i, ElementsInOneLine, j, k
			i = 0
			j = 1
			ElementsInOneLine = 4 ' 每行显示特征个数 
		    while i <= ubound(FEATURE_VALUE_ARRAY) 
				if j >=  ElementsInOneLine then
					k = j mod ElementsInOneLine
				else
					k = -1
				End if
			%>
			  <input type="checkbox" value="<%=FEATURE_VALUE_ARRAY(i)%>" name="cons_feature">
			  <%=Feature_VALUE_ARRAY(i)%>
	          <%
			  if k = 0 AND i < ubound(FEATURE_VALUE_ARRAY) then
			      response.write "<br>"
			  end if
			  i = i + 1
			  j = j + 1
	        wend 
			%>
			  <!--增加空特征查询，空特征值为-1. by Dreamer on 2015-04-11-->
			  <input type="checkbox" value="-1" name="cons_feature">特征缺失
		</div>
	  </div>
	  <!--增加格式类型，by Dreamer on 2014-11-30-->
	  <div class="control-group">
	    <label class="control-label">构式类型</label>
	    <div class="controls">
	    	<select name="cons_type">
	    		<option value="">请选择构式类型</option>
				<%i = 0
				while i <= ubound(TYPE_VALUE_ARRAY)%>
				<option value="<%=TYPE_VALUE_ARRAY(i)%>"><%=TYPE_VALUE_ARRAY(i)%></option>
				<%i = i + 1
				wend%>
        </select>
	    </div>
	  </div>
	  <!--end-->
	  <div class="control-group">
	    <label class="control-label">构式实例</label>
	    <div class="controls">
	      <input type="text" placeholder="可模糊查询，NULL查询空记录" name="cons_example" value=""/>
	    </div>
	  </div>
	  <div class="control-group">
	    <label class="control-label">变项数量</label>
	    <div class="controls">
	      <input type="text" class="span1" name="variable_num_min"/> 
	      &nbsp;至&nbsp;
	      <input type="text" class="span1" name="variable_num_max"/> 
	    </div>
	  </div>
	  <div class="control-group">
	    <label class="control-label">常项数量</label>
	    <div class="controls">
	      <input type="text" class="span1" name="constant_num_min" />
	      &nbsp;至&nbsp;
	      <input type="text" class="span1" name="constant_num_max" />
	    </div>
	  </div>
	  <!--增加构式义项查询，by Hybin on 2014-11-30-->
	  <div class="control-group">
	    <label class="control-label">构式义项</label>
	    <div class="controls">
		  <input type="radio" value="0" name="mono-poly">单义构式
		  <input type="radio" value="1" name="mono-poly">多义构式
	    </div>
	  </div>
	  <!--end-->
	  <!--增加排序方式，by Dreamer on 2014-11-30-->
	  <div class="control-group">
	    <label class="control-label">排序方式</label>
	    <div class="controls">
	      <select name="rank_type">
		    <option value="struct">构式形式（默认）</option>
	    	<option value="const">常项</option>
			<option value="var">变项</option>
			<option value="uptime">更新时间</option>
			<option value="author">填写者</option>
		  </select>
	    </div>
	  </div>
	  <!--end-->
      <!--增加查询条件"录入者"，on 2015-11-2-->
      <div class="control-group">
	    <label class="control-label">编写者</label>
	    <div class="controls">
	      <input type="text" class="span1" name="author" />
	    </div>
	  </div>
      <!--end-->
     <!--增加查询条件"update_time"，on 2018-03-15-->
      <div class="control-group">
	    <label class="control-label">填写时间</label>
	    <div class="controls">
	      从<input type="text" class="span2" name="postdatebegin" />
	      到<input type="text" class="span2" name="postdateend" />
	    </div>
	  </div>
      <!--end-->

	  <!--增加升降序选择，by Dreamer on 2014-11-30-->
	  <div class="control-group">	    
	    <div class="controls">
	      <input type="radio" name="rank_order" value="asc" checked/> 升序&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <input type="radio" name="rank_order" value="desc"/> 降序
	    </div>
	  </div>
	  <!--end-->
	  <div class="control-group">
	    <div class="controls">
	      <input type="hidden" name="action" value="do" />
	      <button type="submit" class="btn btn-primary"> 查询 </button> 
	      &nbsp;&nbsp;&nbsp;&nbsp;
	      <button type="reset" class="btn"> 重置 </button>
	    </div>
	  </div>
	</form>
	<h4 class="text-center"><a href="search_detail.asp">高级查询</a></h4>
<% end sub %>

<%
sub doSearch
	dim cons_form, cons_example, variable_num_min, variable_num_max, constant_num_min, constant_num_max, url, cons_type, author, conditions
	conditions = Array() '收集查询条件 by Hybin on 2018-09-20
	cons_form = Replace(request("cons_form"), "+", "")
	cons_feature = request("cons_feature")	
	cons_type = request("cons_type")
	cons_example = request("cons_example")
	rank_type = request("rank_type")
	rank_order = request("rank_order")
	variable_num_min = request("variable_num_min")
	variable_num_max = request("variable_num_max")
	constant_num_min = request("constant_num_min")
	constant_num_max = request("constant_num_max")
	c_str = request("c_str")'增加常项查询，by Dreamer on 2014-04-11
	author = request("author")'增加查询条件"录入者"，by Anran on 2015-11-02
	postdatebegin = request("postdatebegin") ' updatetime 2018-03-15
	postdateend = request("postdateend") ' updatetime 2018-03-15
	url = "search.asp?action=do&"
	sql = "SELECT * FROM construction "
	where = "WHERE ID>0 and deleted is null "
	'增加排序查询，by Dreamer on 2014-11-30
	order = ""
	select Case rank_type
		Case "struct" order = order & "ORDER BY form "
		Case "const" order = order & "ORDER BY cstr "
		Case "var" order = order & "ORDER BY vstr "
		Case "uptime" order = order & "ORDER BY update_time "
		Case "author" order = order & "ORDER BY username "
		Case "" order = order & "ORDER BY form "
	End Select
		order = order & rank_order
	url = url & "rank_type=" & rank_type & "&rank_order=" & rank_order & "&"
	'end
	'收集查询条件，当且仅当条件不为空 by Hybin on 2018-09-20
	if not isStrEmpty(cons_form) Then
		'增加构式变体查询，by Dreamer on 2015-01-28
		'查询时忽视+号，by Hybin on 2018-09-22
		where = where & "AND (form2 like '%" & Replace(cons_form,"*","%") & "%' OR alter2 like '%" & Replace(cons_form,"*","%") & "%') "	
		cons_form_uri = Replace(cons_form,"%","%25")
		cons_form_uri = Replace(cons_form_uri,"+","%2B")
		url = url & "cons_form=" & cons_form_uri & "&"
		call addItems(conditions, "构式形式：" & request("cons_form"))
	end If
	if not isStrEmpty(c_str) Then
		'增加构式常项查询，by Dreamer on 2015-01-28
		where = where & "AND (cstr = '" & c_str & "' or cstr like '" & c_str & " %' OR cstr like '% " & c_str & "') or cstr like '% " & c_str & " %'"		
		url = url & "c_str=" & c_str & "&"
		call addItems(conditions, "构式常项：" & c_str)
	end if
	if not isStrEmpty(cons_feature) Then
	'增加空特征查询，by Dreamer on 2015-04-11
	  If cons_feature = "-1" Then
	    where = where & "AND feature = '' "
		call addItems(conditions, "构式特征：特征缺失")
	  Else
		where = where & "AND feature like '%" & Replace(cons_feature,", ","%") & "%' "
		call addItems(conditions, "构式常项：" & cons_feature)
	  End If
		url = url & "cons_feature=" & cons_feature & "&"	  
	end If
	'增加类型查询，by Dreamer on 2014-11-30
	if not isStrEmpty(cons_type) Then
	  If cons_type = "NULL" Then
	    where = where & "AND type = '' "
	  Else
		where = where & "AND type = '" & cons_type &"' "
	  End If
		url = url & "cons_type=" & cons_type & "&"
		call addItems(conditions, "构式类型：" & cons_type)
	end If
    ' 实例查询
	if not isStrEmpty(cons_example) then
                   if cons_example = "NULL" then
                               where = where & "AND  example = '' "
                   ELSE
		where = where & "AND example like '%" & cons_example & "%' "
                   End if
                   url = url & "cons_example=" & cons_example & "&"
		call addItems(conditions, "构式实例：" & cons_example)
	end if
	if (not isStrEmpty(variable_num_min)) and (not isStrEmpty(variable_num_max)) then
		if cint(variable_num_min) = cint(variable_num_max) then
			where = where & "AND variables = " & cint(variable_num_min) & " "
		end if
		if cint(variable_num_min) < cint(variable_num_max) then
			where = where & "AND variables between " & cint(variable_num_min) & " and " & cint(variable_num_max) & " "
		end if
		url = url & "variable_num_min=" & variable_num_min & "&"
		url = url & "variable_num_max=" & variable_num_max & "&"
		call addItems(conditions, "变项数量：" & variable_num_min & "-" & variable_num_max)
	end if
	if (not isStrEmpty(constant_num_min)) and (not isStrEmpty(constant_num_max)) then
		if cint(constant_num_min) = cint(constant_num_max) then
			where = where & "AND constants = " & cint(constant_num_min) & " "
		end if
		if cint(constant_num_min) < cint(constant_num_max) then
			where = where & "AND constants between " & cint(constant_num_min) & " and " & cint(constant_num_max) & " "
		end if
		url = url & "constant_num_min=" & constant_num_min & "&"
		url = url & "constant_num_max=" & constant_num_max & "&"
		call addItems(conditions, "常项数量：" & constant_num_min & "-" & constant_num_max)
	end if
	'增加查询条件"录入者"，by Anran on 2015-11-02
	if not isStrEmpty(author) then
		where = where & "AND username = '" & author & "' "
		url = url & "author=" & author & "&"
		call addItems(conditions, "录入者：" & author)
	end if

	'增加查询条件"update_time"，by zwd on 2018-03-15
	if not isStrEmpty(postdatebegin) then
		where = where & "AND update_time > #" & postdatebegin & "# "
		url = url & "postdatebegin=" & postdatebegin & "&"
		call addItems(conditions, "填写时间：" & postdatebegin)
	end if

	if not isStrEmpty(postdateend) then
		where = where & "AND update_time < #" & postdateend & "# "
		url = url & "postdateend=" & postdateend & "&"
		conditions(UBound(conditions)) = conditions(UBound(conditions)) & "~" & postdateend
	end if

	sql = sql & where & Order
       ' response.write "sql:" & sql & "<br>"
	set rs = Server.CreateObject("adodb.recordset")
	rs.CursorLocation = 3
	rs.open sql,Conn,1,1

	current_page = request("page")
	if isStrEmpty(current_page) then
	  current_page = 1
	else
	  current_page = cint(current_page)
	end if
	if not (rs.EOF or rs.BOF) then
		rs.pagesize = NUM_PER_PAGE
		rs.absolutepage = current_page
	end if
	total_page = rs.pagecount
	'跳转页面修复，by Dreamer on 2015-01-28
	urlmark = InStr(url,"action=do&")
	If urlmark > 0 Then
		urlparam = Mid(url,urlmark+10)
	Else
	    urlparam = ""
	End If
	call showConstructionList(rs, 1, urlparam, conditions)
	if total_page > 1 then		
		call showPagination(current_page, total_page, url)
	end if
	set rs = nothing

	response.write "<h4><a href='search.asp'>继续查询</a></h4>"
end sub
%>

<script type="text/javascript">
  $("#menu_search").addClass("active");
</script>
<!-- #include file = "footer.asp"-->
