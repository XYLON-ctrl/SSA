<%-- studentNavbar.jsp --%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!-- Top Navbar -->
<nav class="top-navbar">
    <div class="navbar-left">
        <button class="menu-toggle" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
        <h5 class="mb-0" style="font-weight: 600; color: var(--text-dark);">
            <c:out value="${pageTitle}" default="Dashboard" />
        </h5>
    </div>

    <div class="navbar-right">
        <a href="${pageContext.request.contextPath}/student/notifications" class="nav-icon-btn" title="Notifications">
            <i class="fas fa-bell"></i>
            <c:if test="${not empty unreadNotifCount && unreadNotifCount > 0}">
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem;">
                    <c:out value="${unreadNotifCount}" />
                </span>
            </c:if>
        </a>

        <div class="dropdown">
            <div class="profile-dropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="profile-avatar">
                    <%--  FIXED: Use student.fullName (from DB) instead of loggedInUser.fullName --%>
                    <c:choose>
                        <c:when test="${not empty student}">
                            <c:out value="${fn:substring(student.fullName, 0, 1)}" />
                        </c:when>
                        <c:otherwise>
                            <c:out value="${fn:substring(loggedInUser.fullName, 0, 1)}" default="S" />
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="profile-info">
                    <div class="profile-name">
                        <%--  FIXED: Prefer student.fullName over loggedInUser.fullName --%>
                        <c:choose>
                            <c:when test="${not empty student}">
                                <c:out value="${student.fullName}" />
                            </c:when>
                            <c:otherwise>
                                <c:out value="${loggedInUser.fullName}" default="Student" />
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-role">Student</div>
                </div>
                <i class="fas fa-chevron-down" style="font-size: 0.8rem; color: var(--text-muted);"></i>
            </div>
            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-custom">
                <li><a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/student/profile"><i class="fas fa-user me-2"></i> My Profile</a></li>
                <li><a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/student/notifications"><i class="fas fa-bell me-2"></i> Notifications</a></li>
                <li><hr class="dropdown-divider dropdown-divider-custom"></li>
                <li><a class="dropdown-item dropdown-item-custom" href="${pageContext.request.contextPath}/logout" style="color: var(--error-color);"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></li>
            </ul>
        </div>
    </div>
</nav>