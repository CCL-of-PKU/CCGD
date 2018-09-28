<!-- #include file = "header.asp"-->

<%
'=================================
' 句法信息
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

dim id
id = request("id")
page = request("page")

dim FormInfo(16)
FormInfo(0) = Array("construction_id", "Construction ID", "hidden", id, "num", "")
FormInfo(1) = Array("as_subject", "是否做主语", "select", "", "yesno", "")
FormInfo(2) = Array("as_predicate", "是否做谓语", "select", "", "yesno", "")
FormInfo(3) = Array("as_object", "是否做宾语", "select", "", "yesno", "")
FormInfo(4) = Array("as_attribute", "是否做定语", "select", "", "yesnode1", "")
FormInfo(5) = Array("as_adverbial", "是否做状语", "select", "", "yesnode2", "")
FormInfo(6) = Array("as_complement", "是否做补语", "select", "", "yesnode3", "")
FormInfo(7) = Array("as_preposition", "是否做介宾", "select", "", "yesno", "")
FormInfo(8) = Array("with_object", "是否带宾语", "select", "", "yesno", "")
FormInfo(9) = Array("with_complement", "是否带补语", "select", "", "yesnode3", "")
FormInfo(10) = Array("with_de1", "是否带“的”", "select", "", "yesno", "")
FormInfo(11) = Array("with_de2", "是否带“地”", "select", "", "yesno", "")
FormInfo(12) = Array("joint_preceding", "联合结构前项", "select", "", "yesno", "")
FormInfo(13) = Array("joint_consequent", "联合结构后项", "select", "", "yesno", "")
FormInfo(14) = Array("lianwei_preceding", "连谓结构前项", "select", "", "yesno", "")
FormInfo(15) = Array("lianwei_consequent", "连谓结构后项", "select", "", "yesno", "")

TableName = "syntax"
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
end Select

sub showEditForm %>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="syntax.asp">
      <h2>句法功能</h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM syntax WHERE construction_id=" & id
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
end sub%>

<script type="text/javascript">
  $("#menu_add").addClass("active");
</script>

<!-- #include file = "footer.asp"-->