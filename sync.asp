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
	query = "SELECT * FROM construction WHERE deleted = null AND " & rel_type & " = '" & cxn & "'"
	Set rs = Server.CreateObject("adodb.recordset")
	rs.open query, Conn, 1, 1

	While not rs.EOF
		rels = rs("form") & "|" & rels
		rs.MoveNext
	Wend

	rs.close

  if (Len(rels) > 0) then
	  get_relations = Left(rels, Len(rels) - 1)
  else
    get_relations = rels
  end if
end function

sub sync
	query = "SELECT * FROM construction WHERE deleted = null"
	Set rs = Server.CreateObject("adodb.recordset")
	rs.open query, Conn, 1, 1
	
	while not rs.EOF
		synonymous = get_relation("synonymous", rs("form"))
		antonym = get_relation("antonym", rs("form"))
		hyponym = get_relation("hypernym", rs("form"))
		hypernym = get_relation("hyponym", rs("form")) 
		
		Conn.Execute("UPDATE construction SET synonymous = '" & synonymous & "', antonym = '" & antonym & "', hypernym = '" & hypernym & "', hyponym = '" & hyponym & "' WHERE form = '" & rs("form") & "'")
		rs.Movenext
	wend

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
