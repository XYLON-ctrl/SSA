<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <i class="fas fa-building-columns"></i>
        </div>
        <div class="sidebar-title">Campus Analytics</div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
                <i class="fas fa-th-large"></i> Dashboard
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/departments" 
               class="nav-link ${activePage == 'departments' ? 'active' : ''}">
                <i class="fas fa-building"></i> Departments
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/sections" 
               class="nav-link ${activePage == 'sections' ? 'active' : ''}">
                <i class="fas fa-layer-group"></i> Sections
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/faculty" 
               class="nav-link ${activePage == 'faculty' ? 'active' : ''}">
                <i class="fas fa-chalkboard-teacher"></i> Faculty
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/students" 
               class="nav-link ${activePage == 'students' ? 'active' : ''}">
                <i class="fas fa-user-graduate"></i> Students
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/subjects" 
               class="nav-link ${activePage == 'subjects' ? 'active' : ''}">
                <i class="fas fa-book"></i> Subjects
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/timetable" 
               class="nav-link ${activePage == 'timetable' ? 'active' : ''}">
                <i class="fas fa-calendar-alt"></i> Timetable
            </a>
        </div>

        <div class="nav-divider"></div>

        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/logout" class="nav-link logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </nav>
</aside>