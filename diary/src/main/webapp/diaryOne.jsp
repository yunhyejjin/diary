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
	String diaryDate = request.getParameter("diaryDate");
	System.out.println("diaryDate : " + diaryDate);
	
	/*
	SELECT diary_date, title, weather, content 
	FROM diary
	where title = ?
	*/
	String sql = "SELECT diary_date, feeling, title, weather, content FROM diary where diary_date = ?";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = conn.prepareStatement(sql); 
	stmt.setString(1,diaryDate);
	System.out.println("stmt: " + stmt);
	
	rs = stmt.executeQuery();

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
		color:#6F6F6F;
		font-size:100px;
		text-decoration: none;
		text-align: center;	
		font-family: "Nothing You Could Do", cursive;
		}
		
	table{
		color:#6F6F6F;
		font-family: "Edu NSW ACT Foundation", cursive;
		font-size:25px;
		font-weight:100;

		}
		
	th, td {
		color:#6F6F6F;
		text-align: left;
		border-bottom: 1px solid #ddd;
		}
		
	.fir {
			 color:#6F6F6F;
			 text-align: left;
			 font-size: 30px;
			 font-family: "Edu NSW ACT Foundation", cursive;
		}
		
	.right {
			color:#6F6F6F;
			font-size: 20px;
			text-align: right;	
			font-family: "Edu NSW ACT Foundation", cursive;
		}	
	
	a:link {color:#6F6F6F; text-decoration: none;}
	a:active {color:#6F6F6F; text-decoration: none;}
	a:visited {color:#6F6F6F; text-decoration: none;}
	a:hover {color:#FFFFFF; text-decoration: none;}
	</style>
</head>
<body style="background-image:url(/diary/img/purple.jpg); background-size: cover">

	<div class="container mt-3 fir" >
		<a href="/diary/diary.jsp">&#x1F5D3;</a>
	</div>	
	
	<h1 class="h1 mt-5">Today's Diary</h1>

		
		<%
			if(rs.next()) {
		%>	
		
		<div class="container mt-5 mb-5">
			<table class="table">
				<tr>
					<td>&#10228; Date :</td>
					<td><%=rs.getString("diary_date")%></td>
				</tr>
				<tr>
					<td>&#10228; Feeling : </td>
					<td><%=rs.getString("feeling")%></td>
				</tr>
				<tr>
					<td>&#10228; Title : </td>
					<td><%=rs.getString("title")%></td>
				</tr>
				<tr>
					<td>&#10228; Weather : </td>
					<td><%=rs.getString("weather")%></td>
				</tr>
				<tr>
					<td>&#10228; Story : </td>
					<td><%=rs.getString("content")%></td>
				</tr>
			</table>
		
		<% 
			} else {
		%>
		
			<div><%=diaryDate%>의 글이 존재하지 않습니다.</div>
		
		<%
			}
		%>
	
		
				<div class="container mt-5 right">
					<button type="submit" class="btn btn-outline-secondary"><a href="/diary/updateDiaryForm.jsp?diaryDate=<%=diaryDate%>">수정</a></button>
					<button type="submit" class="btn btn-outline-secondary"><a href="/diary/deleteDiary.jsp?diaryDate=<%=diaryDate%>">삭제</a></button> <!-- 삭제할diaryDate=<%=diaryDate%> 필수  -->
				</div>
		
		</div>

</body>
</html>