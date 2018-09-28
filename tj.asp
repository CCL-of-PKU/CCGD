<!-- #include file = "header.asp"-->
<%
'=================================
' ajax判断数据库是否已经存在了构式形式
' Copyright (c) CCL@PKU
' Author: Anran
'=================================
%>
      <div class='content'>
    <h2>工作统计</h2>
    
    
    
    <table class='table table-bordered table-hover'>
      <thead>

      <tr>
        <th width="6%" style="text-align:center">序号</th>
        <th width="20%">用户名</th>
        <th width="20%">条目数</th>
      </tr>
    
      </thead>
      <tbody>
          <% 
	  
set rshot=server.CreateObject("adodb.recordset")
sql="select username as yh, count(*) as tj from [construction] where deleted is null group by username"
i=1
rshot.open sql,Conn,1,1
if not (rshot.eof and rshot.bof) then
do while not rshot.eof
	  
	   %>
      <tr>
        <td style="text-align:center"><%= i %></td>
        <td><a href="search.asp?action=do&rank_type=uptime&rank_order=desc&author=<%= rshot("yh") %>"><%= rshot("yh") %></a></td>
        <td><%= rshot("tj") %></td>
        </tr>
        
          <% 
	  
rshot.movenext
i=i+1
loop
end if
rshot.close
set rshot=nothing
	   %>
      </tbody></table>

</div>

<script type="text/javascript">
  $("#menu_tj").addClass("active");
</script>

<!-- #include file = "footer.asp"-->