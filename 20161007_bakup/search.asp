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
		      <% i = 0
		    while i <= ubound(FEATURE_VALUE_ARRAY) %>
			  <input type="checkbox" value="<%=FEATURE_VALUE_ARRAY(i)%>" name="cons_feature">
			  <%=Feature_VALUE_ARRAY(i)%>
	          <%if i = CInt(ubound(FEATURE_VALUE_ARRAY)/2)+1 then
			      response.write "<br>"
			  end if
			  i = i + 1
	        wend %>
			  <!--增加空特征查询，空特征值为-1. by Dreamer on 2015-04-11-->
			  <input type="checkbox" value="-1" name="cons_feature">空特征
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
	      <input type="text" placeholder="支持模糊查询" name="cons_example" value=""/>
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
	    <label class="control-label">录入者</label>
	    <div class="controls">
	      <input type="text" class="span1" name="author" />
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
	dim cons_form, cons_example, variable_num_min, variable_num_max, constant_num_min, constant_num_max, url, cons_type, author
	cons_form = request("cons_form")
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
	author = request("author")'增加查询条件"录入者" on 2015-11-2
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
	if not isStrEmpty(cons_form) Then
		'增加构式变体查询，by Dreamer on 2015-01-28
		where = where & "AND (form like '%" & Replace(cons_form,"*","%") & "%' OR alter like '%" & Replace(cons_form,"*","%") & "%') "	
		cons_form_uri = Replace(cons_form,"%","%25")
		cons_form_uri = Replace(cons_form_uri,"+","%2B")
		url = url & "cons_form=" & cons_form_uri & "&"
	end If
	if not isStrEmpty(c_str) Then
		'增加构式常项查询，by Dreamer on 2015-01-28
		where = where & "AND (cstr = '" & c_str & "' or cstr like '" & c_str & " %' OR cstr like '% " & c_str & "') or cstr like '% " & c_str & " %'"		
		url = url & "c_str=" & c_str & "&"
	end if
	if not isStrEmpty(cons_feature) Then
	'增加空特征查询，by Dreamer on 2015-04-11
	  If cons_feature = "-1" Then
	    where = where & "AND feature = '' "
	  Else
		where = where & "AND feature like '%" & Replace(cons_feature,", ","%") & "%' "
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
	end If
	'end
	if not isStrEmpty(cons_example) then
		where = where & "AND example like '%" & cons_example & "%' "
		url = url & "cons_example=" & cons_example & "&"
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
	end if
	'增加查询条件"录入者"，on 2015-11-2
	if not isStrEmpty(author) then
		where = where & "AND username = '" & author & "' "
		url = url & "author=" & author & "&"
	end if

	sql = sql & where & Order
	'Response.write sql
	set rs = Server.CreateObject("adodb.recordset")
	rs.CursorLocation = 3
	rs.open sql,Conn,1,1

	'Response.write(sql)

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
	call showConstructionList(rs, 1, urlparam)
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