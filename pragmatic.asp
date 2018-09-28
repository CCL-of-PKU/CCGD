<!-- #include file = "header.asp"-->

<%
'=================================
' 浏览页面——显示构式信息列表及内容
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

dim id
id = request("id")
page = request("page")

dim FormInfo(4)
FormInfo(0) = Array("construction_id", "Construction ID", "hidden", id, "num", "")
FormInfo(1) = Array("emotional", "感情色彩", "textarea", "", "", "")
FormInfo(2) = Array("stylistic", "语体色彩", "textarea", "", "", "")
FormInfo(3) = Array("field", "领域限制", "textarea", "", "", "")

TableName = "pragmatic"
%>

<%
if not isEditor then
  response.redirect "login.asp?error=lever"
end if

' Do something according to action
select case request("action")
  case "edit"
    call showEditForm
  case "doedit"
    call doEdit
end select

sub showEditForm %>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="pragmatic.asp">
      <h2>语用属性</h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM pragmatic WHERE construction_id=" & id
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
      <input type="hidden" name="id" value="<%=rs("construction_id")%>" />
      <input type="hidden" name="current_id" value="<%=rs("ID")%>" />
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
  urlmark=InStr(url,"id=")
  response.redirect "view.asp?action=detail&" & Mid(url,urlmark)
end sub
%>
<script type="text/javascript">
  $("#menu_add").addClass("active");
</script>

<!-- #include file = "footer.asp"-->