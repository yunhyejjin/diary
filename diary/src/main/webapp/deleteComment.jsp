<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import= "java.net.*"%> 
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
	// diaryOne.jsp 으로 리다이렉트할때 사용
	String diaryDate = request.getParameter("diaryDate");
	// 댓글 삭제시 사용
	int commentno = Integer.parseInt(request.getParameter("commentno"));
	
	System.out.println("del-diaryDate: " + diaryDate);
	System.out.println("del-commentno: " + commentno);
	
	String sql = "delete from comment where comment_no=?";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentno);
	int row = stmt.executeUpdate();	
	
	System.out.println("del-row : " + row); // 삭제 될 행
	
	// 3. 목록(diaryOne.jsp)을 재요청(redirect)하게 된다
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" +diaryDate);
	
%>