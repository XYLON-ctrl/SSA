<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Admin Dashboard" scope="request" />
<%@ include file="adminHead.jsp" %>

<div class="app-wrapper">
    <%@ include file="adminSidebar.jsp" %>
    <div class="main-content">
        <%@ include file="adminNavbar.jsp" %>

        <div class="content-area">
            
            <!-- Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error" id="serverAlert">
                    <i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}" />
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success" id="serverAlert">
                    <i class="fas fa-check-circle"></i> <c:out value="${successMessage}" />
                </div>
            </c:if>

            <!-- Hero Section -->
            <div class="hero-section">
                <div class="hero-content">
                    <div class="hero-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="hero-text">
                        <h1>Admin Control Panel</h1>
                        <p>Manage departments, sections, faculty, students, and timetable from one place.</p>
                    </div>
                </div>
            </div>

            <!-- ✅ ROW 1: Departments, Sections, Faculty (Active / Total format) -->
            <div class="kpi-grid" style="grid-template-columns: repeat(3, 1fr); margin-bottom: 1.5rem;">
                
                <!-- Departments Card -->
                <div class="kpi-card blue">
                    <div class="kpi-icon"><i class="fas fa-building"></i></div>
                    <div class="kpi-label">Departments</div>
                    <div class="kpi-value" style="font-size: 1.75rem;">
                        <span style="color: #10b981;"><c:out value="${activeDepartments}" default="0" /></span>
                        <span style="color: #9ca3af; font-size: 1.25rem;"> / </span>
                        <span style="color: #6b7280;"><c:out value="${totalDepartments}" default="0" /></span>
                    </div>
                    <div class="kpi-sublabel">Active departments</div>
                </div>

                <!-- Sections Card -->
                <div class="kpi-card green">
                    <div class="kpi-icon"><i class="fas fa-layer-group"></i></div>
                    <div class="kpi-label">Sections</div>
                    <div class="kpi-value" style="font-size: 1.75rem;">
                        <span style="color: #10b981;"><c:out value="${activeSections}" default="0" /></span>
                        <span style="color: #9ca3af; font-size: 1.25rem;"> / </span>
                        <span style="color: #6b7280;"><c:out value="${totalSections}" default="0" /></span>
                    </div>
                    <div class="kpi-sublabel">Active sections</div>
                </div>

                <!-- Faculty Card -->
                <div class="kpi-card purple">
                    <div class="kpi-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="kpi-label">Faculty</div>
                    <div class="kpi-value" style="font-size: 1.75rem;">
                        <span style="color: #10b981;"><c:out value="${activeFaculty}" default="0" /></span>
                        <span style="color: #9ca3af; font-size: 1.25rem;"> / </span>
                        <span style="color: #6b7280;"><c:out value="${totalFaculty}" default="0" /></span>
                    </div>
                    <div class="kpi-sublabel">Active faculty members</div>
                </div>

            </div>

            <!-- ✅ ROW 2: Students, Subjects, Timetable (unchanged format) -->
            <div class="kpi-grid" style="grid-template-columns: repeat(3, 1fr); margin-bottom: 1.5rem;">
                
                <!-- Students Card -->
                <div class="kpi-card orange">
                    <div class="kpi-icon"><i class="fas fa-user-graduate"></i></div>
                    <div class="kpi-label">Students</div>
                    <div class="kpi-value"><c:out value="${totalStudents}" default="0" /></div>
                    <div class="kpi-sublabel">Active students</div>
                </div>

                <!-- Subjects Card -->
                <div class="kpi-card blue">
                    <div class="kpi-icon"><i class="fas fa-book"></i></div>
                    <div class="kpi-label">Subjects</div>
                    <div class="kpi-value"><c:out value="${totalSubjects}" default="0" /></div>
                    <div class="kpi-sublabel">Active subjects</div>
                </div>

                <!-- Timetable Card -->
                <div class="kpi-card red">
                    <div class="kpi-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="kpi-label">Timetable Entries</div>
                    <div class="kpi-value"><c:out value="${totalTimetableEntries}" default="0" /></div>
                    <div class="kpi-sublabel">Scheduled classes</div>
                </div>

            </div>

        </div>

        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.custom-alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.classList.add('fade-out');
                setTimeout(() => alert.remove(), 500);
            }, 5000);
        });
    });
</script>
</body>
</html>