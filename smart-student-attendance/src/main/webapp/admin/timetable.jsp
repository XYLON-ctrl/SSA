<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Manage Timetable" scope="request" />
<%@ include file="adminHead.jsp" %>

<style>
	.campus-swal-popup {
    border-radius: 20px;
    backdrop-filter: blur(20px);
}
</style>
<div class="app-wrapper">
    <%@ include file="adminSidebar.jsp" %>
    <div class="main-content">
        <%@ include file="adminNavbar.jsp" %>

        <div class="content-area">
            
            <!-- Alerts -->
            <% String successMessage = (String) session.getAttribute("successMessage");
			String errorMessage = (String) session.getAttribute("errorMessage");
			
			if(successMessage != null){
			%>			
				<div class="alert alert-success">
				    <%= successMessage %>
				</div>			
			<% session.removeAttribute("successMessage");
			}
			
			if(errorMessage != null){
			%>
				<div class="alert alert-danger">
				    <%= errorMessage %>
				</div>			
			<%
			session.removeAttribute("errorMessage");
			}
			%>
            
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

            <!-- Hero -->
            <div class="hero-section">
                <div class="hero-content">
                    <div class="hero-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="hero-text">
                        <h1>Timetable</h1>
                        <p>Manage class schedules, assign faculty and rooms.</p>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="glass-card mb-3">
			    <form method="GET"
			          action="${pageContext.request.contextPath}/admin/timetable"
			          class="row g-3">
			
			        <!-- Section -->
			        <div class="col-md-4">
			            <label class="form-label-custom">Filter by Section</label>
			
			            <select name="section"
			                    class="form-control-custom"
			                    onchange="this.form.submit()">
			
			                <option value="">All Sections</option>
			
			                <c:forEach var="sec" items="${sections}">
			                    <option value="${sec.sectionId}"
			                        ${sectionFilter == sec.sectionId ? 'selected' : ''}>
			                        ${sec.sectionName}
			                    </option>
			                </c:forEach>
			
			            </select>
			        </div>
			
			        <!-- Faculty -->
			        <div class="col-md-4">
			            <label class="form-label-custom">Filter by Faculty</label>
			
			            <select name="faculty"
			                    class="form-control-custom"
			                    onchange="this.form.submit()">
			
			                <option value="">All Faculty</option>
			
			                <c:forEach var="fac" items="${allFaculty}">
			                    <option value="${fac.facultyId}"
			                        ${facultyFilter == fac.facultyId ? 'selected' : ''}>
			                        ${fac.fullName}
			                    </option>
			                </c:forEach>
			
			            </select>
			        </div>
			
			        <!-- Day -->
			        <div class="col-md-4">
			            <label class="form-label-custom">Filter by Day</label>
			
			            <select name="day"
			                    class="form-control-custom"
			                    onchange="this.form.submit()">
			
			                <option value="">All Days</option>
			
			                <option value="MONDAY"
			                    ${dayFilter == 'MONDAY' ? 'selected' : ''}>
			                    Monday
			                </option>
			
			                <option value="TUESDAY"
			                    ${dayFilter == 'TUESDAY' ? 'selected' : ''}>
			                    Tuesday
			                </option>
			
			                <option value="WEDNESDAY"
			                    ${dayFilter == 'WEDNESDAY' ? 'selected' : ''}>
			                    Wednesday
			                </option>
			
			                <option value="THURSDAY"
			                    ${dayFilter == 'THURSDAY' ? 'selected' : ''}>
			                    Thursday
			                </option>
			
			                <option value="FRIDAY"
			                    ${dayFilter == 'FRIDAY' ? 'selected' : ''}>
			                    Friday
			                </option>
			
			                <option value="SATURDAY"
			                    ${dayFilter == 'SATURDAY' ? 'selected' : ''}>
			                    Saturday
			                </option>
			
			            </select>
			        </div>
			
			    </form>
			</div>

            <!-- Timetable Table -->
            <div class="glass-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="fw-bold mb-0">
                        <i class="fas fa-list me-2" style="color: var(--primary-blue);"></i>All Timetable Entries
                    </h3>
                    <button class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addTimetableModal">
                        <i class="fas fa-plus"></i> Add Entry
                    </button>
                </div>

                <c:choose>
                    <c:when test="${not empty entries}">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Subject</th>
                                        <th>Faculty</th>
                                        <th>Section</th>
                                        <th>Day</th>
                                        <th>Time</th>
                                        <th>Room</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="count" value="0" />
                                    <c:forEach var="entry" items="${entries}">
                                        <c:if test="${(empty sectionFilter || entry.sectionId == sectionFilter) &&
											    (empty facultyFilter || entry.facultyId == facultyFilter) &&
											    (empty dayFilter || entry.dayOfWeek == dayFilter)
											}">
                                            <c:set var="count" value="${count + 1}" />
                                            <tr>
                                                <td>${count}</td>
                                                <td class="fw-semibold"><c:out value="${entry.subjectName}" /></td>
                                                <td><c:out value="${entry.facultyName}" default="—" /></td>
                                                <td><span class="badge-custom badge-info"><c:out value="${entry.sectionName}" /></span></td>
                                                <td><span class="badge-custom badge-warning"><c:out value="${entry.dayOfWeek}" /></span></td>
                                                <td>
                                                    <div style="font-size: 0.85rem;">
                                                        <c:set var="s" value="${fn:substring(entry.startTime, 0, 5)}" />
                                                        <c:set var="e" value="${fn:substring(entry.endTime, 0, 5)}" />
                                                        <i class="far fa-clock me-1" style="color: var(--primary-blue);"></i>
                                                        <c:out value="${s}" /> - <c:out value="${e}" />
                                                    </div>
                                                </td>
                                                <td><c:out value="${fn:escapeXml(entry.roomNumber)}" /></td>
                                                <td>
                                                    <button class="btn-action btn-edit" 
                                                            onclick="editTimetable(${entry.timetableId}, '${entry.subjectId}', '${entry.facultyId}', '${entry.sectionId}', '${entry.dayOfWeek}', '${fn:substring(entry.startTime, 0, 5)}', '${fn:substring(entry.endTime, 0, 5)}', '${entry.roomNumber}')">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </button>
                                                    <form method="POST" action="${pageContext.request.contextPath}/admin/timetable" style="display: inline;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="timetableId" value="${entry.timetableId}">
                                                        <button type="button"
														        class="btn-action btn-delete"
														        onclick="confirmDelete(this)">
														    <i class="fas fa-trash"></i> Delete
														</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${count == 0}">
                                        <tr>
                                            <td colspan="8" class="text-center py-4 text-muted">
                                                <i class="fas fa-inbox me-2"></i>No entries found with selected filters
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <div style="width: 80px; height: 80px; margin: 0 auto 1rem; background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: #ef4444;">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <h4 class="fw-bold mb-2">No Timetable Entries</h4>
                            <p class="text-muted mb-0">Click "Add Entry" to create your first timetable entry.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<!-- Add Timetable Modal -->
<div class="modal fade modal-custom" id="addTimetableModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add Timetable Entry</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/timetable">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Subject *</label>
                            <select name="subjectId" class="form-control-custom" required>
                                <option value="">Select Subject</option>
                                <c:forEach var="sub" items="${subjects}">
                                    <option value="${sub.subjectId}"><c:out value="${sub.subjectName}" /> (<c:out value="${sub.subjectCode}" />)</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Faculty *</label>
                            <select name="facultyId" class="form-control-custom" required>
                                <option value="">Select Faculty</option>
                                <c:forEach var="f" items="${allFaculty}">
                                    <option value="${f.facultyId}"><c:out value="${f.fullName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Section *</label>
                            <select name="sectionId" class="form-control-custom" required>
                                <option value="">Select Section</option>
                                <c:forEach var="sec" items="${sections}">
                                    <option value="${sec.sectionId}"><c:out value="${sec.sectionName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Day of Week *</label>
                            <select name="dayOfWeek" class="form-control-custom" required>
                                <option value="MONDAY">Monday</option>
                                <option value="TUESDAY">Tuesday</option>
                                <option value="WEDNESDAY">Wednesday</option>
                                <option value="THURSDAY">Thursday</option>
                                <option value="FRIDAY">Friday</option>
                                <option value="SATURDAY">Saturday</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Start Time *</label>
                            <input type="time" name="startTime" class="form-control-custom" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">End Time *</label>
                            <input type="time" name="endTime" class="form-control-custom" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Room Number</label>
                            <input type="text" name="roomNumber" class="form-control-custom" placeholder="e.g., Room 101">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Save Entry</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Timetable Modal -->
<div class="modal fade modal-custom" id="editTimetableModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>
                    Edit Timetable Entry
                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"></button>
            </div>

            <form method="POST"
                  action="${pageContext.request.contextPath}/admin/timetable">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="timetableId" id="editTimetableId">

                <div class="modal-body">

                    <div class="row g-3">

                        <div class="col-md-6">
                            <label class="form-label-custom">Subject</label>

                            <select name="subjectId"
                                    id="editSubjectId"
                                    class="form-control-custom"
                                    required>

                                <c:forEach var="sub" items="${subjects}">
                                    <option value="${sub.subjectId}">
                                        ${sub.subjectName}
                                    </option>
                                </c:forEach>

                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Faculty</label>

                            <select name="facultyId"
                                    id="editFacultyId"
                                    class="form-control-custom"
                                    required>

                                <c:forEach var="f" items="${allFaculty}">
                                    <option value="${f.facultyId}">
                                        ${f.fullName}
                                    </option>
                                </c:forEach>

                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Section</label>

                            <select name="sectionId"
                                    id="editSectionId"
                                    class="form-control-custom"
                                    required>

                                <c:forEach var="sec" items="${sections}">
                                    <option value="${sec.sectionId}">
                                        ${sec.sectionName}
                                    </option>
                                </c:forEach>

                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Day</label>

                            <select name="dayOfWeek"
                                    id="editDay"
                                    class="form-control-custom">

                                <option value="MONDAY">Monday</option>
                                <option value="TUESDAY">Tuesday</option>
                                <option value="WEDNESDAY">Wednesday</option>
                                <option value="THURSDAY">Thursday</option>
                                <option value="FRIDAY">Friday</option>
                                <option value="SATURDAY">Saturday</option>

                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-custom">Start Time</label>

                            <input type="time"
                                   name="startTime"
                                   id="editStartTime"
                                   class="form-control-custom"
                                   required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-custom">End Time</label>

                            <input type="time"
                                   name="endTime"
                                   id="editEndTime"
                                   class="form-control-custom"
                                   required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-custom">Room</label>

                            <input type="text"
                                   name="roomNumber"
                                   id="editRoom"
                                   class="form-control-custom">
                        </div>

                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button"
                            class="btn btn-light"
                            data-bs-dismiss="modal">
                        Cancel
                    </button>

                    <button type="submit"
                            class="btn-primary-custom">
                        Update Entry
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>

function confirmDelete(button) {

    const form = button.closest("form");

    Swal.fire({
        title: 'Delete Timetable Entry?',
        html: `
            <div style="font-size:14px">
                This timetable entry will be permanently removed.
            </div>
        `,
        icon: 'warning',

        showCancelButton: true,

        confirmButtonText: '<i class="fas fa-trash"></i> Delete',
        cancelButtonText: '<i class="fas fa-times"></i> Cancel',

        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',

        customClass: {
            popup: 'campus-swal-popup'
        }

    }).then((result) => {

        if (result.isConfirmed) {
            form.submit();
        }

    });
}

function editTimetable(
	    id,
	    subjectId,
	    facultyId,
	    sectionId,
	    day,
	    startTime,
	    endTime,
	    room
	) {

	    document.getElementById("editTimetableId").value = id;

	    document.getElementById("editSubjectId").value = subjectId;

	    document.getElementById("editFacultyId").value = facultyId;

	    document.getElementById("editSectionId").value = sectionId;

	    document.getElementById("editDay").value = day;

	    document.getElementById("editStartTime").value = startTime;

	    document.getElementById("editEndTime").value = endTime;

	    document.getElementById("editRoom").value = room || "";

	    const modal =
	        new bootstrap.Modal(
	            document.getElementById("editTimetableModal")
	        );

	    modal.show();
	}

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