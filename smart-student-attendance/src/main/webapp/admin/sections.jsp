<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Manage Sections" scope="request" />
<%@ include file="adminHead.jsp" %>

<!-- Add SweetAlert2 for modern dialogs -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="app-wrapper">
    <%@ include file="adminSidebar.jsp" %>
    <div class="main-content">
        <%@ include file="adminNavbar.jsp" %>

        <div class="content-area">
            
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

            <!-- Hero Section -->
            <div class="hero-section">
                <div class="hero-content">
                    <div class="hero-icon"><i class="fas fa-layer-group"></i></div>
                    <div class="hero-text">
                        <h1>Sections</h1>
                        <p>Manage academic sections, assign departments and class advisors.</p>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="kpi-grid" style="margin-bottom: 1.5rem;">
                <div class="kpi-card blue">
                    <div class="kpi-icon"><i class="fas fa-layer-group"></i></div>
                    <div class="kpi-label">Total Sections</div>
                    <div class="kpi-value">${fn:length(sections)}</div>
                    <div class="kpi-sublabel">Active sections</div>
                </div>
                <div class="kpi-card green">
                    <div class="kpi-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="kpi-label">Active</div>
                    <div class="kpi-value">
                        <c:set var="activeCount" value="0" />
                        <c:forEach var="sec" items="${sections}">
                            <c:if test="${sec.isActive}">
                                <c:set var="activeCount" value="${activeCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </div>
                    <div class="kpi-sublabel">Currently active</div>
                </div>
            </div>

			<!-- Sections Table -->
			<div class="glass-card">
			    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-3">
			        <h3 class="fw-bold mb-0">
			            <i class="fas fa-list me-2" style="color: var(--primary-blue);"></i>All Sections
			        </h3>
			        <form method="GET" action="${pageContext.request.contextPath}/admin/sections" class="d-flex gap-2 flex-wrap align-items-center">
			            <!-- ✅ Department Filter -->
			            <select name="department" class="form-control-custom" style="width: 220px;" onchange="this.form.submit()">						
						    <option value="all"
						        <c:if test="${empty deptFilter or deptFilter eq 'all'}">selected</c:if>>
						        All Departments
						    </option>
						    <c:forEach var="dept" items="${departments}">
						        <option value="${dept.departmentId}"
						            <c:if test="${deptFilter eq dept.departmentId.toString()}">selected</c:if>>
						            <c:out value="${dept.departmentName}" />
						        </option>
						    </c:forEach>
						</select>
			            
			            <!-- Search Box -->
			            <div class="search-box" style="position: relative;">
			                <input type="text" id="searchInput" class="form-control-custom" 
			                       placeholder="Search by ID or name..." 
			                       style="width: 250px; padding-left: 40px;">
			                <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
			            </div>
			            
			            <button type="button" class="btn-primary-custom" onclick="openAddModal()">
			                <i class="fas fa-plus"></i> Add Section
			            </button>
			        </form>
			    </div>
			
			    <c:choose>
			        <c:when test="${not empty sections}">
			            <div class="table-responsive">
			                <table class="data-table" id="sectionsTable">
			                    <thead>
			                        <tr>
			                            <th style="width: 60px;">ID</th>
			                            <th style="min-width: 150px;">Section Name</th>
			                            <th style="min-width: 180px;">Department</th>
			                            <th style="min-width: 100px;">Semester</th>
			                            <th style="min-width: 120px;">Batch</th>
			                            <th style="min-width: 180px;">Class Advisor</th>
			                            <th style="min-width: 120px;">Status</th>
			                            <th style="min-width: 180px;">Actions</th>
			                        </tr>
			                    </thead>
			                    <tbody>
			                        <c:forEach var="section" items="${sections}" varStatus="status">
			                            <tr data-section-id="${section.sectionId}" 
			                                data-section-name="${section.sectionName}"
			                                data-dept-id="${section.departmentId}">
			                                <td><span class="badge-custom badge-info">#${section.sectionId}</span></td>
			                                <td class="fw-semibold text-truncate" style="max-width: 180px;" title="<c:out value='${section.sectionName}' />">
			                                    <c:out value="${section.sectionName}" />
			                                </td>
			                                <td class="text-truncate" style="max-width: 200px;" title="<c:out value='${section.departmentName}' />">
			                                    <c:out value="${section.departmentName}" default="—" />
			                                </td>
			                                <td><span class="badge-custom badge-success">Sem <c:out value="${section.semester}" /></span></td>
			                                <td class="text-truncate" style="max-width: 120px;" title="<c:out value='${section.batch}' />">
			                                    <c:out value="${section.batch}" />
			                                </td>
											<td class="text-truncate" style="max-width: 200px;">
											    <c:out value="${section.advisorName}" default="—" />
											</td>
			                                <td>
			                                    <c:choose>
			                                        <c:when test="${section.isActive}">
			                                            <span class="badge-custom badge-success">
			                                                <i class="fas fa-check-circle"></i> Active
			                                            </span>
			                                        </c:when>
			                                        <c:otherwise>
			                                            <span class="badge-custom badge-danger">
			                                                <i class="fas fa-times-circle"></i> Inactive
			                                            </span>
			                                        </c:otherwise>
			                                    </c:choose>
			                                </td>
			                                <td>
			                                    <div class="d-flex gap-2">
			                                        <button class="btn-action btn-edit" 
			                                                onclick="openEditModal(${section.sectionId}, '${section.sectionName}', ${section.departmentId}, ${section.semester}, '${section.batch}', ${section.classAdvisorId != null ? section.classAdvisorId : 'null'}, ${section.isActive})"
			                                                style="white-space: nowrap;">
			                                            <i class="fas fa-edit"></i> Edit
			                                        </button>
			                                        <button class="btn-action btn-delete" 
			                                                onclick="confirmDelete(${section.sectionId}, '${section.sectionName}')"
			                                                style="white-space: nowrap;">
			                                            <i class="fas fa-trash-alt"></i> Delete
			                                        </button>
			                                    </div>
			                                </td>
			                            </tr>
			                        </c:forEach>
			                    </tbody>
			                </table>
			            </div>
			        </c:when>
			        <c:otherwise>
			            <div class="text-center py-5">
			                <div style="width: 80px; height: 80px; margin: 0 auto 1rem; background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: #10b981;">
			                    <i class="fas fa-layer-group"></i>
			                </div>
			                <h4 class="fw-bold mb-2">No Sections Found</h4>
			                <p class="text-muted mb-0">
			                    <c:choose>
			                        <c:when test="${not empty deptFilter && deptFilter != 'all'}">
			                            No sections found for the selected department.
			                        </c:when>
			                        <c:otherwise>
			                            Click "Add Section" to create your first section.
			                        </c:otherwise>
			                    </c:choose>
			                </p>
			            </div>
			        </c:otherwise>
			    </c:choose>
			</div>
        </div>
        
        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<!-- Add Section Modal -->
<div class="modal fade modal-custom" id="addSectionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add New Section</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addSectionForm" method="POST" action="${pageContext.request.contextPath}/admin/sections">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Section Name *</label>
                            <input type="text" name="sectionName" id="addSectionName" class="form-control-custom" required placeholder="e.g., Phoenix, Alpha">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Department *</label>
                            <select name="departmentId" id="addSectionDept" class="form-control-custom" required>
							    <option value="">Select Department</option>
							    <c:forEach var="dept" items="${departments}">
							        <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
							    </c:forEach>
							</select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Semester *</label>
                            <select name="semester" id="addSectionSemester" class="form-control-custom" required>
                                <c:forEach var="i" begin="1" end="8">
                                    <option value="${i}">Semester ${i}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Batch *</label>
                            <input type="text" name="batch" id="addSectionBatch" class="form-control-custom" required placeholder="e.g., 2024-2028">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Class Advisor</label>
                            <select name="classAdvisorId" id="addSectionAdvisor" class="form-control-custom">
                                <option value="">None</option>
                                <c:forEach var="faculty" items="${allFaculty}">
                                    <option value="${faculty.facultyId}"><c:out value="${faculty.fullName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Save Section</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Section Modal -->
<div class="modal fade modal-custom" id="editSectionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Section</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editSectionForm" method="POST" action="${pageContext.request.contextPath}/admin/sections">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="sectionId" id="editSectionId">
                <input type="hidden" name="isActive" id="editSectionIsActive" value="1">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Section Name *</label>
                            <input type="text" name="sectionName" id="editSectionName" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Department *</label>
                            <select name="departmentId" id="editSectionDept" class="form-control-custom" required>
							    <option value="">Select Department</option>
							    <c:forEach var="dept" items="${departments}">
							        <option value="${dept.departmentId}"><c:out value="${dept.departmentName}" /></option>
							    </c:forEach>
							</select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Semester *</label>
                            <select name="semester" id="editSectionSemester" class="form-control-custom" required>
                                <c:forEach var="i" begin="1" end="8">
                                    <option value="${i}">Semester ${i}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Batch *</label>
                            <input type="text" name="batch" id="editSectionBatch" class="form-control-custom" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label-custom">Class Advisor</label>
                            <select name="classAdvisorId" id="editSectionAdvisor" class="form-control-custom">
                                <option value="">None</option>
                                <c:forEach var="faculty" items="${allFaculty}">
                                    <option value="${faculty.facultyId}"><c:out value="${faculty.fullName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="editSectionActive" checked>
                                <label class="form-check-label" for="editSectionActive">
                                    <strong>Section is active</strong>
                                </label>
                            </div>
                            <small class="text-muted">Inactive sections won't appear in dropdowns</small>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Update Section</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openAddModal() {
        document.getElementById('addSectionForm').reset();
        new bootstrap.Modal(document.getElementById('addSectionModal')).show();
    }
    
    function openEditModal(id, name, deptId, semester, batch, advisorId, isActive) {
        document.getElementById('editSectionId').value = id;
        document.getElementById('editSectionName').value = name;
        document.getElementById('editSectionDept').value = deptId;
        document.getElementById('editSectionSemester').value = semester;
        document.getElementById('editSectionBatch').value = batch;
        
        // Set advisor
        const advisorSelect = document.getElementById('editSectionAdvisor');
        if (advisorId !== null && advisorId !== 'null') {
            advisorSelect.value = advisorId;
        } else {
            advisorSelect.value = '';
        }
        
        // ✅ Set active status from database
        const activeCheckbox = document.getElementById('editSectionActive');
        const activeHidden = document.getElementById('editSectionIsActive');
        const isActiveBool = (isActive === true || isActive === 'true' || isActive === 1);
        activeCheckbox.checked = isActiveBool;
        activeHidden.value = isActiveBool ? '1' : '0';
        
        // Update hidden field when checkbox changes
        activeCheckbox.onchange = function() {
            activeHidden.value = this.checked ? '1' : '0';
        };
        
        new bootstrap.Modal(document.getElementById('editSectionModal')).show();
    }
    
    function confirmDelete(id, name) {
        Swal.fire({
            title: '<i class="fas fa-exclamation-triangle" style="color: #f59e0b; font-size: 3rem;"></i>',
            html: '<h3 class="mb-2">Delete Section?</h3>' +
                  '<p class="text-muted mb-3">Are you sure you want to delete <strong style="color: #1f2937;">' + name + '</strong>?</p>' +
                  '<div class="alert alert-danger" style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 8px; padding: 12px;">' +
                  '<i class="fas fa-info-circle" style="color: #ef4444;"></i> ' +
                  '<span style="color: #991b1b; font-weight: 500;">This action cannot be undone!</span>' +
                  '</div>',
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-trash-alt"></i> Yes, Delete',
            cancelButtonText: '<i class="fas fa-times"></i> Cancel',
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#6b7280',
            reverseButtons: true,
            focusConfirm: false
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Deleting...',
                    allowOutsideClick: false,
                    didOpen: () => { Swal.showLoading(); }
                });
                
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/sections';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'sectionId';
                idInput.value = id;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    }
    
    // Search functionality
    document.getElementById('searchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#sectionsTable tbody tr');
        
        rows.forEach(row => {
            const sectionId = row.getAttribute('data-section-id');
            const sectionName = row.getAttribute('data-section-name').toLowerCase();
            
            if (sectionId.includes(searchTerm) || sectionName.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });
    
    // Form submission with loading state
    document.getElementById('addSectionForm').addEventListener('submit', function(e) {
        const submitBtn = this.querySelector('button[type="submit"]');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        submitBtn.disabled = true;
    });
    
    document.getElementById('editSectionForm').addEventListener('submit', function(e) {
        const submitBtn = this.querySelector('button[type="submit"]');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
        submitBtn.disabled = true;
    });

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

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
</body>
</html>