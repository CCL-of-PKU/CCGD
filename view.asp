<!-- #include file = "header.asp"-->

<%
'=================================
' 浏览页面——显示构式信息列表及内容
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================
%>

<%
response.write "<div class='content'>"

if not isLogin then
  if request("action") = "detail" then
    call showDetail
  else  
    call showList(0) %>
    <p class='text-warning text-right'>提示：注册登录后可浏览全部构式信息，
      <a href='regist.asp'><strong>注册</strong></a>&nbsp;或&nbsp;
      <a href='login.asp'><strong>登录</strong></a>
    </p>
    <%
  end if
else
  ' Do something according to action
  select case request("action")
    case "detail"
      call showDetail
    case "delete"
      call delete
    case else
      if isAdmin AND request("display") = "all" then
         call showListByAdmin()
      else
         call showList(1)
      end if
  end select
end if
response.write "</div>"
%>

<%
sub showList(num_form)
  '显示构式列表
  'num_type：指定显示个数
  '  :0  显示最多十个构式
  '  :1  显示全部构式
  
  if num_form = 0 then
    sql = "SELECT top 10 * FROM construction "
  else
    sql = "SELECT * FROM construction "
  end If
  wheres = "WHERE deleted is null "
  order = " ORDER BY form asc"
  sql = sql & wheres & order
  'Response.write sql
  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 3
  rs.open sql,Conn,1,1

  rs.pagesize = NUM_PER_PAGE
  if num_form = 0 then
    rs.pagesize = 10
  end if
  current_page = request("page")
  if isStrEmpty(current_page) then
    current_page = 1
  else
    current_page = cint(current_page)
  end if
  rs.absolutepage = current_page
  total_page = rs.pagecount
  '跳转页面修复，by Dreamer on 2015-01-28
  call showConstructionList(rs, num_form, "", conditions)

  if num_form = 1 and total_page > 1 then
    call showPagination(current_page, total_page, "view.asp?")
  end if

  set rs = nothing
end sub
%>

<% ' zwd 2016-06-08 showlist order by update time
sub showListByAdmin()
  '显示构式列表
  'order_flag：order by field
  '  :1  order by construction form
  '  :other order by update_time

  dim sql,num_form
  num_form = 1
  sql = trim(request("sql"))
 ' Response.write sql & "<br>"
  if IsStrEmpty(sql) then
    sql = "SELECT * FROM construction WHERE deleted is null AND form in (SELECT form from construction WHERE deleted is null GROUP BY form having count(*)>1) ORDER BY form asc, yixiang asc"
  end if 
%>

<form action="view.asp?display=all" method="post">
<table>
<tr>
<td><input name="sql" type="text" style="width:700px;height:20px;" value="<%=Server.HtmlEncode(sql)%>"></td>
<td><input type="submit" value=search style='CURSOR: hand; background-color: #FFFFFF; border-color: #CCCCCC black #FF0000;border-style: solid; border-width: 0px 0px'></td></tr></table>
</form>

<%
  'Response.write "sql=" & sql & "<br>"
  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 3
  rs.open sql,Conn,1,1

 ' rs.pagesize = NUM_PER_PAGE
  rs.pagesize = 2000

  if num_form = 0 then
    rs.pagesize = 10
  end if
  current_page = request("page")
  if isStrEmpty(current_page) then
    current_page = 1
  else
    current_page = cint(current_page)
  end if
  rs.absolutepage = current_page
  total_page = rs.pagecount
  '跳转页面修复，by Dreamer on 2015-01-28
  call showConstructionListOrderByUpdateTime(rs, num_form, "")

  if total_page > 1 then
    call showPagination(current_page, total_page, "view.asp?display=all&")
  end if

  set rs = nothing
end sub
%>

<%
sub showDetail
  id = request.QueryString("id")
  page = request.QueryString("page")
  '跳转页面修复，by Dreamer on 2015-01-28
  url = request.querystring
  urlmark=InStr(url,"&id=")
  urlmark2=InStr(urlmark+1,url,"&")
  If urlmark2 > 0 Then
    urlparam = Mid(url,urlmark2)
  Else
    urlparam = ""
  End If
  'End 跳转页面修复

  if not isLogin then
    'Find if the id is in top 10, if so, redirect to login.asp
    sql = "SELECT * FROM (SELECT TOP 10 * FROM construction WHERE deleted is null ORDER BY update_time desc) WHERE ID=" & id
    set rs = Server.CreateObject("adodb.recordset")
    rs.CursorLocation = 2
    rs.open sql,Conn,1,1
    if rs.EOF or rs.BOF then
      response.redirect "login.asp?error=lever"
    end if
    set rs = nothing
  end if
  %>
  <h4 class="text-right"><a href="search.asp?action=do<%=urlparam%>">返回列表</a></h4>
  <div class="accordion" id="construction-info">
  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#base-info">
    基本信息
  </a>&nbsp;
  <% if isEditor then %>
  <a href="base.asp?action=edit&id=<%=id%><%=urlparam%>"><small>[编辑]</small></a>
  <% end if %>
  </h2>
  </div>
  <%
  sql = "SELECT * FROM construction WHERE ID=" & id
  'response.write "sql=" & sql & "<br>"
  'response.end 
  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  session("construction") = rs("form")

  dim BaseInfo(22)
  BaseInfo(0) = Array("form", "构式形式")
  '增加构式变体查询，by Dreamer on 2015-01-28
  BaseInfo(1) = Array("alter", "构式变体")
  BaseInfo(2) = Array("yixiang", "义项")
  BaseInfo(3) = Array("feature", "构式特征")
  BaseInfo(4) = Array("type", "构式类型")
  BaseInfo(5) = Array("syllable_num", "构式音节数")
  BaseInfo(6) = Array("multi_chunks", "组块数")
  BaseInfo(7) = Array("is_chunk_expand", "组块扩展")
  BaseInfo(8) = Array("example", "实例")
  BaseInfo(9) = Array("variables", "变项数量")
  BaseInfo(10) = Array("constants", "常项数量")
  BaseInfo(11) = Array("definition", "释义模板")
  BaseInfo(12) = Array("derivation", "形成机制")
  BaseInfo(13) = Array("negation", "否定形式")
  BaseInfo(14) = Array("question", "疑问形式")
  BaseInfo(15) = Array("synonymous", "同义(近义)构式")
  BaseInfo(16) = Array("antonym", "反义构式")
  BaseInfo(17) = Array("hypernym", "上位构式")
  BaseInfo(18) = Array("hyponym", "下位构式")
  BaseInfo(19) = Array("remark", "备注")
  BaseInfo(20) = Array("update_time", "更新时间")
  BaseInfo(21) = Array("username", "修改者")
  %>
  <div id="base-info" class="accordion-body collapse in">
  <div class="accordion-inner">
  <table class="table table-hover table-bordered">
    <tbody>
      <% 
      count = 0
      while count<ubound(BaseInfo)
        'if not isStrEmpty(rs(BaseInfo(count)(0))) then
          response.write "<tr>"
          response.write "<td>" & BaseInfo(count)(1) & "</td>"          
            if count = 2 then
              'response.write "<td>" & showFeature(rs(BaseInfo(count)(0))) & "</td>"  ' zwd 2016-06-08 delete
               response.write "<td>" & rs(BaseInfo(count)(0)) & "</td>"		 ' zwd 2016-06-08 add
            ElseIf count = 3 Then
			  fea = rs(BaseInfo(count)(0))
			  For i = 0 To Ubound(FEATURE_VALUE_ARRAY)
			     fea = Replace(fea,CStr(i),FEATURE_VALUE_ARRAY(i))			  
			  Next
			  response.write "<td>" & fea & "</td>"
            Else
              response.write "<td>" & rs(BaseInfo(count)(0)) & "</td>"
            end if
          response.write "</tr>"
        'end if
        count = count + 1
      wend
      set rs = nothing 
      %>
    </tbody>
  </table>
  </div>
  </div>
  </div>

  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#variable-info">
    变项信息
  </a>&nbsp;
<%
' 2018-07-29 zwd
' 变项、常项信息的“添加”按钮没有必要。只需要点击变项、常项信息后，进入“编辑”各项信息的页面
%>
  <!-- <% if isEditor then %>
 <a href="variable.asp?action=add&id=<%=id%><%=urlparam%>"><small>[添加]</small></a>
  <% end if %>
  --></h2>
  </div>
  <%
  sql = "SELECT * FROM variable WHERE construction_id=" & id & " ORDER BY position asc"

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  %>
  <div id="variable-info" class="accordion-body collapse">
  <div class="accordion-inner">
  <%
  if rs.EOF or rs.BOF then
    set rs = nothing
    response.write "<span class='text-error'>暂时没有变项信息</span>"
  else
    dim VariableInfo(5)
    VariableInfo(0) = Array("vstring", "变项")
    VariableInfo(1) = Array("position", "序位")
    VariableInfo(2) = Array("syn_cat", "句法范畴")
    VariableInfo(3) = Array("sem_cat", "语义范畴")
    VariableInfo(4) = Array("prg_cat", "语用范畴")
    VariableInfo(5) = Array("alter", "可替换度")
    %>
    <table class="table table-hover table-bordered">
      <thead>
        <tr>
          <%
          count = 0
          while count<ubound(VariableInfo)
            response.write "<th>" & VariableInfo(count)(1) & "</th>"
            count = count + 1
          wend
          if isEditor then
            response.write "<th>操作</th>"
          end if
          %>
        </tr>
      </thead>
      <tbody>
        <% 
        while not rs.EOF
          count = 0
          response.write "<tr>"
          while count<ubound(VariableInfo)
            response.write "<td>" & rs(VariableInfo(count)(0)) & "</td>"
            count = count + 1
          wend
          if isEditor then 
            response.write "<td><a href='variable.asp?action=edit&current_id=" & rs("ID") & "&id=" & id & urlparam & "'><small>[编辑]</small></a> "
			response.write "<a href=""javascript:if(confirm('确实要删除吗?')) location='variable.asp?action=delete&id=" & id & "&current_id=" & rs("ID") & "'""><small>[删除]</small></a></td>"
          end if
          response.write "</tr>"
          rs.movenext
        wend
        set rs = nothing 
        %>
      </tbody>
    </table>
  <% end if %>
  </div>
  </div>
  </div>
  
  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#constant-info">
    常项信息
  </a>&nbsp;
  <!--<% if isEditor then %>
  <a href="constant.asp?action=add&id=<%=id%><%=urlparam%>"><small>[添加]</small></a>
  <% end if %>
  --></h2>
  </div>
  <%
  sql = "SELECT * FROM constant WHERE construction_id=" & id & " ORDER BY position asc"

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  %>
  <div id="constant-info" class="accordion-body collapse">
  <div class="accordion-inner">
  <%
  if rs.EOF or rs.BOF then
    set rs = nothing
    response.write "<span class='text-error'>暂时没有常项信息</span>"
  else
    dim ConstantInfo(7)  ' zwd 2016-06-08  ConstantInfo(6) -> ConstantInfo(7)
    ConstantInfo(0) = Array("cstring", "常项")
    ConstantInfo(1) = Array("py", "拼音")
    ConstantInfo(2) = Array("pos", "词性")
    ConstantInfo(3) = Array("position", "序位")
    ConstantInfo(4) = Array("syn_cat", "句法范畴")
    ConstantInfo(5) = Array("sem_cat", "语义范畴")
    ConstantInfo(6) = Array("prg_cat", "语用范畴")
    
    %>
    <table class="table table-hover table-bordered">
      <thead>
        <tr>
          <%
          count = 0
          while count<ubound(ConstantInfo)
            response.write "<th>" & ConstantInfo(count)(1) & "</th>"
            count = count + 1
          wend
          if isEditor then
            response.write "<th>操作</th>"
          end if
          %>
        </tr>
      </thead>
      <tbody>
        <% 
        while not rs.EOF
          count = 0
          response.write "<tr>"
          while count<ubound(ConstantInfo)
            response.write "<td>" & rs(ConstantInfo(count)(0)) & "</td>"
            count = count + 1
          wend
          if isEditor then 
            response.write "<td><a href='constant.asp?action=edit&current_id=" & rs("ID") & "&id=" & id & urlparam & "'><small>[编辑]</small></a> "
			response.write "<a href=""javascript:if(confirm('确实要删除吗?')) location='constant.asp?action=delete&id=" & id & "&current_id=" & rs("ID") & "'""><small>[删除]</small></a></td>"
          end if
          response.write "</tr>"
          rs.movenext
        wend
        set rs = nothing 
        %>
      </tbody>
    </table>
  <% end if %>
  </div>
  </div>
  </div>

  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#variable-constant">
    项间关系
  </a>&nbsp;
  <% if isEditor then %>
  <a href="relations.asp?action=edit&id=<%=id%><%=urlparam%>"><small>[编辑]</small></a>&nbsp;&nbsp;
  <a href="relations.asp?action=delete&id=<%=id%><%=urlparam%>"><small>[删除]</small></a>
  <% end if %>
  </h2>
  </div>
  <%
  sql = "SELECT * FROM variable_constant WHERE construction_id=" & id

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  %>
  <div id="variable-constant" class="accordion-body collapse">
  <div class="accordion-inner">
  <%
  if rs.EOF or rs.BOF then
    set rs = nothing
    response.write "<span class='text-error'>暂时没有项间关系信息</span>"
  else
    dim relationInfo(3)
    relationInfo(0) = Array("var_var", "变项间关系")
    relationInfo(1) = Array("var_con", "变项-常项间关系")
    relationInfo(2) = Array("chunk_chunk", "组块间关系")
    
    %>
    <table class="table table-hover table-bordered">
      <tbody>
        <% 
        while not rs.EOF
          count = 0
          while count<ubound(relationInfo)
            response.write "<tr>"
            response.write "<td>" & relationInfo(count)(1) & "</td>"
            response.write "<td>" & rs(relationInfo(count)(0)) & "</td>"
            response.write "</tr>"
            count = count + 1
          wend
          rs.movenext
        wend
        set rs = nothing 
        %>
      </tbody>
    </table>
  <% end if %>
  </div>
  </div>
  </div>

  <%
  sql = "SELECT * FROM syntax WHERE construction_id=" & id

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1
  %>
  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#syntax-info">
    句法信息
  </a>&nbsp;
  <% if isEditor then %>
  <a href="syntax.asp?action=edit&id=<%=id%><%=urlparam%>"><small>[编辑]</small></a>
  <% end if %>
  </h2>
  </div>
  <%
  dim SyntaxInfo(15)
  SyntaxInfo(0) = Array("as_subject", "是否做主语")
  SyntaxInfo(1) = Array("as_predicate", "是否做谓语")
  SyntaxInfo(2) = Array("as_object", "是否作宾语")
  SyntaxInfo(3) = Array("as_attribute", "是否做定语")
  SyntaxInfo(4) = Array("as_adverbial", "是否做状语")
  SyntaxInfo(5) = Array("as_complement", "是否做补语")
  SyntaxInfo(6) = Array("as_preposition", "是否做介宾")
  SyntaxInfo(7) = Array("with_object", "是否带宾语")
  SyntaxInfo(8) = Array("with_complement", "是否带补语")
  SyntaxInfo(9) = Array("with_de1", "是否带“的”")
  SyntaxInfo(10) = Array("with_de2", "是否带“地”")
  SyntaxInfo(11) = Array("joint_preceding", "联合结构前项")
  SyntaxInfo(12) = Array("joint_consequent", "联合结构后项")
  SyntaxInfo(13) = Array("lianwei_preceding", "连谓结构前项")
  SyntaxInfo(14) = Array("lianwei_consequent", "连谓结构后项")
  %>
  <div id="syntax-info" class="accordion-body collapse">
  <div class="accordion-inner">
  <table class="table table-hover table-bordered">
    <tbody>
      <% 
      count = 0
      while count<ubound(SyntaxInfo)
        'if not isStrEmpty(rs(SyntaxInfo(count)(0))) then
          response.write "<tr>"
          response.write "<td>" & SyntaxInfo(count)(1) & "</td>"
          response.write "<td>" & rs(SyntaxInfo(count)(0)) & "</td>"
          response.write "</tr>"
        'end if
        count = count + 1
      wend
      set rs = nothing 
      %>
    </tbody>
  </table>
  </div>
  </div>
  </div>

  <%
  sql = "SELECT * FROM semantic WHERE construction_id=" & id

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1
  %>
  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#semantic-info">
    语义信息
  </a>&nbsp;
  <% if isEditor then %>
  <a href="semantic.asp?action=edit&id=<%=id%><%=urlparam%>"><small>[编辑]</small></a>
  <% end if %>
  </h2>
  </div>
  <%
  dim SemanticInfo(4)
  SemanticInfo(0) = Array("literal_meaning", "字面义")
  SemanticInfo(1) = Array("implication", "言外之意")
  SemanticInfo(2) = Array("presupposition", "预设")
  SemanticInfo(3) = Array("entailment", "蕴含")
  %>
  <div id="semantic-info" class="accordion-body collapse">
  <div class="accordion-inner">
  <table class="table table-hover table-bordered">
    <tbody>
      <% 
      count = 0
      while count<ubound(SemanticInfo)
        'if not isStrEmpty(rs(SemanticInfo(count)(0))) then
          response.write "<tr>"
          response.write "<td>" & SemanticInfo(count)(1) & "</td>"
          response.write "<td>" & rs(SemanticInfo(count)(0)) & "</td>"
          response.write "</tr>"
        'end if
        count = count + 1
      wend
      set rs = nothing 
      %>
    </tbody>
  </table>
  </div>
  </div>
  </div>
  
  <%
  sql = "SELECT * FROM pragmatic WHERE construction_id=" & id

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1
  %>
  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#pragmatic-info">
    语用信息
  </a>&nbsp;
  <% if isEditor then %>
  <a href="pragmatic.asp?action=edit&id=<%=id%><%=urlparam%>"><small>[编辑]</small></a>
  <% end if %>
  </h2>
  </div>
  <%
  dim PragmaticInfo(3)
  PragmaticInfo(0) = Array("emotional", "感情色彩")
  PragmaticInfo(1) = Array("stylistic", "语体色彩")
  PragmaticInfo(2) = Array("field", "领域限制")
  %>
  <div id="pragmatic-info" class="accordion-body collapse">
  <div class="accordion-inner">
  <table class="table table-hover table-bordered">
    <tbody>
      <% 
      count = 0
      while count<ubound(PragmaticInfo)
        'if not isStrEmpty(rs(PragmaticInfo(count)(0))) then
          response.write "<tr>"
          response.write "<td>" & PragmaticInfo(count)(1) & "</td>"
          response.write "<td>" & rs(PragmaticInfo(count)(0)) & "</td>"
          response.write "</tr>"
        'end if
        count = count + 1
      wend
      set rs = nothing 
      %>
    </tbody>
  </table>
  </div>
  </div>
  </div>

  <div class="accordion-group">
  <div class="accordion-heading">
  <h2 class="detail-topic accordion-toggle">
  <a data-toggle="collapse" href="#reference-info">
    参考文献
  </a>&nbsp;
  <% if isEditor then %>
  <a href="reference.asp?action=add&id=<%=id%><%=urlparam%>"><small>[添加]</small></a>
  <% end if %>
  </h2>
  </div>
  <%
  sql = "SELECT * FROM reference WHERE construction_id=" & id

  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  %>
  <div id="reference-info" class="accordion-body collapse">
  <div class="accordion-inner">
  <%
  if rs.EOF or rs.BOF then
    set rs = nothing
    response.write "<span class='text-error'>暂时没有参考文献信息</span>"
  else
    dim ReferenceInfo(5)
    ReferenceInfo(0) = Array("title", "题目")
    ReferenceInfo(1) = Array("author", "作者")
    ReferenceInfo(2) = Array("type", "类型")
    ReferenceInfo(3) = Array("publish_time", "时间")
    ReferenceInfo(4) = Array("source", "来源")
    %>
	<!--显示摘要及关键词，by Dreamer on 2015-01-13-->
	<script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript">
        $(function () {
            //展开与折叠表格
            $("tr.parent").css("cursor","pointer")//添加一个样式
                            .click(function(){//得到所在的那行表格并添加单击事件
                            $(this).siblings(".child_" + this.id).toggle(); //隐藏/显示所谓的子行
							}).click();
			});
    
    </script>
	<!--end 显示摘要及关键词-->
    <table class="table table-hover table-bordered">
      <thead>
        <tr>
          <%
          count = 0
          while count<ubound(ReferenceInfo)
            response.write "<th>" & ReferenceInfo(count)(1) & "</th>"
            count = count + 1
          wend
          if isEditor then
            response.write "<th>操作</th>"
          end if
          %>
        </tr>
      </thead>
      <tbody>
        <% 
	    detail_count = 0
        while not rs.EOF
		  detail_count = detail_count + 1
          count = 0
          response.write "<tr class = ""parent"" id = ""row_" & CStr(detail_count) & """>"
          while count<ubound(ReferenceInfo)
		    If count = 0 Or count = 4 Then
              response.write "<td style=""width:230px"">" & rs(ReferenceInfo(count)(0)) & "</td>"
			Else If count = 1 Then
			  response.write "<td style=""width:100px"">" & rs(ReferenceInfo(count)(0)) & "</td>"
			Else
			  response.write "<td style=""width:50px"">" & rs(ReferenceInfo(count)(0)) & "</td>"			
			End If
			End If
            count = count + 1
          wend
          if isEditor then 
           response.write "<td><a href='reference.asp?action=edit&current_id=" & rs("ID") & "&id=" & id & urlparam & "'><small>[编辑]</small></a> "
		   response.write "<a href=""javascript:if(confirm('确实要删除吗?')) location='reference.asp?action=delete&id=" & id & "&current_id=" & rs("ID") & "'""><small>[删除]</small></a></td>"
          end if
          response.write "</tr>"
		  Response.write "<tr class = ""child_row_" & CStr(detail_count) & """><th>摘要</th><td colspan = 5>" & rs("abstract") & "</td></tr>"
		  Response.write "<tr class = ""child_row_" & CStr(detail_count) & """><th>关键词</th><td colspan = 5>" & rs("keyword") & "</td></tr>"
          rs.movenext
        wend
        set rs = nothing 
        %>
      </tbody>
    </table>
  <% end if %>
  </div>
  </div>
  </div>

  </div>
  <h4 class="text-right"><a href="search.asp?action=do<%=urlparam%>">返回列表</a></h4>
<% end sub %>

<%
sub delete
  '跳转页面修复，by Dreamer on 2015-01-28
  url = Replace(request.querystring,"%","%25")
  url = Replace(url,"+","%2B")
  urlmark=InStr(url,"&id=")
  urlmark2=InStr(urlmark+1,url,"&")
  If urlmark2 > 0 Then
    urlparam = Mid(url,urlmark2)
  Else
    urlparam = ""
  End If
  'End 跳转页面修复

  'Conn.Execute "DELETE FROM construction WHERE ID=" & request.QueryString("id")
  'Conn.Execute "DELETE FROM constant WHERE construction_id=" & request.QueryString("id")
  'Conn.Execute "DELETE FROM variable WHERE construction_id=" & request.QueryString("id")
  'Conn.Execute "DELETE FROM pragmatic WHERE construction_id=" & request.QueryString("id")
  'Conn.Execute "DELETE FROM reference WHERE construction_id=" & request.QueryString("id")
  'Conn.Execute "DELETE FROM semantic WHERE construction_id=" & request.QueryString("id")
  'Conn.Execute "DELETE FROM syntax WHERE construction_id=" & request.QueryString("id")
  Conn.Execute "UPDATE construction SET deleted = 'Y' WHERE ID = " & request.QueryString("id")
  'call showList(0)
  response.write "<script>alert('条目已删除！');window.location='search.asp?action=do" & urlparam & "'</script>;"
end sub
%>

<script type="text/javascript">
  $("#menu_view").addClass("active");
</script>
<!-- #include file = "footer.asp"-->
