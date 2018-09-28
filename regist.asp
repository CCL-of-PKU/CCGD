<!-- #include file = "header.asp"-->
<!-- #include file = "common/md5.asp"-->

<%
'=================================
' 用户注册
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>

<%
' Do something according to action
if request("action") = "do" then
  call doRegist
else
  call showForm("","")
end if
%>

<%sub showForm(error, username)%>
  <form id="login_form" class="form-horizontal" action="regist.asp" method="post">
    <h2>请注册</h2>
    <% if not isStrEmpty(error) then %>
    <p class="error center"><%=error%></p>
    <% end if %>
    <div class="control-group">
      <label class="control-label" for="inputUsername">用户名</label>
      <div class="controls">
        <input type="hidden" name="action" value="do" />
        <input type="text" placeholder="必填" name="username" value="<%=username%>"/>
        <span class="help-inline error"><%=username_error%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="inputPassword">密码</label>
      <div class="controls">
        <input type="password" placeholder="必填" name="password1" />
        <span class="help-inline error"><%=password1_error%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="inputPassword">确认密码</label>
      <div class="controls">
        <input type="password" placeholder="必填" name="password2" />
        <span class="help-inline error"><%=password2_error%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="inputEmail">Email</label>
      <div class="controls">
        <input type="text" placeholder="必填，以便找回密码" name="email" />
        <span class="help-inline error"><%=email_error%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">真实姓名</label>
      <div class="controls">
        <input type="text" placeholder="请输入真实姓名" name="realname" value=""/>
        <span class="help-inline error"><%=real_error%></span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">所属机构</label>
      <div class="controls">
        <input type="text" placeholder="请输入所属机构" name="organization" value=""/>
        <span class="help-inline error"><%=organization_error%></span>
      </div>
    </div>
    <div class="control-group">
      <div class="controls">
        <button type="submit" class="btn btn-primary"> 提交 </button> 
        &nbsp;&nbsp;&nbsp;&nbsp;
        <button type="reset" class="btn"> 重置 </button>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <button type="button" onclick="location.href='login.asp'" class="btn"> 登录 </button>
      </div>
    </div>
  </form>
<%end sub%>

<%
sub doRegist
	dim username, password1, password2, realname, email, organization
	username = request.form("username")
	password1 = request.form("password1")
	password2 = request.form("password2")
	realname = request.form("realname")
	email = request.form("email")
	organization = request.form("organization")

	if isStrEmpty(username) then
		call showForm("请输入用户名", "")
		exit sub
	end if
	
	if isStrEmpty(password1) then
		call showForm("请输入密码", "")
		exit sub 
	end if

  if isStrEmpty(email) then
    call showForm("请输入Email", "")
    exit sub 
  end if
	
	sql = "SELECT * FROM user WHERE username='" & username & "'"
	set rs = Server.CreateObject("adodb.recordset")
	rs.CursorLocation = 2
	rs.open sql,Conn,1,1
	if rs.recordcount > 0 then
	  call showForm("此用户已存在，请选择新用户名", username)
	  exit sub
	end if

	if not password1 = password2 then
		call showForm("密码输入不一致，请重新输入", username)
		exit sub
	end if
	
	Conn.Execute("INSERT INTO user (username, password, realname, email, organization, lever, last_time, ip) VALUES ('" & username &"', '" & md5(password1) & "', '" & realname & "', '" & email & "', '" & organization & "', 1, '" & now & "', '" & getIP & "')")

	session("username") = username
	session("userlever") = 1
	session("userid") = getUserIDByName(username)
	 
	response.redirect "view.asp"
end sub
%>

<script type="text/javascript">
  $(".user").css("display","none")
</script>
<!-- #include file = "footer.asp"-->