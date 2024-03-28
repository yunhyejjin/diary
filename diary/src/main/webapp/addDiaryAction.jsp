<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import= "java.net.*"%> 
<%
	//로그인 인증(로그인 되어야 다음으로 넘어감)/ mySession이 "ON"인 상태

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
		System.out.println("mySession: " + mySession);
	}
	
	
	if(mySession.equals("OFF")) { // 쿼리문에 mySession이 "OFF"면 출력 로그인X
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8"); // (URLEncoder.encode)-> 한글꺠짐방지 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); // get방식
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용(진행이 필요없다 싶을 때)
	}
	
	// 1.입렵값 받기
	
	String diarydate = request.getParameter("diaryDate");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	System.out.println("diaryDate :  "  + diarydate);
	System.out.println("feeling :  "  + feeling);
	System.out.println("title :  "  + title);
	System.out.println("content : " + content);
	System.out.println("weather : " + weather);
	
	// 2. DB접속해서 입력값 입력한다.
	/* INSERT INTO diary(
	diary_date, title, weather, content, updatedate, createdate
	) VALUES(?, ?, ?, NOW(), NOW())"
	*/
	String addsql = "insert into diary(diary_date, feeling, title, weather, content, update_date, create_date) VALUES(?, ?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null; 
	stmt3 = conn.prepareStatement(addsql); // 추가할 쿼리문 불러오기
	stmt3.setString(1,diarydate);
	stmt3.setString(2,feeling);
	stmt3.setString(3,title);
	stmt3.setString(4,weather);
	stmt3.setString(5,content);
	System.out.println(stmt3);
	
	int row = stmt3.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	
	} else {
		System.out.println("입력실패");
	}
	
	// 3. 목록(diary.jsp)을 재요청(redirect)하게 된다
	response.sendRedirect("/diary/diary.jsp");
	//  else밖에 redirect를 한번 더 보낼 시 , 이중으로 redirect가 계속 진행되니 오류가 남 
	
%>