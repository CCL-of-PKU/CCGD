<!-- #include file = "header.asp"-->

<div class="content">
	<!--构式特征数量统计，by Dreamer on 2015-04-08-->
	<!--该特征限于异序、错配、省略、复现，若有新特征需要重做该部分代码-->
	<center>
	<div class="row feature-show" style="width:700px">
	  <h3 align="center">构式特征数量统计</h3>
	  <center>
	  <button class="btn" id="btn_fea_all" onclick="fea_all()">全部构式</button>
	  <button class="btn" id="btn_fea_ss" onclick="fea_semisolid()">仅半凝固型构式</button>
	  <button class="btn" id="btn_fea_so" onclick="fea_solid()">仅凝固型构式</button>
	  <button class="btn" id="btn_fea_ph" onclick="fea_phrase()">仅短语型构式</button>
	  <button class="btn" id="btn_fea_mc" onclick="fea_multiclause()">仅复句型构式</button>
	  </center>
	  <div id="feature">	  
	  </div>
	</div>
	<!--End 构式特征数量统计-->
	<hr/>
	<!--变项统计，by Dreamer on 2015-04-11-->
	<div class="row variable-show" style="width:900px">
	  <h3 align="center">构式变项数量统计</h3>	  
	  <center>
	  <button class="btn" id="btn_var_all" onclick="var_all()">全部构式</button>
	  <button class="btn" id="btn_var_ss" onclick="var_semisolid()">仅半凝固型构式</button>
	  <button class="btn" id="btn_var_so" onclick="var_solid()">仅凝固型构式</button>
	  <button class="btn" id="btn_var_ph" onclick="var_phrase()">仅短语型构式</button>
	  <button class="btn" id="btn_var_mc" onclick="var_multiclause()">仅复句型构式</button><br><br>
	  <button class="btn" id="btn_var_freq" onclick="change_to_freq('variable')">频次序</button>
	  <button class="btn" id="btn_var_dic" onclick="change_to_dic('variable')">字典序</button>	  
	  </center>	  
	  <div id="variable">	  
	  </div>
	</div>
	</center>
	<!--End 变项统计 -->
	<hr/>
	<!--常项统计，by Dreamer on 2015-04-11-->
	<div class="row constant-show" style="width:900px">
	  <h3 align="center">构式常项数量统计</h3>	  
	  <center>
	  <button class="btn" id="btn_con_all" onclick="con_all()">全部构式</button>
	  <button class="btn" id="btn_con_ss" onclick="con_semisolid()">仅半凝固型构式</button>
	  <button class="btn" id="btn_con_so" onclick="con_solid()">仅凝固型构式</button>
	  <button class="btn" id="btn_con_ph" onclick="con_phrase()">仅短语型构式</button>
	  <button class="btn" id="btn_con_mc" onclick="con_multiclause()">仅复句型构式</button><br><br>
	  <button class="btn" id="btn_con_freq" onclick="change_to_freq('constant')">频次序</button>
	  <button class="btn" id="btn_con_dic" onclick="change_to_dic('constant')">字典序</button>	  
	  </center>
	  <div id="constant">
	  </div>
	</div>
	<!--End 常项统计 -->
	<hr/>
	
</div>
<script type="text/javascript">
var con_cons_type="all", con_rank_type="freq",
var_cons_type="all", var_rank_type="freq";
function loadXMLDoc(eid,url){
	var xmlhttp;
	if (window.XMLHttpRequest)
	{// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else
	{// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			document.getElementById(eid).innerHTML=xmlhttp.responseText;
		}
		else if (xmlhttp.readyState==4)
		{
			document.getElementById(eid).innerHTML="<br>暂无查询结果<br>"
		}
	}
	xmlhttp.open("GET",url,true);
	xmlhttp.send();
}
function fea_all(){
	$("#btn_fea_all").addClass("btn-info active");
	$("#btn_fea_ss").removeClass("btn-info active");
	$("#btn_fea_so").removeClass("btn-info active");
	$("#btn_fea_ph").removeClass("btn-info active");
	$("#btn_fea_mc").removeClass("btn-info active");
	loadXMLDoc("feature","stats.asp?stat=feature");
}
function fea_semisolid(){
	$("#btn_fea_ss").addClass("btn-info active");
	$("#btn_fea_all").removeClass("btn-info active");
	$("#btn_fea_so").removeClass("btn-info active");
	$("#btn_fea_ph").removeClass("btn-info active");
	$("#btn_fea_mc").removeClass("btn-info active");
	loadXMLDoc("feature","stats.asp?stat=feature&cons_type=半凝固型");
}
function fea_solid(){
	$("#btn_fea_so").addClass("btn-info active");
	$("#btn_fea_ss").removeClass("btn-info active");
	$("#btn_fea_all").removeClass("btn-info active");
	$("#btn_fea_ph").removeClass("btn-info active");
	$("#btn_fea_mc").removeClass("btn-info active");
	loadXMLDoc("feature","stats.asp?stat=feature&cons_type=凝固型");
}
function fea_phrase(){
	$("#btn_fea_ph").addClass("btn-info active");
	$("#btn_fea_so").removeClass("btn-info active");
	$("#btn_fea_ss").removeClass("btn-info active");
	$("#btn_fea_all").removeClass("btn-info active");
	$("#btn_fea_mc").removeClass("btn-info active");
	loadXMLDoc("feature","stats.asp?stat=feature&cons_type=短语型");
}
function fea_multiclause(){
	$("#btn_fea_mc").addClass("btn-info active");
	$("#btn_fea_so").removeClass("btn-info active");
	$("#btn_fea_ss").removeClass("btn-info active");
	$("#btn_fea_ph").removeClass("btn-info active");
	$("#btn_fea_all").removeClass("btn-info active");
	loadXMLDoc("feature","stats.asp?stat=feature&cons_type=复句型");
}
function var_all(){
	$("#btn_var_all").addClass("btn-info active");
	$("#btn_var_ss").removeClass("btn-info active");
	$("#btn_var_so").removeClass("btn-info active");
	$("#btn_var_ph").removeClass("btn-info active");
	$("#btn_var_mc").removeClass("btn-info active");
	if (var_rank_type == "freq")
	{
		loadXMLDoc("variable","stats.asp?stat=variable");
	}
	else
	{
		loadXMLDoc("variable","stats.asp?stat=variable&rank_type=dic");
	}
	
	var_cons_type="";

}
function var_semisolid(){	
	$("#btn_var_ss").addClass("btn-info active");
	$("#btn_var_ph").removeClass("btn-info active");
	$("#btn_var_so").removeClass("btn-info active");
	$("#btn_var_all").removeClass("btn-info active");
	$("#btn_var_mc").removeClass("btn-info active");
	if (var_rank_type == "freq")
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=半凝固型");
	}
	else
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=半凝固型&rank_type=dic");
	}
	
	var_cons_type="半凝固型";
}
function var_solid(){	
	$("#btn_var_so").addClass("btn-info active");
	$("#btn_var_ph").removeClass("btn-info active");
	$("#btn_var_ss").removeClass("btn-info active");
	$("#btn_var_all").removeClass("btn-info active");
	$("#btn_var_mc").removeClass("btn-info active");
	if (var_rank_type == "freq")
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=凝固型");
	}
	else
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=凝固型&rank_type=dic");
	}
	
	var_cons_type="凝固型";
}
function var_phrase(){	
	$("#btn_var_ph").addClass("btn-info active");
	$("#btn_var_ss").removeClass("btn-info active");
	$("#btn_var_so").removeClass("btn-info active");
	$("#btn_var_all").removeClass("btn-info active");
	$("#btn_var_mc").removeClass("btn-info active");
	if (var_rank_type == "freq")
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=短语型");
	}
	else
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=短语型&rank_type=dic");
	}
	
	var_cons_type="短语型";
}
function var_multiclause(){		
	$("#btn_var_mc").addClass("btn-info active");
	$("#btn_var_ss").removeClass("btn-info active");
	$("#btn_var_so").removeClass("btn-info active");
	$("#btn_var_ph").removeClass("btn-info active");
	$("#btn_var_all").removeClass("btn-info active");
	if (var_rank_type == "freq")
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=复句型");
	}
	else
	{
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type=复句型&rank_type=dic");
	}	
	var_cons_type="复句型";
}
function con_all(){
	$("#btn_con_all").addClass("btn-info active");
	$("#btn_con_ss").removeClass("btn-info active");
	$("#btn_con_so").removeClass("btn-info active");
	$("#btn_con_ph").removeClass("btn-info active");
	$("#btn_con_mc").removeClass("btn-info active");
	if (con_rank_type == "freq")
	{
		loadXMLDoc("constant","stats.asp?stat=constant");
	}
	else
	{
		loadXMLDoc("constant","stats.asp?stat=constant&rank_type=dic");
	}
	con_cons_type="";	
}
function con_semisolid(){	
	$("#btn_con_ss").addClass("btn-info active");
	$("#btn_con_all").removeClass("btn-info active");
	$("#btn_con_so").removeClass("btn-info active");
	$("#btn_con_ph").removeClass("btn-info active");
	$("#btn_con_mc").removeClass("btn-info active");
	if (con_rank_type == "freq")
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=半凝固型");
	}
	else
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=半凝固型&rank_type=dic");
	}
	con_cons_type="半凝固型";	
}
function con_solid(){	
	$("#btn_con_so").addClass("btn-info active");
	$("#btn_con_all").removeClass("btn-info active");
	$("#btn_con_ss").removeClass("btn-info active");
	$("#btn_con_ph").removeClass("btn-info active");
	$("#btn_con_mc").removeClass("btn-info active");
	if (con_rank_type == "freq")
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=凝固型");
	}
	else
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=凝固型&rank_type=dic");
	}
	con_cons_type="凝固型";	
}
function con_phrase(){
	$("#btn_con_ph").addClass("btn-info active");
	$("#btn_con_ss").removeClass("btn-info active");
	$("#btn_con_so").removeClass("btn-info active");
	$("#btn_con_all").removeClass("btn-info active");
	$("#btn_con_mc").removeClass("btn-info active");
	if (con_rank_type == "freq")
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=短语型");
	}
	else
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=短语型&rank_type=dic");
	}
	con_cons_type="短语型";	
}
function con_multiclause(){
	$("#btn_con_mc").addClass("btn-info active");
	$("#btn_con_ss").removeClass("btn-info active");
	$("#btn_con_so").removeClass("btn-info active");
	$("#btn_con_ph").removeClass("btn-info active");
	$("#btn_con_all").removeClass("btn-info active");
	if (con_rank_type == "freq")
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=复句型");
	}
	else
	{
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type=复句型&rank_type=dic");
	}
	con_cons_type="复句型";	
}
function change_to_freq(stat){
	if (stat == "variable")
	{
		$("#btn_var_freq").addClass("btn-info active");
		$("#btn_var_dic").removeClass("btn-info active");
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type="+var_cons_type+"&rank_type=freq");
		var_rank_type = "freq";
	}
	else
	{
		$("#btn_con_freq").addClass("btn-info active");
		$("#btn_con_dic").removeClass("btn-info active");
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type="+con_cons_type+"&rank_type=freq");
		con_rank_type = "freq";
	}
}
function change_to_dic(stat){
	if (stat == "variable")
	{
		$("#btn_var_dic").addClass("btn-info active");
		$("#btn_var_freq").removeClass("btn-info active");
		loadXMLDoc("variable","stats.asp?stat=variable&cons_type="+var_cons_type+"&rank_type=dic");
		var_rank_type = "dic";
	}
	else
	{
		$("#btn_con_dic").addClass("btn-info active");
		$("#btn_con_freq").removeClass("btn-info active");
		loadXMLDoc("constant","stats.asp?stat=constant&cons_type="+con_cons_type+"&rank_type=dic");
		con_rank_type = "dic";
	}
}
$("#menu_stat").addClass("active");
fea_all();
var_all();
con_all();
$("#btn_var_freq").addClass("btn-info active");
$("#btn_con_freq").addClass("btn-info active");
</script>
<!-- #include file = "footer.asp"-->