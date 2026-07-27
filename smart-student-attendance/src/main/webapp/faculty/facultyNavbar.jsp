<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<nav class="top-navbar">
    <div class="navbar-left">
        <h5 class="mb-0" style="font-weight: 600; color: var(--text-dark);"><c:out value="${pageTitle}" default="Dashboard" /></h5>
    </div>
    <div class="navbar-right">
        <div class="dropdown">
            <div class="profile-dropdown" data-bs-toggle="dropdown">
                <div class="profile-avatar"><c:out value="${fn:substring(loggedInUser.fullName, 0, 1)}" default="F" /></div>
                <div class="profile-info">
                    <div style="font-size: 0.875rem; font-weight: 600;"><c:out value="${loggedInUser.fullName}" /></div>
                    <div style="font-size: 0.75rem; color: var(--text-muted);">Faculty</div>
                </div>
            </div>
            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-custom">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/faculty/profile"><i class="fas fa-user me-2"></i> Profile</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></li>
            </ul>
        </div>
    </div>
</nav>