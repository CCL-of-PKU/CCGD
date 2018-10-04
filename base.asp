<!-- #include file = "header.asp"-->

<%
'=================================
' 浏览页面——显示构式信息列表及内容
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>


<script language="javascript" type="text/javascript">
function CheckConstructionForm()
{// zwd 2016-10-07

	var construction_form;
	construction_form = document.addForm.form.value;
	
	var i;
	i = construction_form.indexOf("+");
	
	var do_insert_or_not;
	if(i<0)
	{// 构式形式中缺少分隔符+
		if(confirm('构式形式中缺少分隔符+，是否继续添加？'))
		{
			do_insert_or_not = true;
		}
		else
			return false;
	}
	else
		do_insert_or_not = true;	
	
	var reg = /^[+,0-9a-zA-Z\u4e00-\u9fa5、]+$/;
	if(!reg.test(construction_form))
	{// 构式形式中包含特殊字符：在汉字，数字，字母，+，、之外的符号
		if (confirm('构式形式中包含特殊字符，是否继续添加？'))
		{
			do_insert_or_not = true;
		}
		else	
			return false;
	}
	else
		do_insert_or_not = true;
		
	return do_insert_or_not;
}

</script>

<%
dim id, page
id = request("id")
page = request("page")

dim FormInfo(23)
' formate: (name, label, type, defaut-value, special-type, help-text)
FormInfo(0) = Array("form", "构式形式", "text", "", "", "")
'增加构式变体查询，by Dreamer on 2015-01-28
FormInfo(1) = Array("alter", "构式变体", "text", "", "", "多个变体请用 <small>|</small> 隔开")
FormInfo(2) = Array("yixiang", "义项", "text", "0", "num", "")
FormInfo(3) = Array("feature", "构式特征", "multi-select", "", "feature", "")
FormInfo(4) = Array("type", "构式类型", "radio", "", "type", "")
FormInfo(5) = Array("syllable_num", "构式音节数", "text", "", "", "")
FormInfo(6) = Array("multi_chunks", "组块数", "radio", "单", "single_or_double", "")
FormInfo(7) = Array("is_chunk_expand", "组块扩展", "radio", "否", "yes_or_no", "")
FormInfo(8) = Array("example", "构式实例", "textarea", "", "", "多个实例请用 <small>|</small> 隔开")
FormInfo(9) = Array("variables", "变项数量", "text", "", "num", "")
FormInfo(10) = Array("constants", "常项数量", "text", "", "num", "")
FormInfo(11) = Array("definition", "释义模板", "text", "", "", "如需作解释性说明，请在释义文字两端用 <strong>#</strong> 标记，如 <strong>#...#</strong>")
FormInfo(12) = Array("derivation", "形成机制", "textarea", "", "", "")
FormInfo(13) = Array("negation", "否定形式", "text", "", "", "")
FormInfo(14) = Array("question", "疑问形式", "text", "", "", "")
'同义、反义、上下位由下拉列表（select）改为文本输入（text）
FormInfo(15) = Array("synonymous", "同义(近义)构式", "text","", "", "多个构式请用 <small>|</small> 隔开")
FormInfo(16) = Array("antonym", "反义构式", "text","", "", "多个构式请用 <small>|</small> 隔开")
FormInfo(17) = Array("hypernym", "上位构式", "text", "", "", "多个构式请用 <small>|</small> 隔开")
FormInfo(18) = Array("hyponym", "下位构式", "text", "", "", "多个构式请用 <small>|</small> 隔开")
FormInfo(19) = Array("remark", "备注", "textarea", "", "", "")
FormInfo(20) = Array("update_time", "更新时间", "hidden", now(), "", "")
FormInfo(21) = Array("username", "修改者", "hidden", session("username"), "", "")
FormInfo(22) = Array("ip", "ip", "hidden", getIP, "", "")

TableName = "construction"

if not isEditor then
  response.redirect "login.asp?error=lever"
end if

' Do something according to action
select case request("action")
  case "add"
    call showAddForm
  case "doadd"
    call doAdd
  case "goon"
    call goOn
  case "edit"
    call showEditForm
  case "doedit"
    call doEdit
end select

sub showAddForm %>
  <div class='content'>
    <form class="form-horizontal" id="addForm" name="addForm" method="post" action="base.asp" onsubmit="return CheckConstructionForm();">
      <input type="hidden" name="action" value="doadd" />
      <h2>基本信息</h2>
      <%
      call createForm(FormInfo)
      %>

       <div class="control-group">
        <div class="controls">
          <button type="submit" class="btn" id="preadd">提交</button> &nbsp;&nbsp;&nbsp; 
          <button type="button" class="btn" onclick="javascript:history.back(-1);">返回</button>
        </div>
      </div>
    </form>
  </div>
<% 
end sub 

sub showEditForm %>
  <div class='content'>
  <%
  url=Request.querystring
  urlmark=InStr(url,"id=")
  url="base.asp?"&Mid(url,urlmark)
  %>
    <form class="form-horizontal" id="addForm" method="post" onsubmit="return CheckConstructionForm();" action=<%=url%>>	
      <h2>基本信息</h2>
      <%
	  
      sql = "SELECT * FROM construction WHERE ID=" & id
      'response.write "sql=" & sql & "<br>"
      'response.end
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
      <input type="hidden" name="current_id" value="<%=id%>" />
      <input type="hidden" name="page" value="<%=page%>" />
      <div class="control-group">
        <div class="controls">
          <button type="submit" class="btn" >提交</button> &nbsp;&nbsp;&nbsp;
          <button type="button" class="btn" onclick="javascript:history.back(-1);">返回</button>
        </div>
      </div>
    </form>
  </div>
<% 
end sub 

sub doAdd
	call do_insert(FormInfo, TableName)
	lastHomonym = getLastConstructionHomonym
	LastID = getLastConstructionID
	
	if (lastHomonym <> "0") then
		response.redirect "confirm.asp?id=" & LastID
	else
		call do_insert_all(LastID)
		response.redirect "view.asp?action=detail&id=" & LastID
	end if
end sub 

sub doEdit
	call do_update(FormInfo, TableName)
	url=Request.ServerVariables("HTTP_REFERER")
	urlmark=InStr(url,"&id=")
	response.redirect "view.asp?action=detail" & Mid(url,urlmark)
end sub
%>


<!-- #include file = "footer.asp"-->
