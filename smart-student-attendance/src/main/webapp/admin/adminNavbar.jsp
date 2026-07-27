<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<nav class="navbar-custom">
    <div>
        <h1 class="navbar-title"><c:out value="${pageTitle}" default="Admin Panel" /></h1>
    </div>
    <div class="navbar-right">
        <div class="user-profile">
            <div class="user-avatar">
                <c:out value="${fn:substring(loggedInUser.fullName, 0, 1)}" default="A" />
            </div>
            <div>
                <div class="user-name"><c:out value="${loggedInUser.fullName}" default="Admin" /></div>
                <div class="user-role">Administrator</div>
            </div>
        </div>
    </div>
</nav>