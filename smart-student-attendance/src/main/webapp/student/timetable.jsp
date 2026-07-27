<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Weekly Timetable" scope="request" />
<c:set var="today" value="${not empty todayDay ? todayDay : 'NONE'}" />

<%@ include file="includes/studentHead.jsp" %>

<style>
    .day-section {
        background: white;
        border-radius: 16px;
        border: 1px solid var(--card-border);
        box-shadow: var(--shadow);
        margin-bottom: 2rem;
        overflow: hidden;
    }
    
    .day-header {
        padding: 1.25rem 1.5rem;
        font-weight: 700;
        font-size: 1.1rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 2px solid #f1f5f9;
    }
    
    .day-header.today {
        background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
        color: white;
        border-bottom: none;
    }
    
    .day-header.today .day-badge {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        font-size: 0.7rem;
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-weight: 500;
    }
    
    .day-header.other {
        background: white;
        color: var(--text-dark);
    }
    
    .table-responsive-custom {
        overflow-x: auto;
    }
    
    .timetable-table {
        width: 100%;
        margin-bottom: 0;
    }
    
    .timetable-table thead th {
        background: #f8fafc;
        color: var(--text-muted);
        font-weight: 600;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 1rem 1.25rem;
        border-bottom: 2px solid #e2e8f0;
    }
    
    .timetable-table tbody tr {
        border-bottom: 1px solid #f1f5f9;
        transition: all 0.2s ease;
    }
    
    .timetable-table tbody tr:hover {
        background: #f8fafc;
    }
    
    .timetable-table tbody td {
        padding: 1.25rem;
        vertical-align: middle;
    }
    
    .col-subject { font-weight: 600; color: var(--text-dark); min-width: 200px; }
    .col-time { color: var(--text-muted); white-space: nowrap; min-width: 150px; }
    .col-faculty { min-width: 180px; }
    .col-room { min-width: 120px; text-align: center; }
    
    .faculty-chip {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        background: #ecfdf5;
        color: #059669;
        padding: 0.4rem 0.75rem;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 600;
    }
    
    .room-chip {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        background: #eff6ff;
        color: var(--primary-blue);
        padding: 0.4rem 0.75rem;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 600;
    }
    
    .time-icon { color: var(--primary-blue); margin-right: 0.4rem; }
</style>

<div class="app-wrapper">
    <%@ include file="includes/studentSidebar.jsp" %>
    <div class="main-content">
        <%@ include file="includes/studentNavbar.jsp" %>
        <div class="content-area">
            
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error"><i class="fas fa-exclamation-circle"></i> <c:out value="${errorMessage}" /></div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success"><i class="fas fa-check-circle"></i> <c:out value="${successMessage}" /></div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <div>
                    <h2 class="page-title mb-1"><i class="fas fa-calendar-alt text-primary me-2"></i>Weekly Timetable</h2>
                    <p class="page-subtitle mb-0">Your scheduled classes for the current semester.</p>
                </div>
                <div class="d-flex gap-2 flex-wrap">
                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill border border-primary-subtle">
                        <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i> Today
                    </span>
                    <span class="badge bg-light text-muted px-3 py-2 rounded-pill border">
                        <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i> Other Days
                    </span>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty timetable}">
                    <c:set var="currentDay" value="" />
                    <c:set var="firstDay" value="true" />
                    
                    <c:forEach var="entry" items="${timetable}">
                        <c:if test="${entry.dayOfWeek != currentDay}">
                            <%-- Close previous day if not first --%>
                            <c:if test="${not firstDay}">
                                </tbody></table></div></div>
                            </c:if>
                            
                            <c:set var="currentDay" value="${entry.dayOfWeek}" />
                            <c:set var="firstDay" value="false" />
                            
                            <%-- Start new day section --%>
                            <div class="day-section">
                                <c:choose>
                                    <c:when test="${entry.dayOfWeek == today}">
                                        <div class="day-header today">
                                            <span><i class="fas fa-star me-2"></i><c:out value="${entry.dayOfWeek}" /></span>
                                            <span class="day-badge">Today</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="day-header other">
                                            <span><i class="far fa-calendar me-2"></i><c:out value="${entry.dayOfWeek}" /></span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="table-responsive-custom">
                                    <table class="timetable-table">
                                        <thead>
                                            <tr>
                                                <th class="col-subject">Subject Name</th>
                                                <th class="col-time">Time Duration</th>
                                                <th class="col-faculty">Faculty Name</th>
                                                <th class="col-room">Room Number</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                        </c:if>
                        
                        <%-- Class row --%>
                        <tr>
                            <td class="col-subject"><c:out value="${entry.subjectName}" /></td>
                            <td class="col-time">
                                <i class="far fa-clock time-icon"></i>
                                <c:set var="startTimeStr" value="${fn:substring(entry.startTime, 0, 5)}" />
                                <c:set var="endTimeStr" value="${fn:substring(entry.endTime, 0, 5)}" />
                                <c:out value="${startTimeStr}" /> - <c:out value="${endTimeStr}" />
                            </td>
                            <td class="col-faculty">
                                <span class="faculty-chip">
                                    <i class="fas fa-user-tie"></i>
                                    <c:out value="${entry.facultyName}" />
                                </span>
                            </td>
                            <td class="col-room">
                                <span class="room-chip">
                                    <i class="fas fa-door-open"></i>
                                    <c:out value="${entry.roomNumber}" />
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <%-- Close last day --%>
                    <c:if test="${not empty currentDay}">
                        </tbody></table></div></div>
                    </c:if>
                </c:when>
                
                <c:otherwise>
                    <div class="glass-card text-center py-5" style="border-radius: 20px;">
                        <i class="fas fa-calendar-times fa-4x text-muted opacity-25 mb-3"></i>
                        <h4 class="fw-bold text-muted mb-2">No Timetable Available</h4>
                        <p class="text-muted mb-0">Your weekly schedule has not been published yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>