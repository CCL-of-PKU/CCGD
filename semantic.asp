<!-- #include file = "header.asp"-->

<%
'=================================
' 语义信息
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

dim id
id = request("id")
page = request("page")

dim FormInfo(5)
FormInfo(0) = Array("construction_id", "Construction ID", "hidden", id, "num", "")
FormInfo(1) = Array("literal_meaning", "字面义", "textarea", "", "", "")
FormInfo(2) = Array("implication", "言外之意", "textarea", "", "", "")
FormInfo(3) = Array("presupposition", "预设", "textarea", "", "", "")
FormInfo(4) = Array("entailment", "蕴含", "textarea", "", "", "")

TableName = "semantic"
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
    <form class="form-horizontal" id="addForm" method="post" action="semantic.asp">
      <h2>语义属性</h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM semantic WHERE construction_id=" & id
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