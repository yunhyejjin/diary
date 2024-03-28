<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 로그인(인증) 분기(확인)
	// diary.login.my_session => 'ON' => redirect("diary.jsp") 
	// **diary.login.my_session => 'OFF' => redirect("loginForm.jsp") -- my_session이 OFF면 ("loginForm.jsp")으로 재요청
	
	String sql1 = "select my_session mySession from login"; // login테이블로부터 my_session을 가져올건데 별칭이 mySession인 것으로 바꿔서 가져오겟다!!
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1); 
	rs1 = stmt1.executeQuery(); // 쿼리문
	
	String mySession = null;
	if(rs1.next()) {
		mySession = rs1.getString("mySession"); 
	}
	
		System.out.println("loginForm mySession: " + mySession);
	
	if(mySession.equals("ON")) { //로그인이 된 상태 'ON'상태면 diary.jsp 로 바로 넘어감
		response.sendRedirect("/diary/diary.jsp"); // get방식
		return; //코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용(진행이 필요없다 싶을 때)
	}
	
	// mySession >> 'ON'상태면 diary.jsp 로 바로 넘어감
	// mySession >> 'OFF'상태면 loginForm.jsp 
	// 'OFF'상태에서 로그인 시도시 errMsg 확인
	
	
	// 1. 요청값 분석
	String errMsg = request.getParameter("errMsg");

	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
		<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- google fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Edu+NSW+ACT+Foundation:wght@400..700&display=swap" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Nothing+You+Could+Do&display=swap" rel="stylesheet">
	<style>
		.h1{
			color:black;
			font-size:100px;
			text-decoration: none;
			text-align: center;	
			font-family:  "Nothing You Could Do", cursive;
		
		}
		
		.m{
			color:black;
			font-size:30px;
			text-align: left;
			text-decoration: none;
			font-family: "Edu NSW ACT Foundation", cursive;
		}
		
		.right {
  			text-align: right;
  			font-weight:bold;
  			font-size:20px
		}

	</style>
</head>
<body style="background-image:url(/diary/img/sunset.jpg); background-size: cover">
	
	<div>
		<%
			if(errMsg != null) {
		%>
			<%="errMsg"%>
		<%		
			}
		%>
	</div>
	

	<h1 class="h1 mt-5">Login</h1>

	
	<div class="row">
		<div class="col"></div>
			<div class="container mt-5 col-10  p-5 mb-5">
				
				<form method="post" action="/diary/loginAction.jsp">
					<div class="m">
						&#9956; Member ID : 
						<br>
						<input type = "text" name= "memberId" class="form-control form-control-lg" placeholder="Your Member ID">
					</div>
					
					<br>
					<div class="m">
						&#9956; Member PW :
						<br>
						<input type = "password" name= "memberPw" class="form-control form-control-lg" placeholder="Your Member PW">
					</div>
					
					<br>
					<br>
					<div class="right">
						<button type = "submit" class="btn btn-outline-danger btn-md">
							&#128746; go...
						</button>
					</div>
				</form>
			
			</div>
		<div class="col"></div>
	</div>
	

</body>
</html>