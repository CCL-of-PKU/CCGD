<!-- #include file = "common/function.asp"-->
<!-- #include file = "common/connect.asp"-->
<%
	construct = Replace(request("form"),"，","+") '将逗号转换为加号，便于split
    construct = Replace(construct,",","+")
	if isExistedForm(construct) then
		Response.Write "{""result"":true}"
	else
		Response.Write "{""result"":false}"
	end if
%>