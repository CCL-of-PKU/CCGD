<!-- #include file = "header.asp"-->

<%
'=================================
' 项间关系信息
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

dim id
id = request("id")
page = request("page")

dim FormInfo(4)
FormInfo(0) = Array("construction_id", "Construction ID", "hidden", id, "num", "")
FormInfo(1) = Array("var_var", "变项间关系", "textarea", "", "", "")
FormInfo(2) = Array("var_con", "变项-常项关系", "textarea", "", "", "")
FormInfo(3) = Array("chunk_chunk", "组块间关系", "textarea", "", "", "")

TableName = "variable_constant"
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

<%
sub showAddForm %>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="relations.asp">
      <h2>项间关系<a href="syntax.asp?action=add&id=<%=id%>"><small>[跳过]</small></a></h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM " & TableName & " WHERE construction_id=" & id
      set rs = Server.CreateObject("adodb.recordset")
      rs.CursorLocation = 2
      rs.open sql,Conn,1,1

      count = 0
      if not (rs.bof or rs.eof) then
        while count < ubound(FormInfo)
          FormInfo(count)(3) = rs(FormInfo(count)(0))
          count = count + 1
        wend
        current_id = rs("ID")
      else
        current_id = 0
      end if
      call createForm(FormInfo)
      %>
      <input type="hidden" name="action" value="doadd" />
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
%>

<%
sub showEditForm 
%>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="relations.asp">
      <h2>项间关系</h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM " & TableName & " WHERE construction_id=" & id
      'response.write "sql=" & sql & "<br>"
      'response.end
      set rs = Server.CreateObject("adodb.recordset")
      rs.CursorLocation = 2
      rs.open sql,Conn,1,1

      count = 0
      if not (rs.bof or rs.eof) then
        while count < ubound(FormInfo)
          FormInfo(count)(3) = rs(FormInfo(count)(0))
          count = count + 1
        wend
        current_id = rs("ID")
      else
        current_id = 0
      end if
       'response.write "current_id=" & current_id & "<br>"
      call createForm(FormInfo)
      %>
      <% if current_id > 0 then %>
                 <input type="hidden" name="action" value="doedit" />
      <% else %>
                 <input type="hidden" name="action" value="doadd" />
      <% end if %>
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
  urlmark=InStr(url,"id=")
  response.redirect "view.asp?action=detail&" & Mid(url,urlmark)
end sub

sub doAdd
  call do_insert(FormInfo, TableName)
  url=Request.ServerVariables("HTTP_REFERER")
  urlmark=InStr(url,"id=")
  response.redirect "view.asp?action=detail&" & Mid(url,urlmark)
end sub 

Sub delete
  sql = "DELETE FROM " & TableName & " WHERE construction_id=" & id
  'response.write "sql=" & sql & "<br>"
  'response.end
  Conn.Execute sql
  response.write "<script>alert('项间关系已删除！');window.location.href=document.referrer;</script>"
End Sub
%>

<script type="text/javascript">
  $("#menu_add").addClass("active");
</script>

<!-- #include file = "footer.asp"-->