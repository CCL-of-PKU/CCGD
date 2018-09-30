<!-- #include file = "common/function.asp"-->
<!-- #include file = "common/connect.asp"-->

<%
'=============================
' 网站页头文件
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=============================
%>

<!DOCTYPE html>
<html>
  <head>
    <title>现代汉语构式数据库</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="keywords" content="现代汉语,构式,数据库,北京大学,Peking University,Construction,database">
    <meta name="description" content="北京大学现代汉语构式数据库">
    <meta http-equiv="content-type" content="text/html; charset = utf-8">

	<script src="js/jquery-1.9.1.min.js" type="text/javascript"></script>

    <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
	<script src="js/bootstrap.min.js" type="text/javascript"></script>

	<link href="css/jquery.bs_pagination.bs2.min.css" rel="stylesheet" media="screen">
	<!--<link href="css/jquery.bs_pagination.min.css" rel="stylesheet" media="screen">-->
    <script src="js/jquery.bs_pagination.min.js" type="text/javascript"></script>    
	<script src="js/en.min.js" type="text/javascript"></script>
	
	<link href="css/style.css" rel="stylesheet" media="screen">
	<script src="js/app.js" type="text/javascript"></script>
	
  </head>
  <body>
    <div class="container">
      <div class="header">
        <ul class="nav nav-pills pull-right">
          <li id="menu_home"><a href="index.asp">首页</a></li>
	  <li id="menu_doc"><a href="CCGD_spec.pdf" target="_blank">文档</a></li>
	  <li id="menu_stat"><a href="stat.asp">统计</a></li>
          <li id="menu_view"><a href="view.asp">浏览</a></li>
        <% if isLogin then%>
          <li id="menu_search"><a href="search.asp">查询</a></li>
          <% if  isEditor then%>
          <li id="menu_add"><a href="base.asp?action=add&">新增</a></li>
          <% end if%>
          <% if isAdmin then%>
          <li id="menu_user"><a href="user.asp">用户</a></li>
          <li id="menu_tj"><a href="tj.asp">工作统计</a></li>
          <li id="menu_latest"><a href="view.asp?display=all">全部记录</a></li>
          <% end if%>
        <%end if%>
        </ul>
        <a href="index.asp"><h2>现代汉语构式数据库</h2></a>
      </div>

      <hr/>

      <% if isLogin then%>
      <div class="user">
        <p><i class="icon-user"></i>&nbsp;<%=session("username")%>&nbsp;&nbsp;
        <a href="user.asp?action=info">修改资料</a>&nbsp;||&nbsp;
        <a href="login.asp?action=logout">注销</a></p>
      </div>
      <% else %>
      <div class="user">
        <p><i class="icon-user"></i>&nbsp;<a href="login.asp">登录</a>&nbsp;||&nbsp;<a href="regist.asp">注册</a></p>
      </div>
      <% end if%>
