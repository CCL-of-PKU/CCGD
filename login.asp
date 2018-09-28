<!-- #include file = "header.asp"-->
<!-- #include file = "common/md5.asp"-->

<%
'=================================
' 网站首页——根据登录情况进行重定位
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>

<%
' Do something according to action
if request("action") = "login" then
  call doLogin
else
  if request("action") = "logout" then
    call doLogout
  else
    if isLogin then
      response.redirect "view.asp"
    end if
    call showForm("","","")
  end if
end if
%>

<%sub showForm(username_error, password_error, username)%>
  <form id="login_form" class="form-horizontal" action="login.asp" method="post">
    <h2>请登录</h2>
    <% if request("error") = "lever" then %>
    <p class="error center">权限不足，请登录</p>
    <% end if %>
    <div class="control-group">
      <label class="control-label" for="inputUsername">用户名</label>
      <div class="controls">
        <input type="hidden" name="action" value="login" />
        <input type="text" placeholder="Username" name="username" value="<%=username%>"/>
        <span class="help-inline error"><%=username_error%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="inputPassword">密码</label>
      <div class="controls">
        <input type="password" placeholder="Password" name="password" />
        <span class="help-inline error"><%=password_error%></span>
      </div>
    </div>
    <div class="control-group">
      <div class="controls">
        <button type="submit" class="btn btn-primary"> 登录 </button> 
        &nbsp;&nbsp;&nbsp;&nbsp;
        <button type="button" onclick="location.href='regist.asp'" class="btn"> 注册 </button>
      </div>
    </div>
  </form>
<%end sub%>

<%
sub doLogin
  dim username, password
  username = request.form("username")
  password = request.form("password")

  sql = "SELECT * FROM user WHERE username='" & username & "'"
  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  if rs.recordcount < 1 then
    call showForm("抱歉，不存在此用户", "", username)
  else
    if not rs("password") = md5(password) then
      call showForm("", "您输入的密码不正确", username)
    else
      session("username") = username
      session("userlever") = rs("lever")
      session("userid") = rs("ID")

      ' update the last login time
      sql = "UPDATE user SET last_time='" & now & "', ip='" & getIP & "' "
      sql = sql & "WHERE ID=" & rs("ID")
      Conn.Execute(sql)
      
      response.redirect "view.asp"
    end if
  end if
end sub
%>

<%
sub doLogout
  session("username") = ""
  session("userlever") = ""
  session("userid") = 0
  response.redirect "view.asp"
end sub
%>

<script type="text/javascript">
  $(".user").css("display","none")
</script>
<!-- #include file = "footer.asp"-->