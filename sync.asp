<!-- #include file = "header.asp"-->

<%
'=================================
' 确认页面——同步已存在的构式关系
' Copyright (c) CCL@PKU
' Author: Hybin Hwang(hhb8550@live.com)
'=================================
%>

<%
if (request("action") = "do") then
	call sync
end if

function get_relation(rel_type, cxn)
	Dim rels
	query = "SELECT * FROM construction WHERE deleted is null AND " & rel_type & " = '" & cxn & "'"
	Set rs = Server.CreateObject("adodb.recordset")
	rs.open query, Conn, 1, 1

	While not rs.EOF
		rels = rs("form") & "|" & rels
		rs.MoveNext
	Wend

	rs.close

  if (Len(rels) > 0) then
	  get_relation = Left(rels, Len(rels) - 1)
  else
    get_relation = rels
  end if
end function

function getVal(rs, rels, rel_type)
	if (Len(rs(rel_type)) <> 0) then
		getVal = Mid(rels & "|" & rs(rel_type), 2)
	else
		getVal= rs(rel_type)
	end if
end function

sub sync
	query = "SELECT * FROM construction WHERE deleted is null"
	Set rs = Server.CreateObject("adodb.recordset")
	rs.open query, Conn, 1, 1
	
	while not rs.EOF
		synonymous = getVal(rs, get_relation("synonymous", rs("form")), "synonymous")
		antonym = getVal(rs, get_relation("antonym", rs("form")), "antonym")
		hyponym = getVal(rs, get_relation("hypernym", rs("form")), "hypernym")
		hypernym = getVal(rs, get_relation("hyponym", rs("form")), "hyponym")
		
		Conn.Execute("UPDATE construction SET synonymous = '" & synonymous & "', antonym = '" & antonym & "', hypernym = '" & hypernym & "', hyponym = '" & hyponym & "' WHERE form = '" & rs("form") & "'")
		rs.MoveNext
	wend

	response.write "总计同步" & rs.RecordCount & "条记录"
	rs.close
end sub	
%>

<div class="content">
	<h2>同步</h2>
	<form class="form-horizontal" method="post" action="sync.asp">
		<input type="hidden" name="action" value="do" />
		<button type="submit" class="btn">同步</button>
	</form>
</div>

<!-- #include file = "footer.asp"-->
