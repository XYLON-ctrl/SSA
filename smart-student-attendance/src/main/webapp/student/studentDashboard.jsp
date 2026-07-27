<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%@ include file="includes/studentHead.jsp" %>

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --warning-gradient: linear-gradient(135deg, #f59e0b 0%, #f97316 100%);
        --danger-gradient: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        --info-gradient: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        --shadow-soft: 0 8px 32px rgba(0, 0, 0, 0.08);
        --shadow-hover: 0 12px 48px rgba(0, 0, 0, 0.12);
        --radius-xl: 20px;
        --radius-lg: 16px;
        --radius-md: 12px;
    }

    .dashboard-container {
        width: 100%;
	    max-width: 1800px;
	    margin: 0 auto;
	    padding: 2rem;
    }

    /* ===== HERO WELCOME ===== */
    .hero-welcome {
        background: var(--primary-gradient);
        border-radius: var(--radius-xl);
        padding: 2.5rem;
        margin-bottom: 2rem;
        color: white;
        position: relative;
        overflow: hidden;
        box-shadow: var(--shadow-soft);
    }

    .hero-welcome::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -10%;
        width: 500px;
        height: 500px;
        background: rgba(255, 255, 255, 0.08);
        border-radius: 50%;
    }

    .hero-content {
        position: relative;
        z-index: 1;
        display: flex;
        align-items: center;
        gap: 2rem;
        flex-wrap: wrap;
    }

    .hero-avatar {
        width: 90px;
        height: 90px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 2.25rem;
        border: 3px solid rgba(255, 255, 255, 0.3);
        flex-shrink: 0;
    }

    .hero-info { flex: 1; min-width: 250px; }

    .hero-greeting {
        font-size: 0.9rem;
        opacity: 0.85;
        margin-bottom: 0.25rem;
        font-weight: 500;
    }

    .hero-name {
        font-size: 2rem;
        font-weight: 700;
        margin: 0 0 0.5rem 0;
    }

    .hero-designation {
        font-size: 1rem;
        opacity: 0.9;
        margin-bottom: 1rem;
    }

    .hero-meta {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
    }

    .hero-chip {
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.25);
        border-radius: 50px;
        padding: 0.5rem 1rem;
        font-size: 0.85rem;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
    }

    /* ===== KPI CARDS ===== */
    .kpi-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .kpi-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.75rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .kpi-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
    }

    .kpi-card.blue::before { background: var(--info-gradient); }
    .kpi-card.green::before { background: var(--success-gradient); }
    .kpi-card.orange::before { background: var(--warning-gradient); }
    .kpi-card.purple::before { background: var(--primary-gradient); }
    .kpi-card.red::before { background: var(--danger-gradient); }
    

    .kpi-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-hover);
    }

    .kpi-icon {
        width: 52px;
        height: 52px;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.4rem;
        margin-bottom: 1rem;
    }

    .kpi-card.blue .kpi-icon { background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); color: #2563eb; }
    .kpi-card.green .kpi-icon { background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #059669; }
    .kpi-card.orange .kpi-icon { background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #d97706; }
    .kpi-card.purple .kpi-icon { background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); color: #6366f1; }
    .kpi-card.red .kpi-icon { background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); color: #dc2626; }

    .kpi-label {
        font-size: 0.75rem;
        font-weight: 700;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.35rem;
    }

    .kpi-value {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        line-height: 1;
    }

    .kpi-sublabel {
        font-size: 0.8rem;
        color: #9ca3af;
        margin-top: 0.35rem;
    }

    /* ===== MAIN GRID ===== */
    .main-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
    }

    /* ===== CARD STYLES ===== */
    .dash-card {
        background: white;
        border-radius: var(--radius-lg);
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        overflow: hidden;
        margin-bottom: 1.5rem;
    }

    .dash-card-header {
        padding: 1.25rem 1.5rem;
        border-bottom: 2px solid #f3f4f6;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
    }

    .dash-card-title {
        font-size: 1rem;
        font-weight: 700;
        color: #111827;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.6rem;
    }

    .dash-card-title i { color: #667eea; }

    .dash-card-body { padding: 1.5rem; }

    .dash-card-link {
        font-size: 0.8rem;
        color: #667eea;
        text-decoration: none;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 0.3rem;
        transition: all 0.2s ease;
    }

    .dash-card-link:hover {
        color: #764ba2;
        gap: 0.5rem;
    }

    /* ===== QUICK ACTIONS ===== */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 0.75rem;
    }

    .quick-action-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
        padding: 1.25rem 1rem;
        background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
        border: 1px solid #e5e7eb;
        border-radius: var(--radius-md);
        text-decoration: none;
        color: #374151;
        transition: all 0.3s ease;
        text-align: center;
    }

    .quick-action-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        border-color: #667eea;
        color: #667eea;
    }

    .quick-action-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #3b82f6;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1rem;
    }

    .quick-action-label {
        font-size: 0.8rem;
        font-weight: 600;
    }

    /* ===== ATTENDANCE CIRCLE ===== */
    .attendance-circle {
        text-align: center;
        padding: 2rem 0;
    }

    .attendance-percentage {
        font-size: 2.5rem;
        font-weight: 700;
        color: #111827;
        margin-bottom: 1rem;
    }

    .attendance-status {
        font-size: 0.9rem;
        font-weight: 600;
        padding: 0.4rem 1rem;
        border-radius: 50px;
        display: inline-block;
    }

    .attendance-status.excellent { background: #d1fae5; color: #065f46; }
    .attendance-status.good { background: #fef3c7; color: #92400e; }
    .attendance-status.critical { background: #fee2e2; color: #991b1b; }

    /* ===== PERFORMANCE LIST ===== */
    .perf-list {
        max-height: 200px;
        overflow-y: auto;
    }

    .perf-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 1rem;
        background: #f9fafb;
        border-radius: 8px;
        margin-bottom: 0.5rem;
        font-size: 0.85rem;
    }

    .perf-item:last-child { margin-bottom: 0; }

    .perf-semester { color: #6b7280; }
    .perf-cgpa { font-weight: 700; color: #111827; }

    /* ===== LEAVE STATUS ===== */
    .leave-status-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 1rem;
        border-radius: 10px;
        margin-bottom: 0.5rem;
        font-size: 0.875rem;
    }

    .leave-status-item:last-child { margin-bottom: 0; }
    .leave-status-item.pending { background: #fffbeb; color: #92400e; }
    .leave-status-item.approved { background: #ecfdf5; color: #065f46; }
    .leave-status-item.rejected { background: #fef2f2; color: #991b1b; }

    .leave-badge {
        padding: 0.3rem 0.6rem;
        border-radius: 8px;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .leave-badge.pending { background: #f59e0b; color: white; }
    .leave-badge.approved { background: #10b981; color: white; }
    .leave-badge.rejected { background: #ef4444; color: white; }

    /* ===== NOTIFICATIONS ===== */
    .notif-item {
        display: flex;
        gap: 0.75rem;
        align-items: flex-start;
        padding: 0.75rem 0;
        border-bottom: 1px solid #f3f4f6;
    }

    .notif-item:last-child { border-bottom: none; }

    .notif-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: #667eea;
        margin-top: 6px;
        flex-shrink: 0;
    }

    .notif-dot.read { background: transparent; border: 2px solid #d1d5db; }

    .notif-content { flex-grow: 1; }
    .notif-title { font-size: 0.875rem; font-weight: 600; color: #111827; margin-bottom: 2px; }
    .notif-message { font-size: 0.8rem; color: #6b7280; line-height: 1.4; }

    /* ===== PROGRESS BAR ===== */
    .progress-container {
        margin-bottom: 1.5rem;
    }

    .progress-label {
        display: flex;
        justify-content: space-between;
        margin-bottom: 0.5rem;
        font-size: 0.85rem;
    }

    .progress {
        height: 8px;
        background: #f3f4f6;
        border-radius: 4px;
        overflow: hidden;
    }

    .progress-bar {
        height: 100%;
        background: var(--primary-gradient);
        border-radius: 4px;
        transition: width 1.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 1200px) {
        .main-grid { grid-template-columns: 1fr; }
        .kpi-grid { grid-template-columns: repeat(2, 1fr); }
    }

    @media (max-width: 768px) {
        .dashboard-container { padding: 1rem; }
        .hero-welcome { padding: 1.5rem; }
        .hero-content { flex-direction: column; text-align: center; }
        .hero-meta { justify-content: center; }
        .kpi-grid { grid-template-columns: 1fr; }
        .quick-actions { grid-template-columns: 1fr; }
    }
</style>

<div class="app-wrapper">
    <%@ include file="includes/studentSidebar.jsp" %>

    <div class="main-content">
        <%@ include file="includes/studentNavbar.jsp" %>

        <div class="dashboard-container">

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

            <!-- Hero Welcome -->
            <div class="hero-welcome">
                <div class="hero-content">
                    <div class="hero-avatar">
                        <c:out value="${fn:substring(dashboard.student.fullName, 0, 1)}" default="S"/>
                    </div>
                    <div class="hero-info">
                        <div class="hero-greeting">
                            <i class="fas fa-hand-sparkles me-1"></i>
                            Welcome Back
                        </div>
                        <h1 class="hero-name"><c:out value="${dashboard.student.fullName}" default="Student"/></h1>
                        <div class="hero-designation">
                            <c:out value="${dashboard.student.branch}" default="Branch" /> • 
                            Sem <c:out value="${dashboard.student.currentSemester}" default="0" />
                        </div>
                        <div class="hero-meta">
                            <span class="hero-chip">
                                <i class="fas fa-id-card"></i>
                                <c:out value="${dashboard.student.enrollmentNumber}" default="ENR-000" />
                            </span>
                            <span class="hero-chip">
                                <i class="fas fa-graduation-cap"></i>
                                CGPA: <c:out value="${dashboard.student.cgpa}" default="0.0"/>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- KPI Cards -->
            <div class="kpi-grid">
                <!-- Attendance KPI -->
                <c:set var="kpiAttColor" value="red" />
                <c:choose>
                    <c:when test="${dashboard.attendancePercentage > 85}">
                        <c:set var="kpiAttColor" value="green" />
                    </c:when>
                    <c:when test="${dashboard.attendancePercentage >= 75}">
                        <c:set var="kpiAttColor" value="orange" />
                    </c:when>
                </c:choose>

                <div class="kpi-card ${kpiAttColor}">
                    <div class="kpi-icon">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <div class="kpi-label">Attendance</div>
                    <div class="kpi-value"><fmt:formatNumber value="${dashboard.attendancePercentage}" pattern="#0"/>%</div>
                    <div class="kpi-sublabel">
                        <c:choose>
                            <c:when test="${dashboard.attendancePercentage > 85}">Excellent</c:when>
                            <c:when test="${dashboard.attendancePercentage >= 75}">Good</c:when>
                            <c:otherwise>Critical</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CGPA KPI -->
                <div class="kpi-card green">
                    <div class="kpi-icon">
                        <i class="fas fa-award"></i>
                    </div>
                    <div class="kpi-label">CGPA</div>
                    <div class="kpi-value"><c:out value="${dashboard.student.cgpa}" default="0.0"/></div>
                    <div class="kpi-sublabel">Improving</div>
                </div>

                <!-- Semester KPI -->
                <div class="kpi-card blue">
                    <div class="kpi-icon">
                        <i class="fas fa-layer-group"></i>
                    </div>
                    <div class="kpi-label">Semester</div>
                    <div class="kpi-value">Sem <c:out value="${dashboard.student.currentSemester}" default="0"/></div>
                    <div class="kpi-sublabel"><c:out value="${dashboard.student.batch}" default="2025-26"/></div>
                </div>

                <!-- Subjects KPI -->
                <div class="kpi-card orange">
                    <div class="kpi-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="kpi-label">Subjects</div>
                    <div class="kpi-value"><c:out value="${dashboard.semesterSubjects}" default="0"/></div>
                    <div class="kpi-sublabel">This Semester</div>
                </div>
            </div>

            <!-- Second Row KPIs -->
            <div class="kpi-grid" style="grid-template-columns: repeat(4, 1fr);">
                <!-- Classes Today -->
                <div class="kpi-card blue">
                    <div class="kpi-icon">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="kpi-label">Classes Today</div>
                    <div class="kpi-value"><c:out value="${dashboard.classesToday}" default="0"/></div>
                    <div class="kpi-sublabel">Scheduled</div>
                </div>

                <!-- Classes Tomorrow -->
                <div class="kpi-card purple">
                    <div class="kpi-icon">
                        <i class="fas fa-calendar-day"></i>
                    </div>
                    <div class="kpi-label">Classes Tomorrow</div>
                    <div class="kpi-value"><c:out value="${dashboard.classesTomorrow}" default="0"/></div>
                    <div class="kpi-sublabel">Upcoming</div>
                </div>

                <!-- Notifications -->
                <div class="kpi-card red">
                    <div class="kpi-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="kpi-label">Unread</div>
                    <div class="kpi-value"><c:out value="${dashboard.unreadNotifications}" default="0"/></div>
                    <div class="kpi-sublabel">Notifications</div>
                </div>

                <!-- Pending Leaves -->
                <div class="kpi-card orange">
                    <div class="kpi-icon">
                        <i class="fas fa-file-signature"></i>
                    </div>
                    <div class="kpi-label">Pending Leaves</div>
                    <div class="kpi-value"><c:out value="${dashboard.pendingLeaves}" default="0"/></div>
                    <div class="kpi-sublabel">Awaiting approval</div>
                </div>
            </div>

            <!-- Main Grid: Left + Right Columns -->
            <div class="main-grid">
                <!-- LEFT COLUMN -->
                <div>
                    <!-- Quick Actions -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-bolt"></i>
                                Quick Actions
                            </h3>
                        </div>
                        <div class="dash-card-body">
                            <div class="quick-actions">
                                <a href="${pageContext.request.contextPath}/student/attendance" class="quick-action-btn">
                                    <div class="quick-action-icon">
                                        <i class="fas fa-clipboard-check"></i>
                                    </div>
                                    <span class="quick-action-label">Attendance</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/marks" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #059669;">
                                        <i class="fas fa-graduation-cap"></i>
                                    </div>
                                    <span class="quick-action-label">Marks</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/timetable" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #ecfeff 0%, #cffafe 100%); color: #0891b2;">
                                        <i class="fas fa-calendar-alt"></i>
                                    </div>
                                    <span class="quick-action-label">Timetable</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/leave/request" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #d97706;">
                                        <i class="fas fa-file-signature"></i>
                                    </div>
                                    <span class="quick-action-label">Leave</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/notifications" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); color: #dc2626;">
                                        <i class="fas fa-bell"></i>
                                    </div>
                                    <span class="quick-action-label">Notifications</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/profile" class="quick-action-btn">
                                    <div class="quick-action-icon" style="background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%); color: #6b7280;">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <span class="quick-action-label">Profile</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Performance -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-graduation-cap"></i>
                                Performance
                            </h3>
                        </div>
                        <div class="dash-card-body">
                            <div class="perf-list">
                                <c:choose>
                                    <c:when test="${not empty dashboard.semesterCgpas}">
                                        <c:forEach var="sem" items="${dashboard.semesterCgpas}">
                                            <div class="perf-item">
                                                <span class="perf-semester">Semester ${sem.semesterNumber}</span>
                                                <span class="perf-cgpa"><fmt:formatNumber value="${sem.cgpa}" maxFractionDigits="2" /></span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-3" style="color: #6b7280; font-size: 0.85rem;">
                                            No semester data available
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 2px solid #f3f4f6;">
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-size: 0.9rem; font-weight: 600; color: #6b7280;">Overall CGPA</span>
                                    <span style="font-size: 1.5rem; font-weight: 700; color: #10b981;">
                                        <c:out value="${dashboard.student.cgpa}" default="0.0"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>  
                </div> 

                <!-- RIGHT COLUMN -->
                <div>
                    <!-- Attendance Circle -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-chart-pie"></i>
                                Attendance
                            </h3>
                        </div>
                        <div class="dash-card-body">
                            <div class="attendance-circle">
                                <div class="attendance-percentage">
                                    <fmt:formatNumber value="${dashboard.attendancePercentage}" pattern="#0"/>%
                                </div>
                                <div class="attendance-status 
                                    <c:choose>
                                        <c:when test="${dashboard.attendancePercentage > 85}">excellent</c:when>
                                        <c:when test="${dashboard.attendancePercentage >= 75}">good</c:when>
                                        <c:otherwise>critical</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test="${dashboard.attendancePercentage > 85}">Excellent</c:when>
                                        <c:when test="${dashboard.attendancePercentage >= 75}">Good</c:when>
                                        <c:otherwise>Critical</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Leave Status -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-file-signature"></i>
                                Leave Status
                            </h3>
                        </div>
                        <div class="dash-card-body">
                            <div class="leave-status-item pending">
                                <span>Pending</span>
                                <span class="leave-badge pending"><c:out value="${dashboard.pendingLeaves}" default="0"/></span>
                            </div>
                            <div class="leave-status-item approved">
                                <span>Approved</span>
                                <span class="leave-badge approved"><c:out value="${dashboard.approvedLeaves}" default="0"/></span>
                            </div>
                            <div class="leave-status-item rejected">
                                <span>Rejected</span>
                                <span class="leave-badge rejected"><c:out value="${dashboard.rejectedLeaves}" default="0"/></span>
                            </div>
                        </div>
                    </div>

                    <!-- Program Progress -->
                    <div class="dash-card">
                        <div class="dash-card-header">
                            <h3 class="dash-card-title">
                                <i class="fas fa-tasks"></i>
                                Program Progress
                            </h3>
                        </div>
                        <div class="dash-card-body">
                            <c:set var="progressPercent" value="0" />
                            <c:if test="${dashboard.totalProgramCredits > 0}">
                                <c:set var="progressPercent" value="${(dashboard.earnedCredits * 100.0) / dashboard.totalProgramCredits}" />
                            </c:if>

                            <div class="progress-container">
                                <div class="progress-label">
                                    <span style="color: #6b7280;">Progress</span>
                                    <span style="font-weight: 700; color: #111827;"><fmt:formatNumber value="${progressPercent}" maxFractionDigits="2" />%</span>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar" style="width: ${progressPercent}%;"></div>
                                </div>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 0.8rem; color: #6b7280;">
                                <span>Credits Earned: <strong style="color: #111827;"><c:out value="${dashboard.earnedCredits}" default="0"/></strong></span>
                                <span>/ <c:out value="${dashboard.totalProgramCredits}" default="160"/></span>
                            </div>
                        </div>
                    </div>
            	</div>
            </div>
            <!-- Notifications -->
            <div class="dash-card">
                <div class="dash-card-header">
                    <h3 class="dash-card-title">
                        <i class="fas fa-bell"></i>
                        Recent Notifications
                    </h3>
                    <a href="${pageContext.request.contextPath}/student/notifications" class="dash-card-link">
                        View All <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <div class="dash-card-body">
                    <c:choose>
                        <c:when test="${not empty recentNotifications}">
                            <c:forEach var="notif" items="${recentNotifications}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <div class="notif-item">
                                        <div class="notif-dot ${notif.isRead ? 'read' : ''}"></div>
                                        <div class="notif-content">
                                            <div class="notif-title"><c:out value="${notif.title}"/></div>
                                            <div class="notif-message"><c:out value="${notif.message}"/></div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <div style="width: 60px; height: 60px; margin: 0 auto 1rem; background: linear-gradient(135deg, #f0f9ff 0%, #faf5ff 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: #667eea;">
                                    <i class="fas fa-bell-slash"></i>
                                </div>
                                <h4 style="font-size: 1rem; font-weight: 700; color: #111827; margin: 0 0 0.25rem 0;">No Notifications</h4>
                                <p style="font-size: 0.85rem; color: #6b7280; margin: 0;">You're all caught up!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-dismiss alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.custom-alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.classList.add('fade-out');
                setTimeout(() => alert.remove(), 500);
            }, 3000);
        });
    });
</script>
</body>
</html>