<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% Session.CodePage=65001%> 
<% Response.Charset="UTF-8" %>
<% Session.Timeout=30 %>
<%
'=============================
' 公共函数及常量定义
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=============================

NUM_PER_PAGE = 10    '列表每页显示个数

'FEATURE_VALUE_ARRAY = Array("异序","错配","省略","复现","冗余","论元异常")
FEATURE_VALUE_ARRAY = Array("异序","语法错配","省略","复现","冗余","论元异常","否定","周遍","主观大量","主观小量","语义错配","修辞")  'zwd 2016-10-06
TYPE_VALUE_ARRAY = Array("半凝固型","凝固型","短语型","复句型","NULL")

'--------------------------
' 字符串str是否为空
'--------------------------
function isStrEmpty(str)
  if str = "" or str = Empty or IsEmpty(str) or IsNull(str) then
    isStrEmpty = true
  else
    isStrEmpty = false
  end if
end function


'--------------------------
' 字符串str是否在数组arr中
'--------------------------
function isInArray(arr, str)
  i = 0
  while i <= ubound(arr)
    if trim(str) = trim(arr(i)) then
      isInArray = i
      exit function 
    end if
    i = i + 1
  wend 
  isInArray = -1
end function


'==============================================
' 向数组添加元素，如JavaScript的Array.push()函数
'----------------------------------------------
' By Hybin 2018-09-20
'----------------------------------------------
Function addItems(arr, item)
  ReDim Preserve arr(UBound(arr) + 1)
  arr(UBound(arr)) = item
  addItems = arr
End Function

'-------------------------
' 获取客户端IP
'-------------------------
Function getIP() 
  dim strIP,IP_Ary,strIP_list
  strIP_list=Replace(Request.ServerVariables("HTTP_X_FORWARDED_FOR"),"'","")
  
  If InStr(strIP_list,",")<>0 Then
   IP_Ary = Split(strIP_list,",")
   strIP = IP_Ary(0)
  Else
   strIP = strIP_list
  End IF
  
  If strIP=Empty Then strIP=Replace(Request.ServerVariables("REMOTE_ADDR"),"'","")
  GetIP=strIP
End Function


'=================================
' 以下为判断用户权限函数，权限级别
' 逐级上升，上层用户拥有下层用户权限
'-------------------------
' 是否为登录用户
'-------------------------
Function isLogin()
  if isStrEmpty(session("username")) then
    isLogin = false
  else
    isLogin = true
  end if
End Function

'-------------------------
' 是否为编辑用户
'-------------------------
Function isEditor()
  if not isLogin Then
    isEditor = false
  else
    if session("userlever") < 2 then
      isEditor = false
    else
      isEditor = true
    end if
  end if
End Function

'-------------------------
Function isAdmin()
  if not isLogin Then
    isAdmin = false
  else
    if session("userlever") < 3 then
      isAdmin = false
    else 
      isAdmin = true
    end if
  end if
End Function

'这个函数可能不要了, by Dreamer on 2015-05-15
'-------------------------
' show construction feature
'-------------------------
function showFeature(value)
  str = ""

  if not isStrEmpty(value) then
    value = split(value, ",")
    if ubound(value) > -1 then
      str = Feature_VALUE_ARRAY(value(0))
    end if
    i = 1
    while i <= ubound(value)
      str = str & " | " & Feature_VALUE_ARRAY(value(i))
      i = i + 1
    wend
  end if
  showFeature = str
end function

'-------------------------
' create form
'-------------------------
' formate: (name, label, <input type>, defaut-value, special-type, help-text)
function createForm(form_info)
  count = 0
  select_count = 0
  while count < ubound(form_info)
    if form_info(count)(2) = "hidden" then %>
      <input type="hidden" name="<%=form_info(count)(0)%>" value="<%=form_info(count)(3)%>" />
 <% elseif not ((form_info(count)(0) = "variables" or form_info(count)(0) = "constants") and request("action") = "add") then %>
      <div class="control-group">
        <label class="control-label"><%=form_info(count)(1)%></label>
        <div class="controls">
          <% if form_info(count)(2) = "text" then %>
            <input type="text" name="<%=form_info(count)(0)%>" placeholder="请输入<%=form_info(count)(1)%>" class="span8" value="<%=form_info(count)(3)%>" />
          <% elseif form_info(count)(2) = "textarea" then %>
            <textarea name="<%=form_info(count)(0)%>" placeholder="请输入<%=form_info(count)(1)%>"  class="span8"><%=form_info(count)(3)%></textarea>
          <% elseif form_info(count)(2) = "multi-select" then %>
            <%
            if form_info(count)(4) = "feature" then '构式特征, by Dreamer on 2015-05-15              
		if isStrEmpty(form_info(count)(3)) Then
			value = Array()
		else
			value = split(form_info(count)(3),"|") '特征格式为：特征1||特征2, by Dreamer on 2015-05-15
		end if
		Dim i, ElementsInOneLine, j, k
		i = 0		
		j = 1
		ElementsInOneLine = 6 ' 每行显示特征个数 
		while i <= ubound(FEATURE_VALUE_ARRAY)
			if j >=  ElementsInOneLine then
				k = j mod ElementsInOneLine
			else
				k = -1
			End if
                %>
                <label class="checkbox inline">
                  <% if isInArray(value, FEATURE_VALUE_ARRAY(i)) > -1 then %>
                  <input type="checkbox" value="<%=FEATURE_VALUE_ARRAY(i)%>" name="feature" checked>
                  <% else %>
                  <input type="checkbox" value="<%=FEATURE_VALUE_ARRAY(i)%>" name="feature">
                  <% end if %>
                  <%=FEATURE_VALUE_ARRAY(i)%>
                </label>
				<%
				if k = 0 AND i < ubound(FEATURE_VALUE_ARRAY) then  
					response.write "<br>" '显示特征个数达到ElementsInOneLine时，输出一个折行，最后一行不再增加折行
				end if
				%>
                <%
                i = i + 1
				j = j + 1
              wend
            end if
            %>
          <% elseif form_info(count)(2) = "radio" then %>
            <%
            If form_info(count)(4) = "yes_or_no" then
              if isStrEmpty(form_info(count)(3)) Then
                value = ""
              else
                value = form_info(count)(3)
              end if
            %>
            <label class="radio inline">
              <input type="radio" value="是" name="<%=form_info(count)(0)%>" 
            <% if value = "是" then %>checked<%end if%>>是
            </label>
            <label class="radio inline">
              <input type="radio" value="否" name="<%=form_info(count)(0)%>" <% if value = "否" then %>checked<%end if%>>否
            </label>
            <%
            ElseIf form_info(count)(4) = "type" then '构式类型, by Dreamer on 2015-05-15
              if isStrEmpty(form_info(count)(3)) Then
                value = ""
              else
                value = form_info(count)(3)
              end If
              i = 0
              While i <= ubound(TYPE_VALUE_ARRAY)
            %>
              <label class="radio inline">
                <input type="radio" value="<%=TYPE_VALUE_ARRAY(i)%>" name="type" <%if TYPE_VALUE_ARRAY(i) = value then%>checked<%end if%>><%=TYPE_VALUE_ARRAY(i)%>
              </label>
            <%i = i + 1
              Wend
            ElseIf form_info(count)(4) = "single_or_double" then
              if isStrEmpty(form_info(count)(3)) Then
                value = ""
              else
                value = form_info(count)(3)
              end If%>
              <label class="radio inline">
                <input type="radio" value="单" name="<%=form_info(count)(0)%>" <%if value = "单" then%>checked<%end if%>>单
              </label>
              <label class="radio inline">
                <input type="radio" value="双" name="<%=form_info(count)(0)%>" <%if value = "双" then%>checked<%end if%>>双
              </label>                        
          <%End If
          elseif form_info(count)(2) = "select" then %>
            <select name="<%=form_info(count)(0)%>" class="span8">
            <%
            if form_info(count)(4) = "id" then
              sql = "SELECT ID, form FROM construction WHERE deleted is null ORDER BY form"
              set rs = Server.CreateObject("adodb.recordset")
              rs.CursorLocation = 2
              rs.open sql,Conn,1,1
              if form_info(count)(3) = "0" then
                response.write "<option value='0' selected>无</option>"
              else
                response.write "<option value='0'>无</option>"
              end if
              if not (rs.EOF or rs.BOF) then
                while not rs.EOF
                  if  form_info(count)(3) = rs("ID") then
                    	'response.write "<option value='" & rs("ID") & "' selected>" & rs("form") & "</option>"
			response.write "<option value='" & rs("form") & "' selected>" & rs("form") & "</option>"
                  else
                    	'response.write "<option value='" & rs("ID") & "'>" & rs("form") & "</option>"
			response.write "<option value='" & rs("form") & "'>" & rs("form") & "</option>"
                  end if
                  rs.moveNext
                wend
              end if
            end if
            dim checked
            if form_info(count)(4) = "reference_type" then
              %>
              <option value='论文' <%if form_info(count)(3)="论文" then response.write "selected" end if%>>论文</option>
              <option value='书籍' <%if form_info(count)(3)="书籍" then response.write "selected" end if%>>书籍</option>
              <%
            end if
            if form_info(count)(4) = "yesno" then
              %>
              <option value='否' <%if form_info(count)(3)="否" then response.write "selected" end if%>>否</option>
              <option value='是' <%if form_info(count)(3)="是" then response.write "selected" end if%>>是</option>
              <%
            end if
            if form_info(count)(4) = "yesnode1" then
              %>
              <option value='否' <%if form_info(count)(3)="否" then response.write "selected" end if%>>否</option>
              <option value='是' <%if form_info(count)(3)="是" then response.write "selected" end if%>>是</option>
              <option value='的' <%if form_info(count)(3)="的" then response.write "selected" end if%>>带“的”后可以</option>
              <%
            end if
            if form_info(count)(4) = "yesnode2" then
              %>
              <option value='否' <%if form_info(count)(3)="否" then response.write "selected" end if%>>否</option>
              <option value='是' <%if form_info(count)(3)="是" then response.write "selected" end if%>>是</option>
              <option value='地' <%if form_info(count)(3)="地" then response.write "selected" end if%>>带“地”后可以</option>
              <%
            end if
            if form_info(count)(4) = "yesnode3" then
              %>
              <option value='否' <%if form_info(count)(3)="否" then response.write "selected" end if%>>否</option>
              <option value='是' <%if form_info(count)(3)="是" then response.write "selected" end if%>>是</option>
              <option value='得' <%if form_info(count)(3)="得" then response.write "selected" end if%>>带“得”后可以</option>
              <%
            end if
            %>
            </select>
          <%
            select_count = select_count + 1 
          end if %>
          <span class="help-inline"><%=form_info(count)(5)%></span>
        </div>
      </div>
    <%
    end if
    count = count + 1
  wend
end function

'-------------------------------
' DO INSERT FROM the FORM
'-------------------------------
function do_insert(form_info, table_name)
'如果构式形式相同且相同义项编号已经存在，则不能增加新的记录 zwd 2016-10-07
'只有碰到多义构式时，才需要增加相同的构式形式的记录
    Dim Construction_Form_Checked
    Construction_Form_Checked = True 'The construction added should be a new one

    if table_name = "construction" then
        if isExistedForm(request.form("form"),request.form("yixiang")) then
            Construction_Form_Checked = False
        end if
    end if

    if Construction_Form_Checked = true then
	     sql = "INSERT INTO " & table_name & " ( "
	     values = "VALUES ( "
	     c_str = ""
	     v_str = ""
	     cons_num = 0
	     vari_num = 0
                     dedup = ""
	     '增加构式常变项组合提取，by Dreamer on 2014-12-08
	     If table_name = "construction" Then
		'提取下一个ID
		newsql = "select top 1 ID from construction order by ID desc"
		Set rs = Server.CreateObject("adodb.recordset")
		rs.CursorLocation = 3
		rs.open newsql,Conn,1,1
		cid = CInt(rs("ID")) + 1
		rs.close

		construct = Replace(request.form("form"),"，","+") '将逗号转换为加号，便于split
		construct = Replace(construct,",","+")
		items = Split(construct,"+")
		count_pos = 1
		For i = 0 To ubound(items)
		  If items(i) = "" Then
			continue
		  ElseIf Left(items(i),1) >= "A" And Left(items(i),1) <= "z" Then '变项
			conn.execute("INSERT INTO variable (construction_id,position,vstring) VALUES (" & CStr(cid) & "," & CStr(count_pos) & ",'" & items(i) & "')")
			v_str = v_str & items(i) & " "
			vari_num = vari_num + 1
			count_pos = count_pos + 1
                                                dedup = dedup & items(i)
		  Else        
			newsql = "select cat, py from syndict where lex = '" & items(i) & "'"
			rs.open newsql,Conn,1,1
			If rs.RecordCount Then
			  conn.execute("INSERT INTO constant (construction_id,position,cstring,py,pos) VALUES (" & CStr(cid) & "," & CStr(count_pos) & ",'" & items(i) & "','" & rs("py") & "','" & rs("cat") & "')")
			Else
			  conn.execute("INSERT INTO constant (construction_id,position,cstring) VALUES (" & CStr(cid) & "," & CStr(count_pos) & ",'" & items(i) & "')")
			End If
			rs.close
			c_str = c_str & items(i) & " "
			cons_num = cons_num + 1
			count_pos = count_pos + 1
                                                dedup = dedup & items(i)
		  End If
		Next
		If v_str <> "" Then
		v_str = Left(v_str,Len(v_str)-1)
		End If
		If c_str <> "" Then
		  c_str = Left(c_str,Len(c_str)-1)
		End If
	  End If
	  'End 增加构式常变项组合提取

	  count = 0
	  while count < ubound(form_info)
		if count = ubound(form_info) -1 then
		  sql = sql & form_info(count)(0)
		else
		  sql = sql & form_info(count)(0) & ", "
		end if
		
		If form_info(count)(0) = "constants" Then
		  values = values & CStr(cons_num) & ","
		ElseIf form_info(count)(0) = "variables" Then
		  values = values & CStr(vari_num) & ","
		Elseif form_info(count)(4) = "num" or form_info(count)(4) = "id" then
		  value = request.form(form_info(count)(0))
		  if isStrEmpty(value) then
			value = "0"
		  end if
		  if count = ubound(form_info) -1 then
			values = values & value
		  else
			values = values & value & ","
		  end if
		Else
		  value = request.form(form_info(count)(0))
		  if form_info(count)(0) = "feature" then
			value = Replace(value,", ","|")
		  end if
		  if count = ubound(form_info) -1 then
			values = values & "'" & value & "'"
		  else
			values = values & "'" & value & "',"
		  end If      
		End If
		count = count + 1
	  Wend
	  
	  '增加构式常变项组合提取，by Dreamer on 2014-12-08
	  If table_name = "construction" Then
		sql = sql & ", cstr, vstr, dedup"
		values = values & ",'" & c_str & "','" & v_str & "','" & dedup & "'"
	  End If

	  sql = sql & ") " & values & ")"
	  Conn.Execute sql
	  if table_name = "construction" then
		session("construction") = request.form("form")
	  end if
    else
        response.write "相同构式形式及义项编号记录已经存在，页面将在3秒后返回上一页<br>"
        response.write "<Script language='Javascript'>setTimeout('history.go(-1)',3000)</Script>"
        response.end
    end if
end function

'-------------------------------
' 添加构式基本信息后的初始化操作，
' 向其他表添加对应的空记录
' 不包括一对多记录的variable、
' constant、reference表
'-------------------------------
function do_insert_all(id)
  Conn.Execute("INSERT INTO pragmatic (construction_id) VALUES (" & id &")")
  Conn.Execute("INSERT INTO semantic (construction_id) VALUES (" & id &")")
  Conn.Execute("INSERT INTO syntax (construction_id) VALUES (" & id &")")
end function

'-------------------------------
' DO UPDATE FROM the FORM
'-------------------------------
function do_update(form_info, table_name)
  sql = "UPDATE " & table_name & " SET "
  c_str = ""
  v_str = ""
  cons_num = 0
  vari_num = 0

  Set rs = Server.CreateObject("adodb.recordset")

  
  '增加构式常变项组合提取，by Dreamer on 2014-12-08
  If table_name = "construction" Then
    rs.CursorLocation = 3
    'Conn.Execute "DELETE FROM constant WHERE construction_id=" & request.form("current_id")
    'Conn.Execute "DELETE FROM variable WHERE construction_id=" & request.form("current_id")
    construct = Replace(request.form("form"),"，","+") '将逗号转换为加号，便于split
    construct = Replace(construct,",","+")
    items = Split(construct,"+")
    count_pos = 1
    
    For i = 0 To ubound(items)
      If items(i) = "" Then
        continue
      ElseIf Left(items(i),1) >= "A" And Left(items(i),1) <= "z" Then '变项
        'conn.execute("INSERT INTO variable (construction_id,position,vstring) VALUES (" & request.form("current_id") & "," & CStr(count_pos) & ",'" & items(i) & "')")
         update_sql = "UPDATE variable SET construction_id=" & request.form("current_id") & "," & "position=" & CStr(count_pos) & "," & "vstring='" & items(i) & "'" & " where construction_id =" &  request.form("current_id") & " AND position=" & CStr(count_pos)
         'response.write "update_variable_sql=" & update_sql & "<br>"
         'response.end
         Conn.Execute update_sql
        v_str = v_str & items(i) & " "
        vari_num = vari_num + 1
        count_pos = count_pos + 1
      Else        
        newsql = "select cat, py from syndict where lex = '" & items(i) & "'"
        rs.open newsql,Conn,1,1
        If rs.RecordCount Then
          'conn.execute("INSERT INTO constant (construction_id,position,cstring,py,pos) VALUES (" & request.form("current_id") & "," & CStr(count_pos) & ",'" & items(i) & "','" & rs("py") & "','" & rs("cat") & "')")
         update_sql = "UPDATE  constant  SET construction_id=" & request.form("current_id") & "," & "position=" & CStr(count_pos) & "," & "cstring='" & items(i) & "'," & "py='" & rs("py") & "'," & "pos='" & rs("cat") & "'" & " where construction_id =" &  request.form("current_id") & " AND position=" & CStr(count_pos)
         'response.write "update_constant1_sql=" & update_sql & "<br>"
         'response.end
         Conn.Execute update_sql
        Else
          'conn.execute("INSERT INTO constant (construction_id,position,cstring) VALUES (" & request.form("current_id") & "," & CStr(count_pos) & ",'" & items(i) & "')")
         update_sql = "UPDATE  constant  SET construction_id=" & request.form("current_id") & "," & "position=" & CStr(count_pos) & "," & "cstring='" & items(i) & "'"  & " where construction_id =" &  request.form("current_id") & " AND position=" & CStr(count_pos)
         'response.write "update_constant2_sql=" & update_sql & "<br>"
         'response.end
         Conn.Execute update_sql
        End If
        rs.close
        c_str = c_str & items(i) & " "
        cons_num = cons_num + 1
        count_pos = count_pos + 1
      End If
    Next
    If v_str <> "" Then
    v_str = Left(v_str,Len(v_str)-1)
    End If
    If c_str <> "" Then
      c_str = Left(c_str,Len(c_str)-1)
    End If
  End If
  'End 增加构式常变项组合提取
  count = 0
  while count < ubound(form_info)
    newsql = "SELECT * FROM construction WHERE id = " & request.form("id")  ' zwd 2016-06-08
    'response.write "newsql=" & newsql & "<br>"
    rs.open newsql,Conn,1,1
    If rs.Eof And rs.Bof Then
	    response.write "no record found" & "<br>"
	    response.end
    end if

    If form_info(count)(0) = "constants" And rs("constants") = CInt(request.form("constants")) And rs("form") <> request.form("form") Then
      sql = sql & form_info(count)(0) &  "=" & CStr(cons_num) & ", "
    ElseIf form_info(count)(0) = "variables" And rs("variables") = CInt(request.form("variables")) And rs("form") <> request.form("form") Then
      sql = sql & form_info(count)(0) &  "=" & CStr(vari_num) & ", "
    ElseIf form_info(count)(4) = "num" or form_info(count)(4) = "id" then
      if form_info(count)(2) = "hidden" then
        value = form_info(count)(3)
      else
        value = request.form(form_info(count)(0))
      end if

      if isStrEmpty(value) then
        value = "0"
      end if
      if count = ubound(form_info) -1 then
        sql = sql & form_info(count)(0) & "=" & value
      else
        sql = sql & form_info(count)(0) &  "=" & value & ", "
      end if
    else
      if form_info(count)(2) = "hidden" then
        value = form_info(count)(3)
      else
        value = request.form(form_info(count)(0))
              if form_info(count)(0) = "feature" then
              value = Replace(value,", ","|")
            end if
      end if
      if count = ubound(form_info) -1 then
        sql = sql & form_info(count)(0) & "='" & value & "'"
      else
        sql = sql & form_info(count)(0) &  "='" & value & "', "
      end if
    End if
    rs.close
    count = count + 1
  Wend
  '增加构式常变项组合提取，by Dreamer on 2014-12-08
  If table_name = "construction" Then
    sql = sql & ", cstr='" & c_str & "', vstr='" & v_str & "'"
  End If
  sql = sql & " WHERE ID=" & request.form("current_id")
  'response.write "sql=" & sql & "<br>"
  'response.end
  Conn.Execute sql

  If table_name = "constant" Then
    rs.CursorLocation = 3
    sql = "select cstring from constant where construction_id = " & request.form("construction_id") & " order by position asc"
    rs.open sql, conn, 1, 1
    c_str = ""
    rs.MoveFirst
    While Not rs.EOF
      c_str = c_str & " " & rs("cstring")
      rs.MoveNext
    Wend
    If c_str <> "" Then
      c_str = Mid(c_str,2) '去掉首空格
      Conn.Execute "Update construction SET cstr='" & c_str & "' WHERE ID = " & request.form("construction_id")
    End If
  ElseIf table_name = "variable" Then
    rs.CursorLocation = 3
    sql = "select vstring from variable where construction_id = " & request.form("construction_id") & " order by position asc"
    rs.open sql, conn, 1, 1
    v_str = ""
    rs.MoveFirst
    While Not rs.EOF
      v_str = v_str & " " & rs("vstring")
      rs.MoveNext
    Wend
    If v_str <> "" Then
      v_str = Mid(v_str,2) '去掉首空格
      Conn.Execute "Update construction SET vstr='" & v_str & "' WHERE ID = " & request.form("construction_id")
    End If
  End If

  if rs.State<>adstateclosed then   ' zwd 2016-06-22
    rs.close
  End if
  set rs=nothing
end function

'----------------------------------------
' get the last construction id that added
'----------------------------------------
function getLastConstructionID()
  sql = "SELECT top 1 ID FROM construction WHERE username='" & session("username") & "' ORDER BY ID desc"
  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  getLastConstructionID = rs("ID")
  rs.close   ' zwd 2016-06-22
  set rs = nothing
end function


'----------------------------------------
' get user id by username
'----------------------------------------
function getUserIDByName(username)
  sql = "SELECT top 1 ID FROM user WHERE username='" & username & "'"
  set rs = Server.CreateObject("adodb.recordset")
  rs.CursorLocation = 2
  rs.open sql,Conn,1,1

  getUserIDByName = rs("ID")
  rs.close  ' zwd 2016-06-22
  set rs = nothing
end function


'----------------------------------------
' show construction list
'----------------------------------------
sub showConstructionList(rs, hasPage, urlparam, conditions)
  ' 显示构式列表
  ' rs：Construction Recordset
  '   SELECT * FROM construction  
  if not (rs.EOF or rs.BOF) then
    %>
    <h2>浏览数据库</h2>
	<% if IsArray(conditions) then %>
	<div class="search-conditions">
		<ul>
		<% For each item in conditions %>
			<li><%=item%></li>
		<% Next %>
		</ul>
	</div>
	<% end if %>
    <% if hasPage=1 then %>
    <p class="text-right muted"><%=rs.recordcount%>条结果，分<%=rs.pagecount%>页显示</p>
    <% end if %>
    <table class='table table-bordered table-hover'>
      <thead><tr>
        <th width="4%" style="text-align:center">ID</th>
        <th width="20%">构式形式</th>
        <th width="6%" style="text-align:center">义项</th>
        <th width="10%">构式类型</th>
        <th width="10%">构式特征</th> 
        <th width="20%" style="text-align:center">释义模板</th>
        <th width="20%">实例</th>
        <th width="10%" style="text-align:center">更多操作</th>
      </tr></thead>
      <tbody>
    <%
    count = 1
    while not (rs.EOF or count > rs.pagesize)
      %>
      <tr>
  <!--      <td style="text-align:center"><%=(rs.absolutepage - 1) * rs.pagesize + count%></td> -->
        <td style="text-align:center"><%=rs("id")%></td>
        <td><%=rs("form")%></td>
        <td style="text-align:center"><%=rs("yixiang")%></td>
        <td><%=rs("type")%></td>
        <td><%=rs("feature")%></td>
        <td style="text-align:left"><%=rs("definition")%></td>
        <td><%=rs("example")%></td>
        <td style="text-align:center">
          <!--跳转页面修复，by Dreamer on 2015-01-28-->
          <a href="view.asp?action=detail&id=<%=rs("ID")%>&page=<%=rs.absolutepage%>&<%=urlparam%>">详细</a>&nbsp;&nbsp;
          <%if isEditor then%>
          <!--跳转页面修复，by Dreamer on 2015-01-28-->
          <a href="javascript:if(confirm('确实要删除吗?')) location='view.asp?action=delete&id=<%=rs("ID")%>&page=<%=rs.absolutepage%>&<%=urlparam%>'">删除</a>
          <%end if%>
        </td>
      </tr>
      <%
      rs.movenext
      count = count + 1
    wend
    response.write "</tbody></table>"
  else
    response.write "<h4 class='error center'>没有找到相关构式信息</h4>"
  end if
end sub

'----------------------------------------

'----------------------------------------
' show construction list order by update_time
'----------------------------------------
sub showConstructionListOrderByUpdateTime(rs, hasPage, urlparam)
  ' 显示构式列表
  ' rs：Construction Recordset
  '   SELECT * FROM construction  
  if not (rs.EOF or rs.BOF) then
    %>
    <h2>浏览数据库</h2>
    <% if hasPage=1 then %>
    <p class="text-right muted"><%=rs.recordcount%>条结果，分<%=rs.pagecount%>页显示</p>
    <% end if %>
    <table class='table table-bordered table-hover'>
      <thead><tr>
        <th width="6%" style="text-align:center">序号</th>
        <th width="18%">构式形式</th>
        <th width="6%" style="text-align:center">义项</th>
        <th width="10%">构式类型</th>
        <th width="10%">构式特征</th>
        <th width="6%" style="text-align:center">更新时间</th>
        <th width="6%" style="text-align:center">编辑者</th>
        <th width="26%">实例</th>
        <th width="12%" style="text-align:center">更多操作</th>
      </tr></thead>
      <tbody>
    <%
    count = 1
    while not (rs.EOF or count > rs.pagesize)
      %>
      <tr>
       <!-- <td style="text-align:center"><%=(rs.absolutepage - 1) * rs.pagesize + count%></td> -->
       <td style="text-align:center"><%=rs("id")%></td>
        <td><%=rs("form")%></td>
        <td style="text-align:center"><%=rs("yixiang")%></td>
        <td><%=rs("type")%></td>
        <td><%=rs("feature")%></td>
        <td style="text-align:center"><%=rs("update_time")%></td>
        <td style="text-align:center"><%=rs("username")%></td>
        <td><%=rs("example")%></td>
        <td style="text-align:center">
          <!--跳转页面修复，by Dreamer on 2015-01-28-->
          <a href="view.asp?action=detail&id=<%=rs("ID")%>&page=<%=rs.absolutepage%>&<%=urlparam%>">详细</a>&nbsp;&nbsp;
          <%if isEditor then%>
          <!--跳转页面修复，by Dreamer on 2015-01-28-->
          <a href="javascript:if(confirm('确实要删除吗?')) location='view.asp?action=delete&id=<%=rs("ID")%>&page=<%=rs.absolutepage%>&<%=urlparam%>'">删除</a>
          <%end if%>
        </td>
      </tr>
      <%
      rs.movenext
      count = count + 1
    wend
    response.write "</tbody></table>"
  else
    response.write "<h4 class='error center'>没有找到相关构式信息</h4>"
  end if
end sub

'----------------------------------------
'----------------------------------------
' 列表分页
'----------------------------------------
sub showPagination(current_page, total_page, url)
%>
<div id="showpage"></div>
  <script>
  $(function() {
  $("#showpage").bs_pagination({
  showRowsPerPage: false,
  showRowsInfo: false,
  showRowsDefaultInfo: false,  
  currentPage: <%=current_page%>,
  rowsPerPage: <%=NUM_PER_PAGE%>,
  totalPages: <%=total_page%>,
  directURL: function(currpage){return "<%=url%>page="+currpage;},
  bootstrap_version: "2"
  });
  });</script>
<%
end Sub

'-------------------------
' 生成高级查询各数据表Form
'-------------------------
sub showSearchDetailForm(form_info, table_name)
  count = 0
  select_count = 0
  while count < ubound(form_info) %>
    <div class="control-group">
      <label class="control-label"><%=form_info(count)(1)%></label>
      <div class="controls">
        <% if form_info(count)(2) = "text" then %>
          <input type="text" name="<%=table_name & "_" & form_info(count)(0)%>" placeholder="请输入<%=form_info(count)(1)%>" class="span7" />
        <% end if %>

        <% if form_info(count)(2) = "feature" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
            <option value="">请选择<%=form_info(count)(1)%></option>
            <% i = 0
            while i <= ubound(FEATURE_VALUE_ARRAY) %>
              <option value="<%=i%>"><%=FEATURE_VALUE_ARRAY(i)%></option>
              <% i = i + 1
            wend %>
          </select>
        <% end if %>

        <% if form_info(count)(2) = "type" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
            <option value="">请选择<%=form_info(count)(1)%></option>
            <% i = 0
            while i <= ubound(TYPE_VALUE_ARRAY) %>
              <option value="<%=i%>"><%=TYPE_VALUE_ARRAY(i)%></option>
              <% i = i + 1
            wend %>
          </select>
        <% end if %>

        <% if form_info(count)(2) = "id" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
          <option value='' >未选择</option>
          <%
          	sql = "SELECT ID,form FROM construction ORDER BY form"
          	set rs = Server.CreateObject("adodb.recordset")
          	rs.CursorLocation = 2
          	rs.open sql,Conn,1,1

          	response.write "<option value='0'>无</option>"
          	if not (rs.EOF or rs.BOF) then
            		while not rs.EOF
              			'response.write "<option value='" & rs("ID") & "'>" & rs("form") & "</option>"
				response.write "<option value='" & rs("form") & "'>" & rs("form") & "</option>"
              			rs.moveNext
            		wend
          	end if
          %>
          </select>
        <% end if %>

        <% if form_info(count)(2) = "min-max" then %>
          <input type="text" class="span2" name="<%=table_name & "_" & form_info(count)(0)%>_min"/> 
          &nbsp;至&nbsp;
          <input type="text" class="span2" name="<%=table_name & "_" & form_info(count)(0)%>_max"/> 
        <% end if %>

        <% if form_info(count)(2) = "reference_type" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
          <option value='' >未选择</option>
          <option value='论文' >论文</option>
          <option value='书籍' >书籍</option>
          </select>
        <% end if %>

        <% if form_info(count)(2) = "yesno" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
          <option value='' >未选择</option>
          <option value='否' >否</option>
          <option value='是' >是</option>
          </select>
        <% end if %>

        <% if form_info(count)(2) = "yesnode1" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
          <option value='' >未选择</option>
          <option value='否' >否</option>
          <option value='是' >是</option>
          <option value='的' >带“的”后可以</option>
          </select>
        <% end if %>

        <% if form_info(count)(2) = "yesnode2" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
          <option value='' >未选择</option>
          <option value='否' >否</option>
          <option value='是' >是</option>
          <option value='地' >带“地”后可以</option>
          </select>
        <% end if %>

        <% if form_info(count)(2) = "yesnode3" then %>
          <select name="<%=table_name & "_" & form_info(count)(0)%>" class="span7">
          <option value='' >未选择</option>
          <option value='否' >否</option>
          <option value='是' >是</option>
          <option value='得' >带“得”后可以</option>
          </select>
        <% end if %>
      </div>
    </div>
    <%
    count = count + 1
  wend
end sub

%>

<%
'--------------------------
' 判断form构式形式是否已经存在
'--------------------------
function isExistedForm(str,sense)
  '------------------------------
  ' 删除str中的+号并重组，以作去重判断
  '------------------------------
	elems = Split(str, "+")
	Dim dedup
	For each elem in elems
		dedup = dedup & elem
	Next

	the_sql = "select ID from construction where dedup = '" & dedup & "' AND yixiang = " & sense & " AND deleted is null"
	Set rs = Server.CreateObject("adodb.recordset")
	rs.open the_sql, Conn, 1, 1
	count = rs.RecordCount

	if count > 0 then
		isExistedForm = True
	else
		isExistedForm = False
	end if
	
	rs.close
end function
%>
