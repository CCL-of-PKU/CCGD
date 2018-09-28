<!-- #include file = "header.asp"-->

<%
'=================================
' 变项信息
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

dim id, current_id
id = request("id")
current_id = request("current_id")
page = request("page")

dim FormInfo(6)
FormInfo(0) = Array("construction_id", "Construction ID", "hidden", id, "num", "")
FormInfo(1) = Array("vstring", "变项", "text", "", "", "")
FormInfo(2) = Array("position", "变项序位", "text", "", "num", "")
FormInfo(3) = Array("syn_cat", "句法特征", "textarea", "", "", "")
FormInfo(4) = Array("sem_cat", "语义特征", "textarea", "", "", "")
FormInfo(5) = Array("prg_cat", "语用特征", "textarea", "", "", "")
FormInfo(6) = Array("alter", "可替换度", "text", "", "num", "")

TableName = "variable"
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
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="variable.asp">
      <input type="hidden" name="action" value="doadd" />
      <input type="hidden" name="id" value="<%=id%>" />
      <input type="hidden" name="page" value="<%=page%>" />
      <h2>变项信息&nbsp;<a href="constant.asp?action=add&id=<%=id%>"><small>[跳过]</small></a></h2>
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
    <form class="form-horizontal" id="addForm" method="post" action="variable.asp">
      <h2>变项信息</h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM variable WHERE ID=" & current_id
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
  response.write "<script>alert('变项已删除！');window.location.href=document.referrer;</script>"
End Sub
%>

<script type="text/javascript">
  $("#menu_add").addClass("active");
</script>

<!-- #include file = "footer.asp"-->