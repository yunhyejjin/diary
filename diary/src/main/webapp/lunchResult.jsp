<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import= "java.net.*"%> 
<%
	// 로그인 인증(로그인 되어야 다음으로 넘어감)/ mySession이 "ON"인 상태
	/*
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
	*/
%>

<%
	//로그인 인증(로그인 되어야 다음으로 넘어감)
	String loginMember = (String)(session.getAttribute("loginMember"));
		if(loginMember == null) { // null값이면 로그아웃상태이니까 
			String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
			response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
			return;
		}
%>

<%
	// 점심투표결과 데이터 가져오기
	String lunchDate = request.getParameter("lunchDate");
	String menu = request.getParameter("menu");
	
	System.out.println("rs.lunchDate : " + lunchDate);
	System.out.println("rs.menu : " + menu);
	/* 
		INSERT INTO lunch(
		lunch_date, menu, update_date, create_date
		) VALUES(?, ?, NOW(), NOW())"
	*/
	String sql ="INSERT INTO lunch(lunch_date, menu, update_date, create_date) VALUES(?, ?, NOW(), NOW())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,lunchDate);
	stmt.setString(2,menu);
	
	
	int row = 0;
	row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	
	} else {
		System.out.println("입력실패");
	
	}
	
%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	
	<h1>오늘 점심은?????</h1>
		<form method="post" action="/diary/lunchVoteAction.jsp"></form>
		<div>
			<%=lunchDate%>
		</div>
		
		<div>

			<%=menu%>
		
		</div>
		<br>			
		<div class="container mt-5 right">
			<button type="submit" class="btn btn-outline-secondary">
				<a href="/diary/deleteLunchVoteAction.jsp">삭제</a>
			</button> 
			<button type="submit"><a href="/diary/lunch.jsp">전체통계보기</a></button>
		</div>
		</form>
</body>
</html>
