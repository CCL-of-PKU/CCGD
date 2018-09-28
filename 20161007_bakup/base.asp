<!-- #include file = "header.asp"-->

<%
'=================================
' 浏览页面——显示构式信息列表及内容
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>

<%
dim id, page
id = request("id")
page = request("page")

dim FormInfo(23)
' formate: (name, label, type, defaut-value, special-type, help-text)
FormInfo(0) = Array("form", "构式形式", "text", "", "", "")
'增加构式变体查询，by Dreamer on 2015-01-28
FormInfo(1) = Array("alter", "构式变体", "text", "", "", "多个变体请用 <small>|</small> 隔开")
FormInfo(2) = Array("yixiang", "义项", "text", "1", "num", "")
FormInfo(3) = Array("feature", "构式特征", "multi-select", "", "feature", "")
FormInfo(4) = Array("type", "构式类型", "radio", "", "type", "")
FormInfo(5) = Array("syllable_num", "构式音节数", "text", "", "", "")
FormInfo(6) = Array("multi_chunks", "组块数", "radio", "单", "single_or_double", "")
FormInfo(7) = Array("is_chunk_expand", "组块扩展", "radio", "否", "yes_or_no", "")
FormInfo(8) = Array("example", "构式实例", "textarea", "", "", "多个实例请用 <small>|</small> 隔开")
FormInfo(9) = Array("variables", "变项数量", "text", "", "num", "")
FormInfo(10) = Array("constants", "常项数量", "text", "", "num", "")
FormInfo(11) = Array("definition", "释义模板", "text", "", "", "")
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
    <form class="form-horizontal" id="addForm" method="post" action="base.asp">
      <input type="hidden" name="action" value="doadd" />
      <h2>基本信息</h2>
      <%
      call createForm(FormInfo)
      %>

       <div class="control-group">
        <div class="controls">
          <a class="btn" id="preadd2" >提交</a>
          <!-- <button type="submit" class="btn" id="preadd">提交</button> &nbsp;&nbsp;&nbsp; -->
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
    <form class="form-horizontal" id="addForm" method="post" action=<%=url%>>	
      <h2>基本信息</h2>
      <%
	  
      sql = "SELECT * FROM construction WHERE ID=" & id
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
  LastID = getLastConstructionID
  call do_insert_all(LastID)
  response.redirect "view.asp?action=detail&id=" & LastID
end sub 

sub doEdit
  call do_update(FormInfo, TableName)
  url=Request.ServerVariables("HTTP_REFERER")
  urlmark=InStr(url,"&id=")
  response.redirect "view.asp?action=detail" & Mid(url,urlmark)
end sub
%>


<!--'新增条目查重及特殊字符检查，by Anran on 2016-01-22-->
<div class="modal hide fade">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>请确认是否继续</h3>
  </div>
  <div class="modal-body">
    <p>已存在该条目，是否继续添加？</p>
  </div>
  <div class="modal-footer">
    <a href="#" class="btn">关闭</a>
    <a href="#" class="btn btn-primary">Save changes</a>
  </div>
</div>

<script type="text/javascript">
  $("#menu_add").addClass("active");
  function mySubmit(){  
    $.post("isExistedForm.asp", 
		{ form:$("input[name='form']").val() }, 
		function(data,status){
			result = JSON.parse(data);
			if(result.result){
				var r = confirm('已存在该条目，是否继续添加？');
				if(!r) { 
					//alert(r);
					//e.preventDefault();
					return false;
				}else
					return true;
			}else
				return  true;
		});
  }; 
   
   $("#preadd2").bind("click",function(event){ 
   		var reg1 = /^[+,0-9a-zA-Z\u4e00-\u9fa5、]+$/;
		if(!reg1.test($("input[name='form']").val())){
			var z = confirm('该条目中包含特殊字符，是否继续添加？');
			if(!z)
				return false;
		}
   		$.post("isExistedForm.asp", 
		{ form:$("input[name='form']").val() }, 
		function(data,status){
			result = JSON.parse(data);
			if(result.result){
				var r = confirm('已存在该条目，是否继续添加？');
				if(!r) { 
					//alert(r);
					//e.preventDefault();
					return false;
				}else
					$("#addForm").submit();
			}else
				 $("#addForm").submit();
		});
  });
  
  
</script>

<!-- #include file = "footer.asp"-->