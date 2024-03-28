<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import= "java.net.*"%> 
<%
	// ON -->OFF로 변경
	// 로그인(인증) 분기
	
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
	if(rs1.next()) {
		mySession = rs1.getString("mySession"); 
		System.out.println("logoutmySession: " + mySession);
	}
	
	// mySession 상태가 OFF상태 일수도 있으니까(모든 경우 수를 대비)
	if(mySession.equals("OFF")) { 
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8"); // (URLEncoder.encode)-> 한글꺠짐방지 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); // get방식
	}

	
	// 현재값이 OFF 아니고 ON이다 -> 'ON'상태에서 'OFF' 변경 후 loginForm으로 Redirect
	String sql2 = "update login set my_session='OFF', off_date=now() where my_session='ON'";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	int row = stmt2.executeUpdate(); // 수정된 행수 
	
	System.out.println("row : " + row);
	
	response.sendRedirect("/diary/loginForm.jsp");

%>