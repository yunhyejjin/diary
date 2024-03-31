<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.net.*"%> 
<%
	//0. post 인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//1. 입력값 받는다
	String diaryDate = request.getParameter("diaryDate");
	String memo = request.getParameter("memo");
	
	System.out.println("diaryDate : " + diaryDate);
	System.out.println("memo : " + memo);
	
	// 2. DB접속해서 입력값 입력한다.
	String sql = "insert into comment(diary_date, memo, update_date, create_date) values(?, ?, now(), now())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	PreparedStatement stmt = conn.prepareStatement(sql); //객체생성
	stmt.setString(1, diaryDate);
	stmt.setString(2, memo);
	
	System.out.println(stmt);
	
	int row = stmt.executeUpdate();
	if(row == 1) { //입력받은 행이 1이면 성공
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
		
	// 3. 목록(diaryOne.jsp)을 재요청(redirect)하게 된다
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" +diaryDate);
%>