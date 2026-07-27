<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Academic Marks" scope="request" />

<%@ include file="includes/studentHead.jsp" %>

<div class="app-wrapper">
    <%@ include file="includes/studentSidebar.jsp" %>

    <div class="main-content">
        <%@ include file="includes/studentNavbar.jsp" %>

        <div class="content-area">
            
            <!-- Server Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error"><i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}" /></div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success"><i class="fas fa-check-circle"></i> <c:out value="${successMessage}" /></div>
            </c:if>

            <!-- 1. Performance Summary Cards -->
            <div class="row g-4 mb-4">
                <!-- Calculate aggregates dynamically using JSTL -->
                <c:set var="totalExams" value="${fn:length(marks)}" />
                <c:set var="totalPercentage" value="0" />
                <c:set var="highestPercentage" value="0" />
                
                <c:forEach var="mark" items="${marks}">
                    <c:if test="${mark.maxMarks > 0}">
                        <c:set var="currentPct" value="${(mark.marksObtained / mark.maxMarks) * 100}" />
                        <c:set var="totalPercentage" value="${totalPercentage + currentPct}" />
                        <c:if test="${currentPct > highestPercentage}">
                            <c:set var="highestPercentage" value="${currentPct}" />
                        </c:if>
                    </c:if>
                </c:forEach>
                
                <c:set var="averagePercentage" value="0" />
                <c:if test="${totalExams > 0}">
                    <c:set var="averagePercentage" value="${totalPercentage / totalExams}" />
                </c:if>

                <!-- Total Exams Card -->
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="glass-card h-100 mb-0 p-4" style="border-radius: 16px;">
                        <div class="d-flex align-items-center gap-3">
                            <div class="bg-primary bg-opacity-10 text-primary rounded-3 p-3">
                                <i class="fas fa-file-alt fa-lg"></i>
                            </div>
                            <div>
                                <div class="text-muted small mb-1">Total Exams</div>
                                <div class="fw-bold fs-4 text-dark"><c:out value="${totalExams}" default="0" /></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Average Score Card -->
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="glass-card h-100 mb-0 p-4" style="border-radius: 16px;">
                        <div class="d-flex align-items-center gap-3">
                            <div class="bg-success bg-opacity-10 text-success rounded-3 p-3">
                                <i class="fas fa-chart-line fa-lg"></i>
                            </div>
                            <div>
                                <div class="text-muted small mb-1">Average Score</div>
                                <div class="fw-bold fs-4 text-dark">
                                    <fmt:formatNumber value="${averagePercentage}" pattern="#0.0" />%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Highest Score Card -->
                <div class="col-12 col-sm-6 col-lg-4">
                    <div class="glass-card h-100 mb-0 p-4" style="border-radius: 16px;">
                        <div class="d-flex align-items-center gap-3">
                            <div class="bg-warning bg-opacity-10 text-warning rounded-3 p-3">
                                <i class="fas fa-trophy fa-lg"></i>
                            </div>
                            <div>
                                <div class="text-muted small mb-1">Highest Score</div>
                                <div class="fw-bold fs-4 text-dark">
                                    <fmt:formatNumber value="${highestPercentage}" pattern="#0.0" />%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. Marks Table Section -->
            <div class="glass-card" style="border-radius: 20px;">
                
                <!-- Header & Filter Placeholder -->
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                    <div>
                        <h4 class="fw-bold text-dark mb-1"><i class="fas fa-graduation-cap text-primary me-2"></i>Detailed Marks Sheet</h4>
                        <p class="text-muted small mb-0">Comprehensive breakdown of your academic performance.</p>
                    </div>
                    
					<!-- Debug: Show available semesters -->
					<c:if test="${false}">
					    <div class="alert alert-info">
					        Available Semesters: ${availableSemesters}<br>
					        Selected Semester: ${selectedSemester}<br>
					        Student's Current Semester: ${student.currentSemester}
					    </div>
					</c:if>
					
					<!-- Dynamic Filter Form -->
					<form method="GET" action="${pageContext.request.contextPath}/student/marks" id="filterForm" class="d-flex gap-2 flex-wrap">
					    <input type="hidden" name="action" value="marks">
					    
					    <!-- 1. Semester Dropdown -->
					    <select name="semester" class="form-select form-select-sm border-0 bg-light shadow-sm" style="width: 150px; border-radius: 8px;" onchange="this.form.submit()">
					        <option value="">All Semesters</option>
					        <c:forEach var="sem" items="${availableSemesters}">
					            <option value="${sem}" ${sem == selectedSemester ? 'selected' : ''}>
					                Semester ${sem}
					            </option>
					        </c:forEach>
					    </select>
					
					    <!-- 2. Exam Type Dropdown -->
					    <select name="examType" class="form-select form-select-sm border-0 bg-light shadow-sm" style="width: 150px; border-radius: 8px;" onchange="this.form.submit()">
					        <option value="">All Exam Types</option>
					        <option value="INTERNAL" ${selectedExamType == 'INTERNAL' ? 'selected' : ''}>Internal</option>
					        <option value="MIDTERM" ${selectedExamType == 'MIDTERM' ? 'selected' : ''}>Midterm</option>
					        <option value="FINAL" ${selectedExamType == 'FINAL' ? 'selected' : ''}>Final</option>
					    </select>
					
					    <!-- 3. Subject Dropdown -->
						<select name="subjectId" class="form-select form-select-sm border-0 bg-light shadow-sm" style="width: 200px; border-radius: 8px;" onchange="this.form.submit()">
						    <option value="">All Subjects</option>
						    <c:forEach var="sub" items="${availableSubjects}">
						        <option value="${sub.subjectId}" ${sub.subjectId == selectedSubjectId ? 'selected' : ''}>
						            <c:out value="${sub.subjectName}" />
						        </option>
						    </c:forEach>
						</select>
					</form>
                </div>

                <!-- Data Table -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th scope="col" class="border-0 rounded-start-3 py-3 px-4 text-muted small text-uppercase">#</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase">Subject Name</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase">Exam Type</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Obtained</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Max Marks</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase text-center">Percentage</th>
                                <th scope="col" class="border-0 rounded-end-3 py-3 text-muted small text-uppercase text-center">Grade</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty marks}">
                                    <c:forEach var="mark" items="${marks}" varStatus="status">
                                        <tr>
                                            <td class="px-4 fw-semibold text-muted">
                                                <c:out value="${status.index + 1}" />
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark">
                                                    <c:out value="${mark.subjectName}" />
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${mark.examType == 'INTERNAL'}">
                                                        <span class="badge bg-info bg-opacity-10 text-info px-3 py-2 rounded-pill border border-info-subtle">Internal</span>
                                                    </c:when>
                                                    <c:when test="${mark.examType == 'MIDTERM'}">
                                                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill border border-primary-subtle">Midterm</span>
                                                    </c:when>
                                                    <c:when test="${mark.examType == 'FINAL'}">
                                                        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill border border-success-subtle">Final</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill"><c:out value="${mark.examType}" /></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center fw-bold text-dark">
                                                <c:out value="${mark.marksObtained}" />
                                            </td>
                                            <td class="text-center text-muted">
                                                <c:out value="${mark.maxMarks}" />
                                            </td>
                                            <td class="text-center">
                                                <c:if test="${mark.maxMarks > 0}">
                                                    <c:set var="pct" value="${(mark.marksObtained / mark.maxMarks) * 100}" />
                                                    <c:choose>
                                                        <c:when test="${pct >= 80}">
                                                            <span class="fw-bold text-success"><fmt:formatNumber value="${pct}" pattern="#0.0" />%</span>
                                                        </c:when>
                                                        <c:when test="${pct >= 60}">
                                                            <span class="fw-bold text-primary"><fmt:formatNumber value="${pct}" pattern="#0.0" />%</span>
                                                        </c:when>
                                                        <c:when test="${pct >= 40}">
                                                            <span class="fw-bold text-warning"><fmt:formatNumber value="${pct}" pattern="#0.0" />%</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="fw-bold text-danger"><fmt:formatNumber value="${pct}" pattern="#0.0" />%</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:if test="${mark.maxMarks == 0}">
                                                    <span class="text-muted">N/A</span>
                                                </c:if>
                                            </td>
                                            <td class="text-center">
                                                <c:if test="${mark.maxMarks > 0}">
                                                    <c:set var="pct" value="${(mark.marksObtained / mark.maxMarks) * 100}" />
                                                    <c:choose>
                                                        <c:when test="${pct >= 90}">
                                                            <span class="badge bg-success text-white px-3 py-2 rounded-pill">A+</span>
                                                        </c:when>
                                                        <c:when test="${pct >= 80}">
                                                            <span class="badge bg-primary text-white px-3 py-2 rounded-pill">A</span>
                                                        </c:when>
                                                        <c:when test="${pct >= 70}">
                                                            <span class="badge bg-info text-white px-3 py-2 rounded-pill">B+</span>
                                                        </c:when>
                                                        <c:when test="${pct >= 60}">
                                                            <span class="badge bg-info text-white px-3 py-2 rounded-pill">B</span>
                                                        </c:when>
                                                        <c:when test="${pct >= 50}">
                                                            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">C</span>
                                                        </c:when>
                                                        <c:when test="${pct >= 40}">
                                                            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">D</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger text-white px-3 py-2 rounded-pill">F</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:if test="${mark.maxMarks == 0}">
                                                    <span class="text-muted">-</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="fas fa-file-signature fa-3x mb-3 opacity-25"></i>
                                            <p class="mb-0">No marks have been published for your enrolled subjects yet.</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>