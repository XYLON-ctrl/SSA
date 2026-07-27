<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Mark Attendance" scope="request" />
<%@ include file="facultyHead.jsp" %>

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --warning-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        --danger-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        --glass-bg: rgba(255, 255, 255, 0.95);
        --glass-border: rgba(255, 255, 255, 0.3);
        --shadow-soft: 0 8px 32px rgba(0, 0, 0, 0.08);
        --shadow-hover: 0 12px 48px rgba(0, 0, 0, 0.12);
        --radius-xl: 20px;
        --radius-lg: 16px;
        --radius-md: 12px;
    }

    .attendance-container {
	    width: 100%;
	    max-width: 1800px;
	    margin: 0 auto;
	    padding: 2rem;
    }

    /* ===== ALERT MESSAGES (Same as other pages) ===== */
    .custom-alert {
        border-radius: var(--radius-md);
        border: none;
        padding: 1rem 1.25rem;
        font-size: 0.9rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        animation: slideDown 0.4s ease-out;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        transition: opacity 0.5s ease, transform 0.5s ease;
    }

    .custom-alert.fade-out {
        opacity: 0;
        transform: translateY(-10px);
    }

    .alert-error {
        background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
        color: #991b1b;
        border-left: 4px solid #ef4444;
    }

    .alert-success {
        background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
        color: #166534;
        border-left: 4px solid #10b981;
    }

    .alert-warning {
        background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
        color: #92400e;
        border-left: 4px solid #f59e0b;
    }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* ===== HERO HEADER ===== */
    .hero-header {
        background: var(--glass-bg);
        backdrop-filter: blur(20px);
        border: 1px solid var(--glass-border);
        border-radius: var(--radius-xl);
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-soft);
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 2rem;
    }

    .hero-content h2 {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 0.5rem 0;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .hero-content p {
        color: #6b7280;
        margin: 0;
        font-size: 0.95rem;
    }

    .hero-stats {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .stat-chip {
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        border: 1px solid #bae6fd;
        border-radius: 50px;
        padding: 0.75rem 1.25rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-weight: 600;
        color: #0369a1;
        font-size: 0.9rem;
        transition: all 0.3s ease;
    }

    .stat-chip:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(3, 105, 161, 0.15);
    }

    .stat-chip i { font-size: 1.1rem; }

    /* ===== SUMMARY CARDS ===== */
    .summary-cards {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .summary-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .summary-card::before {
        content: '';
        position: absolute;
        top: 0; left: 0;
        width: 100%; height: 4px;
        background: var(--primary-gradient);
    }

    .summary-card.present::before { background: var(--success-gradient); }
    .summary-card.absent::before { background: var(--danger-gradient); }
    .summary-card.late::before { background: var(--warning-gradient); }

    .summary-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-hover);
    }

    .summary-icon {
        width: 48px; height: 48px;
        border-radius: var(--radius-md);
        display: flex; align-items: center; justify-content: center;
        font-size: 1.5rem;
        margin-bottom: 1rem;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #3b82f6;
    }

    .summary-card.present .summary-icon { background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #10b981; }
    .summary-card.absent .summary-icon { background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); color: #ef4444; }
    .summary-card.late .summary-icon { background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #f59e0b; }

    .summary-value { font-size: 2rem; font-weight: 700; color: #111827; margin-bottom: 0.25rem; }
    .summary-label { font-size: 0.85rem; color: #6b7280; font-weight: 500; }

    /* ===== FILTER PANEL ===== */
    .filter-panel {
        background: white;
        border-radius: var(--radius-lg);
        padding: 2rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        margin-bottom: 2rem;
    }

    .filter-title {
        font-size: 1.1rem; font-weight: 700; color: #111827;
        margin: 0 0 1.5rem 0;
        display: flex; align-items: center; gap: 0.75rem;
    }

    .filter-title i { color: #667eea; }

    .filter-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        align-items: end;
    }

    .filter-group label {
        display: flex; align-items: center; gap: 0.5rem;
        font-size: 0.85rem; font-weight: 600; color: #374151;
        margin-bottom: 0.5rem;
    }

    .filter-group label i { color: #667eea; }

    .filter-select, .filter-input {
        width: 100%; padding: 0.75rem 1rem;
        border: 2px solid #e5e7eb;
        border-radius: var(--radius-md);
        font-size: 0.9rem;
        transition: all 0.3s ease;
        background: white;
    }

    .filter-select:focus, .filter-input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    }

    .btn-load {
        padding: 0.75rem 2rem;
        background: var(--primary-gradient);
        color: white; border: none;
        border-radius: var(--radius-md);
        font-weight: 600; cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex; align-items: center; gap: 0.5rem;
        font-size: 0.9rem;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .btn-load:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
    }

    /* ===== ATTENDANCE CARD ===== */
    .attendance-card {
        background: white;
        border-radius: var(--radius-xl);
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        overflow: hidden;
    }

    .attendance-header {
        background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
        padding: 1.5rem 2rem;
        border-bottom: 2px solid #e5e7eb;
        display: flex; justify-content: space-between; align-items: center;
        flex-wrap: wrap; gap: 1rem;
    }

    .attendance-title {
        font-size: 1.1rem; font-weight: 700; color: #111827;
        margin: 0; display: flex; align-items: center; gap: 0.75rem;
    }

    .attendance-title i { color: #667eea; }

    /* ===== PROGRESS ===== */
    .progress-section {
        padding: 1.5rem 2rem;
        background: #f9fafb;
        border-bottom: 1px solid #e5e7eb;
    }

    .progress-header {
        display: flex; justify-content: space-between; align-items: center;
        margin-bottom: 0.75rem;
    }

    .progress-label { font-size: 0.9rem; font-weight: 600; color: #374151; }
    .progress-count { font-size: 0.9rem; font-weight: 700; color: #667eea; }

    .progress-bar-container {
        height: 8px; background: #e5e7eb;
        border-radius: 10px; overflow: hidden;
    }

    .progress-bar-fill {
        height: 100%;
        background: var(--primary-gradient);
        border-radius: 10px;
        transition: width 0.5s ease;
    }

    /* ===== STUDENT LIST ===== */
    .student-list { padding: 2rem; }

    .student-item {
        display: flex; align-items: center; justify-content: space-between;
        padding: 1.25rem;
        border-radius: var(--radius-md);
        margin-bottom: 1rem;
        background: #f9fafb;
        transition: all 0.3s ease;
        border: 1px solid transparent;
    }

    .student-item:hover {
        background: white;
        border-color: #e5e7eb;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        transform: translateX(4px);
    }

    .student-item.marked-present { border-left: 3px solid #10b981; }
    .student-item.marked-absent { border-left: 3px solid #ef4444; }
    .student-item.marked-late { border-left: 3px solid #f59e0b; }

    .student-info { display: flex; align-items: center; gap: 1rem; flex: 1; }

    .student-avatar {
        width: 48px; height: 48px;
        border-radius: 50%;
        background: var(--primary-gradient);
        display: flex; align-items: center; justify-content: center;
        color: white; font-weight: 700; font-size: 1.1rem;
        flex-shrink: 0;
    }

    .student-details { display: flex; flex-direction: column; gap: 0.25rem; }
    .student-name { font-weight: 600; color: #111827; font-size: 0.95rem; }

    .student-meta {
        font-size: 0.8rem; color: #6b7280;
        display: flex; align-items: center; gap: 0.5rem;
    }

    .student-meta i { font-size: 0.7rem; }

    /* ===== SEGMENTED CONTROLS ===== */
    .segmented-control {
        display: flex;
        background: #f3f4f6;
        border-radius: 50px;
        padding: 4px;
        gap: 4px;
    }

    .segment-btn {
        padding: 0.5rem 1.25rem;
        border: none; border-radius: 50px;
        font-size: 0.85rem; font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        background: transparent;
        color: #6b7280;
        display: flex; align-items: center; gap: 0.4rem;
    }

    .segment-btn:hover { background: rgba(255, 255, 255, 0.5); }

    .segment-btn.present.active { background: var(--success-gradient); color: white; box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3); }
    .segment-btn.absent.active { background: var(--danger-gradient); color: white; box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3); }
    .segment-btn.late.active { background: var(--warning-gradient); color: white; box-shadow: 0 2px 8px rgba(245, 158, 11, 0.3); }

    /* ===== STICKY ACTION BAR ===== */
    .action-bar {
        position: sticky; bottom: 0;
        background: white;
        border-top: 2px solid #e5e7eb;
        padding: 1.5rem 2rem;
        display: flex; justify-content: space-between; align-items: center;
        flex-wrap: wrap; gap: 1rem;
        box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.05);
    }

    .action-summary { display: flex; gap: 1.5rem; flex-wrap: wrap; }

    .action-stat { display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; font-weight: 600; }
    .action-stat.present { color: #10b981; }
    .action-stat.absent { color: #ef4444; }
    .action-stat.late { color: #f59e0b; }

    .action-buttons { display: flex; gap: 1rem; }

    .btn-save {
        padding: 0.75rem 2rem;
        background: var(--primary-gradient);
        color: white; border: none;
        border-radius: var(--radius-md);
        font-weight: 600; cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex; align-items: center; gap: 0.5rem;
        font-size: 0.9rem;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .btn-save:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4); }

    .btn-reset {
        padding: 0.75rem 1.5rem;
        background: #f3f4f6; color: #6b7280;
        border: 1px solid #e5e7eb;
        border-radius: var(--radius-md);
        font-weight: 600; cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex; align-items: center; gap: 0.5rem;
        font-size: 0.9rem;
    }

    .btn-reset:hover { background: #e5e7eb; color: #374151; }

    /* ===== EMPTY STATE ===== */
    .empty-state { text-align: center; padding: 4rem 2rem; }

    .empty-icon {
        width: 100px; height: 100px;
        margin: 0 auto 1.5rem;
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 3rem; color: #3b82f6;
    }

    .empty-title { font-size: 1.25rem; font-weight: 700; color: #111827; margin: 0 0 0.5rem 0; }
    .empty-text { color: #6b7280; margin-bottom: 1.5rem; }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 1024px) {
        .summary-cards { grid-template-columns: repeat(2, 1fr); }
    }

    @media (max-width: 768px) {
        .summary-cards { grid-template-columns: 1fr; }
        .hero-header { flex-direction: column; text-align: center; }
        .hero-stats { justify-content: center; }
        .filter-grid { grid-template-columns: 1fr; }
        .student-item { flex-direction: column; align-items: flex-start; gap: 1rem; }
        .segmented-control { width: 100%; justify-content: center; }
        .action-bar { flex-direction: column; }
        .action-buttons { width: 100%; flex-direction: column; }
        .btn-save, .btn-reset { width: 100%; justify-content: center; }
    }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>
        
        <div class="attendance-container">
            
            <!-- ===== SUCCESS / ERROR MESSAGES (Auto-dismiss after 3s) ===== -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error" id="serverAlert">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><c:out value="${errorMessage}" /></span>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success" id="serverAlert">
                    <i class="fas fa-check-circle"></i>
                    <span><c:out value="${successMessage}" /></span>
                </div>
            </c:if>

            <!-- ===== HERO HEADER ===== -->
            <div class="hero-header">
                <div class="hero-content">
                    <h2>
                        <i class="fas fa-clipboard-check" style="color: #667eea;"></i>
                        Mark Attendance
                    </h2>
                    <p>Record and manage attendance for your assigned classes</p>
                </div>
                <div class="hero-stats">
                    <div class="stat-chip">
                        <i class="fas fa-book"></i>
                        <c:out value="${fn:length(subjects)}" /> Subjects
                    </div>
                    <div class="stat-chip">
                        <i class="fas fa-users"></i>
                        <c:out value="${fn:length(sections)}" /> Sections
                    </div>
                    <div class="stat-chip" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); border-color: #6ee7b7; color: #065f46;">
                        <i class="fas fa-calendar-alt"></i>
                        <c:choose>
                            <c:when test="${not empty selectedDate}">
                                <c:set var="year" value="${fn:substring(selectedDate, 0, 4)}" />
                                <c:set var="month" value="${fn:substring(selectedDate, 5, 7)}" />
                                <c:set var="day" value="${fn:substring(selectedDate, 8, 10)}" />
                                <c:set var="monthName" value="Jan" />
                                <c:if test="${month == '01'}"><c:set var="monthName" value="Jan" /></c:if>
                                <c:if test="${month == '02'}"><c:set var="monthName" value="Feb" /></c:if>
                                <c:if test="${month == '03'}"><c:set var="monthName" value="Mar" /></c:if>
                                <c:if test="${month == '04'}"><c:set var="monthName" value="Apr" /></c:if>
                                <c:if test="${month == '05'}"><c:set var="monthName" value="May" /></c:if>
                                <c:if test="${month == '06'}"><c:set var="monthName" value="Jun" /></c:if>
                                <c:if test="${month == '07'}"><c:set var="monthName" value="Jul" /></c:if>
                                <c:if test="${month == '08'}"><c:set var="monthName" value="Aug" /></c:if>
                                <c:if test="${month == '09'}"><c:set var="monthName" value="Sep" /></c:if>
                                <c:if test="${month == '10'}"><c:set var="monthName" value="Oct" /></c:if>
                                <c:if test="${month == '11'}"><c:set var="monthName" value="Nov" /></c:if>
                                <c:if test="${month == '12'}"><c:set var="monthName" value="Dec" /></c:if>
                                ${day} ${monthName} ${year}
                            </c:when>
                            <c:otherwise>Today</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- ===== SUMMARY CARDS ===== -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="summary-icon"><i class="fas fa-users"></i></div>
                    <div class="summary-value" id="totalStudents">
                        <c:choose>
                            <c:when test="${not empty students}"><c:out value="${fn:length(students)}" /></c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="summary-label">Students Loaded</div>
                </div>
                <div class="summary-card present">
                    <div class="summary-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="summary-value" id="presentCount">0</div>
                    <div class="summary-label">Present Selected</div>
                </div>
                <div class="summary-card absent">
                    <div class="summary-icon"><i class="fas fa-times-circle"></i></div>
                    <div class="summary-value" id="absentCount">0</div>
                    <div class="summary-label">Absent Selected</div>
                </div>
                <div class="summary-card late">
                    <div class="summary-icon"><i class="fas fa-clock"></i></div>
                    <div class="summary-value" id="lateCount">0</div>
                    <div class="summary-label">Late Selected</div>
                </div>
            </div>

            <!-- ===== FILTER PANEL ===== -->
            <div class="filter-panel">
                <h3 class="filter-title"><i class="fas fa-filter"></i> Select Class</h3>
                <form method="GET" action="${pageContext.request.contextPath}/faculty/attendance">
                    <div class="filter-grid">
                        <div class="filter-group">
                            <label><i class="fas fa-book"></i> Subject</label>
                            <select name="subjectId" class="filter-select" required>
                                <option value="">Select Subject</option>
                                <c:forEach var="sub" items="${subjects}">
                                    <option value="${sub.subjectId}" ${sub.subjectId == selectedSubjectId ? 'selected' : ''}>
                                        <c:out value="${sub.subjectName}" />
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label><i class="fas fa-users"></i> Section</label>
                            <select name="sectionId" class="filter-select" required>
                                <option value="">Select Section</option>
                                <c:forEach var="sec" items="${sections}">
                                    <option value="${sec.sectionId}" ${sec.sectionId == selectedSectionId ? 'selected' : ''}>
                                        <c:out value="${sec.sectionName}" />
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label><i class="fas fa-calendar"></i> Date</label>
                            <input type="date" name="attendanceDate" class="filter-input" value="<c:out value='${selectedDate}' />" required>
                        </div>
                        <div class="filter-group">
                            <button type="submit" class="btn-load">
                                <i class="fas fa-search"></i> Load Students
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- ===== ATTENDANCE FORM ===== -->
            <c:if test="${showAttendanceForm}">
                <c:choose>
                    <c:when test="${not empty students}">
                        <div class="attendance-card">
                            <div class="attendance-header">
                                <h3 class="attendance-title">
                                    <i class="fas fa-users"></i>
                                    Students for Attendance
                                </h3>
                                <div style="font-size: 0.9rem; color: #6b7280;">
                                    <c:out value="${fn:length(students)}" /> students loaded
                                </div>
                            </div>

                            <!-- Progress -->
                            <div class="progress-section">
                                <div class="progress-header">
                                    <span class="progress-label">Attendance Completion</span>
                                    <span class="progress-count" id="progressText">0 / <c:out value="${fn:length(students)}" /> Students Marked</span>
                                </div>
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" id="progressBar" style="width: 0%;"></div>
                                </div>
                            </div>

                            <!-- Student List -->
                            <div class="student-list">
                                <form method="POST" action="${pageContext.request.contextPath}/faculty/attendance" id="attendanceForm">
                                    <input type="hidden" name="subjectId" value="${selectedSubjectId}">
                                    <input type="hidden" name="sectionId" value="${selectedSectionId}">
                                    <input type="hidden" name="attendanceDate" value="${selectedDate}">
                                    
                                    <c:forEach var="student" items="${students}" varStatus="status">
                                        <c:set var="existingStatus" value="" />
                                        <c:forEach var="record" items="${existingRecords}">
                                            <c:if test="${record.studentId == student.userId}">
                                                <c:set var="existingStatus" value="${record.status}" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <div class="student-item" id="student-row-${status.index}">
                                            <div class="student-info">
                                                <div class="student-avatar">
                                                    <c:out value="${fn:substring(student.fullName, 0, 1)}" />
                                                </div>
                                                <div class="student-details">
                                                    <div class="student-name"><c:out value="${student.fullName}" /></div>
                                                    <div class="student-meta">
                                                        <i class="fas fa-id-card"></i>
                                                        <c:out value="${student.enrollmentNumber}" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="segmented-control">
                                                <input type="hidden" name="studentId" value="${student.userId}">
                                                <button type="button" class="segment-btn present ${existingStatus == 'PRESENT' ? 'active' : ''}" 
                                                        onclick="setStatus(this, 'PRESENT', ${status.index})">
                                                    <i class="fas fa-check"></i> Present
                                                </button>
                                                <button type="button" class="segment-btn absent ${existingStatus == 'ABSENT' ? 'active' : ''}" 
                                                        onclick="setStatus(this, 'ABSENT', ${status.index})">
                                                    <i class="fas fa-times"></i> Absent
                                                </button>
                                                <button type="button" class="segment-btn late ${existingStatus == 'LATE' ? 'active' : ''}" 
                                                        onclick="setStatus(this, 'LATE', ${status.index})">
                                                    <i class="fas fa-clock"></i> Late
                                                </button>
                                                <input type="hidden" name="status" value="${existingStatus}" id="status-${status.index}">
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <!-- Sticky Action Bar -->
                                    <div class="action-bar">
                                        <div class="action-summary">
                                            <div class="action-stat present">
                                                <i class="fas fa-check-circle"></i>
                                                Present: <span id="summaryPresent">0</span>
                                            </div>
                                            <div class="action-stat absent">
                                                <i class="fas fa-times-circle"></i>
                                                Absent: <span id="summaryAbsent">0</span>
                                            </div>
                                            <div class="action-stat late">
                                                <i class="fas fa-clock"></i>
                                                Late: <span id="summaryLate">0</span>
                                            </div>
                                        </div>
                                        <div class="action-buttons">
                                            <button type="button" class="btn-reset" onclick="resetAttendance()">
                                                <i class="fas fa-undo"></i> Reset
                                            </button>
                                            <button type="submit" class="btn-save">
                                                <i class="fas fa-save"></i> Save Attendance
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="attendance-card">
                            <div class="empty-state">
                                <div class="empty-icon"><i class="fas fa-user-slash"></i></div>
                                <h3 class="empty-title">No Students Found</h3>
                                <p class="empty-text">No students are enrolled in this section.</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <!-- Empty State when form not shown -->
            <c:if test="${!showAttendanceForm}">
                <div class="attendance-card">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-clipboard-list"></i></div>
                        <h3 class="empty-title">Select a Subject, Section, and Date</h3>
                        <p class="empty-text">Load students to begin recording attendance.</p>
                        <button class="btn-load" onclick="document.querySelector('.filter-panel').scrollIntoView({behavior: 'smooth'})">
                            <i class="fas fa-search"></i> Load Students
                        </button>
                    </div>
                </div>
            </c:if>

        </div>
        
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<script>
    let presentCount = 0;
    let absentCount = 0;
    let lateCount = 0;
    const totalStudents = parseInt(document.getElementById('totalStudents').textContent) || 0;

    // ===== AUTO-DISMISS SERVER ALERTS AFTER 3 SECONDS =====
    document.addEventListener('DOMContentLoaded', function() {
        const serverAlert = document.getElementById('serverAlert');
        if (serverAlert) {
            setTimeout(function() {
                serverAlert.classList.add('fade-out');
                setTimeout(function() {
                    serverAlert.remove();
                }, 500);
            }, 3000);
        }

        // Initialize counts from existing data
        document.querySelectorAll('.segment-btn.active').forEach(btn => {
            const status = btn.classList.contains('present') ? 'PRESENT' : 
                          btn.classList.contains('absent') ? 'ABSENT' : 'LATE';
            if (status === 'PRESENT') presentCount++;
            else if (status === 'ABSENT') absentCount++;
            else if (status === 'LATE') lateCount++;
        });
        updateSummary();
    });

    // ===== SET ATTENDANCE STATUS =====
    function setStatus(btn, status, index) {
        const parent = btn.parentElement;
        const hiddenInput = document.getElementById('status-' + index);
        const previousStatus = hiddenInput.value;
        const studentRow = document.getElementById('student-row-' + index);

        // Remove active from siblings
        parent.querySelectorAll('.segment-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        
        // Update hidden input
        hiddenInput.value = status;

        // Update row border color
        studentRow.classList.remove('marked-present', 'marked-absent', 'marked-late');
        if (status === 'PRESENT') studentRow.classList.add('marked-present');
        else if (status === 'ABSENT') studentRow.classList.add('marked-absent');
        else if (status === 'LATE') studentRow.classList.add('marked-late');

        // Update counts
        if (previousStatus === 'PRESENT') presentCount--;
        else if (previousStatus === 'ABSENT') absentCount--;
        else if (previousStatus === 'LATE') lateCount--;

        if (status === 'PRESENT') presentCount++;
        else if (status === 'ABSENT') absentCount++;
        else if (status === 'LATE') lateCount++;

        updateSummary();
    }

    // ===== UPDATE SUMMARY DISPLAY =====
    function updateSummary() {
        document.getElementById('presentCount').textContent = presentCount;
        document.getElementById('absentCount').textContent = absentCount;
        document.getElementById('lateCount').textContent = lateCount;
        document.getElementById('summaryPresent').textContent = presentCount;
        document.getElementById('summaryAbsent').textContent = absentCount;
        document.getElementById('summaryLate').textContent = lateCount;

        const marked = presentCount + absentCount + lateCount;
        const percentage = totalStudents > 0 ? (marked / totalStudents) * 100 : 0;
        document.getElementById('progressBar').style.width = percentage + '%';
        document.getElementById('progressText').textContent = marked + ' / ' + totalStudents + ' Students Marked';
    }

    // ===== RESET ALL SELECTIONS =====
    function resetAttendance() {
        if (confirm('Are you sure you want to reset all attendance selections?')) {
            document.querySelectorAll('.segment-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('input[name="status"]').forEach(input => input.value = '');
            document.querySelectorAll('.student-item').forEach(row => {
                row.classList.remove('marked-present', 'marked-absent', 'marked-late');
            });
            presentCount = 0;
            absentCount = 0;
            lateCount = 0;
            updateSummary();
        }
    }

    // ===== VALIDATE BEFORE SUBMIT =====
    const attendanceForm = document.getElementById('attendanceForm');
    if (attendanceForm) {
        attendanceForm.addEventListener('submit', function(e) {
            const marked = presentCount + absentCount + lateCount;
            
            if (marked < totalStudents) {
                e.preventDefault();
                
                // Show inline error alert
                const existingAlert = document.getElementById('clientAlert');
                if (existingAlert) existingAlert.remove();
                
                const alertDiv = document.createElement('div');
                alertDiv.id = 'clientAlert';
                alertDiv.className = 'custom-alert alert-warning';
                alertDiv.innerHTML = '<i class="fas fa-exclamation-triangle"></i> <span>Please mark attendance for all ' + 
                    totalStudents + ' students before saving. Currently marked: ' + marked + '/' + totalStudents + '</span>';
                
                const container = document.querySelector('.attendance-container');
                container.insertBefore(alertDiv, container.firstChild);
                
                // Auto dismiss after 5 seconds
                setTimeout(function() {
                    alertDiv.classList.add('fade-out');
                    setTimeout(function() { alertDiv.remove(); }, 500);
                }, 5000);
                
                // Scroll to top to show alert
                window.scrollTo({ top: 0, behavior: 'smooth' });
                
                return false;
            }
        });
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>