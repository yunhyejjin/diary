<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import= "java.net.*"%> 
<%@ page import = "java.util.*" %>
<%
	// 0. 로그인(인증) 분기
	// **diary.login.my_session => 'ON' => redirect("diary.jsp") -- my_session이 ON면 ("diary.jsp")으로 재요청
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	/*
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
		System.out.println("diary mySession: " + mySession);
	}
	
	
	if(mySession.equals("OFF")) { // 쿼리문에 mySession이 "OFF"면 출력 로그인X
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8"); // (URLEncoder.encode)-> 한글꺠짐방지 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); // get방식
		
		//DB자원 반납
		rs1.close();
		stmt1.close();
		conn.close();
	 	
		return; //코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용(진행이 필요없다 싶을 때)
	}
	*/
%>

<%
	//0. 로그인(인증) 분기
		String loginMember = (String)(session.getAttribute("loginMember"));
		if(loginMember == null) { // null값이면 로그아웃상태이니까 
			String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
			response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
			return;
		}

%>

<%	
	// 1. 입력값 요청 분석
	// 받으려는 달력의 년과 월값을 넘겨 받는다
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	Calendar target = Calendar.getInstance(); //오늘날짜 구하는 API
	
	//디버깅코드
	System.out.println("targetYear: " + targetYear);
	System.out.println("targetMonth: " + targetMonth);
	System.out.println("target: " + target);
	
	if(targetYear != null && targetMonth != null ) { //tYear값이 null값이 아니고, tMonth값이 null값이 아니면 출력
		target.set(Calendar.YEAR, Integer.parseInt(targetYear)); //년도부터 받아야함
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
	}
	// 시작공백의 갯수 -> 1일의 요일확인 -> 요일은 직접구할수 없고, 정해져잇는 숫자를 구한다 -> 원하는 날짜를 1일로 변경
	target.set(Calendar.DATE, 1);
	
	// 구하려는 요일의 숫자(순서)
	int yoNum = target.get(Calendar.DAY_OF_WEEK); // 일요일:1, 월:2, 화:3,....토:7 ex)24.3.1 금요일의 순서 
	System.out.println("yoNum: " + yoNum);
	
	// 시작 공백의 겟수 :  일요일이면 공백 없음, 월요일은 1칸, 화요일은 2칸, 수요일은 3칸,,,,토요일은 6칸
	int startBlank = yoNum - 1; // 달력의 처음 공백란을 구하기 위한 패턴 파악 ex)일요일=1, 공백수 0 /월요일=2, 공백수 1 /화요일=3, 공백수 2... 요일의 숫자 빼기 1을 하면 공백수가 나옴..
	// 원하는 달의 마지막 날짜(28일 or 29일 or 30일 or 31일) 반환
	int lastDate = target.getActualMaximum(Calendar.DATE);
	// 전체 div갯수(날짜가있는 달력칸의 갯수) 구하기
	int countDiv = startBlank + lastDate;
	//디버깅코드
	System.out.println("startBlank: " + startBlank);
	System.out.println("lastDate: " + lastDate);
	System.out.println("countDiv: " + countDiv);
	
	
	// 달력 제목을 위함 출력값
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH); // 0부터 시작하기 때문에 생각한 값보다 1적게 나옴
	//디버깅코드
	System.out.println("tYear: " + tYear);
	System.out.println("tMonth: " + tMonth);
	
	// DB에서 tYear와 tMonth에 해당하다는 diary 목록 추출
	
	/*SELECT 
	diary_date diaryDate, day(diary_date) day, left(title, 5) title --- diary_date diaryDate: 날짜를 받기위해, /day(diary_date) day: 일자를 받기위해, /left(title, 5) title: 제목의 다섯글자만 
	FROM diary
	WHERE YEAR(diary_date) = ? AND MONTH(diary_date) = ?
	*/
	
	String sql2 = "SELECT diary_date diaryDate, day(diary_date) day, feeling, left(title,5) title FROM diary WHERE YEAR(diary_date)= ? AND MONTH(diary_date)= ?";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt2 = conn.prepareStatement(sql2); 
	stmt2.setInt(1,tYear);
	stmt2.setInt(2,tMonth+1); // 0부터 시작하기 때문에 생각한 값보다 1적게 나옴 ex)3월을 생각했지만 2월이 나오는?
	System.out.println("stmt2: " + stmt2);
	
	rs2 = stmt2.executeQuery(); // 쿼리문
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
	
		.cell {
			float: left;
			background: rgba(175, 178, 193, 0.1);
			width: 110px; height: 80px;
			border: 2px solid ;
			border-style: outset;
			margin: 3px;
			text-align: left;
			font-family: "Edu NSW ACT Foundation", cursive;	
		
		}
		
		.sun {
			clear: both;
			color: #F15F5F;
			background: rgba(175, 178, 193, 0.1);
		}
		
		.sat {
			clear: right;
			color: #5F00FF;
			background: rgba(175, 178, 193, 0.1);
		}
		
		.yo {
			float: left;
			width: 110px; height: 30px;
			border: 2px solid ;
			border-style: outset;
			margin: 3px;
			text-align: center;
			font-size:large;
			font-family: "Edu NSW ACT Foundation", cursive;
			background: rgba(175, 178, 193, 0.1);
			
		}
		.h1{
			color:#6F6F6F;
			font-size:100px;
			text-decoration: none;
			text-align: center;	
			font-family: "Nothing You Could Do", cursive;
		
		}
		
		.h3{
			color:black;
			font-size:30px;
			text-decoration: none;
			text-align: center;	
			font-family: "Edu NSW ACT Foundation", cursive;
		
		}
		
		.left { 
			color:#6F6F6F;
			font-size: 20px;
			text-decoration: none;
			text-align: left;	
			font-family: "Edu NSW ACT Foundation", cursive;
		}
		
		.right {
			color:#6F6F6F;
			font-size: 20px;
			text-decoration: none;
			text-align: right;	
			font-family: "Edu NSW ACT Foundation", cursive;
		}
		
		.log {
			color:#6F6F6F;
			font-size:20px;
			text-decoration: none;
			text-align: center;	
			font-family: "Edu NSW ACT Foundation", cursive;
		}
		
		.fir {
			 color:#6F6F6F;
			 text-align: left;
			 font-size: 30px;
			 font-family: "Edu NSW ACT Foundation", cursive;
		}
		
		a:link {color:#6F6F6F; text-decoration: none;}
		a:active {color:#6F6F6F; text-decoration: none;}
		a:visited {color:#6F6F6F; text-decoration: none;}
		a:hover {color:#FFFFFF; text-decoration: none;}
				
	</style>	
</head>
<body style="background-image:url(/diary/img/www.jpg); background-size: cover">
	
	<div class="container mt-3 fir" >
		<a href="/diary/diary.jsp">&#x1F5D3;</a>
		<a href="/diary/diaryList.jsp">&#8801;</a>
	</div>
	
	
	<h1 class="h1 mt-5">Diary.Calendar</h1>
	
	
	<div class="container mt-5 p-3 mb-5">	
	
		<div class="row">
				<button type="submit" class="btn btn-outline-secondary btn-sm">
					<a href="/diary/addDiaryForm.jsp" class= "log">일기쓰기</a>
				</button>
		</div>	
		
		<div class="row">
			
				<h3 class="h3 mt-4">
					<a href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>" class="left" ><<< PREV</a>
					
						<span class="col-10"><%=tYear%>년 <%=tMonth+1%>월</span> <!-- 0부터 시작하기 때문에 생각한 값보다 1적게 나옴 --> 
				
					<a href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>" class="right">NEXT >>></a>
				</h3>
		</div>	
	
		
		<div class="row">
			<div class="col-2"></div>
			
			
			<div class="col-10">
			
				<div class="yo sun">SUN</div>
				<div class="yo">MON</div>
				<div class="yo">TUE</div>
				<div class="yo">WED</div>
				<div class="yo">THU</div>
				<div class="yo">FRI</div>
				<div class="yo sat">SAT</div>
				
				<%
					for(int i=1; i<=countDiv; i=i+1) {
						
						if(i%7 == 1) {
				%>
				
							<div class ="cell sun">
				
				<%			
						} else if(i%7 == 0) {
				%>
				
							<div class ="cell sat">
				
				<%			
						} else {
				%>
				
							<div class ="cell">
				
				<%			
						}
								if(i-startBlank > 0) { // 입력값빼기 시작공란이 0보다 크면(1부터 나옴) 출력 ex) startBlank : 5
							%>
									<%=i-startBlank%><br>
							<%		
									//현재날짜(i-startBlank)의 일기가 rs2목록에 있는지 비교
									while(rs2.next()){
										//날짜에 일기가 존재한다 ->> 출력 후  
										if(rs2.getInt("day") == (i-startBlank)) {
							%>
											<div>
												<span><%=rs2.getString("feeling")%></span>
												<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
													<%=rs2.getString("title")%>...
												</a> 
											</div>
							<%
											break;	// brake로 빠져 나온 후 
										}
									}
									rs2.beforeFirst(); // ResultSet의 커스 위치(1일부터 다시 찾기)를 처음으로..
								} else {
							%>
									&nbsp;
							<%		
								}
							%>	
							</div>
				<% 			
					}
				%>
					</div>
					</div>
			</div>
			
			<div class="col-2"></div>
		</div>
	</div>	
			
		
		<div class="row">
			<div class="log">
				<button type="submit" class="btn btn-outline-secondary btn-md">
					<a href="/diary/logout.jsp">&nbsp;&nbsp;&nbsp;&nbsp;로그아웃&nbsp;&nbsp;&nbsp;&nbsp;</a>
				</button>
			</div>
		</div>
		
	

</body>
</html>