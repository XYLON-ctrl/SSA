<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Academic Performance" scope="request" />

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

            <!-- 1. Academic Standing Summary Cards -->
			<div class="row g-4 mb-4">
			    <!-- CGPA Card -->
			    <div class="col-12 col-md-4">
			        <div class="glass-card h-100 mb-0 p-4" style="border-radius: 16px; position: relative; overflow: hidden;">
			            <div class="position-absolute top-0 end-0 p-3 opacity-10">
			                <i class="fas fa-award fa-4x text-primary"></i>
			            </div>
			            <div class="text-muted small mb-2 text-uppercase fw-semibold" style="letter-spacing: 1px;">Current CGPA</div>
			            <div class="fw-bold display-5 text-primary mb-2">
			                <c:out value="${student.cgpa}" default="0.0" />
			            </div>
			            <div class="small text-muted">
			                <i class="fas fa-arrow-up text-success me-1"></i> Maintained good standing
			            </div>
			        </div>
			    </div>
			
				<!-- Total Credits Card -->
				<div class="col-12 col-md-4">
				    <div class="glass-card h-100 mb-0 p-4" style="border-radius: 16px; position: relative; overflow: hidden;">
				        <div class="position-absolute top-0 end-0 p-3 opacity-10">
				            <i class="fas fa-layer-group fa-4x text-success"></i>
				        </div>
				        <div class="text-muted small mb-2 text-uppercase fw-semibold" style="letter-spacing: 1px;">Credits Earned</div>
				        <div class="fw-bold display-5 text-success mb-2">
				            <c:out value="${totalCredits}" default="0" />
				        </div>
				        <div class="small text-muted">
				            Out of <c:out value="${totalPossibleCredits}" default="0" /> total credits
				        </div>
				    </div>
				</div>
			
			    <!-- Class Rank Card -->
				<div class="col-12 col-md-4">
				    <div class="glass-card h-100 mb-0 p-4" style="border-radius: 16px; position: relative; overflow: hidden;">
				        <div class="position-absolute top-0 end-0 p-3 opacity-10">
				            <i class="fas fa-trophy fa-4x text-warning"></i>
				        </div>
				        <div class="text-muted small mb-2 text-uppercase fw-semibold" style="letter-spacing: 1px;">Class Rank</div>
				        <div class="fw-bold display-5 text-warning mb-2">
				            <c:choose>
				                <c:when test="${totalStudentsInBatch > 1}">
				                    #<c:out value="${classRank}" default="--" />
				                </c:when>
				                <c:otherwise>
				                    N/A
				                </c:otherwise>
				            </c:choose>
				        </div>
				        <div class="small text-muted">
				            <c:choose>
				                <c:when test="${totalStudentsInBatch > 1}">
				                    Among <c:out value="${totalStudentsInBatch}" default="0" /> students
				                </c:when>
				                <c:otherwise>
				                    Insufficient data for ranking
				                </c:otherwise>
				            </c:choose>
				        </div>
				    </div>
				</div>
			</div>
			
			<div class="row g-4">
			    <!-- 2. CGPA Trend Chart -->
				<div class="col-lg-8">
				    <div class="glass-card h-100" style="border-radius: 20px;">
				        <div class="d-flex justify-content-between align-items-center mb-4">
				            <h4 class="fw-bold text-dark mb-0"><i class="fas fa-chart-line text-primary me-2"></i>Academic Progress Trend</h4>
				            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2" style="border-radius: 8px;">
				                <i class="fas fa-info-circle me-1"></i> Semester-wise SGPA
				            </span>
				        </div>
				
				        <!-- Chart.js Integration Area -->
				        <div class="chart-container position-relative" style="height: 300px; border: 2px dashed rgba(0,0,0,0.1); border-radius: 12px; background: rgba(255,255,255,0.4); display: flex; align-items: center; justify-content: center;">
				            <canvas id="performanceTrendChart" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></canvas>
				            
				            <!-- Fallback UI if no data -->
				            <c:if test="${empty chartDataJson or chartDataJson == '{\"labels\": [], \"cgpaValues\": []}'}">
				                <div class="text-center p-4" id="chartFallback">
				                    <i class="fas fa-chart-area fa-3x text-primary opacity-50 mb-3"></i>
				                    <h6 class="fw-bold text-muted mb-1">No Performance Data Yet</h6>
				                    <p class="small text-muted mb-0">Your semester-wise progress will appear here once results are published.</p>
				                </div>
				            </c:if>
				        </div>
				    </div>
				</div>

                <!-- 3. Subject-wise Performance Bars -->
                <div class="col-lg-4">
                    <div class="glass-card h-100" style="border-radius: 20px;">
                        <h4 class="fw-bold text-dark mb-4"><i class="fas fa-tasks text-success me-2"></i>Subject Performance</h4>
                        
                        <div class="performance-list" style="max-height: 320px; overflow-y: auto; padding-right: 5px;">
                            <c:choose>
                                <c:when test="${not empty marks}">
                                    <c:forEach var="mark" items="${marks}">
                                        <c:if test="${mark.maxMarks > 0}">
                                            <c:set var="pct" value="${(mark.marksObtained / mark.maxMarks) * 100}" />
                                            
                                            <div class="mb-4">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <div class="fw-semibold text-dark small text-truncate" style="max-width: 60%;">
                                                        <c:out value="${mark.subjectName}" />
                                                    </div>
                                                    <div class="fw-bold small">
                                                        <c:choose>
                                                            <c:when test="${pct >= 80}"><span class="text-success"><fmt:formatNumber value="${pct}" pattern="#0" />%</span></c:when>
                                                            <c:when test="${pct >= 60}"><span class="text-primary"><fmt:formatNumber value="${pct}" pattern="#0" />%</span></c:when>
                                                            <c:when test="${pct >= 40}"><span class="text-warning"><fmt:formatNumber value="${pct}" pattern="#0" />%</span></c:when>
                                                            <c:otherwise><span class="text-danger"><fmt:formatNumber value="${pct}" pattern="#0" />%</span></c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div class="progress" style="height: 8px; border-radius: 4px; background: rgba(0,0,0,0.05);">
                                                    <c:choose>
                                                        <c:when test="${pct >= 80}">
                                                            <div class="progress-bar bg-success" role="progressbar" style="width: ${pct}%"></div>
                                                        </c:when>
                                                        <c:when test="${pct >= 60}">
                                                            <div class="progress-bar bg-primary" role="progressbar" style="width: ${pct}%"></div>
                                                        </c:when>
                                                        <c:when test="${pct >= 40}">
                                                            <div class="progress-bar bg-warning" role="progressbar" style="width: ${pct}%"></div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="progress-bar bg-danger" role="progressbar" style="width: ${pct}%"></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="small text-muted mt-1">
                                                    <c:out value="${mark.marksObtained}" /> / <c:out value="${mark.maxMarks}" /> 
                                                    <span class="ms-2 badge bg-light text-muted border"><c:out value="${mark.examType}" /></span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5 text-muted">
                                        <i class="fas fa-chart-bar fa-3x mb-3 opacity-25"></i>
                                        <p class="mb-0 small">No performance data available yet.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. Academic Insights & Improvement Tips -->
            <div class="glass-card mt-4" style="border-radius: 20px;">
                <h4 class="fw-bold text-dark mb-4"><i class="fas fa-lightbulb text-warning me-2"></i>Academic Insights & Recommendations</h4>
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="d-flex gap-3">
                            <div class="bg-success bg-opacity-10 text-success rounded-3 p-2" style="height: fit-content;">
                                <i class="fas fa-check"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold text-dark mb-1">Strong Performance</h6>
                                <p class="small text-muted mb-0">You are performing exceptionally well in core subjects. Maintain this consistency to secure a high final CGPA.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex gap-3">
                            <div class="bg-warning bg-opacity-10 text-warning rounded-3 p-2" style="height: fit-content;">
                                <i class="fas fa-exclamation"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold text-dark mb-1">Focus Areas</h6>
                                <p class="small text-muted mb-0">Consider dedicating extra study hours to subjects where your attendance or internal marks are below 75%.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex gap-3">
                            <div class="bg-primary bg-opacity-10 text-primary rounded-3 p-2" style="height: fit-content;">
                                <i class="fas fa-book-reader"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold text-dark mb-1">Resource Utilization</h6>
                                <p class="small text-muted mb-0">Utilize the digital library and faculty consultation hours to clarify doubts before the final examinations.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex gap-3">
                            <div class="bg-info bg-opacity-10 text-info rounded-3 p-2" style="height: fit-content;">
                                <i class="fas fa-users"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold text-dark mb-1">Peer Learning</h6>
                                <p class="small text-muted mb-0">Engage in group studies for complex subjects. Collaborative learning has shown to improve retention by 40%.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log("=== JSP: DOM Loaded ===");
        
        // 1. DATA INJECTION
        const chartData = ${chartDataJson};
        console.log("JSP: Received chartData:", chartData);
        console.log("JSP: chartData type:", typeof chartData);
        console.log("JSP: chartData.labels:", chartData.labels);
        console.log("JSP: chartData.cgpaValues:", chartData.cgpaValues);
        
        // Check if data is valid
        if (!chartData || !chartData.labels || chartData.labels.length === 0) {
            console.error("JSP: NO DATA AVAILABLE - Showing fallback message");
            document.getElementById('performanceTrendChart').style.display = 'none';
            const fallback = document.getElementById('chartFallback');
            if (fallback) {
                fallback.style.display = 'block';
                fallback.innerHTML = `
                    <div class="text-center p-4">
                        <i class="fas fa-chart-area fa-3x text-danger opacity-50 mb-3"></i>
                        <h6 class="fw-bold text-muted mb-1">No Performance Data</h6>
                        <p class="small text-muted mb-0">Chart data is empty. Check server logs.</p>
                        <p class="small text-muted">Debug: chartData = ${chartDataJson}</p>
                    </div>
                `;
            }
            return;
        }
        
        console.log("JSP: Data is valid, hiding fallback");
        const fallback = document.getElementById('chartFallback');
        if (fallback) fallback.style.display = 'none';
        document.getElementById('performanceTrendChart').style.display = 'block';

        // 2. CHART INITIALIZATION
        const ctx = document.getElementById('performanceTrendChart').getContext('2d');
        console.log("JSP: Canvas context obtained");

        // 3. RENDER CHART
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: chartData.labels,
                datasets: [{
                    label: 'SGPA',
                    data: chartData.cgpaValues,
                    borderColor: '#2a5298',
                    backgroundColor: 'rgba(42, 82, 152, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#2a5298',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { 
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return ' SGPA: ' + context.parsed.y.toFixed(2);
                            }
                        }
                    }
                },
                scales: {
                    y: { 
                        beginAtZero: false, 
                        min: 4, 
                        max: 10, 
                        ticks: { stepSize: 1 }
                    },
                    x: { grid: { display: false } }
                }
            }
        });
        
        console.log("JSP: Chart rendered successfully");
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>