<%
'=================================
' 高级搜索数据表定义文件
' Copyright (c) CCL@PKU
' Author: Neo Ma(matengneo@gmail.com)
'=================================

' 基本信息表:Construction
dim BaseInfo(14)
BaseInfo(0) = Array("form2", "构式形式", "text", "text")     ' 使用不含+号的关键词搜索
BaseInfo(1) = Array("feature", "构式特征", "feature", "text")
BaseInfo(2) = Array("type", "构式类型", "type", "text")
BaseInfo(3) = Array("example", "构式实例", "text", "text")
BaseInfo(4) = Array("variables", "变项数量", "min-max", "num")
BaseInfo(5) = Array("constants", "常项数量", "min-max", "num")
BaseInfo(6) = Array("definition", "释义模板", "text", "text")
BaseInfo(7) = Array("derivation", "形成机制", "text", "text")
BaseInfo(8) = Array("negation", "否定形式", "text", "text")
BaseInfo(9) = Array("question", "疑问形式", "text", "text")
BaseInfo(10) = Array("synonymous", "同义(近义)构式", "id","text")
BaseInfo(11) = Array("antonym", "反义构式", "id","text")
BaseInfo(12) = Array("hypernym", "上位构式", "id","text")
BaseInfo(13) = Array("hyponym", "下位构式", "id","text")

' 变项信息表：Variable
dim VariableInfo(5)
VariableInfo(0) = Array("position", "变项序位", "min-max", "num")
VariableInfo(1) = Array("syn_cat", "句法范畴", "text", "text")
VariableInfo(2) = Array("sem_cat", "语义范畴", "text", "text")
VariableInfo(3) = Array("prg_cat", "语用范畴", "text", "text")
VariableInfo(4) = Array("alter", "可替换度", "min-max", "num") 

' 常项信息表：Constan
dim ConstantInfo(6)
ConstantInfo(0) = Array("position", "常项序位", "min-max", "num")
ConstantInfo(1) = Array("syn_cat", "句法范畴", "text", "text")
ConstantInfo(2) = Array("sem_cat", "语义范畴", "text", "text")
ConstantInfo(3) = Array("prg_cat", "语用范畴", "text", "text")
ConstantInfo(4) = Array("py", "拼音", "text", "text")
ConstantInfo(5) = Array("lex", "词性", "text", "text")

' 句法信息表：Syntax
dim SyntaxInfo(17)
SyntaxInfo(0) = Array("as_subject", "是否作主语", "yesno", "text")
SyntaxInfo(1) = Array("as_predicate", "是否作谓语", "yesno", "text")
SyntaxInfo(2) = Array("as_object", "是否作宾语", "yesno", "text")
SyntaxInfo(3) = Array("as_attribute", "是否作定语", "yesnode1", "text")
SyntaxInfo(4) = Array("as_adverbial", "是否作状语", "yesnode2", "text")
SyntaxInfo(5) = Array("as_complement", "是否作补语", "yesnode3", "text")
SyntaxInfo(6) = Array("as_preposition", "是否作介宾", "yesno", "text")
SyntaxInfo(7) = Array("with_object", "是否带宾语", "yesno", "text")
SyntaxInfo(8) = Array("with_complement", "是否带补语", "yesnode3", "text")
SyntaxInfo(9) = Array("with_de1", "是否带“的”", "yesno", "text")
SyntaxInfo(10) = Array("with_de2", "是否带“地”", "yesno", "text")
SyntaxInfo(11) = Array("joint_preceding", "联合结构前项", "yesno", "text")
SyntaxInfo(12) = Array("joint_consequent", "联合结构后项", "yesno", "text")
SyntaxInfo(13) = Array("lianwei_preceding", "连谓结构前项", "yesno", "text")
SyntaxInfo(14) = Array("lianwei_consequent", "连谓结构后项", "yesno", "text")
SyntaxInfo(15) = Array("be_sentence", "是否独立成句", "yesno", "text")
SyntaxInfo(16) = Array("bound", "是否能自由使用", "yesno", "text")

' 语义信息表：Semantic
dim SemanticInfo(4)
SemanticInfo(0) = Array("literal_meaning", "字面义", "text", "text")
SemanticInfo(1) = Array("implication", "言外之意", "text", "text")
SemanticInfo(2) = Array("presupposition", "预设", "text", "text")
SemanticInfo(3) = Array("entailment", "蕴含", "text", "text")

' 语用信息：Pragmatic
dim PragmaticInfo(4)
PragmaticInfo(0) = Array("emotional", "感情色彩", "text", "text")
PragmaticInfo(1) = Array("stylistic", "语体色彩", "text", "text")
PragmaticInfo(2) = Array("field", "领域限制", "text", "text")
PragmaticInfo(3) = Array("context", "上下文环境", "text", "text")

' 参考文献：Reference
dim ReferenceInfo(5)
ReferenceInfo(0) = Array("title", "题目","text", "text")
ReferenceInfo(1) = Array("author", "作者","text", "text")
ReferenceInfo(2) = Array("form", "类型","reference_type", "text")
ReferenceInfo(3) = Array("publish_time", "时间","text", "text")
ReferenceInfo(4) = Array("source", "来源","text", "text")

' 所有表信息
dim TableInfo(7)
TableInfo(0) = Array("基本信息", BaseInfo, "construction")
TableInfo(1) = Array("变项信息", VariableInfo, "variable")
TableInfo(2) = Array("常项信息", ConstantInfo, "constant")
TableInfo(3) = Array("句法信息", SyntaxInfo, "syntax")
TableInfo(4) = Array("语义信息", SemanticInfo, "semantic")
TableInfo(5) = Array("语用信息", PragmaticInfo, "pragmatic")
TableInfo(6) = Array("参考文献", ReferenceInfo, "reference")
%>
