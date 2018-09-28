<!-- #include file = "header.asp"-->

<%
'=================================
' 浏览页面——显示构式信息列表及内容
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

dim id, current_id
id = request("id")
current_id = request("current_id")
page = request("page")

dim FormInfo(8)  ' zwd 2016-06-08 FormInfo(7) -> FormInfo(8)
FormInfo(0) = Array("construction_id", "Construction ID", "hidden", id, "num", "")
FormInfo(1) = Array("cstring", "常项", "text", "", "", "")
FormInfo(2) = Array("py", "拼音", "text", "", "", "")
FormInfo(3) = Array("pos", "词性", "text", "", "", "")
FormInfo(4) = Array("position", "常项序位", "text", "", "num", "")
FormInfo(5) = Array("syn_cat", "句法特征", "textarea", "", "", "")
FormInfo(6) = Array("sem_cat", "语义特征", "textarea", "", "", "")
FormInfo(7) = Array("prg_cat", "语用特征", "textarea", "", "", "")

TableName = "constant"
%>

<%
if not isEditor then
  response.redirect "login.asp?error=lever"
end if

' Do something according to action
select case request("action")
  case "add"
    call showAddForm
  case "doadd"
    call doAdd
  case "edit"
    call showEditForm
  case "doedit"
    call doEdit
  Case "delete"
    Call delete
end select
%>

<% sub showAddForm %>
<%If InStr(Request.ServerVariables("HTTP_REFERER"),"view.asp") > 0 Then '说明从view过来的
url=Request.ServerVariables("HTTP_REFERER")
urlmark=InStr(url,"&id=")
url=Mid(url,urlmark+1)
url=Replace(url,"&","$")'将参数传回去
Else
url = ""
End If%>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="constant.asp">
      <input type="hidden" name="action" value="doadd" />
	  <input type="hidden" name="forepage" value="<%=url%>" />
      <input type="hidden" name="id" value="<%=id%>" />
      <input type="hidden" name="page" value="<%=page%>" />
      <h2>常项信息&nbsp;<a href="syntax.asp?action=add&id=<%=id%>"><small>[跳过]</small></a></h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      call createForm(FormInfo)
      %>

       <div class="control-group">
        <div class="controls">
          <button type="submit" class="btn">提交</button> &nbsp;&nbsp;&nbsp;
          <button type="button" class="btn" onclick="javascript:history.back(-1);">返回</button>
        </div>
      </div>
    </form>
  </div>
<% end sub 

sub showEditForm %>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="constant.asp">
      <h2>常项信息</h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM constant WHERE ID=" & current_id
      set rs = Server.CreateObject("adodb.recordset")
      rs.CursorLocation = 2
      rs.open sql,Conn,1,1

      count = 0
      while count < ubound(FormInfo)
        FormInfo(count)(3) = rs(FormInfo(count)(0))
        count = count + 1
      wend
      call createForm(FormInfo)
      %>

      <input type="hidden" name="action" value="doedit" />
      <input type="hidden" name="id" value="<%=id%>" />
      <input type="hidden" name="current_id" value="<%=current_id%>" />
      <input type="hidden" name="page" value="<%=page%>" />
      <div class="control-group">
        <div class="controls">
          <button type="submit" class="btn">提交</button> &nbsp;&nbsp;&nbsp;
          <button type="button" class="btn" onclick="javascript:history.back(-1);">返回</button>
        </div>
      </div>
    </form>
  </div>
<% 
end sub 

sub doEdit
  call do_update(FormInfo, TableName)
  url=Request.ServerVariables("HTTP_REFERER")
  urlmark=InStr(url,"&id=")
  response.redirect "view.asp?action=detail" & Mid(url,urlmark)
end sub

sub doAdd
  call do_insert(FormInfo, TableName) 
  url=Request.ServerVariables("HTTP_REFERER")
  urlmark=InStr(url,"&id=")
  response.redirect "view.asp?action=detail" & Mid(url,urlmark)
end sub 

Sub delete
  Conn.Execute "DELETE FROM " & TableName & " WHERE ID=" & current_id
  response.write "<script>alert('常项已删除！');window.location.href=document.referrer;</script>"
End Sub%>

<script type="text/javascript">
  $("#menu_add").addClass("active");
</script>

<!-- #include file = "footer.asp"-->