<!-- #include file = "header.asp"-->

<%
'=================================
' 浏览页面——显示构式信息列表及内容
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

dim id
id = request("id")
current_id = request("current_id")
page = request("page")

dim FormInfo(8)
FormInfo(0) = Array("construction_id", "Construction ID", "hidden", id, "num", "")
FormInfo(1) = Array("title", "题目", "text", "", "", "")
FormInfo(2) = Array("author", "作者", "text", "", "", "")
FormInfo(3) = Array("type", "类型", "select", "", "reference_type", "")  ' zwd 2016-11-02 form -> type
FormInfo(4) = Array("publish_time", "时间", "text", "", "", "发表或出版时间，如：2000")
FormInfo(5) = Array("source", "来源", "text", "", "", "期刊、出版机构或论文集")
FormInfo(6) = Array("abstract", "摘要", "text", "", "", "请注意不要出现西文标点符号")
FormInfo(7) = Array("keyword", "关键词", "text", "", "", "请不要以西文逗号间隔")
TableName = "reference"
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
<%
If InStr(Request.ServerVariables("HTTP_REFERER"),"view.asp") > 0 Then '说明从view过来的
	url=Request.ServerVariables("HTTP_REFERER")
	urlmark=InStr(url,"&id=")
	url=Mid(url,urlmark+1)
	url=Replace(url,"&","$")'将参数传回去
Else
	url = ""
End If
%>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="reference.asp">
      <input type="hidden" name="action" value="doadd" />
	  <input type="hidden" name="forepage" value="<%=url%>" />
      <input type="hidden" name="id" value="<%=id%>" />
      <h2>参考文献&nbsp;<a href="reference.asp?action=goon&id=<%=id%>"><small>[跳过]</small></a></h2>
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
<% end sub %> 

<%sub showEditForm %>
<% 'zwd 2016-11-02 added in order to get construction_form
If InStr(Request.ServerVariables("HTTP_REFERER"),"view.asp") > 0 Then '说明从view过来的
	url=Request.ServerVariables("HTTP_REFERER")
	urlmark=InStr(url,"&id=")
	url=Mid(url,urlmark+1)
	url=Replace(url,"&","$")'将参数传回去
Else
	url = ""
End If
%>
  <div class='content'>
    <form class="form-horizontal" id="addForm" method="post" action="reference.asp">
      <h2>参考文献</h2>
      <div class="control-group">
        <label class="control-label">构式形式</label>
        <div class="controls">
          <input type="text" readonly="true" class="span8" value="<%=session("construction")%>" />
        </div>
      </div>
      <%
      sql = "SELECT * FROM reference WHERE ID=" & current_id
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
  Conn.Execute "DELETE FROM reference WHERE ID=" & current_id
  response.write "<script>alert('文献已删除！');window.location.href=document.referrer;</script>"
End Sub
%>

<script type="text/javascript">
  $("#menu_add").addClass("active");
</script>

<!-- #include file = "footer.asp"-->