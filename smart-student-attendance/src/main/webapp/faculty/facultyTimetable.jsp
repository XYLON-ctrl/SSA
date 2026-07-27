<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="My Timetable" scope="request" />
<%@ include file="facultyHead.jsp" %>

<style>
    .day-section { background: white; border-radius: 16px; border: 1px solid var(--card-border); box-shadow: var(--shadow); margin-bottom: 2rem; overflow: hidden; transition: all 0.3s ease; }
    .day-section.today { border: 2px solid var(--primary-blue); box-shadow: 0 0 20px rgba(37, 99, 235, 0.15); transform: scale(1.01); }
    .day-header { padding: 1.25rem 1.5rem; font-weight: 700; font-size: 1.1rem; display: flex; align-items: center; justify-content: space-between; border-bottom: 2px solid #f1f5f9; background: white; color: var(--text-dark); }
    .day-section.today .day-header { background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); color: var(--primary-blue); border-bottom-color: var(--primary-blue); }
    .today-badge { background: var(--primary-blue); color: white; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
    .table-responsive-custom { overflow-x: auto; }
    .timetable-table { width: 100%; margin-bottom: 0; }
    .timetable-table thead th { background: #f8fafc; color: var(--text-muted); font-weight: 600; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; padding: 1rem 1.25rem; border-bottom: 2px solid #e2e8f0; }
    .timetable-table tbody tr { border-bottom: 1px solid #f1f5f9; transition: all 0.2s ease; }
    .timetable-table tbody tr:hover { background: #f8fafc; }
    .timetable-table tbody td { padding: 1.25rem; vertical-align: middle; }
    .col-subject { font-weight: 600; color: var(--text-dark); min-width: 200px; }
    .col-time { color: var(--text-muted); white-space: nowrap; min-width: 150px; }
    .col-section { min-width: 150px; }
    .col-room { min-width: 120px; text-align: center; }
    .section-chip { display: inline-flex; align-items: center; gap: 0.4rem; background: #fef3c7; color: #92400e; padding: 0.4rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 600; border: 1px solid #fde68a; }
    .room-chip { display: inline-flex; align-items: center; gap: 0.4rem; background: #eff6ff; color: var(--primary-blue); padding: 0.4rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 600; border: 1px solid #dbeafe; }
    .time-icon { color: var(--primary-blue); margin-right: 0.4rem; }
</style>

<div class="app-wrapper">
    <%@ include file="facultySidebar.jsp" %>
    <div class="main-content">
        <%@ include file="facultyNavbar.jsp" %>
        <div class="content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <div>
                    <h2 class="page-title mb-1"><i class="fas fa-calendar-alt text-primary me-2"></i>My Teaching Schedule</h2>
                    <p class="page-subtitle mb-0">Your weekly class timetable.</p>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty timetable}">
                    <%-- Get current day of week --%>
                    <c:set var="currentDayOfWeek" value="<%= java.time.LocalDate.now().getDayOfWeek().toString() %>" />
                    
                    <c:set var="currentDay" value="" />
                    <c:set var="firstDay" value="true" />
                    
                    <c:forEach var="entry" items="${timetable}">
                        <c:if test="${entry.dayOfWeek != currentDay}">
                            <c:if test="${not firstDay}">
                                </tbody></table></div></div>
                            </c:if>
                            
                            <c:set var="currentDay" value="${entry.dayOfWeek}" />
                            <c:set var="firstDay" value="false" />
                            
                            <%-- Check if this is today --%>
                            <c:set var="isToday" value="${currentDay == currentDayOfWeek}" />
                            
                            <div class="day-section ${isToday ? 'today' : ''}">
                                <div class="day-header">
                                    <span><i class="far fa-calendar me-2"></i><c:out value="${entry.dayOfWeek}" /></span>
                                    <c:if test="${isToday}">
                                        <span class="today-badge"><i class="fas fa-star me-1"></i>Today</span>
                                    </c:if>
                                </div>
                                
                                <div class="table-responsive-custom">
                                    <table class="timetable-table">
                                        <thead>
                                            <tr>
                                                <th class="col-subject">Subject Name</th>
                                                <th class="col-time">Time Duration</th>
                                                <th class="col-section">Section</th>
                                                <th class="col-room">Room Number</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                        </c:if>
                        
                        <tr>
                            <td class="col-subject"><c:out value="${entry.subjectName}" /></td>
                            <td class="col-time">
                                <i class="far fa-clock time-icon"></i>
                                <c:set var="startTimeStr" value="${fn:substring(entry.startTime, 0, 5)}" />
                                <c:set var="endTimeStr" value="${fn:substring(entry.endTime, 0, 5)}" />
                                <c:out value="${startTimeStr}" /> - <c:out value="${endTimeStr}" />
                            </td>
                            <td class="col-section">
                                <span class="section-chip">
                                    <i class="fas fa-users"></i>
                                    <c:out value="${entry.sectionName}" />
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
                    
                    <c:if test="${not empty currentDay}">
                        </tbody></table></div></div>
                    </c:if>
                </c:when>
                
                <c:otherwise>
                    <div class="glass-card text-center py-5" style="border-radius: 20px;">
                        <i class="fas fa-calendar-times fa-4x text-muted opacity-25 mb-3"></i>
                        <h4 class="fw-bold text-muted mb-2">No Timetable Available</h4>
                        <p class="text-muted mb-0">Your teaching schedule has not been assigned yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>