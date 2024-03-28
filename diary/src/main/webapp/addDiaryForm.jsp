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
	String checkDate = request.getParameter("checkDate");
	System.out.println("checkDate : " + checkDate);
	
	if(checkDate == null) { // null이면 일기가 있다.(날짜를 쓸수없다.)
		checkDate = " "; // null로 표기하면 보기싫으니까 공란으로 표시하겠다.
	}
	
	String ck = request.getParameter("ck");
	System.out.println("ck : " + ck);
	
	if(ck == null) {
		ck = " ";
	}
	
	
	String msg = " ";
	
	if(ck.equals("T")) { //일기쓰기가 가능하다
		msg = "Possible to keep a diary.";
	
	} else if(ck.equals("F")){ //일기가 존재한다
		msg = "A diary already existes.";
	
	}

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- google fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Edu+NSW+ACT+Foundation:wght@400..700&display=swap" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Nothing+You+Could+Do&display=swap" rel="stylesheet">
	
	<style>
		.h{
			color:#6F6F6F;
			font-size:100px;
			text-decoration: none;
			text-align: center;	
			font-family: "Nothing You Could Do", cursive;
		
		}
		
		.ch{
			color:#6F6F6F;
			font-family: "Edu NSW ACT Foundation", cursive;
			font-size:25px;
		}
		
		table{
			color:#6F6F6F;
			font-family: "Edu NSW ACT Foundation", cursive;
			font-size:25px;
			font-weight:100;
			width: 100%;
		}
		
		th, td {
			color:#6F6F6F;
			text-align: left;
			border-bottom: 1px solid #ddd;
		}
		
		.right {
  			text-align: right;
  			font-weight:bold;
  			font-size:20px
		}
		
		.left {
  			text-align: left;
  			font-weight:bold;
  			font-size:20px
		}
	</style>
</head>
<body style="background-image:url(/diary/img/purple.jpg); background-size: cover">
	
	<h1 class="h mt-5">Writing a Diary</h1>
	

		<div class= "container mt-5">
		<form method="post" action="/diary/checkDateAction.jsp">
			<div class="ch">&#10003; CheckDate : 
				<input type="date" name="checkDate" value="<%=checkDate%>"><span style=color:#F15F5F;>&nbsp;&nbsp;&nbsp;<%=msg%></span>
			</div>
			<br>
			<div class="left">
				<button type= "submit" class="btn btn-outline-secondary">날짜가능확인</button>
			</div>
		</form> 
		</div>	
		
		<hr>
		<br>
		
		<div class= "container">
		<form method="post" action="/diary/addDiaryAction.jsp">
			<table>
				<tr>
					<td>&#10228; Date : </td>
					<td>
						<%
						if(ck.equals("T")) { //checkDate equals T면 출력 
						%>
								
							<input value="<%=checkDate%>" type="text" name="diaryDate" readonly="readonly">
				
						<%		
							} else {
						%>
								
							<input value="" type="text" name="diaryDate" readonly="readonly">
				
						<%		
							}
						%>
					</td>
				</tr>
				
				
				<tr>
					<td>&#10228; Feeling : </td>
					<td>
						<input type="radio" name="feeling" value="&#128525;">&#128525;
						<input type="radio" name="feeling" value="&#128528;">&#128528;
						<input type="radio" name="feeling" value="&#128545;">&#128545;
						<input type="radio" name="feeling" value="&#128557;">&#128557;
						<input type="radio" name="feeling" value="&#128567;">&#128567;
						<input type="radio" name="feeling" value="&#128564;">&#128564;
					</td>
				</tr>	
				
				<tr>
					<td>&#10228; Title : </td>
					<td><input type="text" name="title"></td>
				</tr>
					
				<tr>
					<td>&#10228; Weather : </td>
					<td>
						<select name="weather">
							<option value="맑음">맑음</option>
							<option value="흐림">흐림</option>
							<option value="비">비</option>
							<option value="눈">눈</option>
						</select>
					</td>
				</tr>
					
				<tr>
					<td>&#10228; Story : </td>
					<td><textarea rows= "3" cols="70" name="content"></textarea></td>
				</tr>
			</table>
			
			<br>
			<div class="right">
				<button type="submit" class="btn btn-outline-secondary">일기쓰기</button>
			</div>		
				
		</form>
		</div>
</body>
</html>