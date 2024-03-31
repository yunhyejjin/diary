<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
	//투표 가능한 날짜인지 확인하기 위한 모듈 
	// checkDateAction.jsp 활용
	String checkDate = request.getParameter("checkDate");
	System.out.println("checkDate : " + checkDate);
	
	if(checkDate == null) { // null이면 투표를 했다.(날짜를 쓸수없다.)
		checkDate = " "; // null로 표기하면 보기싫으니까 공란으로 표시하겠다.
	}
	
	String ck = request.getParameter("ck");
	System.out.println("voteck : " + ck);
	
	if(ck == null) {
		ck = " ";
	}
	
	
	String msg = " ";
	
	if(ck.equals("T")) { //투표가 가능하다
		msg = "Possible to keep a voto.";
	
	} else if(ck.equals("F")){ // 이미 존재한다
		msg = "A vote already existes.";
	
	}

%>

<%
	// 점심투표(가능한날짜) 할 데이터 가져오기
	String lunchDate = request.getParameter("lunchDate");
	String menu = request.getParameter("menu");
	
	System.out.println("votelunchDate :  "  + lunchDate);
	System.out.println("votemenu :  "  + menu);
	/*
		SELECT lunch_date, menu FROM lunch 
	*/
	String sql ="SELECT lunch_date, menu FROM lunch ";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
		
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- google fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Edu+NSW+ACT+Foundation:wght@400..700&display=swap" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Nothing+You+Could+Do&display=swap" rel="stylesheet">
	
</head>
<body style="background-image:url(/diary/img/www.jpg); background-size: cover">

	<div class="container mt-3 fir" >
		<a href="/diary/diary.jsp">&#x1F5D3;</a>
	</div>
	
	<h1>점심메뉴투표하기</h1>
	
	<form method="post" action="/diary/voteCheckAction.jsp">
		<div>&#10003; CheckDate : 
			<input type="date" name="checkDate" value="<%=checkDate%>"><span style=color:#F15F5F;>&nbsp;&nbsp;&nbsp;<%=msg%></span>
		</div>
			<br>
		<div>
			<button type= "submit" class="btn btn-outline-danger btn-md">투표가능확인</button>
		</div>
	</form> 
	<hr>
	
										
	<form method="post" action="/diary/lunchResult.jsp">
			<div>Date : 					
				<%
					if(ck.equals("T")) { //checkDate equals T면 출력 
				%>
									
					<input value="<%=checkDate%>" type="text" name="lunchDate" readonly="readonly">
					
				<%		
					} else {
				%>
								
						<input value="" type="text" name="lunchDate" readonly="readonly">
				
				<%		
					}
				%>
			</div>
			
			<div><input type="radio" name="menu" value="한식" >한식</div>
			<div><input type="radio" name="menu" value="양식" >양식</div>
			<div><input type="radio" name="menu" value="일식" >일식</div>
			<div><input type="radio" name="menu" value="중식" >중식</div>
			<div><input type="radio" name="menu" value="기타" >기타</div>		
		
			<hr>
	
	
	
		<div>
			<button type="submit" class="btn btn-outline-secondary btn-md">선택하기</button>
		</div>
	</form>

</body>
</html>