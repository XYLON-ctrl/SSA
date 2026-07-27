<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<aside class="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-university"></i>
        <span>Campus Analytics</span>
    </div>
    <ul class="sidebar-menu">
        
        <%-- Determine active page from request URI if not set --%>
        <c:set var="currentPage" value="${activePage}" />
        <c:if test="${empty currentPage}">
            <c:set var="requestURI" value="${pageContext.request.requestURI}" />
            <c:choose>
                <c:when test="${fn:contains(requestURI, '/dashboard')}">
                    <c:set var="currentPage" value="dashboard" />
                </c:when>
                <c:when test="${fn:contains(requestURI, '/profile')}">
                    <c:set var="currentPage" value="profile" />
                </c:when>
                <c:when test="${fn:contains(requestURI, '/timetable')}">
                    <c:set var="currentPage" value="timetable" />
                </c:when>
                <c:when test="${fn:contains(requestURI, '/attendance')}">
                    <c:set var="currentPage" value="attendance" />
                </c:when>
                <c:when test="${fn:contains(requestURI, '/marks')}">
                    <c:set var="currentPage" value="marks" />
                </c:when>
                <c:when test="${fn:contains(requestURI, '/students')}">
                    <c:set var="currentPage" value="students" />
                </c:when>
                <c:when test="${fn:contains(requestURI, '/leave-approval')}">
                    <c:set var="currentPage" value="leaveApproval" />
                </c:when>
            </c:choose>
        </c:if>
        
        <li>
            <a href="${pageContext.request.contextPath}/faculty/dashboard" 
               class="${currentPage == 'dashboard' ? 'active' : ''}">
                <i class="fas fa-th-large"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/faculty/profile" 
               class="${currentPage == 'profile' ? 'active' : ''}">
                <i class="fas fa-user-tie"></i> Profile
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/faculty/timetable" 
               class="${currentPage == 'timetable' ? 'active' : ''}">
                <i class="fas fa-calendar-alt"></i> Timetable
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/faculty/attendance" 
               class="${currentPage == 'attendance' ? 'active' : ''}">
                <i class="fas fa-clipboard-check"></i> Attendance
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/faculty/marks" 
               class="${currentPage == 'marks' ? 'active' : ''}">
                <i class="fas fa-graduation-cap"></i> Marks
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/faculty/students" 
               class="${currentPage == 'students' ? 'active' : ''}">
                <i class="fas fa-users"></i> Students
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/faculty/leave-approval" 
               class="${currentPage == 'leaveApproval' ? 'active' : ''}">
                <i class="fas fa-file-signature"></i> Leave Approvals
            </a>
        </li>
        
        <li style="margin-top: auto; padding-top: 1rem; border-top: 1px solid var(--sidebar-border);">
            <a href="${pageContext.request.contextPath}/login?action=logout" style="color: var(--error-color);">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </li>
    </ul>
</aside>