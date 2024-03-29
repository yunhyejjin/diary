<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import= "java.net.*"%> 
<%
	// 0.로그인(인증) 분기(확인)
	// diary.login.my_session => 'ON' => redirect("diary.jsp") 
	// **diary.login.my_session => 'OFF' => redirect("loginForm.jsp") -- my_session이 OFF면 ("loginForm.jsp")으로 재요청
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
	}
	if(mySession.equals("ON")) { // mySession >> 'ON'상태면 diary.jsp 로 바로 넘어감
		response.sendRedirect("/diary/diary.jsp"); // get방식
		return; //코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용(진행이 필요없다 싶을 때)
	}
	
	System.out.println("logAction mySession: " + mySession);
	*/
%>

<%
	//0-1.로그인(인증) 분기(확인)
	String loginMember = (String)(session.getAttribute("loginMember"));
	System.out.println("loginMember(session) : " + loginMember);
	// loginForm페이지는 로그아웃상태에서만 출력되는 페이지
	if(loginMember != null) {
		response.sendRedirect("/diary/diary.jsp");
		return; //코드 진행을 끝내는 문법 ex) 메서드 끝낼때
	}
%>
<%	
	// 1. 요청값(입력값) 분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println("memberId : " + memberId);
	System.out.println("memberPw : " + memberPw);
	
	String sql2 = "select member_id memberId from member where member_id=? and member_pw=?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	conn = DriverManager.getConnection( // DB접속
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt2 = conn.prepareStatement(sql2); 
	stmt2.setString(1,memberId);
	stmt2.setString(2,memberPw);
	rs2 = stmt2.executeQuery(); // 쿼리문
%>	
	
<%		
	if(rs2.next()) {
		// 로그인 성공
		System.out.println("로그인 성공");
		// diary.login.my_session => 'OFF'상태이면 'ON'상태로 변경 업데이트 쿼리문 
		/*
		String sql3 = "UPDATE login SET my_session ='ON', on_date = now() where my_session='OFF'";
		PreparedStatement stmt3 = conn.prepareStatement(sql3); //'ON' 변경쿼리문
		int row = stmt3.executeUpdate(); 
		System.out.println("row : " + row);		
		*/
		// 로그인 성공시 DB값 설정 -> session변수("loginMember", rs2.getString("memberId")) 설정
		session.setAttribute("loginMember", rs2.getString("memberId"));
		
		response.sendRedirect("/diary/diary.jsp");

		
	} else {
		//로그인 실패 
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요.", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); // get방식
	}
		
	
	
%>
