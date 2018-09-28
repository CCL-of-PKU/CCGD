<!-- #include file = "header.asp"-->
<!-- #include file = "common/md5.asp"-->

<%
'=================================
' 用户页面——用户管理及用户信息
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>

<%
if not isLogin then
  response.redirect "login.asp?error=lever"
end if

ROLES = Array("普通用户","编辑","管理员")

' Do something according to action
if request("action") = "info" then
  if request("type") = "modify" then
    call modifyInfo
  else
    call userInfo("")          '用户信息管理,根据session("userid")显示用户资料
  end if
else
  ' 只有管理员能够进行以下操作
  if not isAdmin then
  	response.redirect "login.asp?error=lever"
  end if

  if request("action") = "manage" then
    call userManage      '管理员对特定用户信息进行管理
  else
    if request("action") = "delete" then
      call deleteUser    '删除用户
    else
      call showList        '显示用户列表
    end if
  end if
end if
%>

<%
sub showList()
  response.write "<div class='content'>"
  response.write "<h2>用户列表</h2>"

  dim lStrSqlSelect, MySqlStr
			
  lStrSqlSelect = trim(request("MySqlStr"))
  MySqlStr = request("MySqlStr")
			
  if IsStrEmpty(lStrSqlSelect) then
     lStrSqlSelect = "select * from user where username like '%%' order by last_time desc"
  end if
%>

<form action="user.asp" method="post">
<table>
<tr>
<td><input name="MySqlStr" type="text" style="width:500px;" value="<%=Server.HtmlEncode(lStrSqlSelect)%>"></td>
<td><input type="submit" value=search style='CURSOR: hand; background-color: #FFFFFF; border-color: #CCCCCC black #FF0000;border-style: solid; border-width: 0px 0px'></td></tr></table>
</form>

<%  
' sql = "SELECT * FROM user "
' where = " "
' order = "ORDER BY lever"
' sql = sql & where & order

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 3
  rs.open lStrSqlSelect, Conn, 1, 1

  'response.write lStrSqlSelect
  'response.write "<br>"

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

  call showUserList(rs)
  if total_page > 1 then   
    call showPagination(current_page, total_page, "user.asp?")
  end if
  set rs = nothing
  %>

  <div id="manageModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h3 id="myModalLabel">编辑用户信息</h3>
    </div>
    <div class="modal-body">
      <form class="form-horizontal" action="user.asp" method="post">
        <input type="hidden" name="id" value="" id="input-id">
        <input type="hidden" name="action" value="manage">
        <div class="control-group">
          <label class="control-label">用户名</label>
          <div class="controls">
            <span class="uneditable-input" id="input-username"></span>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">用户角色</label>
          <div class="controls">
            <select name="lever" id="select-lever">
              <option value="1">普通用户</option>
              <option value="2">编辑</option>
              <option value="3">管理员</option>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">真实姓名</label>
          <div class="controls">
            <input type="text" value="" name="realname" id="input-realname">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">所属机构</label>
          <div class="controls">
            <input type="text" value="" name="organization" id="input-organization">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Email</label>
          <div class="controls">
            <input type="text" value="" name="email" id="input-email">
          </div>
        </div>
    </div>
    <div class="modal-footer">
      <button type="submit" class="btn btn-primary"> 修改 </button>&nbsp;&nbsp;
      <button class="btn" data-dismiss="modal" aria-hidden="true"> 取消 </button>
    </div>
    </form>
  </div>
  <%
  response.write "</div>"
end sub
%>

<%
sub showUserList(rs)
  if not (rs.EOF or rs.BOF) then
    %>
    <p class="text-right muted"><%=rs.recordcount%>条结果，分<%=rs.pagecount%>页显示</p>
    <table class='table table-bordered table-hover'>
      <thead><tr>
        <th width="6%">序号</th>
        <th width="10%" style="text-align:center">用户名</th>
        <th width="10%" style="text-align:center">用户角色</th>
        <th width="10%" style="text-align:center">真实姓名</th>
        <th width="15%" style="text-align:center">所属机构</th>
        <th width="22%" style="text-align:center">Email</th>
        <th width="13%" style="text-align:center">最近登录</th>
        <th width="14%" style="text-align:center">操作</th>
      </tr></thead>
      <tbody>
    <%
    count = 1
    while not (rs.EOF or count > rs.pagesize)
      %>
      <tr>
        <td style="text-align:center"><%=(rs.absolutepage - 1) * rs.pagesize + count%></td>
        <td><%=rs("username")%></td>
        <td class="<%=rs("lever")%>"><%=ROLES(rs("lever")-1)%></td>
        <td><%=rs("realname")%></td>
        <td><%=rs("organization")%></td>
        <td><%=rs("email")%></td>
        <td><%=rs("last_time")%></td>
        <td>
          <a href="#manageModal" role="button" data-toggle="modal" onclick="showManage(this)" id="<%=rs("ID")%>">修改信息</a>&nbsp;&nbsp;
          <a href="javascript:if(confirm('确实要删除吗?')) location='user.asp?action=delete&id=<%=rs("ID")%>'">删除</a>
        </td>
      </tr>
      <%
      rs.movenext
      count = count + 1
    wend
    response.write "</tbody></table>"
  else
    response.write "<h4 class='error center'>没有找到相关用户信息</h4>"
  end if
end sub
%>

<%
sub userManage()
  dim userid, realname, lever, organization, email
  userid = request.form("id")
  realname = request.form("realname")
  lever = request.form("lever")
  organization = request.form("organization")
  email = request.form("email")

  Conn.Execute("UPDATE user SET realname='" & realname & "', lever=" & lever & ", organization='" & organization & "', email='" & email &"' WHERE ID= " & userid)
  response.redirect "user.asp"
end sub
%>

<%
sub deleteUser
  Conn.Execute "DELETE FROM user WHERE ID=" & request.QueryString("id")
  call showList
  response.write "<script>alert('用户已删除！');window.location='user.asp'</script>;"
  'response.redirect "user.asp"
end sub
%>

<%
sub userInfo(error)
  sql = "SELECT * FROM user WHERE ID=" & session("userid")
  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1
  %>
  <form id="login_form" class="form-horizontal" action="user.asp" method="post">
    <h2>用户信息</h2>
    <% if not isStrEmpty(error) then %>
    <p class="error center"><%=error%></p>
    <% end if %>
    <div class="control-group">
      <label class="control-label">用户名</label>
      <div class="controls">
        <input type="hidden" name="action" value="info" />
        <input type="hidden" name="type" value="modify" />
        <input type="hidden" name="id" value="<%=session("userid")%>">
        <span class="uneditable-input"><%=rs("username")%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">用户角色</label>
      <div class="controls">
        <span class="uneditable-input"><%=ROLES(rs("lever")-1)%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">密码</label>
      <div class="controls">
        <input type="password" name="password1" placeholder="修改密码" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">确认密码</label>
      <div class="controls">
        <input type="password" name="password2" placeholder="确认密码" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Email</label>
      <div class="controls">
        <input type="text" name="email" value="<%=rs("email")%>" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">真实姓名</label>
      <div class="controls">
        <input type="text" name="realname" value="<%=rs("realname")%>"/>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">所属机构</label>
      <div class="controls">
        <input type="text" name="organization" value="<%=rs("organization")%>" />
      </div>
    </div>
    <div class="control-group">
      <div class="controls">
        <button type="submit" class="btn btn-primary"> 修改 </button> 
        &nbsp;&nbsp;&nbsp;&nbsp;
        <button type="reset" class="btn" onclick="javascript:history.go(-1)"> 取消 </button>
      </div>
    </div>
  </form>
  <%
end sub
%>

<%
sub modifyInfo
  dim userid, password1, password2, realname, email, organization
  userid = request.form("id")
  password1 = request.form("password1")
  password2 = request.form("password2")
  realname = request.form("realname")
  email = request.form("email")
  organization = request.form("organization")

  if not password1 = password2 then
    call userInfo("密码输入不一致，请重新输入")
    exit sub
  end if

  Conn.Execute("UPDATE user SET realname='" & realname & "', password='" & md5(password1) & "', organization='" & organization & "', email='" & email &"' WHERE ID= " & userid)
  call userInfo("")
  response.write "<script>alert('用户信息已修改！');window.location='view.asp'</script>;"
end sub
%>

<script type="text/javascript">
  $("#menu_user").addClass("active");

  function showManage(ele){
    $("#manageModal #input-id").attr("value", $(ele).attr("id"))
    $(ele).parent().parent().find("td").each(function(index){
      if(index==1)
        $("#manageModal #input-username").html($(this).html())
      if(index==2)
        $("#manageModal #select-lever").val($(this).attr("class"))
      if(index==3)
        $("#manageModal #input-realname").attr("value", $(this).html())
      if(index==4)
        $("#manageModal #input-organization").attr("value", $(this).html())
      if(index==5)
        $("#manageModal #input-email").attr("value", $(this).html())
    })
  }
</script>
<!-- #include file = "footer.asp"-->