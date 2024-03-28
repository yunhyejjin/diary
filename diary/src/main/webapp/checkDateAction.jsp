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
	
	// 날짜확인하는 소스코드
	
	String checkDate =  request.getParameter("checkDate");
	System.out.println("checkDate : " + checkDate);
	// 결과가 있으면 이미 이 날짜에 일기가 있다 -> 이 날짜에는 일기 입력 x
	String sql2 = "select diary_date diaryDate from diary where diary_date=?";
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,checkDate);
	System.out.println("stmt2 : " + stmt2);
	
	rs2 = stmt2.executeQuery();
	
	if(rs2.next()) {
		// 이 날짜 일기 기록 불가능 (이미 일기가 존재)
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=F");
	} else {
		// 이 날짜 일기 기록 가능
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=T");
	}
	
%>