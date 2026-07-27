<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Manage Departments" scope="request" />
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
			        <i class="fas fa-exclamation-circle"></i> 
			        <strong>Validation Error:</strong> <c:out value="${errorMessage}" />
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
                    <div class="hero-icon"><i class="fas fa-building"></i></div>
                    <div class="hero-text">
                        <h1>Departments</h1>
                        <p>Add, edit, and manage academic departments.</p>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="kpi-grid" style="margin-bottom: 1.5rem;">
                <div class="kpi-card blue">
                    <div class="kpi-icon"><i class="fas fa-building"></i></div>
                    <div class="kpi-label">Total Departments</div>
                    <div class="kpi-value">${fn:length(departments)}</div>
                    <div class="kpi-sublabel">Active departments</div>
                </div>
                <div class="kpi-card green">
                    <div class="kpi-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="kpi-label">Active</div>
                    <div class="kpi-value">
                        <c:set var="activeCount" value="0" />
                        <c:forEach var="dept" items="${departments}">
                            <c:if test="${dept.active}">
                                <c:set var="activeCount" value="${activeCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </div>
                    <div class="kpi-sublabel">Currently active</div>
                </div>
            </div>

			<!-- Departments Table -->
			<div class="glass-card">
			    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-3">
			        <h3 class="fw-bold mb-0">
			            <i class="fas fa-list me-2" style="color: var(--primary-blue);"></i>All Departments
			        </h3>
			        <div class="d-flex gap-2 flex-wrap align-items-center">
			            <!-- Status Filter -->
			            <select id="statusFilter" class="form-control-custom" style="width: 150px;" onchange="filterByStatus()">
			                <option value="all">All Status</option>
			                <option value="active">Active</option>
			                <option value="inactive">Inactive</option>
			            </select>
			            
			            <!-- Search Box -->
			            <div class="search-box" style="position: relative;">
			                <input type="text" id="searchInput" class="form-control-custom" 
			                       placeholder="Search by ID or name..." 
			                       style="width: 250px; padding-left: 40px;">
			                <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
			            </div>
			            
			            <button class="btn-primary-custom" onclick="openAddModal()">
			                <i class="fas fa-plus"></i> Add Department
			            </button>
			        </div>
			    </div>
			
			    <c:choose>
			        <c:when test="${not empty departments}">
			            <div class="table-responsive">
			                <table class="data-table" id="departmentsTable">
			                    <thead>
			                        <tr>
			                            <th style="width: 60px;">ID</th>
			                            <th style="min-width: 180px;">Department Name</th>
			                            <th style="min-width: 100px;">Code</th>
			                            <th style="min-width: 180px;">Head of Department</th>
			                            <th style="min-width: 220px;">Contact Email</th>
			                            <th style="min-width: 120px;">Status</th>
			                            <th style="min-width: 180px;">Actions</th>
			                        </tr>
			                    </thead>
			                    <tbody>
			                        <c:forEach var="dept" items="${departments}" varStatus="status">
			                            <tr data-dept-id="${dept.departmentId}" 
			                                data-dept-name="${dept.departmentName}" 
			                                data-dept-status="${dept.active ? 'active' : 'inactive'}">
			                                <td><span class="badge-custom badge-info">#${dept.departmentId}</span></td>
			                                <td class="fw-semibold text-truncate" style="max-width: 200px;" title="<c:out value='${dept.departmentName}' />">
			                                    <c:out value="${dept.departmentName}" />
			                                </td>
			                                <td><span class="badge-custom badge-warning"><c:out value="${dept.departmentCode}" /></span></td>
			                                <td class="text-truncate" style="max-width: 200px;" title="<c:out value='${dept.headOfDepartment}' />">
			                                    <c:out value="${dept.headOfDepartment}" default="—" />
			                                </td>
			                                <td class="text-truncate" style="max-width: 240px;" title="<c:out value='${dept.contactEmail}' />">
			                                    <c:out value="${dept.contactEmail}" default="—" />
			                                </td>
			                                <td>
			                                    <c:choose>
			                                        <c:when test="${dept.active}">
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
			                                                onclick="openEditModal(${dept.departmentId}, '${dept.departmentName}', '${dept.departmentCode}', '${dept.headOfDepartment != null ? dept.headOfDepartment : ""}', '${dept.contactEmail != null ? dept.contactEmail : ""}', '${dept.contactPhone != null ? dept.contactPhone : ""}', ${dept.active})"
			                                                style="white-space: nowrap;">
			                                            <i class="fas fa-edit"></i> Edit
			                                        </button>
			                                        <button class="btn-action btn-delete" 
			                                                onclick="confirmDelete(${dept.departmentId}, '${dept.departmentName}')"
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
			                <div style="width: 80px; height: 80px; margin: 0 auto 1rem; background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: #3b82f6;">
			                    <i class="fas fa-building"></i>
			                </div>
			                <h4 class="fw-bold mb-2">No Departments Found</h4>
			                <p class="text-muted mb-0">Click "Add Department" to create your first department.</p>
			            </div>
			        </c:otherwise>
			    </c:choose>
			</div>
        </div>

        <footer class="footer">&copy; 2026 University. All rights reserved.</footer>
    </div>
</div>

<!-- Add Department Modal -->
<div class="modal fade modal-custom" id="addDepartmentModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add New Department</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addDepartmentForm" method="POST" action="${pageContext.request.contextPath}/admin/departments">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Department Name *</label>
                            <input type="text" name="departmentName" id="addDeptName" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Department Code *</label>
                            <input type="text" name="departmentCode" id="addDeptCode" class="form-control-custom" required placeholder="e.g., CS, MATH">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Head of Department</label>
                            <input type="text" name="headOfDepartment" id="addDeptHod" class="form-control-custom">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Contact Email</label>
                            <input type="email" name="contactEmail" id="addDeptEmail" class="form-control-custom">
                        </div>
                        <div class="col-md-12">
                            <label class="form-label-custom">Contact Phone</label>
                            <input type="text" name="contactPhone" id="addDeptPhone" class="form-control-custom">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Save Department</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Department Modal -->
<div class="modal fade modal-custom" id="editDepartmentModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Department</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editDepartmentForm" method="POST" action="${pageContext.request.contextPath}/admin/departments">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="departmentId" id="editDeptId">
                <!-- ✅ FIX: Preserve is_active status -->
                <input type="hidden" name="isActive" id="editDeptIsActive" value="1">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Department Name *</label>
                            <input type="text" name="departmentName" id="editDeptName" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Department Code *</label>
                            <input type="text" name="departmentCode" id="editDeptCode" class="form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Head of Department</label>
                            <input type="text" name="headOfDepartment" id="editDeptHod" class="form-control-custom">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Contact Email</label>
                            <input type="email" name="contactEmail" id="editDeptEmail" class="form-control-custom">
                        </div>
                        <div class="col-md-12">
                            <label class="form-label-custom">Contact Phone</label>
                            <input type="text" name="contactPhone" id="editDeptPhone" class="form-control-custom">
                        </div>
                        <div class="col-md-12">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="editDeptActive" checked>
                                <label class="form-check-label" for="editDeptActive">
                                    <strong>Department is active</strong>
                                </label>
                            </div>
                            <small class="text-muted">Inactive departments won't appear in dropdowns</small>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-primary-custom"><i class="fas fa-save"></i> Update Department</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ✅ Open Add Modal
    function openAddModal() {
        document.getElementById('addDepartmentForm').reset();
        new bootstrap.Modal(document.getElementById('addDepartmentModal')).show();
    }
	
	 // ✅ Client-side validation before form submission
	 function validateDepartmentForm(formId) {
	     const form = document.getElementById(formId);
	     const deptName = form.querySelector('[name="departmentName"]').value.trim();
	     const deptCode = form.querySelector('[name="departmentCode"]').value.trim();
	     const hod = form.querySelector('[name="headOfDepartment"]').value.trim();
	     const email = form.querySelector('[name="contactEmail"]').value.trim();
	     
	     // Basic validation
	     if (!deptName) {
	         showError('Department name is required');
	         return false;
	     }
	     if (!deptCode) {
	         showError('Department code is required');
	         return false;
	     }
	     
	     // Email format validation
	     if (email && !isValidEmail(email)) {
	         showError('Please enter a valid email address');
	         return false;
	     }
	     
	     return true;
	 }
	
	 function isValidEmail(email) {
	     const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	     return re.test(email);
	 }
	
	 function showError(message) {
	     Swal.fire({
	         icon: 'warning',
	         title: 'Validation Error',
	         text: message,
	         confirmButtonColor: '#667eea'
	     });
	 }
	
	 // Update form submission handlers
	 document.getElementById('addDepartmentForm').addEventListener('submit', function(e) {
	     if (!validateDepartmentForm('addDepartmentForm')) {
	         e.preventDefault();
	         return;
	     }
	     const submitBtn = this.querySelector('button[type="submit"]');
	     submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
	     submitBtn.disabled = true;
	 });
	
	 document.getElementById('editDepartmentForm').addEventListener('submit', function(e) {
	     if (!validateDepartmentForm('editDepartmentForm')) {
	         e.preventDefault();
	         return;
	     }
	     const submitBtn = this.querySelector('button[type="submit"]');
	     submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
	     submitBtn.disabled = true;
	 });
 
 // ✅ Filter by Status
    function filterByStatus() {
        const statusFilter = document.getElementById('statusFilter').value;
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('#departmentsTable tbody tr');
        
        rows.forEach(row => {
            const rowStatus = row.getAttribute('data-dept-status');
            const deptId = row.getAttribute('data-dept-id');
            const deptName = row.getAttribute('data-dept-name').toLowerCase();
            
            // Check if status matches
            const statusMatch = (statusFilter === 'all' || rowStatus === statusFilter);
            
            // Check if search term matches
            const searchMatch = (deptId.includes(searchTerm) || deptName.includes(searchTerm));
            
            // Show row if both conditions match
            if (statusMatch && searchMatch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // ✅ Search Functionality (updated to work with status filter)
    document.getElementById('searchInput').addEventListener('input', function(e) {
        filterByStatus(); // Reuse the filter function
    });
    
    // ✅ Open Edit Modal with proper data
    function openEditModal(id, name, code, hod, email, phone, isActive) {
        document.getElementById('editDeptId').value = id;
        document.getElementById('editDeptName').value = name;
        document.getElementById('editDeptCode').value = code;
        document.getElementById('editDeptHod').value = hod || '';
        document.getElementById('editDeptEmail').value = email || '';
        document.getElementById('editDeptPhone').value = phone || '';
        
        // ✅ Set active status
        const isActiveChecked = isActive === true || isActive === 'true' || isActive === 1;
        document.getElementById('editDeptActive').checked = isActiveChecked;
        document.getElementById('editDeptIsActive').value = isActiveChecked ? '1' : '0';
        
        // Update hidden field when checkbox changes
        document.getElementById('editDeptActive').onchange = function() {
            document.getElementById('editDeptIsActive').value = this.checked ? '1' : '0';
        };
        
        new bootstrap.Modal(document.getElementById('editDepartmentModal')).show();
    }
    
    // ✅ Professional Delete Confirmation
    function confirmDelete(id, name) {
        Swal.fire({
            title: '<i class="fas fa-exclamation-triangle" style="color: #f59e0b; font-size: 3rem;"></i>',
            html: '<h3 class="mb-2">Delete Department?</h3>' +
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
            focusConfirm: false,
            showClass: {
                popup: 'animate__animated animate__fadeInDown'
            },
            hideClass: {
                popup: 'animate__animated animate__fadeOutUp'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                // Show loading
                Swal.fire({
                    title: 'Deleting...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });
                
                // Create and submit delete form
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/departments';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'departmentId';
                idInput.value = id;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    }
    
    // ✅ Search Functionality
    document.getElementById('searchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#departmentsTable tbody tr');
        
        rows.forEach(row => {
            const deptId = row.getAttribute('data-dept-id');
            const deptName = row.getAttribute('data-dept-name').toLowerCase();
            
            if (deptId.includes(searchTerm) || deptName.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });
    
    // Form submission with loading state
    document.getElementById('addDepartmentForm').addEventListener('submit', function(e) {
        const submitBtn = this.querySelector('button[type="submit"]');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        submitBtn.disabled = true;
    });
    
    document.getElementById('editDepartmentForm').addEventListener('submit', function(e) {
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

<!-- Add Animate.css for smooth animations -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
</body>
</html>