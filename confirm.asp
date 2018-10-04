<!-- #include file = "header.asp"-->

<%
'=================================
' 确认页面——用户确认是否新增同形构式
' Copyright (c) CCL@PKU
' Author: Hybin Hwang(hhb8550@live.com)
'=================================
%>

<%
dim id
id = request.QueryString("id")

sub delete
	Conn.Execute "DELETE FROM construction WHERE id = '" & id & "'"
	
	Response.redirect "base.asp?action=add&"
end sub

sub continue
	LastID = getLastConstructionID
	call do_insert_all(LastID)
	response.redirect "view.asp?action=detail&id=" & LastID
end sub

if (request("action") = "delete") then
	call delete
elseif (request("action") = "continue") then
	call continue
end if
%>

<div class="content">
	<h2>提示<h2>
	<p>检测到存在形式及义项相同的构式，确认是否继续添加？</p>
	<div class="confirm-button">
		<a href="confirm.asp?action=delete&id=<%=id%>" id="confirm-back">返回</a>
		<a href="confirm.asp?action=continue&id=<%=id%>" id="confirm-go">继续</a>
	</div> 
</div>

<!-- #include file = "footer.asp"-->
