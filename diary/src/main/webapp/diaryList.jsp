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
	// 0. 로그인(인증) 분기
		String loginMember = (String)(session.getAttribute("loginMember"));
		if(loginMember == null) { // null값이면 로그아웃상태이니까 
			String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
			response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
			return;
		}

%>

<%
	//출력할 리스트 모듈
	int currentPage = 1; // 현재 페이지가 1이다
	if(request.getParameter("currentPage") != null) { // 넘어온 페이지가 null값이 아닐때
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10; // 한페이지당 보여지는 행수가 10개다
	
	/*
	if(request.getParameter("rowPerPage") != null) { 
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	*/
	int startRow = ((currentPage-1)*10); // 시작하는 행번호 ex)현재페이지가 1페이지면 0~9 >>0번, 2페이지면 10~19>>10번
	
	
	String searchWord = ""; // 1.("") 2.(" ") 1번과 2번 차이점: 공백이 들어가면 while문이 없다(반복할 리스트가 없다)와 같다 >> 빈 리스트만 출력됨
	//searchWord는 null값이 들어갈 수 없다.(null으로 title을 정하진 않으니까.) --> 경우의 수을 하나 줄인 것 
	if(request.getParameter("searchWord") != null) { 
		searchWord = request.getParameter("searchWord");
	}
	/*
		SELECT diary_date diaryDate, title
		FROM diary
		WHERE title LIKE '(searchWord)? ' --> title에 'searchWord' 가 들어가는...
		ORDER BY diary_date DESC
		LIMIT ?, ?;
	*/	
	
	String sql2 = "SELECT diary_date diaryDate, title FROM diary WHERE title LIKE ? ORDER BY diary_date DESC LIMIT ?, ?";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt2 = conn.prepareStatement(sql2); // sql 불러오기
	stmt2.setString(1, "%"+searchWord+"%"); // 검색할 단어
	stmt2.setInt(2,startRow); // 시작하는 행번호 0
	stmt2.setInt(3,rowPerPage); // 한페이지당 보여지는 행수
	System.out.println("stmt2: " + stmt2);
	
	rs2 = stmt2.executeQuery(); // 쿼리문 실행(출력)
%>

<%
	//lastPage  모듈
	/*
		select count(*) count 
		from diary 
		where title like ? >> diary로부터 '?' 가 들어가는 전체행수를 구하는 쿼리 		
	*/			
	String sql3 = "select count(*) count from diary where title like ?";
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1,"%"+searchWord+"%");
	System.out.println("stmt3: " + stmt3);
	
	rs3 = stmt3.executeQuery();
	int totalRow = 0;
	if(rs3.next()){
		totalRow = rs3.getInt("count");
		System.out.println("totalRow: " + totalRow);
	}
	int lastPage = totalRow / rowPerPage; //마지막 페이지= 전체 행/한 페이지당 보여지는 행(10)
	if(totalRow%rowPerPage !=0) { // 전체 행/한 페이지당 보여지는 행(10)을 했을때 나머지가 0이 아니면 출력
		lastPage = lastPage + 1; // 나머지 값이 생기기 때문에 +1을 해줘야 함  
	}
	
	System.out.println("lastPage: " + lastPage);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
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
		
	.right { 
			color:#6F6F6F;
			font-size: 20px;
			text-decoration: none;
			text-align: right;	
			font-family: "Edu NSW ACT Foundation", cursive;
		}
		
	.fir {
			 color:#6F6F6F;
			 text-align: left;
			 font-size: 30px;
			 font-family: "Edu NSW ACT Foundation", cursive;
		}
		
	table{
			color:#6F6F6F;
			font-family: "Nothing You Could Do", cursive;
			font-size:22px;
			
		}
				
	th, td {				
			color:#6F6F6F;
			text-align: left;
			border-bottom: 1px solid #ddd;
		}
	
	a:link {color:#6F6F6F; text-decoration: none;}
	a:active {color:#6F6F6F; text-decoration: none;}
	a:visited {color:#6F6F6F; text-decoration: none;}
	a:hover {color:#6799FF; text-decoration: none;}
	</style>
</head>
<body style="background-image:url(/diary/img/www.jpg); background-size: cover">
	
	<div class="container mt-3 fir" >
		<a href="/diary/diary.jsp">&#x1F5D3;</a>
	</div>	
	
	<h1 class="h1 mt-5">Diary'List</h1>
	
	<div class= "container mt-5 fir">
		<table class="table table-Active">
			<tr>
				<td>날짜</td>
				<td>제목</td>
			</tr>
			<%
				while(rs2.next()) {
			%>
					<tr>
						<td><a href="/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>"><%=rs2.getString("diaryDate")%></a></td>
						<td><%=rs2.getString("title")%></td>
					</tr>
			<%		
				}
			%>
		</table>
	
		<!-- 페이징버튼 -->
		<nav aria-label="Page navigation example">
			<ul class="pagination">
			  	
			  	<%
					if(currentPage > 1) {
				%>
			  	
				  		<li class="page-item">
				  			<a class="page-link" href="./diaryList.jsp?currentPage=1"><<<</a>
				  		</li>
				    	<li class="page-item">
				    		<a class="page-link" href="./diaryList.jsp?currentPage=<%=currentPage-1%>">PREW</a>
				    	</li>
				    
			    <%			
					} else {
				%>	
			    
				    	<li class="page-item disabled">
				    	 	<a class="page-link" href="./diaryList.jsp?currentPage=1"><<<</a>
				    	</li>
				    	<li class="page-item disabled">
				    		<a class="page-link" href="./diaryList.jsp?currentPage=<%=currentPage-1%>">PREW</a>
				    	</li>
			    
			    <%		
					}
			
					if(currentPage < lastPage) {
				%>
			  	
			  			<li class="page-item">
			    		 	<a class="page-link" href="./diaryList.jsp?currentPage=<%=currentPage+1%>">NEXT</a>
			    		</li>
			    		<li class="page-item">
			    			<a class="page-link" href="./diaryList.jsp?currentPage=<%=lastPage%>">>>></a>
			    		</li>
			  	
			  	<%	
					} 
				%>
			</ul>
		</nav>
	
		<form method="get" action="/diary/diaryList.jsp"> 
		<!-- get 방식은 검색정보 확인 할수 있음 / post 방식은 보안 -->
			<div class="right">
				<input type="text" name="searchWord" placeholder="SearchWord..." >
				<button type="submit" class="btn btn-outline-secondary btn-sm">검색&#128269;</button>
			</div>
		</form>

	</div>

</body>
</html>