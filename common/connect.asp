<%
'=============================
' 数据库操作函数
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=============================

dim ConnString
ConnString = "driver={microsoft access driver (*.mdb)};dbq=" & Server.Mappath("construction.mdb")
set Conn=Server.CreateObject("adodb.connection") '连接数据库
Conn.Open ConnString

%>