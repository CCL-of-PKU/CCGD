<!-- #include file = "header.asp"-->
<!-- #include file = "search_detail_define.asp"-->

<%
'=================================
' 高级搜索页面
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
	<form class="form-horizontal search-detail-form" action="search_detail.asp" method="post">
	<h2 class="text-center">高级查询</h2>
	<div class="accordion" id="construction-info">
	  <% count = 0 %>
	  <% while count < ubound(TableInfo) %>
	  <div class="accordion-group">
	  	<div class="accordion-heading">
		  <h2 class="detail-topic accordion-toggle">
		  	<a data-toggle="collapse" href="#base-info-<%=count%>"><%=TableInfo(count)(0)%></a>
		  </h2>
		</div>
	  	<div id="base-info-<%=count%>" class="accordion-body collapse in">
	  		<div class="accordion-inner">
	  		  <% call showSearchDetailForm(TableInfo(count)(1), TableInfo(count)(2)) %>
  			</div>
  		</div>
      </div>
      <% count = count + 1 %>
      <% wend %>
    </div>

	<p class="text-center">
	    <input type="hidden" name="action" value="do" />
	    <button type="submit" class="btn btn-primary"> 查询 </button> 
	    &nbsp;&nbsp;&nbsp;&nbsp;
	    <button type="reset" class="btn"> 重置 </button>
	</p>
	</form>
	<h4 class="text-center"><a href="search.asp">简单查询</a></h4>
<% end sub %>

<%
sub doSearch
	dim url, sql
	url = "search_detail.asp?action=do&"
	sql = "SELECT DISTINCT construction.ID as ID, construction.form as form,construction.feature as feature,construction.type as type,example,definition,variables,constants " &_
		"FROM ((((((construction LEFT JOIN constant ON construction.ID = constant.construction_id) " &_
		"LEFT JOIN variable ON construction.ID = variable.construction_id) " &_
		"LEFT JOIN syntax ON construction.ID = syntax.construction_id) " &_
		"LEFT JOIN semantic ON construction.ID = semantic.construction_id) " &_
		"LEFT JOIN pragmatic ON construction.ID = pragmatic.construction_id) " &_
		"LEFT JOIN reference ON construction.ID = reference.construction_id) WHERE construction.ID>0 AND deleted is null "

	count = 0
	while count < ubound(TableInfo)
		word_num = 0
		while word_num < ubound(TableInfo(count)(1))
			if not TableInfo(count)(1)(word_num)(2) = "min-max" then
				word_str = TableInfo(count)(2) & "_" & TableInfo(count)(1)(word_num)(0)
				'response.write "word_str=" & word_str & "<br>"
				if TableInfo(count)(1)(word_num)(0) = "feature" then
					if not isStrEmpty(request(word_str)) then 
						word_value = FEATURE_VALUE_ARRAY(request(word_str))
					end if
					'response.write "word_value_feature:" & word_value & "<br>"
				end if
				if TableInfo(count)(1)(word_num)(0) = "type" then
					if not isStrEmpty(request(word_str)) then
						word_value = TYPE_VALUE_ARRAY(request(word_str))
					end if
					'response.write "word_value_type:" & word_value & "<br>"
				end if
				if TableInfo(count)(1)(word_num)(0) <> "feature" AND TableInfo(count)(1)(word_num)(0) <> "type" then
					word_value = request(word_str)
					'response.write "word_value=" & word_value & "<br>"
				end if

				if not isStrEmpty(word_value) then
					if TableInfo(count)(1)(word_num)(3) = "text" then
						if TableInfo(count)(1)(word_num)(0) <> "type" then 
							sql = sql & "AND " & TableInfo(count)(2) & "." & TableInfo(count)(1)(word_num)(0) & " like '%" & word_value & "%' "
						else
							sql = sql & "AND " & TableInfo(count)(2) & "." & TableInfo(count)(1)(word_num)(0) & "='" & word_value & "' "
						end if
						'response.write "SQL1=" & sql & "<br>"
						word_value = ""
					end if
					if TableInfo(count)(1)(word_num)(3) = "num" then
						sql = sql & "AND " & TableInfo(count)(2) & "." & TableInfo(count)(1)(word_num)(0) & "=" & word_value & " "
						'response.write "SQL2=" & sql & "<br>"
					end if
					if TableInfo(count)(1)(word_num)(3) = "id" then
						sql = sql & "AND " & TableInfo(count)(2) & ".ID"  & "=" & word_value & " "
						'response.write "SQL3=" & sql & "<br>"
					end if
					url = url & word_str & "=" & word_value & "&"
				end if
			else
				min_str = TableInfo(count)(2) & "_" & TableInfo(count)(1)(word_num)(0) & "_min"
				max_str = TableInfo(count)(2) & "_" & TableInfo(count)(1)(word_num)(0) & "_max"
				min_num = request(min_str)
				max_num = request(max_str)
				if (not isStrEmpty(min_num)) and (not isStrEmpty(max_num)) then
					if cint(min_num) = cint(max_num) then
						sql = sql & "AND " & TableInfo(count)(2) & "." & TableInfo(count)(1)(word_num)(0) & " = " & cint(min_num) & " "
						'response.write "SQL4=" & sql & "<br>"
					end if
					if cint(min_num) < cint(max_num) then
						sql = sql & "AND " & TableInfo(count)(2) & "." & TableInfo(count)(1)(word_num)(0) & " between " & cint(min_num) & " and " & cint(max_num) & " "
						'response.write "SQL5=" & sql & "<br>"
					end if
					url = url & min_str & "=" & min_num & "&"
					url = url & max_str & "=" & max_num & "&"
				end if
			end if
			word_num = word_num + 1
		wend
		count = count + 1
	wend
	
	'response.write "SQL_final=" & sql & "<br>"
	'response.end
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
	urlparam = Mid(url,29)
'	call showConstructionList(rs, 1)
	call showConstructionList(rs, 1, urlparam) 'zwd  2016-06-22
	
	if total_page > 1 then		
		call showPagination(current_page, total_page, url)
	end if

	set rs = nothing

	response.write "<h4><a href='search_detail.asp'>继续查询</a></h4>"
end sub
%>

<script type="text/javascript">
  $("#menu_search").addClass("active");
</script>
<!-- #include file = "footer.asp"-->