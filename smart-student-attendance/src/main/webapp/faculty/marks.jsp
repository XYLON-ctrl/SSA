<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Enter Marks" scope="request" />
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

    .marks-container {
	    width: 100%;
	    max-width: 1800px;
	    margin: 0 auto;
	    padding: 2rem;
    }

    /* ===== ALERT MESSAGES ===== */
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
    .custom-alert.fade-out { opacity: 0; transform: translateY(-10px); }
    .alert-error { background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); color: #991b1b; border-left: 4px solid #ef4444; }
    .alert-success { background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); color: #166534; border-left: 4px solid #10b981; }
    .alert-warning { background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%); color: #92400e; border-left: 4px solid #f59e0b; }
    @keyframes slideDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

    /* ===== HERO HEADER ===== */
    .hero-header {
        background: var(--glass-bg); backdrop-filter: blur(20px);
        border: 1px solid var(--glass-border); border-radius: var(--radius-xl);
        padding: 2rem; margin-bottom: 2rem; box-shadow: var(--shadow-soft);
        display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 2rem;
    }
    .hero-content h2 { font-size: 2rem; font-weight: 700; color: #111827; margin: 0 0 0.5rem 0; display: flex; align-items: center; gap: 0.75rem; }
    .hero-content p { color: #6b7280; margin: 0; font-size: 0.95rem; }
    .hero-stats { display: flex; gap: 1rem; flex-wrap: wrap; }
    .stat-chip {
        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        border: 1px solid #bae6fd; border-radius: 50px;
        padding: 0.75rem 1.25rem; display: flex; align-items: center; gap: 0.5rem;
        font-weight: 600; color: #0369a1; font-size: 0.9rem; transition: all 0.3s ease;
    }
    .stat-chip:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(3, 105, 161, 0.15); }
    .stat-chip i { font-size: 1.1rem; }

    /* ===== SUMMARY CARDS ===== */
    .summary-cards { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-bottom: 2rem; }
    .summary-card {
        background: white; border-radius: var(--radius-lg); padding: 1.5rem;
        border: 1px solid #e5e7eb; box-shadow: var(--shadow-soft);
        transition: all 0.3s ease; position: relative; overflow: hidden;
    }
    .summary-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 4px; background: var(--primary-gradient); }
    .summary-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-hover); }
    .summary-icon { width: 48px; height: 48px; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 1rem; background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); color: #3b82f6; }
    .summary-value { font-size: 2rem; font-weight: 700; color: #111827; margin-bottom: 0.25rem; }
    .summary-label { font-size: 0.85rem; color: #6b7280; font-weight: 500; }

    /* ===== FILTER PANEL ===== */
    .filter-panel { background: white; border-radius: var(--radius-lg); padding: 2rem; border: 1px solid #e5e7eb; box-shadow: var(--shadow-soft); margin-bottom: 2rem; }
    .filter-title { font-size: 1.1rem; font-weight: 700; color: #111827; margin: 0 0 1.5rem 0; display: flex; align-items: center; gap: 0.75rem; }
    .filter-title i { color: #667eea; }
    .filter-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; align-items: end; }
    .filter-group label { display: flex; align-items: center; gap: 0.5rem; font-size: 0.85rem; font-weight: 600; color: #374151; margin-bottom: 0.5rem; }
    .filter-group label i { color: #667eea; }
    .filter-select { width: 100%; padding: 0.75rem 1rem; border: 2px solid #e5e7eb; border-radius: var(--radius-md); font-size: 0.9rem; transition: all 0.3s ease; background: white; }
    .filter-select:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1); }
    .btn-load { padding: 0.75rem 2rem; background: var(--primary-gradient); color: white; border: none; border-radius: var(--radius-md); font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3); }
    .btn-load:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4); }

    /* ===== MARKS ENTRY CARD ===== */
    .marks-entry-card { background: white; border-radius: var(--radius-xl); border: 1px solid #e5e7eb; box-shadow: var(--shadow-soft); overflow: hidden; }
    .marks-header { background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%); padding: 1.5rem 2rem; border-bottom: 2px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; }
    .marks-title { font-size: 1.1rem; font-weight: 700; color: #111827; margin: 0; display: flex; align-items: center; gap: 0.75rem; }
    .marks-title i { color: #667eea; }
    .max-marks-input { display: flex; align-items: center; gap: 0.5rem; }
    .max-marks-input label { font-weight: 600; color: #374151; }
    .max-marks-input input { width: 100px; padding: 0.5rem 0.75rem; border: 2px solid #e5e7eb; border-radius: var(--radius-md); font-weight: 600; text-align: center; }
    .max-marks-input input:focus { outline: none; border-color: #667eea; }

    /* ===== PROGRESS ===== */
    .progress-section { padding: 1.5rem 2rem; background: #f9fafb; border-bottom: 1px solid #e5e7eb; }
    .progress-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem; }
    .progress-label { font-size: 0.9rem; font-weight: 600; color: #374151; }
    .progress-count { font-size: 0.9rem; font-weight: 700; color: #667eea; }
    .progress-bar-container { height: 8px; background: #e5e7eb; border-radius: 10px; overflow: hidden; }
    .progress-bar-fill { height: 100%; background: var(--primary-gradient); border-radius: 10px; transition: width 0.5s ease; }

    /* ===== LIVE STATS ===== */
    .live-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
    .stat-mini { background: white; border: 1px solid #e5e7eb; border-radius: var(--radius-md); padding: 1rem; text-align: center; }
    .stat-mini-value { font-size: 1.5rem; font-weight: 700; color: #111827; margin-bottom: 0.25rem; }
    .stat-mini-label { font-size: 0.75rem; color: #6b7280; font-weight: 500; }

    /* ===== STUDENT LIST ===== */
    .student-list { padding: 2rem; }
    .student-item { display: flex; align-items: center; justify-content: space-between; padding: 1.25rem; border-radius: var(--radius-md); margin-bottom: 1rem; background: #f9fafb; transition: all 0.3s ease; border: 1px solid transparent; }
    .student-item:hover { background: white; border-color: #e5e7eb; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); transform: translateX(4px); }
    .student-item.has-marks { border-left: 3px solid #10b981; }
    .student-info { display: flex; align-items: center; gap: 1rem; flex: 1; }
    .student-avatar { width: 48px; height: 48px; border-radius: 50%; background: var(--primary-gradient); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.1rem; flex-shrink: 0; }
    .student-details { display: flex; flex-direction: column; gap: 0.25rem; }
    .student-name { font-weight: 600; color: #111827; font-size: 0.95rem; }
    .student-meta { font-size: 0.8rem; color: #6b7280; display: flex; align-items: center; gap: 0.5rem; }
    .assessment-info { text-align: center; flex: 0 0 150px; }
    .assessment-label { font-size: 0.75rem; color: #6b7280; margin-bottom: 0.25rem; }
    .assessment-value { font-size: 0.9rem; font-weight: 600; color: #111827; }
    .marks-input-wrapper { flex: 0 0 150px; }
    .marks-input { width: 100%; padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: var(--radius-md); text-align: center; font-size: 1.1rem; font-weight: 700; transition: all 0.3s ease; }
    .marks-input:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1); }
    .status-badge { flex: 0 0 120px; display: inline-flex; align-items: center; justify-content: center; gap: 0.4rem; padding: 0.5rem 1rem; border-radius: 50px; font-size: 0.85rem; font-weight: 600; }
    .status-badge.excellent { background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #065f46; }
    .status-badge.good { background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); color: #1e40af; }
    .status-badge.pass { background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #92400e; }
    .status-badge.fail { background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); color: #991b1b; }

    /* ===== ACTION BAR ===== */
    .action-bar { position: sticky; bottom: 0; background: white; border-top: 2px solid #e5e7eb; padding: 1.5rem 2rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.05); }
    .action-summary { display: flex; gap: 1.5rem; flex-wrap: wrap; }
    .action-stat { display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; font-weight: 600; }
    .action-stat.completed { color: #10b981; }
    .action-stat.remaining { color: #f59e0b; }
    .action-buttons { display: flex; gap: 1rem; }
    .btn-save { padding: 0.75rem 2rem; background: var(--primary-gradient); color: white; border: none; border-radius: var(--radius-md); font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3); }
    .btn-save:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4); }
    .btn-reset { padding: 0.75rem 1.5rem; background: #f3f4f6; color: #6b7280; border: 1px solid #e5e7eb; border-radius: var(--radius-md); font-weight: 600; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; }
    .btn-reset:hover { background: #e5e7eb; color: #374151; }

    /* ===== EMPTY STATE ===== */
    .empty-state { text-align: center; padding: 4rem 2rem; }
    .empty-icon { width: 100px; height: 100px; margin: 0 auto 1.5rem; background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 3rem; color: #3b82f6; }
    .empty-title { font-size: 1.25rem; font-weight: 700; color: #111827; margin: 0 0 0.5rem 0; }
    .empty-text { color: #6b7280; margin-bottom: 1.5rem; }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 1024px) { .summary-cards, .live-stats { grid-template-columns: repeat(2, 1fr); } }
    @media (max-width: 768px) {
        .summary-cards, .live-stats { grid-template-columns: 1fr; }
        .hero-header { flex-direction: column; text-align: center; }
        .hero-stats { justify-content: center; }
        .filter-grid { grid-template-columns: 1fr; }
        .student-item { flex-direction: column; align-items: flex-start; gap: 1rem; }
        .assessment-info, .marks-input-wrapper, .status-badge { width: 100%; flex: none; }
        .action-bar { flex-direction: column; }
        .action-buttons { width: 100%; flex-direction: column; }
        .btn-save, .btn-reset { width: 100%; justify-content: center; }
    }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>

        <div class="marks-container">

            <!-- ===== SERVER ALERTS (Auto-dismiss after 3s) ===== -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error" id="alertError">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><c:out value="${errorMessage}" /></span>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success" id="alertSuccess">
                    <i class="fas fa-check-circle"></i>
                    <span><c:out value="${successMessage}" /></span>
                </div>
            </c:if>

            <!-- ===== HERO HEADER ===== -->
            <div class="hero-header">
                <div class="hero-content">
                    <h2><i class="fas fa-graduation-cap" style="color: #667eea;"></i> Enter Marks</h2>
                    <p>Record and manage student assessment scores</p>
                </div>
                <div class="hero-stats">
                    <div class="stat-chip"><i class="fas fa-book"></i> <c:out value="${fn:length(subjects)}" /> Subjects</div>
                    <div class="stat-chip"><i class="fas fa-users"></i> <c:out value="${fn:length(sections)}" /> Sections</div>
                    <div class="stat-chip" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border-color: #fcd34d; color: #92400e;">
                        <i class="fas fa-clipboard-list"></i> 3 Assessments
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
                    <div class="summary-label">Total Students</div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #f59e0b;"><i class="fas fa-clipboard-check"></i></div>
                    <div class="summary-value" id="assessmentType">
                        <c:choose>
                            <c:when test="${not empty selectedExamType}"><c:out value="${selectedExamType}" /></c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="summary-label">Assessment</div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); color: #10b981;"><i class="fas fa-chart-line"></i></div>
                    <div class="summary-value" id="averageMarks">0</div>
                    <div class="summary-label">Average Marks</div>
                </div>
                <div class="summary-card">
                    <div class="summary-icon" style="background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); color: #3b82f6;"><i class="fas fa-percentage"></i></div>
                    <div class="summary-value" id="passPercentage">0%</div>
                    <div class="summary-label">Pass Percentage</div>
                </div>
            </div>

            <!-- ===== FILTER PANEL ===== -->
            <div class="filter-panel">
                <h3 class="filter-title"><i class="fas fa-filter"></i> Select Assessment</h3>
                <form method="GET" action="${pageContext.request.contextPath}/faculty/marks">
                    <div class="filter-grid">
                        <div class="filter-group">
                            <label><i class="fas fa-book"></i> Subject</label>
                            <select name="subjectId" class="filter-select" required>
                                <option value="">Select Subject</option>
                                <c:forEach var="sub" items="${subjects}">
                                    <option value="${sub.subjectId}" ${sub.subjectId == selectedSubjectId ? 'selected' : ''}><c:out value="${sub.subjectName}" /></option>
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
                            <label><i class="fas fa-clipboard-list"></i> Exam Type</label>
                            <select name="examType" class="filter-select" required>
                                <option value="">Select Type</option>
                                <option value="INTERNAL" ${selectedExamType == 'INTERNAL' ? 'selected' : ''}>Internal</option>
                                <option value="MIDTERM" ${selectedExamType == 'MIDTERM' ? 'selected' : ''}>Midterm</option>
                                <option value="FINAL" ${selectedExamType == 'FINAL' ? 'selected' : ''}>Final</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <button type="submit" class="btn-load"><i class="fas fa-search"></i> Load Students</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- ===== MARKS ENTRY FORM ===== -->
            <c:if test="${showMarksForm}">
                <c:choose>
                    <c:when test="${not empty students}">
                        <div class="marks-entry-card">
                            <div class="marks-header">
                                <h3 class="marks-title"><i class="fas fa-users"></i> Student Marks Entry</h3>
                                <div class="max-marks-input">
                                    <label>Max Marks:</label>
                                    <input type="number" id="maxMarksInput" value="100" min="1">
                                </div>
                            </div>

                            <div class="progress-section">
                                <div class="progress-header">
                                    <span class="progress-label">Marks Entry Progress</span>
                                    <span class="progress-count" id="progressText">0 / <c:out value="${fn:length(students)}" /> Students Completed</span>
                                </div>
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" id="progressBar" style="width: 0%;"></div>
                                </div>
                            </div>

                            <div class="student-list">
                                <div class="live-stats">
                                    <div class="stat-mini"><div class="stat-mini-value" id="enteredCount">0</div><div class="stat-mini-label">Entered Records</div></div>
                                    <div class="stat-mini"><div class="stat-mini-value" id="avgMarks">0</div><div class="stat-mini-label">Average</div></div>
                                    <div class="stat-mini"><div class="stat-mini-value" id="highestMarks">0</div><div class="stat-mini-label">Highest</div></div>
                                    <div class="stat-mini"><div class="stat-mini-value" id="passRate">0%</div><div class="stat-mini-label">Pass Rate</div></div>
                                </div>

                                <form method="POST" action="${pageContext.request.contextPath}/faculty/marks" id="marksForm">
                                    <input type="hidden" name="subjectId" value="${selectedSubjectId}">
                                    <input type="hidden" name="sectionId" value="${selectedSectionId}">
                                    <input type="hidden" name="examType" value="${selectedExamType}">
                                    <input type="hidden" name="maxMarks" id="maxMarksHidden" value="100">

                                    <c:forEach var="student" items="${students}" varStatus="status">
                                        <c:set var="existingMark" value="" />
                                        <c:forEach var="mark" items="${existingMarks}">
                                            <c:if test="${mark.studentId == student.userId}">
                                                <c:set var="existingMark" value="${mark.marksObtained}" />
                                            </c:if>
                                        </c:forEach>

                                        <div class="student-item" id="student-row-${status.index}">
                                            <div class="student-info">
                                                <div class="student-avatar"><c:out value="${fn:substring(student.fullName, 0, 1)}" /></div>
                                                <div class="student-details">
                                                    <div class="student-name"><c:out value="${student.fullName}" /></div>
                                                    <div class="student-meta"><i class="fas fa-id-card"></i> <c:out value="${student.enrollmentNumber}" /></div>
                                                </div>
                                            </div>
                                            <div class="assessment-info">
                                                <div class="assessment-label">Max Marks</div>
                                                <div class="assessment-value max-display">100</div>
                                            </div>
                                            <div class="marks-input-wrapper">
                                                <input type="hidden" name="studentId" value="${student.userId}">
                                                <input type="number" name="marks" class="marks-input marks-field"
                                                       value="<c:out value='${existingMark}' />"
                                                       placeholder="0" min="0" step="0.01" max="100">
                                            </div>
                                            <div class="status-badge" id="status-${status.index}">
                                                <i class="fas fa-circle" style="font-size: 0.5rem;"></i> Pending
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="action-bar">
                                        <div class="action-summary">
                                            <div class="action-stat"><i class="fas fa-users"></i> Students: <span id="summaryTotal"><c:out value="${fn:length(students)}" /></span></div>
                                            <div class="action-stat completed"><i class="fas fa-check-circle"></i> Completed: <span id="summaryCompleted">0</span></div>
                                            <div class="action-stat remaining"><i class="fas fa-clock"></i> Remaining: <span id="summaryRemaining"><c:out value="${fn:length(students)}" /></span></div>
                                        </div>
                                        <div class="action-buttons">
                                            <button type="button" class="btn-reset" onclick="resetMarks()"><i class="fas fa-undo"></i> Reset</button>
                                            <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save Marks</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="marks-entry-card">
                            <div class="empty-state">
                                <div class="empty-icon"><i class="fas fa-user-slash"></i></div>
                                <h3 class="empty-title">No Students Found</h3>
                                <p class="empty-text">No students are enrolled in this section.</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <c:if test="${!showMarksForm}">
                <div class="marks-entry-card">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-clipboard-list"></i></div>
                        <h3 class="empty-title">Select Subject, Section and Assessment</h3>
                        <p class="empty-text">Load students to begin entering marks.</p>
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
    // ===== CONFIG =====
    let maxMarks = 100;
    const passingMarks = 40;
    const totalStudents = parseInt(document.getElementById('totalStudents').textContent) || 0;

    // ===== AUTO-DISMISS ALERTS (3 seconds) =====
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.custom-alert').forEach(function (alert) {
            setTimeout(function () {
                alert.classList.add('fade-out');
                setTimeout(function () { alert.remove(); }, 500);
            }, 3000);
        });

        // Initialize status badges for pre-filled marks
        document.querySelectorAll('.marks-field').forEach(function (input, index) {
            if (input.value && input.value.trim() !== '') {
                updateStatus(index);
            }
        });
        updateStatistics();
        updateProgress();
    });

    // ===== MAX MARKS CHANGE =====
    document.getElementById('maxMarksInput').addEventListener('input', function () {
        maxMarks = parseInt(this.value) || 100;
        document.getElementById('maxMarksHidden').value = maxMarks;
        document.querySelectorAll('.marks-field').forEach(function (field) {
            field.max = maxMarks;
        });
        document.querySelectorAll('.max-display').forEach(function (el) {
            el.textContent = maxMarks;
        });
        updateStatistics();
    });

    // ===== LIVE UPDATE ON INPUT =====
    document.querySelectorAll('.marks-field').forEach(function (input, index) {
        input.addEventListener('input', function () {
            updateStatus(index);
            updateStatistics();
            updateProgress();
        });
    });

    // ===== UPDATE STATUS BADGE =====
    function updateStatus(index) {
        var input = document.querySelectorAll('.marks-field')[index];
        var badge = document.getElementById('status-' + index);
        var row = document.getElementById('student-row-' + index);
        var value = parseFloat(input.value);

        row.classList.remove('has-marks');

        if (input.value && input.value.trim() !== '' && !isNaN(value)) {
            row.classList.add('has-marks');
            badge.className = 'status-badge';

            if (value >= 90) {
                badge.classList.add('excellent');
                badge.innerHTML = '<i class="fas fa-check-circle"></i> Excellent';
            } else if (value >= 75) {
                badge.classList.add('good');
                badge.innerHTML = '<i class="fas fa-thumbs-up"></i> Good';
            } else if (value >= passingMarks) {
                badge.classList.add('pass');
                badge.innerHTML = '<i class="fas fa-check"></i> Pass';
            } else {
                badge.classList.add('fail');
                badge.innerHTML = '<i class="fas fa-times"></i> Fail';
            }
        } else {
            badge.className = 'status-badge';
            badge.innerHTML = '<i class="fas fa-circle" style="font-size: 0.5rem;"></i> Pending';
        }
    }

    // ===== UPDATE PROGRESS =====
    function updateProgress() {
        var completed = 0;
        document.querySelectorAll('.marks-field').forEach(function (input) {
            if (input.value && input.value.trim() !== '') completed++;
        });

        var pct = totalStudents > 0 ? (completed / totalStudents) * 100 : 0;
        document.getElementById('progressBar').style.width = pct + '%';
        document.getElementById('progressText').textContent = completed + ' / ' + totalStudents + ' Students Completed';
        document.getElementById('summaryCompleted').textContent = completed;
        document.getElementById('summaryRemaining').textContent = totalStudents - completed;
    }

    // ===== UPDATE STATISTICS =====
    function updateStatistics() {
        var sum = 0, count = 0, highest = 0, passCount = 0;

        document.querySelectorAll('.marks-field').forEach(function (input) {
            if (input.value && input.value.trim() !== '') {
                var value = parseFloat(input.value);
                if (!isNaN(value)) {
                    sum += value;
                    count++;
                    if (value > highest) highest = value;
                    if (value >= passingMarks) passCount++;
                }
            }
        });

        var avg = count > 0 ? (sum / count).toFixed(1) : '0';
        var rate = count > 0 ? Math.round((passCount / count) * 100) : 0;

        document.getElementById('enteredCount').textContent = count;
        document.getElementById('avgMarks').textContent = avg;
        document.getElementById('highestMarks').textContent = highest;
        document.getElementById('passRate').textContent = rate + '%';
        document.getElementById('averageMarks').textContent = avg;
        document.getElementById('passPercentage').textContent = rate + '%';
    }

    // ===== RESET =====
    function resetMarks() {
        if (confirm('Are you sure you want to reset all marks?')) {
            document.querySelectorAll('.marks-field').forEach(function (input, index) {
                input.value = '';
                updateStatus(index);
            });
            updateStatistics();
            updateProgress();
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>