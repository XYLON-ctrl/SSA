<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Attendance Details" scope="request" />

<%@ include file="includes/studentHead.jsp" %>

<style>
    /* Filter Bar Styles */
    .filter-bar {
        background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,250,252,0.9) 100%);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(226, 232, 240, 0.8);
        border-radius: 16px;
        padding: 1.25rem 1.5rem;
        margin-bottom: 1.5rem;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    }
    
    .filter-section {
        display: flex;
        gap: 1.5rem;
        align-items: center;
        flex-wrap: wrap;
    }
    
    .filter-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }
    
    .filter-label {
        font-size: 0.75rem;
        font-weight: 600;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .filter-label i {
        color: #3b82f6;
        font-size: 0.875rem;
    }
    
    .filter-select {
        border: 1.5px solid #e2e8f0;
        border-radius: 10px;
        padding: 0.625rem 1rem;
        font-size: 0.875rem;
        font-weight: 500;
        background: white;
        color: #1e293b;
        transition: all 0.2s ease;
        min-width: 200px;
        cursor: pointer;
    }
    
    .filter-select:hover {
        border-color: #94a3b8;
    }
    
    .filter-select:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        outline: none;
    }
    
    .reset-btn {
        background: white;
        border: 1.5px solid #e2e8f0;
        border-radius: 10px;
        padding: 0.625rem 1.25rem;
        font-size: 0.875rem;
        font-weight: 600;
        color: #64748b;
        cursor: pointer;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        margin-top: auto;
    }
    
    .reset-btn:hover {
        background: #f8fafc;
        border-color: #cbd5e1;
        color: #334155;
        transform: translateY(-1px);
    }
    
    .reset-btn i {
        font-size: 0.875rem;
    }
    
    .no-records-match {
        text-align: center;
        padding: 3rem 1rem;
        color: #94a3b8;
    }
    
    .no-records-match i {
        font-size: 3rem;
        opacity: 0.3;
        margin-bottom: 1rem;
        color: #cbd5e1;
    }
    
    .no-records-match h6 {
        color: #475569;
        font-weight: 600;
        margin-bottom: 0.5rem;
    }
    
    .no-records-match p {
        font-size: 0.875rem;
        color: #94a3b8;
    }
    
    /* Smooth row transitions */
    .attendance-row {
        transition: all 0.2s ease;
    }
    
    .attendance-row:hover {
        background: rgba(241, 245, 249, 0.6);
    }
</style>

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

            <!-- 1. Header & Navigation -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/student/attendance" class="btn btn-light rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                        <i class="fas fa-arrow-left text-primary"></i>
                    </a>
                    <div>
                        <h2 class="page-title mb-1">
                            <c:choose>
                                <c:when test="${not empty dailyRecords && not empty dailyRecords[0].subjectName}">
                                    <c:out value="${dailyRecords[0].subjectName}" />
                                </c:when>
                                <c:otherwise>
                                    Subject Attendance Details
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="page-subtitle mb-0">Detailed daily attendance record for this subject.</p>
                    </div>
                </div>
                
                <!-- Status Legend -->
                <div class="d-flex gap-2 flex-wrap">
                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill border border-success-subtle">Present</span>
                    <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill border border-danger-subtle">Absent</span>
                    <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill border border-warning-subtle">Late</span>
                    <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill border border-secondary-subtle">Cancelled</span>
                </div>
            </div>

            <!-- 2. Filter Bar -->
            <c:if test="${not empty dailyRecords}">
                <div class="filter-bar">
                    <div class="filter-section">
                        <div class="filter-group">
                            <label class="filter-label">
                                <i class="fas fa-filter"></i>
                                Filter by Status
                            </label>
                            <select id="statusFilter" class="form-select filter-select">
                                <option value="ALL">All Statuses</option>
                                <option value="PRESENT">Present</option>
                                <option value="ABSENT">Absent</option>
                                <option value="LATE">Late</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">
                                <i class="fas fa-sort-amount-down"></i>
                                Sort by Date
                            </label>
                            <select id="dateSort" class="form-select filter-select">
                                <option value="DESC">Newest First</option>
                                <option value="ASC">Oldest First</option>
                            </select>
                        </div>
                        
                        <div class="filter-group" style="margin-left: auto;">
                            <button type="button" class="reset-btn" onclick="resetFilters()">
                                <i class="fas fa-undo"></i>
                                Reset Filters
                            </button>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 3. Daily Attendance Records Table -->
            <div class="glass-card" style="border-radius: 20px;">
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                    <h4 class="fw-bold text-dark mb-0"><i class="fas fa-calendar-day text-primary me-2"></i>Daily Records</h4>
                    <span class="badge bg-light text-primary border border-primary-subtle px-3 py-2 rounded-pill">
                        <span id="recordCount"><c:out value="${fn:length(dailyRecords)}" default="0" /></span> Entries
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="attendanceTable">
                        <thead class="bg-light">
                            <tr>
                                <th scope="col" class="border-0 rounded-start-3 py-3 px-4 text-muted small text-uppercase">#</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase">Date</th>
                                <th scope="col" class="border-0 py-3 text-muted small text-uppercase">Day</th>
                                <th scope="col" class="border-0 rounded-end-3 py-3 text-muted small text-uppercase text-center">Status</th>
                            </tr>
                        </thead>
                        <tbody id="attendanceBody">
                            <c:choose>
                                <c:when test="${not empty dailyRecords}">
                                    <c:forEach var="record" items="${dailyRecords}" varStatus="status">
                                        <tr class="attendance-row" 
                                            data-status="${record.status}" 
                                            data-date="${record.attendanceDate}">
                                            <td class="px-4 fw-semibold text-muted row-number">
                                                <c:out value="${status.index + 1}" />
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark">
                                                    <c:out value="${record.dateFormatted}" />
                                                </div>
                                            </td>
                                            <td>
                                                <span class="text-muted">
                                                    <c:out value="${record.dayOfWeekFormatted}" />
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${record.status == 'PRESENT'}">
                                                        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill border border-success-subtle">
                                                            <i class="fas fa-check me-1"></i> Present
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.status == 'ABSENT'}">
                                                        <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill border border-danger-subtle">
                                                            <i class="fas fa-times me-1"></i> Absent
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.status == 'LATE'}">
                                                        <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill border border-warning-subtle">
                                                            <i class="fas fa-clock me-1"></i> Late
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill border border-secondary-subtle">
                                                            <i class="fas fa-ban me-1"></i> Cancelled
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center py-5 text-muted">
                                            <i class="fas fa-calendar-times fa-3x mb-3 opacity-25"></i>
                                            <p class="mb-0">No attendance records found for this subject yet.</p>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                
                <!-- Empty state when filter returns no results -->
                <div id="noMatchMessage" class="no-records-match" style="display: none;">
                    <i class="fas fa-search d-block"></i>
                    <h6 class="fw-bold text-muted mb-1">No Matching Records</h6>
                    <p class="small mb-0">Try adjusting your filters to see more results.</p>
                </div>
            </div>

        </div>

        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const statusFilter = document.getElementById('statusFilter');
        const dateSort = document.getElementById('dateSort');
        const attendanceBody = document.getElementById('attendanceBody');
        const recordCount = document.getElementById('recordCount');
        const noMatchMessage = document.getElementById('noMatchMessage');
        
        if (!statusFilter || !attendanceBody) return;
        
        // Get all attendance rows
        const rows = Array.from(attendanceBody.querySelectorAll('.attendance-row'));
        
        // Listen for filter changes
        statusFilter.addEventListener('change', applyFilters);
        dateSort.addEventListener('change', applyFilters);
        
        function applyFilters() {
            const selectedStatus = statusFilter.value;
            const sortOrder = dateSort.value;
            
            // Filter rows
            let visibleRows = rows.filter(row => {
                const rowStatus = row.getAttribute('data-status');
                return selectedStatus === 'ALL' || rowStatus === selectedStatus;
            });
            
            // Sort rows by date
            visibleRows.sort((a, b) => {
                const dateA = new Date(a.getAttribute('data-date'));
                const dateB = new Date(b.getAttribute('data-date'));
                return sortOrder === 'ASC' ? dateA - dateB : dateB - dateA;
            });
            
            // Remove all rows from tbody
            rows.forEach(row => row.remove());
            
            // Re-append filtered and sorted rows
            visibleRows.forEach(row => attendanceBody.appendChild(row));
            
            // Update row numbers
            visibleRows.forEach((row, index) => {
                const numberCell = row.querySelector('.row-number');
                if (numberCell) {
                    numberCell.textContent = index + 1;
                }
            });
            
            // Update count badge
            recordCount.textContent = visibleRows.length;
            
            // Show/hide no match message
            if (visibleRows.length === 0) {
                noMatchMessage.style.display = 'block';
                attendanceBody.style.display = 'none';
            } else {
                noMatchMessage.style.display = 'none';
                attendanceBody.style.display = '';
            }
        }
    });
    
    // Reset all filters to default
    function resetFilters() {
        document.getElementById('statusFilter').value = 'ALL';
        document.getElementById('dateSort').value = 'DESC';
        
        // Trigger change event to apply filters
        document.getElementById('statusFilter').dispatchEvent(new Event('change'));
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>