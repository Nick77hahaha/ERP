<%
Utils u = new Utils(request);
try {
	String act = u.getStringParam("act");
	
	StringBuffer sql = null;
	ResultSet rs = null, rs1 = null;
	String queryDiPQGDH = u.getStringParam("queryDiPQGDH");
	String queryQingGRY = u.getStringParam("queryQingGRY");
	String queryPartno = u.getStringParam("queryPartno");
	String queryStartQingGRQ = u.getStringParam("queryStartQingGRQ");
	String queryEndQingGRQ = u.getStringParam("queryEndQingGRQ");
	String queryBiS = u.getStringParam("queryBiS", "50");
	if (act.equals("retQuery") || u.getStringParam("pageQuery").equals("pageQuery")) {
		queryDiPQGDH = new String(queryDiPQGDH.getBytes("iso-8859-1"), "utf-8");
		queryQingGRY = new String(queryQingGRY.getBytes("iso-8859-1"), "utf-8");
		queryPartno = new String(queryPartno.getBytes("iso-8859-1"), "utf-8");
		queryStartQingGRQ = new String(queryStartQingGRQ.getBytes("iso-8859-1"), "utf-8");
		queryEndQingGRQ = new String(queryEndQingGRQ.getBytes("iso-8859-1"), "utf-8");
		queryBiS = new String(queryBiS.getBytes("iso-8859-1"), "utf-8");
	} else if (act.equals("")) {
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/misc/utils.jsp"%>
<script type="text/javascript">
$(function() {
	$('#chaX').click(function() {
		pop_out_loading($('#div_loading'));
		$('#act').val('query');
		$('form').submit();
	});
	Lock_FirstRow('dataTable');
})
</script>
</head>
<body>
<form method="post" action="mm0001q.jsp">
<div align="center">
  <table width="100%" border="1" cellpadding="1" cellspacing="1" bordercolor="#000000">
    <tr>
      <td bgcolor="#FFFFFF" align="center"><%=u.getI18n(u, "caiG")%>-<%=u.getI18n(u, "diPQGSY")%></td>
	</tr>
  </table>
  <br/>
  <%=u.getI18n(u, "diPQGDH")%>(key):
  <input type="text" id="queryDiPQGDH" name="queryDiPQGDH" size="10" value="<%=queryDiPQGDH%>"/>
  <%=u.getI18n(u, "qingGRY")%>:
  <u:select name="queryQingGRY" u="<%=u%>" sql="<%=u.getDDLHr0002YuanGBHAll().toString()%>" value="<%=queryQingGRY%>"></u:select>
  <u:integer name="queryBiS" value="<%=queryBiS%>" min="1" max="100" size="3"/>/<%=u.getI18n(u, "ye")%>
  <br/>
  <%=u.getI18n(u, "產品編號")%>(key):
  <input type="text" id="queryPartno" name="queryPartno" size="10" value="<%=queryPartno%>"/>
  <%=u.getI18n(u, "qingGRQ")%>:
  <u:dateInput name="queryStartQingGRQ" value="<%=queryStartQingGRQ%>"/>-<u:dateInput name="queryEndQingGRQ" value="<%=queryEndQingGRQ%>"/>
  <br/>
  <br/>
  <input type="button" id="chaX" name="chaX" value="<%=u.getI18n(u, "chaX")%>">
  <a href="mm0002e.jsp?act=new&mm0001Sn=0&queryDiPQGDH=<%=u.unescape(queryDiPQGDH)%>&queryQingGRY=<%=u.unescape(queryQingGRY)%>&queryPartno=<%=u.unescape(queryPartno)%>&queryStartQingGRQ=<%=u.unescape(queryStartQingGRQ)%>&queryEndQingGRQ=<%=u.unescape(queryEndQingGRQ)%>&queryBiS=<%=u.unescape(queryBiS)%>"><%=u.getI18n(u, "xinZ")%></a>
  <br/>
  <br/>
<%
	if (!act.equals("")) {
		String partnoJH = "";
		sql = new StringBuffer("select top ");
		sql.append(queryBiS);
		sql.append(" a.sn, a.diPQGDH, d.yuanGBH + '-' + d.xingM as qingGRY, ");
		sql.append("case when convert(char, a.qingGRQ, 111) = '1900/01/01' then '' else convert(char, a.qingGRQ, 111) end as qingGRQ, ");
		sql.append("f.yuanGBH + '-' + f.xingM as queRRY, ");
		sql.append("case when convert(char, a.queRRQ, 111) = '1900/01/01' then '' else convert(char, a.queRRQ, 111) end as queRRQ ");
		sql.append("from cmmm..mm0001 a with(nolock) ");
		sql.append("left outer join cmhr..hr0003 c with(nolock) on a.qingGRYhr0003Sn = c.sn ");
		sql.append("left outer join cmhr..hr0002 d with(nolock) on c.hr0002Sn = d.sn ");
		sql.append("left outer join cmhr..hr0003 e with(nolock) on a.queRRYhr0003Sn = e.sn ");
		sql.append("left outer join cmhr..hr0002 f with(nolock) on e.hr0002Sn = f.sn ");
		sql.append("where 1 = 1 ");
		if (!queryDiPQGDH.equals("")) {
			sql.append("and a.diPQGDH like N'").append(queryDiPQGDH.replace("?", "%")).append("' ");
		}
		if (!queryQingGRY.equals("")) {
			sql.append("and a.qingGRYhr0003Sn in (select b.sn from cmhr..hr0002 a with(nolock) join cmhr..hr0003 b with(nolock) on a.sn = b.hr0002Sn where a.sn = '").append(queryQingGRY).append("') ");
		}
		if (!queryPartno.equals("")) {
			sql.append("and a.sn in (select mm0001Sn from cmmm..mm0001a a with(nolock) where a.partno like N'").append(queryPartno.replace("?", "%")).append("') ");
		}
		if (!queryStartQingGRQ.equals("")) {
			sql.append("and a.qingGRQ >= '").append(queryStartQingGRQ).append("' ");
		}
		if (!queryEndQingGRQ.equals("")) {
			sql.append("and a.qingGRQ <= '").append(queryEndQingGRQ).append("' ");
		}
		sql.append("order by a.diPQGDH desc ");
		rs = u.executePagingQuery("erp", sql.toString(), "a.sn");
%>
  <u:page u="<%=u%>" dataSource="erp" sql="<%=sql.toString()%>"/>
  <table width="100%" border="1" cellpadding="1" cellspacing="1" bordercolor="#000000" id="dataTable">
  	<tr>
      <th bgcolor="#CCCCCC" align="center"><%=u.getI18n(u, "gongN")%></th>
      <th bgcolor="#CCCCCC" align="center"><%=u.getI18n(u, "diPQGDH")%></th>
      <th bgcolor="#CCCCCC" align="center"><%=u.getI18n(u, "qingGRY")%></th>
      <th bgcolor="#CCCCCC" align="center"><%=u.getI18n(u, "qingGRQ")%></th>
      <th bgcolor="#CCCCCC" align="center"><%=u.getI18n(u, "產品編號")%></th>
      <th bgcolor="#CCCCCC" align="center"><%=u.getI18n(u, "queRRY")%></th>
      <th bgcolor="#CCCCCC" align="center"><%=u.getI18n(u, "queRRQ")%></th>
    </tr>
<%
		while(rs.next()) {
			partnoJH = "";
			sql = new StringBuffer("select a.partno, zhangS from cmmm..mm0001a a where a.mm0001Sn = ? order by left(a.partno, 2), right(a.partno, 4) ");
			u.prepareStatement("erp", sql.toString());
			u.setString(1, u.getRsString(rs, "sn"));
			rs1 = u.executeQuery();
			while (rs1.next()) {
				if (partnoJH.equals("")) {
					partnoJH = u.getRsString(rs1, "partno") + (!u.getRsString(rs1, "zhangS").equals("") ? "(" + u.getRsString(rs1, "zhangS") + ")" : "");
				} else {
					partnoJH += "<br/>" + u.getRsString(rs1, "partno") + (!u.getRsString(rs1, "zhangS").equals("") ? "(" + u.getRsString(rs1, "zhangS") + ")" : "");
				}
			}
			
%>
	<tr onmouseover="this.bgColor='#D4F8F8';" onmouseout="this.bgColor='#FFFFFF';">
	  <td align="center">
	  	<a href="mm0002e.jsp?act=edit&mm0001Sn=<%=u.getRsString(rs, "sn")%>&queryDiPQGDH=<%=u.unescape(queryDiPQGDH)%>&queryQingGRY=<%=u.unescape(queryQingGRY)%>&queryPartno=<%=u.unescape(queryPartno)%>&queryStartQingGRQ=<%=u.unescape(queryStartQingGRQ)%>&queryEndQingGRQ=<%=u.unescape(queryEndQingGRQ)%>&queryBiS=<%=u.unescape(queryBiS)%>"><%=u.getI18n(u, "bianJ")%></a>
	  </td>
	  <td align="center"><%=u.getRsString(rs, "diPQGDH")%></td>
	  <td align="center"><%=u.getRsString(rs, "qingGRY")%></td>
      <td align="center"><%=u.getRsString(rs, "qingGRQ")%></td>
      <td align="center"><%=partnoJH%></td>
      <td align="center"><%=u.getRsString(rs, "queRRY")%></td>
      <td align="center"><%=u.getRsString(rs, "queRRQ")%></td>
	</tr>
<%
		}
%>
  </table>
<%
	}
%>
</div>
<u:hidden id="act" name="act" value="<%=act%>"/>
<u:mis></u:mis>
</form>
</body>
</html>
<%
} catch (Exception ex) {
	u.recordException(ex);
	throw ex;
} finally {
	u.cleanUp();
}
%>