<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="My Students" scope="request" />
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

    .students-container {
    	width: 100%;
        max-width: 1800px;
        margin: 0 auto;
        padding: 2rem;
    }

    /* Hero Header Section */
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
        font-size: 0.95rem;
        margin: 0;
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

    .stat-chip i {
        font-size: 1.1rem;
    }

    /* Analytics Cards Row */
    .analytics-row {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .analytics-card {
        background: white;
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .analytics-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background: var(--primary-gradient);
    }

    .analytics-card.success::before { background: var(--success-gradient); }
    .analytics-card.warning::before { background: var(--warning-gradient); }
    .analytics-card.danger::before { background: var(--danger-gradient); }

    .analytics-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-hover);
    }

    .analytics-icon {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        margin-bottom: 1rem;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #3b82f6;
    }

    .analytics-card.success .analytics-icon {
        background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
        color: #10b981;
    }

    .analytics-card.warning .analytics-icon {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        color: #f59e0b;
    }

    .analytics-card.danger .analytics-icon {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
        color: #ef4444;
    }

    .analytics-value {
        font-size: 2rem;
        font-weight: 700;
        color: #111827;
        margin-bottom: 0.25rem;
    }

    .analytics-label {
        font-size: 0.85rem;
        color: #6b7280;
        font-weight: 500;
    }

    /* Modern Filter Bar */
    .filter-bar {
        background: var(--glass-bg);
        backdrop-filter: blur(20px);
        border: 1px solid var(--glass-border);
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        margin-bottom: 2rem;
        box-shadow: var(--shadow-soft);
    }

    .filter-row {
        display: flex;
        gap: 1rem;
        align-items: flex-end;
        flex-wrap: wrap;
    }

    .filter-group {
        flex: 1;
        min-width: 200px;
    }

    .filter-group label {
        display: block;
        font-size: 0.85rem;
        font-weight: 600;
        color: #374151;
        margin-bottom: 0.5rem;
    }

    .filter-select, .filter-search {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 2px solid #e5e7eb;
        border-radius: var(--radius-md);
        font-size: 0.9rem;
        transition: all 0.3s ease;
        background: white;
    }

    .filter-select:focus, .filter-search:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    }

    .filter-actions {
        display: flex;
        gap: 0.75rem;
        margin-top: 1rem;
    }

    .btn-filter {
        padding: 0.75rem 1.5rem;
        border-radius: var(--radius-md);
        border: none;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.9rem;
    }

    .btn-reset {
        background: #f3f4f6;
        color: #6b7280;
    }

    .btn-reset:hover {
        background: #e5e7eb;
        color: #374151;
    }

    .btn-search {
        background: var(--primary-gradient);
        color: white;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .btn-search:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
    }

    /* Students Table Container - Full Width */
    .students-table-container {
        background: white;
        border-radius: var(--radius-xl);
        border: 1px solid #e5e7eb;
        box-shadow: var(--shadow-soft);
        overflow: hidden;
        width: 100%;
    }

    .table-header {
        background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
        padding: 1.25rem 1.5rem;
        border-bottom: 2px solid #e5e7eb;
    }

    .table-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #111827;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .modern-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }

    .modern-table thead {
        background: #f9fafb;
    }

    .modern-table th {
        padding: 1rem 1.5rem;
        text-align: left;
        font-size: 0.75rem;
        font-weight: 700;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 2px solid #e5e7eb;
    }

    .modern-table td {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid #f3f4f6;
        vertical-align: middle;
    }

    .modern-table tbody tr {
        transition: all 0.3s ease;
    }

    .modern-table tbody tr:hover {
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        transform: scale(1.01);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    .modern-table tbody tr:last-child td {
        border-bottom: none;
    }

    /* Student Cell */
    .student-cell {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .student-avatar {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: var(--primary-gradient);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 1.1rem;
        flex-shrink: 0;
    }

    .student-info {
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
    }

    .student-name {
        font-weight: 600;
        color: #111827;
        font-size: 0.95rem;
    }

    .student-enrollment {
        font-size: 0.8rem;
        color: #6b7280;
        font-weight: 500;
    }

    /* Attendance Progress */
    .attendance-cell {
        min-width: 180px;
    }

    .attendance-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 0.5rem;
    }

    .attendance-percentage {
        font-weight: 700;
        color: #111827;
        font-size: 0.95rem;
    }

    .attendance-bar-bg {
        height: 8px;
        background: #e5e7eb;
        border-radius: 10px;
        overflow: hidden;
    }

    .attendance-bar-fill {
        height: 100%;
        background: var(--success-gradient);
        border-radius: 10px;
        transition: width 1s ease;
    }

    .attendance-bar-fill.warning {
        background: var(--warning-gradient);
    }

    .attendance-bar-fill.danger {
        background: var(--danger-gradient);
    }

    /* Status Badge */
    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.5rem 1rem;
        border-radius: 50px;
        font-size: 0.8rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .status-badge.excellent {
        background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
        color: #065f46;
    }

    .status-badge.good {
        background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
        color: #1e40af;
    }

    .status-badge.warning {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        color: #92400e;
    }

    .status-badge.critical {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
        color: #991b1b;
    }

    /* Action Buttons */
    .action-buttons {
        display: flex;
        gap: 0.5rem;
    }

    .btn-action-icon {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        border: none;
        background: #f3f4f6;
        color: #6b7280;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .btn-action-icon:hover {
        background: var(--primary-gradient);
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
        background: white;
        border-radius: var(--radius-xl);
        border: 2px dashed #e5e7eb;
    }

    .empty-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto 1.5rem;
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.5rem;
        color: #3b82f6;
    }

    .empty-title {
        font-size: 1.25rem;
        font-weight: 700;
        color: #111827;
        margin: 0 0 0.5rem 0;
    }

    .empty-text {
        color: #6b7280;
        margin-bottom: 1.5rem;
    }

    @media (max-width: 1200px) {
        .analytics-row {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 768px) {
        .analytics-row {
            grid-template-columns: 1fr;
        }
        .hero-header {
            flex-direction: column;
            text-align: center;
        }
        .hero-stats {
            justify-content: center;
        }
        .filter-row {
            flex-direction: column;
        }
        .filter-group {
            width: 100%;
        }
    }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>
        
        <div class="students-container">
            
            <!-- Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>

            <!-- Hero Header -->
            <div class="hero-header">
                <div class="hero-content">
                    <h2>
                        <i class="fas fa-users" style="color: #667eea;"></i>
                        My Students
                    </h2>
                    <p>Manage and monitor students enrolled in your assigned subjects.</p>
                </div>
                <div class="hero-stats">
                    <div class="stat-chip">
                        <i class="fas fa-user-graduate"></i>
                        Total: <c:out value="${fn:length(students)}" />
                    </div>
                    <div class="stat-chip">
                        <i class="fas fa-book"></i>
                        Subjects: <c:out value="${fn:length(subjects)}" />
                    </div>
                    <div class="stat-chip" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); border-color: #6ee7b7; color: #065f46;">
                        <i class="fas fa-chart-line"></i>
                        Avg: <c:out value="${averageAttendance}" default="84" />%
                    </div>
                </div>
            </div>

			<!-- Analytics Cards -->
			<div class="analytics-row">
			    <div class="analytics-card">
			        <div class="analytics-icon">
			            <i class="fas fa-users"></i>
			        </div>
			        <div class="analytics-value"><c:out value="${fn:length(students)}" /></div>
			        <div class="analytics-label">Total Students</div>
			    </div>
			    <div class="analytics-card success">
			        <div class="analytics-icon">
			            <i class="fas fa-check-circle"></i>
			        </div>
			        <div class="analytics-value"><c:out value="${excellentCount}" default="0" /></div>
			        <div class="analytics-label">Excellent Attendance</div>
			    </div>
			    <div class="analytics-card warning">
			        <div class="analytics-icon">
			            <i class="fas fa-chart-line"></i>
			        </div>
			        <div class="analytics-value"><c:out value="${averageAttendance}" default="0" />%</div>
			        <div class="analytics-label">Average Attendance</div>
			    </div>
			    <div class="analytics-card danger">
			        <div class="analytics-icon">
			            <i class="fas fa-exclamation-triangle"></i>
			        </div>
			        <div class="analytics-value"><c:out value="${atRiskCount}" default="0" /></div>
			        <div class="analytics-label">At Risk Students</div>
			    </div>
			</div>

			<!-- Modern Filter Bar -->
			<div class="filter-bar">
			    <form method="GET" action="${pageContext.request.contextPath}/faculty/students" id="filterForm">
			        <div class="filter-row">
			            <div class="filter-group">
			                <label><i class="fas fa-book me-1"></i> Subject</label>
			                <select name="subjectId" class="filter-select">
			                    <option value="all" ${empty selectedSubjectId ? 'selected' : ''}>
			                        All Subjects
			                    </option>
			                    <c:forEach var="subject" items="${subjects}">
			                        <option value="${subject.subjectId}" 
			                                ${selectedSubjectId == subject.subjectId ? 'selected' : ''}>
			                            <c:out value="${subject.subjectName}" />
			                        </option>
			                    </c:forEach>
			                </select>
			            </div>
			            <div class="filter-group">
			                <label><i class="fas fa-users me-1"></i> Section</label>
			                <select name="sectionId" class="filter-select">
			                    <option value="all" ${empty selectedSectionId ? 'selected' : ''}>
			                        All Sections
			                    </option>
			                    <c:forEach var="section" items="${sections}">
			                        <option value="${section.sectionId}" 
			                                ${selectedSectionId == section.sectionId ? 'selected' : ''}>
			                            <c:out value="${section.sectionName}" />
			                        </option>
			                    </c:forEach>
			                </select>
			            </div>
			            <div class="filter-group">
			                <label><i class="fas fa-search me-1"></i> Search Student</label>
			                <input type="text" name="search" class="filter-search" 
			                       placeholder="Search by name or enrollment no..." 
			                       value="${searchQuery}" />
			            </div>
			        </div>
			        <div class="filter-actions">
			            <button type="button" class="btn-filter btn-reset" onclick="resetFilters()">
			                <i class="fas fa-undo"></i> Reset
			            </button>
			            <button type="submit" class="btn-filter btn-search">
			                <i class="fas fa-search"></i> Search
			            </button>
			        </div>
			    </form>
			</div>

            <!-- Students Table - Full Width -->
            <div class="students-table-container">
                <div class="table-header">
                    <h3 class="table-title">
                        <i class="fas fa-list" style="color: #667eea;"></i>
                        Student List
                    </h3>
                </div>
                
                <c:choose>
                    <c:when test="${not empty students}">
                        <table class="modern-table">
                            <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Enrollment No</th>
                                    <th>Branch</th>
                                    <th>Semester</th>
                                    <th>Attendance</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="student" items="${students}" varStatus="status">
                                    <tr>
                                        <td>
                                            <div class="student-cell">
                                                <div class="student-avatar">
                                                    <c:out value="${fn:substring(student.fullName, 0, 1)}" default="S" />
                                                </div>
                                                <div class="student-info">
                                                    <div class="student-name">
                                                        <c:out value="${student.fullName}" />
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600; color: #374151; font-size: 0.9rem;">
                                                <c:out value="${student.enrollmentNumber}" />
                                            </span>
                                        </td>
                                        <td>
                                            <span style="color: #6b7280; font-size: 0.9rem;">
                                                <c:out value="${student.branch}" />
                                            </span>
                                        </td>
                                        <td>
                                            <span class="status-badge" style="background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); color: #1e40af;">
                                                Sem <c:out value="${student.currentSemester}" />
                                            </span>
                                        </td>
                                        <td>
                                            <div class="attendance-cell">
                                                <c:choose>
                                                    <c:when test="${not empty selectedSubjectId}">
                                                        <c:set var="attendance" value="${attendanceMap[student.userId]}" />
                                                        <c:choose>
                                                            <c:when test="${attendance == '0%'}">
                                                                <div class="attendance-header">
                                                                    <span class="attendance-percentage">--</span>
                                                                </div>
                                                                <div class="attendance-bar-bg">
                                                                    <div class="attendance-bar-fill" style="width: 0%;"></div>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="attendanceNum" value="${fn:substringBefore(attendance, '%') + 0}" />
                                                                <div class="attendance-header">
                                                                    <span class="attendance-percentage"><c:out value="${attendance}" /></span>
                                                                </div>
                                                                <div class="attendance-bar-bg">
                                                                    <div class="attendance-bar-fill 
                                                                        <c:choose>
                                                                            <c:when test="${attendanceNum >= 75}"></c:when>
                                                                            <c:when test="${attendanceNum >= 50}">warning</c:when>
                                                                            <c:otherwise>danger</c:otherwise>
                                                                        </c:choose>" 
                                                                         style="width: ${attendanceNum}%;"></div>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="attendance-header">
                                                            <span class="attendance-percentage">--</span>
                                                        </div>
                                                        <div class="attendance-bar-bg">
                                                            <div class="attendance-bar-fill" style="width: 0%;"></div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty selectedSubjectId}">
                                                    <c:set var="attendance" value="${attendanceMap[student.userId]}" />
                                                    <c:choose>
                                                        <c:when test="${attendance == '0%'}">
                                                            <span class="status-badge" style="background: #f3f4f6; color: #9ca3af;">
                                                                <i class="fas fa-minus"></i> No Data
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="attendanceNum" value="${fn:substringBefore(attendance, '%') + 0}" />
                                                            <c:choose>
                                                                <c:when test="${attendanceNum >= 90}">
                                                                    <span class="status-badge excellent">
                                                                        <i class="fas fa-check-circle"></i> Excellent
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${attendanceNum >= 75}">
                                                                    <span class="status-badge good">
                                                                        <i class="fas fa-thumbs-up"></i> Good
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${attendanceNum >= 50}">
                                                                    <span class="status-badge warning">
                                                                        <i class="fas fa-exclamation-circle"></i> Warning
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-badge critical">
                                                                        <i class="fas fa-times-circle"></i> Critical
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge" style="background: #f3f4f6; color: #9ca3af;">
                                                        <i class="fas fa-minus"></i> Select Subject
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
										    <div class="action-buttons">
										        <button class="btn-action-icon" title="View Profile" 
										                onclick="viewProfile(${student.studentId})">
										            <i class="fas fa-eye"></i>
										        </button>
										        <button class="btn-action-icon" title="Attendance Details" 
										                onclick="viewAttendance(${student.studentId})">
										            <i class="fas fa-chart-bar"></i>
										        </button>
										        <button class="btn-action-icon" title="Contact" 
										                onclick="contactStudent('<c:out value="${student.email}" />')">
										            <i class="fas fa-envelope"></i>
										        </button>
										    </div>
										</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-user-slash"></i>
                            </div>
                            <h3 class="empty-title">No Students Found</h3>
                            <p class="empty-text">Try changing filters or selecting another subject.</p>
                            <button class="btn-filter btn-reset" onclick="resetFilters()">
                                <i class="fas fa-undo"></i> Reset Filters
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
        
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<script>
	function resetFilters() {
	    window.location.href = '${pageContext.request.contextPath}/faculty/students';
	}
	
	// ✅ FIXED: Correct URLs matching servlet mappings
	function viewProfile(studentId) {
	    window.location.href = '${pageContext.request.contextPath}/faculty/student/profile?id=' + studentId;
	}
	
	function viewAttendance(studentId) {
	    window.location.href = '${pageContext.request.contextPath}/faculty/student/attendance?id=' + studentId;
	}
    
    function contactStudent(email) {
        window.location.href = 'mailto:' + email;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>