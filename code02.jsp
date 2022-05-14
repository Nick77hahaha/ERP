<%
Utils u = new Utils(request);
try {
	CommonType comm = new CommonType(u);
	StringBuffer sql = null;
	ResultSet rs = null, rs1 = null, rs2 = null;
	SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
	SimpleDateFormat dfTime = new SimpleDateFormat("yyyy/MM/dd HH:mm");
	Locale locale = new Locale("en", "US");
	SimpleDateFormat dayInWeek = new SimpleDateFormat("E", locale);
	SimpleDateFormat dfYear = new SimpleDateFormat("yyyy");
	
	String act = u.getStringParam("act");
	
	String mm0001Sn = u.getStringParam("mm0001Sn", "0");
	String diPQGDH = u.getStringParam("diPQGDH");
	String qingGRYhr0003Sn = u.getStringParam("qingGRYhr0003Sn");
	String qingGRQ = u.getStringParam("qingGRQ");
	String beiZ = u.getStringParam("beiZ");
	String version = u.getStringParam("version");
	
	String queRsys0005ShiFDM = "0";
	String yiCGsys0005ShiFDM = "0";
	
	String queryDiPQGDH = u.getStringParam("queryDiPQGDH");
	String queryQingGRY = u.getStringParam("queryQingGRY");
	String queryPartno = u.getStringParam("queryPartno");
	String queryStartQingGRQ = u.getStringParam("queryStartQingGRQ");
	String queryEndQingGRQ = u.getStringParam("queryEndQingGRQ");
	String queryBiS = u.getStringParam("queryBiS");
	if (act.equals("new") || act.equals("edit")) {
		queryDiPQGDH = new String(queryDiPQGDH.getBytes("iso-8859-1"), "utf-8");
		queryQingGRY = new String(queryQingGRY.getBytes("iso-8859-1"), "utf-8");
		queryPartno = new String(queryPartno.getBytes("iso-8859-1"), "utf-8");
		queryStartQingGRQ = new String(queryStartQingGRQ.getBytes("iso-8859-1"), "utf-8");
		queryEndQingGRQ = new String(queryEndQingGRQ.getBytes("iso-8859-1"), "utf-8");
		queryBiS = new String(queryBiS.getBytes("iso-8859-1"), "utf-8");
	}
	
	if (act.equals("new")) { 
		act = "insertNew";
		qingGRQ = u.getToday();
		qingGRYhr0003Sn = u.getSessionHr0003Sn();
	} else if (act.equals("insertNew")) { 
		synchronized(this) {
			u.setTransaction();
			Calendar cal = Calendar.getInstance();
			diPQGDH = "CMXA" + String.valueOf(cal.get(Calendar.YEAR)) + String.valueOf(cal.get(Calendar.MONTH) + 101).substring(1, 3) + String.valueOf(cal.get(Calendar.DATE) + 100).substring(1, 3);
			diPQGDH = u.getNewDanH("erp", "cmmm", "mm0001", "diPQGDH", diPQGDH, 4);
			sql = new StringBuffer("insert into cmmm..mm0001 (diPQGDH, qingGRYhr0003Sn, qingGRQ, beiZ, ");
			sql.append("prgName, crtDay, crtHr0003Sn, crtName, crtIp) ");
			sql.append("values (?, ?, ?, ?, ?, getdate(), ?, ?, ?);select @@IDENTITY;");
			u.prepareStatement("erp", sql.toString());
			u.setString(1, diPQGDH);
			u.setString(2, qingGRYhr0003Sn);
			u.setString(3, qingGRQ);
			u.setString(4, beiZ);
			u.setString(5, u.getJspName());
			u.setString(6, u.getSessionHr0003Sn());
			u.setString(7, u.getSessionXingM());
			u.setString(8, u.getUserIp());
			rs = u.executeQuery();
			rs.next();
			mm0001Sn = rs.getString(1);
			//mm0001a data
			String[] mm0001aSns = u.getStringParams("mm0001aSn");
			String[] mm0001aDeletes = u.getStringParams("mm0001aDelete");
			String[] partnos = u.getStringParams("partno");
			String[] sys0036DiPLBDMs = u.getStringParams("sys0036DiPLBDM");
			String[] zhouQs = u.getStringParams("zhouQ");
			String[] zhangSs = u.getStringParams("zhangS");
			String[] xuQRQs = u.getStringParams("xuQRQ");
			String[] qingGSLs = u.getStringParams("qingGSL");
			int i = 0;
			for (String mm0001aSn : mm0001aSns) {
				if (mm0001aDeletes[i].equals("")) {
					//insert into mm0001a
					sql = new StringBuffer("insert into cmmm..mm0001a (mm0001Sn, partno, sys0036DiPLBDM, zhouQ, zhangS, xuQRQ, qingGSL, ");
					sql.append("prgName, crtDay, crtHr0003Sn, crtName, crtIp) ");
					sql.append("values (?, ?, ?, ?, ?, ?, ?, ?, getdate(), ?, ?, ?)");
					u.prepareStatement("erp", sql.toString());
					u.setString(1, mm0001Sn);
					u.setString(2, partnos[i]);
					u.setString(3, sys0036DiPLBDMs[i]);
					u.setString(4, zhouQs[i]);
					u.setString(5, zhangSs[i]);
					u.setString(6, xuQRQs[i]);
					u.setString(7, qingGSLs[i]);
					u.setString(8, u.getJspName());
					u.setString(9, u.getSessionHr0003Sn());
					u.setString(10, u.getSessionXingM());
					u.setString(11, u.getUserIp());
					u.executeUpdate();
				}
				i++;
			}
			u.commit();
			response.sendRedirect("mm0002e.jsp?act=edit&mm0001Sn=" + mm0001Sn + "&queryDiPQGDH=" + u.unescape(queryDiPQGDH) + "&queryQingGRY=" + u.unescape(queryQingGRY) + "&queryPartno=" + u.unescape(queryPartno) + "&queryStartQingGRQ=" + u.unescape(queryStartQingGRQ) + "&queryEndQingGRQ=" + u.unescape(queryEndQingGRQ) + "&queryBiS=" + u.unescape(queryBiS));
		}
		act = "updateEdit";
	} else if (act.equals("edit")) {
		sql = new StringBuffer("select a.sn, a.diPQGDH, a.qingGRYhr0003Sn, a.beiZ, a.queRsys0005ShiFDM, a.version, ");
		sql.append("case when convert(char, a.qingGRQ, 111) = '1900/01/01' then '' else convert(char, a.qingGRQ, 111) end as qingGRQ, ");
		sql.append("isnull(b.yiCGsys0005ShiFDM, '0') as yiCGsys0005ShiFDM ");
		sql.append("from cmmm..mm0001 a with(nolock) left outer join (select mm0001Sn, max(yiCGsys0005ShiFDM) as yiCGsys0005ShiFDM from cmmm..mm0001a with(nolock) group by mm0001Sn) as b on a.sn = b.mm0001Sn ");
		sql.append("where a.sn = ? ");
		u.prepareStatement("erp", sql.toString());
		u.setString(1, mm0001Sn);
		rs = u.executeQuery();
		if (rs.next()) {
			mm0001Sn = u.getRsString(rs, "sn");
			diPQGDH = u.getRsString(rs, "diPQGDH");
			qingGRYhr0003Sn = u.getRsString(rs, "qingGRYhr0003Sn");
			qingGRQ = u.getRsString(rs, "qingGRQ");
			beiZ = u.getRsString(rs, "beiZ");
			version = u.getRsString(rs, "version");
			queRsys0005ShiFDM = u.getRsString(rs, "queRsys0005ShiFDM");
			yiCGsys0005ShiFDM = u.getRsString(rs, "yiCGsys0005ShiFDM");
		}
	} else if (act.equals("updateEdit") || act.equals("chuCBQR")) {
		u.setTransaction();
		sql = new StringBuffer("update cmmm..mm0001 set qingGRYhr0003Sn = ?, qingGRQ = ?, beiZ = ?, version = version + 1, ");
		sql.append("prgName = ?, updDay = getdate(), updHr0003Sn = ?, updName = ?, updIp = ? ");
		sql.append("where sn = ? ");
		u.prepareStatement("erp", sql.toString());
		u.setString(1, qingGRYhr0003Sn);
		u.setString(2, qingGRQ);
		u.setString(3, beiZ);
		u.setString(4, u.getJspName());
		u.setString(5, u.getSessionHr0003Sn());
		u.setString(6, u.getSessionXingM());
		u.setString(7, u.getUserIp());
		u.setString(8, mm0001Sn);
		u.executeUpdate();
		//mm0001a data
		String[] mm0001aSns = u.getStringParams("mm0001aSn");
		String[] mm0001aDeletes = u.getStringParams("mm0001aDelete");
		String[] partnos = u.getStringParams("partno");
		String[] sys0036DiPLBDMs = u.getStringParams("sys0036DiPLBDM");
		String[] zhouQs = u.getStringParams("zhouQ");
		String[] zhangSs = u.getStringParams("zhangS");
		String[] xuQRQs = u.getStringParams("xuQRQ");
		String[] qingGSLs = u.getStringParams("qingGSL");
		int i = 0;
		for (String mm0001aSn : mm0001aSns) {
			if (mm0001aSn.equals("0")) {
				if (mm0001aDeletes[i].equals("")) {
					//insert into mm0001a
					sql = new StringBuffer("insert into cmmm..mm0001a (mm0001Sn, partno, sys0036DiPLBDM, zhouQ, zhangS, xuQRQ, qingGSL, ");
					sql.append("prgName, crtDay, crtHr0003Sn, crtName, crtIp) ");
					sql.append("values (?, ?, ?, ?, ?, ?, ?, ?, getdate(), ?, ?, ?)");
					u.prepareStatement("erp", sql.toString());
					u.setString(1, mm0001Sn);
					u.setString(2, partnos[i]);
					u.setString(3, sys0036DiPLBDMs[i]);
					u.setString(4, zhouQs[i]);
					u.setString(5, zhangSs[i]);
					u.setString(6, xuQRQs[i]);
					u.setString(7, qingGSLs[i]);
					u.setString(8, u.getJspName());
					u.setString(9, u.getSessionHr0003Sn());
					u.setString(10, u.getSessionXingM());
					u.setString(11, u.getUserIp());
					u.executeUpdate();
				}
			} else {
				//update
				if (mm0001aDeletes[i].equals("")) {
					//update mm0001a
					sql = new StringBuffer("update cmmm..mm0001a set partno = ?, sys0036DiPLBDM = ?, zhouQ = ?, zhangS = ?, xuQRQ = ?, qingGSL = ?, ");
					sql.append("prgName = ?, updDay = getdate(), updHr0003Sn = ?, updName = ?, updIp = ? where sn = ? ");
					u.prepareStatement("erp", sql.toString());
					u.setString(1, partnos[i]);
					u.setString(2, sys0036DiPLBDMs[i]);
					u.setString(3, zhouQs[i]);
					u.setString(4, zhangSs[i]);
					u.setString(5, xuQRQs[i]);
					u.setString(6, qingGSLs[i]);
					u.setString(7, u.getJspName());
					u.setString(8, u.getSessionHr0003Sn());
					u.setString(9, u.getSessionXingM());
					u.setString(10, u.getUserIp());
					u.setString(11, mm0001aSns[i]);
					u.executeUpdate();
				} else {
					//delete mm0001a
					sql = new StringBuffer("update cmmm..mm0001a set prgName = ?, updDay = getdate(), updHr0003Sn = ?, updName = ?, updIp = ? ");
					sql.append("where sn = ? ");
					u.prepareStatement("erp", sql.toString());
					u.setString(1, u.getJspName());
					u.setString(2, u.getSessionHr0003Sn());
					u.setString(3, u.getSessionXingM());
					u.setString(4, u.getUserIp());
					u.setString(5, mm0001aSns[i]);
					u.executeUpdate();
					sql = new StringBuffer("delete cmmm..mm0001a where sn = ? ");
					u.prepareStatement("erp", sql.toString());
					u.setString(1, mm0001aSns[i]);
					u.executeUpdate();
				}
			}
			i++;
		}
		
		if (act.equals("chuCBQR")) {
			sql = new StringBuffer("update cmmm..mm0001 set queRsys0005ShiFDM = 1, queRRYhr0003Sn = ?, queRRQ = getdate(), version = version + 1, ");
			sql.append("prgName = ?, updDay = getdate(), updHr0003Sn = ?, updName = ?, updIp = ? ");
			sql.append("where sn = ? ");
			u.prepareStatement("erp", sql.toString());
			u.setString(1, u.getSessionHr0003Sn());
			u.setString(2, u.getJspName());
			u.setString(3, u.getSessionHr0003Sn());
			u.setString(4, u.getSessionXingM());
			u.setString(5, u.getUserIp());
			u.setString(6, mm0001Sn);
			u.executeUpdate();
		}
		u.commit();
		response.sendRedirect("mm0002e.jsp?act=edit&mm0001Sn=" + mm0001Sn + "&queryDiPQGDH=" + u.unescape(queryDiPQGDH) + "&queryQingGRY=" + u.unescape(queryQingGRY) + "&queryPartno=" + u.unescape(queryPartno) + "&queryStartQingGRQ=" + u.unescape(queryStartQingGRQ) + "&queryEndQingGRQ=" + u.unescape(queryEndQingGRQ) + "&queryBiS=" + u.unescape(queryBiS));
	} else if (act.equals("quXQR")) {
		u.setTransaction();
		sql = new StringBuffer("update cmmm..mm0001 set queRsys0005ShiFDM = 0, queRRYhr0003Sn = 0, queRRQ = '1900/01/01', version = version + 1, ");
		sql.append("prgName = ?, updDay = getdate(), updHr0003Sn = ?, updName = ?, updIp = ? ");
		sql.append("where sn = ? ");
		u.prepareStatement("erp", sql.toString());
		u.setString(1, u.getJspName());
		u.setString(2, u.getSessionHr0003Sn());
		u.setString(3, u.getSessionXingM());
		u.setString(4, u.getUserIp());
		u.setString(5, mm0001Sn);
		u.executeUpdate();
		u.commit();
		response.sendRedirect("mm0002e.jsp?act=edit&mm0001Sn=" + mm0001Sn + "&queryDiPQGDH=" + u.unescape(queryDiPQGDH) + "&queryQingGRY=" + u.unescape(queryQingGRY) + "&queryPartno=" + u.unescape(queryPartno) + "&queryStartQingGRQ=" + u.unescape(queryStartQingGRQ) + "&queryEndQingGRQ=" + u.unescape(queryEndQingGRQ) + "&queryBiS=" + u.unescape(queryBiS));
	} else if (act.equals("shanC")) {
		u.setTransaction();
		sql = new StringBuffer("select sn from cmmm..mm0001a where mm0001Sn = ? ");
		u.prepareStatement("erp", sql.toString());
		u.setString(1, mm0001Sn);
		rs = u.executeQuery();
		while (rs.next()) {
			sql = new StringBuffer("update cmmm..mm0001a set prgName = ?, updDay = getdate(), updHr0003Sn = ?, updName = ?, updIp = ? ");
			sql.append("where sn = ? ");
			u.prepareStatement("erp", sql.toString());
			u.setString(1, u.getJspName());
			u.setString(2, u.getSessionHr0003Sn());
			u.setString(3, u.getSessionXingM());
			u.setString(4, u.getUserIp());
			u.setString(5, u.getRsString(rs, "sn"));
			u.executeUpdate();
			sql = new StringBuffer("delete cmmm..mm0001a where sn = ? ");
			u.prepareStatement("erp", sql.toString());
			u.setString(1, u.getRsString(rs, "sn"));
			u.executeUpdate();
		}
		sql = new StringBuffer("update cmmm..mm0001 set prgName = ?, updDay = getdate(), updHr0003Sn = ?, updName = ?, updIp = ? ");
		sql.append("where sn = ? ");
		u.prepareStatement("erp", sql.toString());
		u.setString(1, u.getJspName());
		u.setString(2, u.getSessionHr0003Sn());
		u.setString(3, u.getSessionXingM());
		u.setString(4, u.getUserIp());
		u.setString(5, mm0001Sn);
		u.executeUpdate();
		sql = new StringBuffer("delete cmmm..mm0001 where sn = ? ");
		u.prepareStatement("erp", sql.toString());
		u.setString(1, mm0001Sn);
		u.executeUpdate();
		u.commit();
		response.sendRedirect("mm0001q.jsp?act=retQuery&queryDiPQGDH=" + u.unescape(queryDiPQGDH) + "&queryQingGRY=" + u.unescape(queryQingGRY) + "&queryPartno=" + u.unescape(queryPartno) + "&queryStartQingGRQ=" + u.unescape(queryStartQingGRQ) + "&queryEndQingGRQ=" + u.unescape(queryEndQingGRQ) + "&queryBiS=" + u.unescape(queryBiS));
	} else if (act.equals("xinZXYB")) {
		response.sendRedirect("mm0002e.jsp?act=new&mm0001Sn=0&queryDiPQGDH=" + u.unescape(queryDiPQGDH) + "&queryQingGRY=" + u.unescape(queryQingGRY) + "&queryPartno=" + u.unescape(queryPartno) + "&queryStartQingGRQ=" + u.unescape(queryStartQingGRQ) + "&queryEndQingGRQ=" + u.unescape(queryEndQingGRQ) + "&queryBiS=" + u.unescape(queryBiS));
	} else if(act.equals("huiSY")) {
		response.sendRedirect("mm0001q.jsp?act=retQuery&queryDiPQGDH=" + u.unescape(queryDiPQGDH) + "&queryQingGRY=" + u.unescape(queryQingGRY) + "&queryPartno=" + u.unescape(queryPartno) + "&queryStartQingGRQ=" + u.unescape(queryStartQingGRQ) + "&queryEndQingGRQ=" + u.unescape(queryEndQingGRQ) + "&queryBiS=" + u.unescape(queryBiS));
	}
	if (mm0001Sn.equals("0")) {
		chuCQX = "true";
		xinZQGMXQX = "true";
	} else {
		chuCQX = "true";
		shanCQX = "true";
		chuCBQRQX = "true";
		xinZQGMXQX = "true";
		xinZXYBQX = "true";
		lieYQX = "true";
		
		if (yiCGsys0005ShiFDM.equals("0")) {
			if (queRsys0005ShiFDM.equals("0")) {
			} else {
				chuCQX = "false";
				shanCQX = "false";
				chuCBQRQX = "false";
				xinZQGMXQX = "false";
				quXQRQX = "true";
			}
		} else {
			chuCQX = "false";
			shanCQX = "false";
			chuCBQRQX = "false";
			xinZQGMXQX = "false";
			quXQRQX = "false";
		}
	}
	String qingGRYhr0003SnQX = "true";
	if (queRsys0005ShiFDM.equals("0")) {
		qingGRYhr0003SnQX = "false";
	}
	if (!u.getSessionIsAdmin() && !u.getSessionZuZDM().equals("7") && !u.getSessionHr0002Sn().equals("2") && !u.getSessionHr0002Sn().equals("134") && !u.getSessionHr0002Sn().equals("174")) {
		chuCBQRQX = "false";
		quXQRQX = "false";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/misc/utils.jsp"%>
<script type="text/javascript">
var act = '<%=act%>';
$(function() {
	$("#chuC").click(function() {
		chuCClick();
	});
	$("#chuCBQR").click(function() {
		$('#act').val('chuCBQR');
		chuCClick();
	});
	$("#quXQR").click(function() {
		$('#act').val('quXQR');
		chuCClick();
	});
	$("#huiSY").click(function() {
		pop_out_loading($('#div_loading'));
		$("#act").val("huiSY");
		$('form').submit();
	});
	$("#xinZXYB").click(function() {
		pop_out_loading($('#div_loading'));
		$("#act").val("xinZXYB");
		$('form').submit();
	});
	$('#shanC').click(function() {
		if (confirm('<%=u.getI18n(u, "queDSC")%>')) {
			if (confirm('<%=u.getI18n(u, "zaiCQRSC")%>')) {
				pop_out_loading($('#div_loading'));
				$('#act').val('shanC');
				chuCClick();
			}
		}
	});
	$('#xinZQGMX').click(function() {
		var qingGRQ = $.trim($('#qingGRQ').val());
		if (qingGRQ.length == 0) {
			qingGRQ = "<%=u.getToday()%>";
		}
		var id = new UUID();
		var trStr = '';
		trStr += '<tr>';
		trStr += '  <td align="center">';
		trStr += '    <input type="button" name="mm0001aSC" value="<%=u.getI18n(u, "shanC")%>">';
		trStr += '    <input type="hidden" name="mm0001aSn" value="0"/>';
		trStr += '    <input type="hidden" name="mm0001aDelete" value=""/>';
		trStr += '  </td>';
		trStr += '  <td align="center" nowrap="nowrap">';
		trStr += '    <input type="text" name="partno" id="partno' + id + '" size="15" value=""/>';
		trStr += '    <font color="#FF0000"><span name="partnoMessage"></span></font>';
		trStr += '  </td>';
		trStr += '  <td align="center" nowrap="nowrap">';
		trStr += '    <select name="sys0036DiPLBDM">';
		$.ajax({
			url : '/cm/common/ajaxCode.jsp', 
			data : {
					gongNDM : '92', 
					sys0007QiYDM : '2' 
				}, 
			type : 'POST', 
			cache : false, 
			async : false, 
			dataType : 'json', 
			success : function(data) {
					for (var key in data) {
						if (data[key]["val"] == "0") {
							trStr += '<option value="' + data[key]["val"] + '" selected="selected">' + data[key]["txt"] + '</option>';
						} else {
							trStr += '<option value="' + data[key]["val"] + '">' + data[key]["txt"] + '</option>';
						}
					}
			},
			error : function(responseText) {
				alert(responseText.status+'  ::  '+responseText.statusText);
			}
		});
		trStr += '    </select>';
		trStr += '  </td>';
		trStr += '  <td align="center" nowrap="nowrap">';
		trStr += '    <input type="text" name="zhouQ" value="" size="10" maxlength="50"/>';
		trStr += '  </td>';
		trStr += '  <td align="center" nowrap="nowrap">';
		trStr += '    <input type="text" name="zhangS" value="" size="10" maxlength="50"/>';
		trStr += '  </td>';
		trStr += '  <td align="center" nowrap="nowrap">';
		trStr += '    <input type="text" name="xuQRQ" size="7" value="' + qingGRQ + '" class="dateInput"/>';
		trStr += '  </td>';
		trStr += '  <td align="center" nowrap="nowrap">';
		trStr += '  <input type="text" name="qingGSL" class="classInteger" size="6" value="1" max="65535" min="0" style="text-align:right;null"/>';
		trStr += '  </td>';
		trStr += '</tr>';
		$('#trMm0001aQingG').after(trStr);
		$('#partno' + id).suggest('/cm/common/partno.jsp');
		$('.dateInput').datepicker($.extend({},
			$.datepicker.regional["<%=u.getSessionSys0003YuYDM()%>"], { 
				firstDay: 7,
			    showStatus: true, 
			    showOn: "button", 
			    buttonImage: "/cm/misc/jquery/images/calendar.gif", 
			    buttonImageOnly: true,
			    dateFormat: 'yy/mm/dd'
		}));
		$('.dateInput').blur(function(){
			tag05(this, '<%=u.getI18n(u, "qingSRZQRQGS")%>');
		});
		$('.classInteger').numeric({allow:"-"}).blur(function() {
			var max = parseFloat($(this).attr('max'));
			var min = parseFloat($(this).attr('min'));
			if ($(this).val().length == 0) {
				$(this).val(min);
			}
			tag01(this, min, max, '<%=u.getI18n(u, "ciLWBXTXSZ")%>', '<%=u.getI18n(u, "shuZCGFW")%>');
		});
		$('.classInteger').focus(function() {
			$(this).select();
		});
		$('.classInteger').mouseup(function() {
			return false;
		});
		$('input[name=mm0001aSC]').unbind('click');
		$('input[name=mm0001aSC]').bind('click', mm0001aSCClick);
	});
	$('input[name=mm0001aSC]').bind('click', mm0001aSCClick);
	if ('<%=yiCGsys0005ShiFDM%>' != '0') {
		alert('已採購，無法儲存！'); 
	}
})
function mm0001aSCClick() {
	if (confirm('<%=u.getI18n(u, "queDSC")%>')) {
		$(this).closest("tr").find('input[name=mm0001aDelete]').val('ON');
		$(this).closest("tr").hide();
	}
}

function chuCClick(type) {
	var errorStr = "";
	var flag = false;
	pop_out_loading($('#div_loading'));
	setButtonDisable();
	var mm0001Sn = $.trim($('#mm0001Sn').val());
	var qingGRYhr0003Sn = $.trim($('#qingGRYhr0003Sn').val());
	var qingGRQ = $.trim($('#qingGRQ').val());
	var beiZ = $.trim($('#beiZ').val());
	var version = $.trim($('#version').val());
	var youDZLBTCnt = 0;
	$('input[name=mm0001aSn]').each(function() {
		var mm0001aDelete = $.trim($(this).closest("tr").find('input[name=mm0001aDelete]').val());
		var partno = $.trim($(this).closest("tr").find('input[name=partno]').val());
		var sys0036DiPLBDM = $.trim($(this).closest("tr").find('select[name=sys0036DiPLBDM] option:selected').val());
		var zhouQ = $.trim($(this).closest("tr").find('input[name=zhouQ]').val());
		var xuQRQ = $.trim($(this).closest("tr").find('input[name=xuQRQ]').val());
		var qingGSL = $.trim($(this).closest("tr").find('input[name=qingGSL]').val());
		if (mm0001aDelete.length == 0) {
			if (partno.length == 0 || sys0036DiPLBDM.length == 0 || xuQRQ.length == 0 || parseFloat(qingGSL) == 0) {
				youDZLBTCnt++;
			}
		}
	});
	if (qingGRQ.length == 0 || youDZLBTCnt > 0) {
		alert('<%=u.getI18n(u, "youDZLBT")%> !!');
		$.unblockUI();
		setButtonEnable();
		$('#act').val(act);
	} else {
		if (mm0001Sn != '0') {
			$.ajax({
				url : '/cm/common/ajaxCode.jsp', 
				data : {
						gongNDM : '93', 
						mm0001Sn : mm0001Sn, 
						version : version 
					}, 
				type : 'POST', 
				cache : false, 
				async : false, 
				dataType : 'json', 
				success : function(data) {
						if ($.trim(data.errorMessage).length != 0) {
							if (errorStr.length == 0) {
								errorStr = data.errorMessage;
							} else {
								errorStr += '\n' + data.errorMessage;
							}
						} else {
							
						}
				},
				error : function(responseText) {
					alert(responseText.status+'  ::  '+responseText.statusText);
					errorStr = 'ajax error';
				}
			});
		}
		if (errorStr.length == 0) {
			var errorFlag = false;
			$('input[name=mm0001aSn]').each(function() {
				var mm0001aDelete = $.trim($(this).closest("tr").find('input[name=mm0001aDelete]').val());
				var partno = $.trim($(this).closest("tr").find('input[name=partno]').val());
				var partnoMessage = $(this).closest("tr").find('span[name=partnoMessage]');
				if (mm0001aDelete.length == 0) {
					$.ajax({
						url : '/cm/common/ajaxCode.jsp', 
						data : {
								gongNDM : '94', 
								partno : partno 
							}, 
						type : 'POST', 
						cache : false, 
						async : false, 
						dataType : 'json', 
						success : function(data) {
								if ($.trim(data.errorMessage).length != 0) {
									errorFlag = true;
									partnoMessage.html(data.errorMessage);
								} else {
									partnoMessage.html('');
								}
						},
						error : function(responseText) {
							alert(responseText.status+'  ::  '+responseText.statusText);
							errorStr = 'ajax error';
						}
					});
				}
			});
		}
		if (beiZ.length > 500) {
			if (errorStr.length == 0) {
				errorStr = '<%=u.getI18n(u, "beiZZSBDCG500ZMQZS")%> ' + beiZ.length;
			} else {
				errorStr += '\n' + '<%=u.getI18n(u, "beiZZSBDCG500ZMQZS")%> ' + beiZ.length;
			}
		}
		
		if (errorStr.length == 0) {
			$('form').submit();
		} else {
			alert(errorStr + '\n\n\n以上錯誤請修正後再行儲存！');
			$.unblockUI();
			setButtonEnable();
			$('#act').val(act);
		}
	}
}
function setButtonDisable() {
	$('#chuC').prop('disabled', true);
	$('#chuCBQR').prop('disabled', true);
	$('#quXQR').prop('disabled', true);
	$('#huiSY').prop('disabled', true);
	$('#xinZXYB').prop('disabled', true);
	$('#shanC').prop('disabled', true);
	$('#xinZQGMX').prop('disabled', true);
}

	
</script>
</head>
<body>
<form method="post" action="mm0002e.jsp">
<div align="center">
  <table width="100%" border="1" cellpadding="1" cellspacing="1" bordercolor="#000000">
    <tr>
      <td align="center"><%=u.getI18n(u, "caiG")%>-<%=u.getI18n(u, "diPQGBJ")%></td>
	</tr>
  </table>
  <br/>
  <table width="100%" border="1" cellpadding="1" cellspacing="1" bordercolor="#000000">
  	<tr>
  	  <th width="15%" align="right" nowrap="nowrap"><%=u.getI18n(u, "diPQGDH")%> :</th>
  	  <td width="35%" align="left"><input type="text" id="diPQGDH" name="diPQGDH" size="20" value="<%=diPQGDH%>" maxlength="50" readonly/></td>
  	  <th width="15%" align="right" nowrap="nowrap"><font color="#FF0000">*</font><%=u.getI18n(u, "qingGRY")%> :</th>
      <td width="35%" align="left">
      	<u:select id="qingGRYhr0003Sn" name="qingGRYhr0003Sn" u="<%=u%>" sql="<%=u.getDDLHr0003YuanGBHAll(qingGRYhr0003Sn).toString()%>" value="<%=qingGRYhr0003Sn%>" readonly="<%=qingGRYhr0003SnQX%>" empty="empty"></u:select>
      </td>
  	</tr>
    <tr>
      <th width="15%" align="right" nowrap="nowrap"><font color="#FF0000">*</font><%=u.getI18n(u, "qingGRQ")%> :</th>
      <td width="35%" align="left">
      	<u:dateInput id="qingGRQ" name="qingGRQ" value="<%=qingGRQ%>"></u:dateInput>
      </td>
      <th width="15%" align="right" nowrap="nowrap"></th>
      <td width="35%" align="left"></td>
    </tr>
    <tr>
      <th width="15%" align="right" nowrap="nowrap"><%=u.getI18n(u, "beiZ")%> :</th>
      <td width="85%" align="left" colspan="3">
      	<textarea id="beiZ" name="beiZ" rows="5" cols="70" maxlength="500"><%=beiZ%></textarea>
      </td>
    </tr>
    <tr>
      <td colspan="4" align="center">
<%
	if (chuCQX.equals("true")) {
%>
        <input type="button" id="chuC" name="chuC" value="<%=u.getI18n(u, "chuC")%>"/>
<%
	}
	if (chuCBQRQX.equals("true")) {
%>
        <input type="button" id="chuCBQR" name="chuCBQR" value="<%=u.getI18n(u, "chuCBQR")%>"/>
<%
	}
	if (quXQRQX.equals("true")) {
%>
        <input type="button" id="quXQR" name="quXQR" value="<%=u.getI18n(u, "quXQR")%>"/>
<%
	}
	if (shanCQX.equals("true")) {
%>
        <input type="button" id="shanC" name="shanC" value="<%=u.getI18n(u, "shanC")%>"/>
<%
	}
	if (huiSYQX.equals("true")) {
%>
        <input type="button" id="huiSY" name="huiSY" value="<%=u.getI18n(u, "huiSY")%>"/>
<%
	}
	if (xinZXYBQX.equals("true")) {
%>
        <input type="button" id="xinZXYB" name="xinZXYB" value="<%=u.getI18n(u, "xinZXYB")%>"/>
<%
	}
	if (lieYQX.equals("true")) {
%>
        <input type="button" id="leiY" name="lieY" value="<%=u.getI18n(u, "lieY")%>"/>
<%
	}
%>
      </td>
    </tr>
  </table>
  <hr/>
  <table width="100%" border="1" align="center"  cellpadding="1" cellspacing="1" bordercolor="#000000">
<%
	if (xinZQGMXQX.equals("true")) {
%>
  	<tr>
      <td align="center" colspan="17">
      	<input type="button" id="xinZQGMX" name="xinZQGMX" value="<%=u.getI18n(u, "xinZQGMX")%>"/>
      </td>
    </tr>
<%
	}
%>
  	<tr id="trMm0001aQingG">
<%
	if (xinZQGMXQX.equals("true")) {
%>
  	  <th align="center"><%=u.getI18n(u, "gongN")%></th>
<%
	}
%>
      <th align="center"><font color="#FF0000">*</font><%=u.getI18n(u, "產品編號")%></th>
      <th align="center"><font color="#FF0000">*</font><%=u.getI18n(u, "diPLB")%></th>
      <th align="center"><%=u.getI18n(u, "zhouQ")%></th>
      <th align="center"><%=u.getI18n(u, "zhangS")%></th>
      <th align="center"><font color="#FF0000">*</font><%=u.getI18n(u, "xuQRQ")%></th>
      <th align="center"><font color="#FF0000">*</font><%=u.getI18n(u, "qingGSL")%></th>
  	</tr>
<%
	String rsMm0001aSn = "";
	String rsPartno = "";
	String rsSys0036DiPLBDM = "";
	String rsZhouQ = "";
	String rsZhangS = "";
	String rsXuQRQ = "";
	String rsQingGSL = "";
	String partnoID = "";
	sql = new StringBuffer("select a.sn as mm0001aSn, a.partno, a.sys0036DiPLBDM, a.zhouQ, a.zhangS, a.qingGSL, ");
	sql.append("case when convert(char, a.xuQRQ, 111) = '1900/01/01' then '' else convert(char, a.xuQRQ, 111) end as xuQRQ ");
	sql.append("from cmmm..mm0001a a with(nolock) ");
	sql.append("where a.mm0001Sn = ? ");
	sql.append("order by a.sn ");
	//sql.append("order by left(a.partno, 2), right(a.partno, 4) ");
	u.prepareStatement("erp", sql.toString());
	u.setString(1, mm0001Sn);
	rs = u.executeQuery();
	while (rs.next()) {
		rsMm0001aSn = u.getRsString(rs, "mm0001aSn");
		rsPartno = u.getRsString(rs, "partno");
		rsSys0036DiPLBDM = u.getRsString(rs, "sys0036DiPLBDM");
		rsZhouQ = u.getRsString(rs, "zhouQ");
		rsZhangS = u.getRsString(rs, "zhangS");
		rsXuQRQ = u.getRsString(rs, "xuQRQ");
		rsQingGSL = u.trunc(rs.getDouble("qingGSL"), 0);
		partnoID = "partno_" + u.getRsString(rs, "mm0001aSn");
%>
	<tr>
<%
		if (xinZQGMXQX.equals("true")) {
%>
      <td align="center">
        <input type="button" name="mm0001aSC" value="<%=u.getI18n(u, "shanC")%>"/>
        <input type="hidden" name="mm0001aSn" value="<%=rsMm0001aSn%>"/>
        <input type="hidden" name="mm0001aDelete" value=""/>
      </td>
<%
		}
%>
      <td align="center" nowrap="nowrap">
        <u:partno name="partno" id="<%=partnoID%>" value="<%=rsPartno%>" size="15"></u:partno>
        <font color="#FF0000"><span name="partnoMessage"></span></font>
      </td>
      <td align="center" nowrap="nowrap">
        <u:select name="sys0036DiPLBDM" u="<%=u%>" sql="<%=u.getDDLSys0036DiPLBEnab(rsSys0036DiPLBDM).toString()%>" value="<%=rsSys0036DiPLBDM%>"></u:select>
      </td>
      <td align="center" nowrap="nowrap">
        <input type="text" name="zhouQ" value="<%=rsZhouQ%>" size="10" maxlength="50"/>
      </td>
      <td align="center" nowrap="nowrap">
        <input type="text" name="zhangS" value="<%=rsZhangS%>" size="10" maxlength="50"/>
      </td>
      <td align="center" nowrap="nowrap">
        <u:dateInput name="xuQRQ" value="<%=rsXuQRQ%>"></u:dateInput>
      </td>
      <td align="center" nowrap="nowrap">
      	<u:integer name="qingGSL" min="0" max="65535" value="<%=rsQingGSL%>"></u:integer>
      </td>
	</tr>
<%
	}
%>
  </table>
  </div>
<u:hidden id="act" name="act" value="<%=act%>"></u:hidden>
<u:hidden id="version" name="version" value="<%=version%>"></u:hidden>
<u:hidden id="mm0001Sn" name="mm0001Sn" value="<%=mm0001Sn%>"></u:hidden>
<u:hidden name="queryDiPQGDH" value="<%=queryDiPQGDH%>"></u:hidden>
<u:hidden name="queryQingGRY" value="<%=queryQingGRY%>"></u:hidden>
<u:hidden name="queryPartno" value="<%=queryPartno%>"></u:hidden>
<u:hidden name="queryStartQingGRQ" value="<%=queryStartQingGRQ%>"></u:hidden>
<u:hidden name="queryEndQingGRQ" value="<%=queryEndQingGRQ%>"></u:hidden>
<u:hidden name="queryBiS" value="<%=queryBiS%>"></u:hidden>
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