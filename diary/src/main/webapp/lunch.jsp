<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import= "java.net.*"%> 
<%
	// 로그인 인증(로그인 되어야 다음으로 넘어감)/ mySession이 "ON"인 상태
	String sql1 = "select my_session mySession from login"; // login테이블로부터 my_session을 가져올건데 별칭이 mySession인 것으로 바꿔서 가져오겟다!!
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1); // sql 불러오기
	rs1 = stmt1.executeQuery(); // 쿼리문 실행(출력)
	
	
	String mySession = null;
	if(rs1.next()) { //mySession 'ON'이여야 진행
		mySession = rs1.getString("mySession"); 
		System.out.println("diary mySession: " + mySession);
	}
	
	
	if(mySession.equals("OFF")) { // 쿼리문에 mySession이 "OFF"면 출력--> 로그인X
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8"); // (URLEncoder.encode)-> 한글꺠짐방지 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); // get방식
		
		return; //코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용(진행이 필요없다 싶을 때)
	}
%>

<%
	//입력값받기
	/*
		SELECT menu,COUNT(*) 
		FROM lunch 
		GROUP BY menu;
	*/
	
	
	String sql2 = "SELECT menu, COUNT(*) count FROM lunch GROUP BY menu"; // lunch로 부터 menu 그룹의 count(행수) 쿼리문
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2); // sql 불러오기
	rs2 = stmt2.executeQuery(); // 쿼리문 실행하겠다.(출력)
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<h1>statsLunch</h1>
	
		<%
			double maxHeight = 500;
			double totalCnt = 0; 
			while(rs2.next()) {
				totalCnt = totalCnt + rs2.getInt("count"); // 누적되는 것
			}
			
			rs2.beforeFirst(); // 출력하려는 값을 받은 후 다시 처음으로 돌아가...
		%>
	
		<div>
			전체 투표수 : <%=(int)totalCnt%>
		</div>
	
		<table border="1" style="width: 400px;">
			<tr>
				<%
					String[] c = {"#F15F5F", "#F29661", "#E5D85C", "#86E57F", "#6B66FF"}; // 배열 
					int i = 0; // 그래프바 색깔변수 
					while(rs2.next()) {
						int h = (int)((maxHeight / totalCnt) * rs2.getInt("count")); // 그래프의 높이 = (전체높이 / 총투표수)*지정메뉴투표수
				%>
					<td style="vertical-align:bottom;">
						<div style="height: <%=h%>px;
									background-color:<%=c[i]%>; 
									text-align: center">
							<%=rs2.getInt("count")%>
						</div>
					</td>
				<%
						i = i+1;
					}
					
				%>
			</tr>
			
			<tr>	
				<%
					rs2.beforeFirst();
					
					while(rs2.next()) {
				%>
					<td>
						<%=rs2.getString("menu")%>
					</td>
				<%
					}
				%>
			</tr>
		</table>

</body>
</html>