<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-university"></i>
        <span><c:out value="${systemShortName}" default="Campus Analytics" /></span>
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/student/dashboard" class="${activePage == 'dashboard' ? 'active' : ''}"><i class="fas fa-th-large"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/student/profile" class="${activePage == 'profile' ? 'active' : ''}"><i class="fas fa-user"></i> Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/student/attendance" class="${activePage == 'attendance' ? 'active' : ''}"><i class="fas fa-clipboard-check"></i> Attendance</a></li>
        <li><a href="${pageContext.request.contextPath}/student/marks" class="${activePage == 'marks' ? 'active' : ''}"><i class="fas fa-graduation-cap"></i> Marks</a></li>
        <li><a href="${pageContext.request.contextPath}/student/performance" class="${activePage == 'performance' ? 'active' : ''}"><i class="fas fa-chart-line"></i> Academic Performance</a></li>
        <li><a href="${pageContext.request.contextPath}/student/timetable" class="${activePage == 'timetable' ? 'active' : ''}"><i class="fas fa-calendar-alt"></i> Timetable</a></li>
        <li>
            <a href="${pageContext.request.contextPath}/student/notifications" class="${activePage == 'notifications' ? 'active' : ''}">
                <i class="fas fa-bell"></i> Notifications
                <c:if test="${not empty unreadNotifCount && unreadNotifCount > 0}">
                    <span class="badge-notification"><c:out value="${unreadNotifCount}" /></span>
                </c:if>
            </a>
        </li>
        <li><a href="${pageContext.request.contextPath}/student/leave/request" class="${activePage == 'leaveRequest' ? 'active' : ''}"><i class="fas fa-file-signature"></i> Leave Request</a></li>
        <li><a href="${pageContext.request.contextPath}/student/leave/history" class="${activePage == 'leaveHistory' ? 'active' : ''}"><i class="fas fa-history"></i> Leave History</a></li>
        <li style="margin-top: auto; padding-top: 1rem; border-top: 1px solid var(--sidebar-border);">
            <a href="${pageContext.request.contextPath}/logout" style="color: var(--error-color);"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </li>
    </ul>
</aside>

<div class="sidebar-overlay" id="sidebarOverlay" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.5); z-index:999;" onclick="toggleSidebar()"></div>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        sidebar.classList.toggle('show');
        overlay.style.display = sidebar.classList.contains('show') ? 'block' : 'none';
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.custom-alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                alert.classList.add('hiding');
                setTimeout(function() {
                    if (alert.parentElement) { alert.remove(); }
                }, 300);
            }, 3000);
        });
    });
</script>