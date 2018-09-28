<!-- #include file = "common/function.asp"-->
<!-- #include file = "common/connect.asp"-->
<!-- #include file = "common/md5.asp"-->

<%
'=================================
' ajax判断数据库是否已经存在了构式形式
' Copyright (c) CCL@PKU
' Author: Anran
'=================================
%>

<%
if not isLogin then
  response.redirect "login.asp?error=lever"
end if
dim f

 f =JSdecodeURL( Replace(request("f"),"，","+"))
 
 
 if Checkst(f)=false  then
st=1
end if
 
 

 sql="select * from construction where form='"&f&"'"


      set rs4=server.createobject("adodb.recordset")
      rs4.open sql,Conn,1,1
	
	 	 if rs4.bof and rs4.eof then'没有
		 stt=2
		 else
		  sttt=3
		 end if
	  
	  
	   rs4.close
  set rs4=nothing
  
   Response.Write(st&sttt)
  
  
  Function JSdecodeURL(ByVal oriurl)
        Err.Clear
        on error resume next
        dim sobj,outputstr
        set sobj=CreateObject("MSScriptControl.ScriptControl")
        sobj.Language="JavaScript"
        outputstr=sobj.Eval("decodeURI("""&oriurl&""")")
        set sobj=Nothing
        If Err.Number=0 then JSdecodeURL=outputstr else JSdecodeURL=oriurl
End Function



Public function Checkst(email)
  Checkst=true
  Dim Rep
  Set Rep = new RegExp
  rep.pattern="^[+,0-9a-zA-Z\u4e00-\u9fa5、]+$"
  pass=rep.Test(email)
  Set Rep=Nothing
  If not pass Then Checkst=false
 End function

  
  %>