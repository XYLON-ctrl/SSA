<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Set page title for the Navbar --%>
<c:set var="pageTitle" value="Leave Request" scope="request" />

<%@ include file="includes/studentHead.jsp" %>

<style>
    :root {
        --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --gradient-success: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --gradient-warning: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        --gradient-danger: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        --shadow-soft: 0 10px 40px rgba(0, 0, 0, 0.08);
        --shadow-hover: 0 20px 60px rgba(0, 0, 0, 0.12);
        --radius-lg: 16px;
        --radius-md: 12px;
        --radius-sm: 8px;
    }

    .leave-request-container {
        width: 100%;
        max-width: 1400px;
        margin: 0 auto;
        padding: 1.5rem;
    }

    /* Compact Hero Section */
    .hero-section {
        background: var(--gradient-primary);
        border-radius: var(--radius-lg);
        padding: 1.75rem 2rem;
        margin-bottom: 1.5rem;
        color: white;
        position: relative;
        overflow: hidden;
        box-shadow: var(--shadow-soft);
    }

    .hero-section::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -5%;
        width: 300px;
        height: 300px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
    }

    .hero-content {
        position: relative;
        z-index: 1;
        display: flex;
        align-items: center;
        gap: 1.25rem;
    }

    .hero-icon {
        width: 50px;
        height: 50px;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(10px);
        font-size: 1.5rem;
        flex-shrink: 0;
    }

    .hero-text h1 {
        font-size: 1.75rem;
        font-weight: 700;
        margin-bottom: 0.25rem;
        letter-spacing: -0.5px;
    }

    .hero-text p {
        font-size: 0.9rem;
        opacity: 0.95;
        margin: 0;
    }

    /* Compact Grid Layout */
    .content-grid {
        display: grid;
        grid-template-columns: 1.2fr 0.8fr;
        gap: 1.25rem;
    }

    @media (max-width: 1024px) {
        .content-grid {
            grid-template-columns: 1fr;
        }
    }

    /* Glass Cards - More Compact */
    .glass-card {
        background: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-soft);
        padding: 1.5rem;
        transition: all 0.3s ease;
        height: 100%;
    }

    .glass-card:hover {
        box-shadow: var(--shadow-hover);
    }

    .card-header-custom {
        display: flex;
        align-items: center;
        gap: 0.875rem;
        margin-bottom: 1.25rem;
        padding-bottom: 0.875rem;
        border-bottom: 2px solid #f0f0f0;
    }

    .card-icon {
        width: 40px;
        height: 40px;
        background: var(--gradient-primary);
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.1rem;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        flex-shrink: 0;
    }

    .card-title {
        font-size: 1.15rem;
        font-weight: 700;
        color: #1a202c;
        margin: 0;
    }

    .card-subtitle {
        font-size: 0.825rem;
        color: #718096;
        margin: 0.2rem 0 0 0;
    }

    /* Compact Form Styling */
    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
        margin-bottom: 1rem;
    }

    @media (max-width: 640px) {
        .form-row {
            grid-template-columns: 1fr;
        }
    }

    .form-group {
        margin-bottom: 1rem;
    }

    .form-label {
        display: block;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 0.4rem;
        font-size: 0.825rem;
        letter-spacing: 0.3px;
    }

    .form-control-custom {
        width: 100%;
        padding: 0.75rem 0.875rem;
        border: 2px solid #e2e8f0;
        border-radius: var(--radius-md);
        font-size: 0.9rem;
        transition: all 0.3s ease;
        background: #f8fafc;
    }

    .form-control-custom:focus {
        outline: none;
        border-color: #667eea;
        background: white;
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    }

    /* Compact Textarea */
    textarea.form-control-custom {
        min-height: 100px;
        max-height: 100px;
        resize: none;
        overflow-y: auto;
        font-family: inherit;
        line-height: 1.5;
    }

    .char-counter {
        text-align: right;
        font-size: 0.75rem;
        color: #718096;
        margin-top: 0.3rem;
        font-weight: 500;
    }

    /* Duration Alert */
    .duration-alert {
        border-radius: var(--radius-md);
        padding: 0.875rem 1rem;
        margin-bottom: 1rem;
        display: none;
        animation: slideIn 0.3s ease;
        font-size: 0.85rem;
    }

    .duration-alert.show {
        display: flex;
        align-items: center;
        gap: 0.625rem;
    }

    .duration-alert.success {
        background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
        color: #065f46;
        border: 1px solid #6ee7b7;
    }

    .duration-alert.error {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
        color: #991b1b;
        border: 1px solid #fca5a5;
    }

    .duration-alert.warning {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        color: #92400e;
        border: 1px solid #fcd34d;
    }

    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Compact Submit Button */
    .form-actions {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 0.75rem;
        margin-top: 1.25rem;
        padding-top: 1.25rem;
        border-top: 2px solid #f0f0f0;
    }

    .btn-submit {
        background: var(--gradient-primary);
        color: white;
        border: none;
        padding: 0.875rem 2rem;
        border-radius: 50px;
        font-size: 0.925rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        display: inline-flex;
        align-items: center;
        gap: 0.625rem;
        position: relative;
        overflow: hidden;
    }

    .btn-submit::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
        transition: left 0.5s ease;
    }

    .btn-submit:hover::before {
        left: 100%;
    }

    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 35px rgba(102, 126, 234, 0.5);
    }

    .btn-submit:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none;
    }

    /* Compact KPI Cards */
    .kpi-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 0.75rem;
        margin-bottom: 1rem;
    }

    .kpi-card {
        padding: 1rem;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.875rem;
        transition: all 0.3s ease;
        border: 2px solid transparent;
    }

    .kpi-card:hover {
        transform: translateX(3px);
    }

    .kpi-card.pending {
        background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
        border-left: 4px solid #f59e0b;
    }

    .kpi-card.approved {
        background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
        border-left: 4px solid #10b981;
    }

    .kpi-card.rejected {
        background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
        border-left: 4px solid #ef4444;
    }

    .kpi-info {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .kpi-icon {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1rem;
    }

    .kpi-card.pending .kpi-icon {
        background: #f59e0b;
        color: white;
    }

    .kpi-card.approved .kpi-icon {
        background: #10b981;
        color: white;
    }

    .kpi-card.rejected .kpi-icon {
        background: #ef4444;
        color: white;
    }

    .kpi-label {
        font-weight: 600;
        color: #2d3748;
        font-size: 0.875rem;
    }

    .kpi-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #2d3748;
    }

    .kpi-card.pending .kpi-value { color: #f59e0b; }
    .kpi-card.approved .kpi-value { color: #10b981; }
    .kpi-card.rejected .kpi-value { color: #ef4444; }

    /* Compact History Button */
    .btn-history {
        width: 100%;
        padding: 0.75rem;
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: var(--radius-md);
        color: #4a5568;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        text-decoration: none;
        font-size: 0.85rem;
    }

    .btn-history:hover {
        border-color: #667eea;
        color: #667eea;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
    }

    /* Compact Guidelines Panel */
    .guidelines-panel {
        background: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 100%);
        border-radius: var(--radius-lg);
        padding: 1.25rem;
        border: 2px solid rgba(102, 126, 234, 0.1);
    }

    .guidelines-header {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 1rem;
    }

    .guidelines-icon {
        width: 32px;
        height: 32px;
        background: var(--gradient-primary);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 0.9rem;
        flex-shrink: 0;
    }

    .guidelines-title {
        font-size: 1rem;
        font-weight: 700;
        color: #2d3748;
        margin: 0;
    }

    .guidelines-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .guidelines-item {
        display: flex;
        align-items: flex-start;
        gap: 0.75rem;
        padding: 0.75rem 0;
        border-bottom: 1px solid rgba(102, 126, 234, 0.1);
        transition: all 0.3s ease;
    }

    .guidelines-item:last-child {
        border-bottom: none;
        padding-bottom: 0;
    }

    .guidelines-item:first-child {
        padding-top: 0;
    }

    .guidelines-check {
        width: 20px;
        height: 20px;
        background: #10b981;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 0.7rem;
        flex-shrink: 0;
        margin-top: 0.1rem;
    }

    .guidelines-text {
        color: #4a5568;
        font-size: 0.85rem;
        line-height: 1.4;
        margin: 0;
    }

    /* Info Box */
    .info-box {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        border-radius: var(--radius-md);
        padding: 1rem;
        margin-bottom: 1rem;
        border-left: 4px solid #3b82f6;
    }

    .info-box-title {
        font-weight: 700;
        color: #1e40af;
        font-size: 0.875rem;
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .info-box-text {
        color: #1e3a8a;
        font-size: 0.825rem;
        line-height: 1.5;
        margin: 0;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .leave-request-container {
            padding: 1rem;
        }

        .hero-section {
            padding: 1.25rem;
        }

        .hero-content {
            flex-direction: column;
            text-align: center;
        }

        .hero-text h1 {
            font-size: 1.4rem;
        }

        .glass-card {
            padding: 1.25rem;
        }

        .card-title {
            font-size: 1.05rem;
        }

        .kpi-value {
            font-size: 1.3rem;
        }

        .form-actions {
            flex-direction: column;
        }

        .btn-submit {
            width: 100%;
            justify-content: center;
        }
    }

    /* Loading State */
    .btn-submit.loading {
        pointer-events: none;
        opacity: 0.8;
    }

    .btn-submit.loading i {
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    /* Alert Styling */
    .custom-alert {
        border-radius: var(--radius-md);
        border-left: 4px solid;
        padding: 0.875rem 1.125rem;
        margin-bottom: 1.25rem;
        animation: slideDown 0.3s ease;
        box-shadow: var(--shadow-soft);
        font-size: 0.9rem;
    }

    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .alert-error {
        background: linear-gradient(135deg, #fff5f5 0%, #fed7d7 100%);
        border-color: #f56565;
        color: #c53030;
    }

    .alert-success {
        background: linear-gradient(135deg, #f0fff4 0%, #c6f6d5 100%);
        border-color: #48bb78;
        color: #276749;
    }

    /* Validation Message */
    .validation-message {
        font-size: 0.775rem;
        color: #ef4444;
        margin-top: 0.3rem;
        display: none;
        font-weight: 500;
    }

    .validation-message.show {
        display: block;
        animation: shake 0.5s ease;
    }

    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }
</style>

<div class="app-wrapper">
    <%@ include file="includes/studentSidebar.jsp" %>

    <div class="main-content">
        <%@ include file="includes/studentNavbar.jsp" %>

        <div class="leave-request-container">
            
            <!-- Server Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="custom-alert alert-error">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="custom-alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    <c:out value="${successMessage}" />
                </div>
            </c:if>

            <!-- Compact Hero Section -->
            <div class="hero-section">
                <div class="hero-content">
                    <div class="hero-icon">
                        <i class="fas fa-paper-plane"></i>
                    </div>
                    <div class="hero-text">
                        <h1>Apply for Leave</h1>
                        <p>Submit your leave request. Maximum 30 days allowed per request.</p>
                    </div>
                </div>
            </div>

            <!-- Compact Content Grid -->
            <div class="content-grid">
                
                <!-- Left Column: Application Form -->
                <div class="glass-card">
                    <div class="card-header-custom">
                        <div class="card-icon">
                            <i class="fas fa-edit"></i>
                        </div>
                        <div>
                            <h2 class="card-title">Leave Application</h2>
                            <p class="card-subtitle">Fill in the details below</p>
                        </div>
                    </div>

                    <form id="leaveForm" action="${pageContext.request.contextPath}/student/leave/request" method="POST">
                        
                        <!-- Info Box -->
                        <div class="info-box">
                            <div class="info-box-title">
                                <i class="fas fa-info-circle"></i>
                                Important Information
                            </div>
                            <p class="info-box-text">
                                • Maximum leave duration: <strong>30 days</strong><br>
                                • Apply at least 2 days in advance<br>
                                • Medical certificate required for leaves > 3 days
                            </p>
                        </div>

                        <!-- Duration Alert -->
                        <div class="duration-alert" id="durationAlert">
                            <i class="fas fa-calendar-alt"></i>
                            <span id="durationText">0 days</span>
                        </div>

                        <!-- Date Fields -->
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="startDate">
                                    <i class="fas fa-calendar-day me-2"></i>Start Date
                                </label>
                                <input type="date" 
                                       class="form-control-custom" 
                                       id="startDate" 
                                       name="startDate" 
                                       required
                                       min="${todayDate}">
                                <div class="validation-message" id="startDateError">Please select a valid start date</div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="endDate">
                                    <i class="fas fa-calendar-check me-2"></i>End Date
                                </label>
                                <input type="date" 
                                       class="form-control-custom" 
                                       id="endDate" 
                                       name="endDate" 
                                       required
                                       min="${todayDate}">
                                <div class="validation-message" id="endDateError">End date cannot exceed 30 days from start date</div>
                            </div>
                        </div>

                        <!-- Reason Field -->
                        <div class="form-group">
                            <label class="form-label" for="reason">
                                <i class="fas fa-comment-alt me-2"></i>Reason for Leave
                            </label>
                            <textarea class="form-control-custom" 
                                      id="reason" 
                                      name="reason" 
                                      placeholder="Please provide a detailed reason..."
                                      maxlength="500"
                                      required
                                      oninput="updateCharCounter(this)"></textarea>
                            <div class="char-counter">
                                <span id="charCount">0</span>/500 characters
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="form-actions">
                            <button type="submit" class="btn-submit" id="submitBtn" disabled>
                                <i class="fas fa-paper-plane"></i>
                                <span>Submit Request</span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Right Column: Summary & Guidelines -->
                <div style="display: flex; flex-direction: column; gap: 1.25rem;">
                    <!-- Request Summary -->
                    <div class="glass-card">
                        <div class="card-header-custom">
                            <div class="card-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                <i class="fas fa-chart-pie"></i>
                            </div>
                            <div>
                                <h2 class="card-title">Summary</h2>
                                <p class="card-subtitle">Your leave statistics</p>
                            </div>
                        </div>

                        <div class="kpi-grid">
                            <div class="kpi-card pending">
                                <div class="kpi-info">
                                    <div class="kpi-icon">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div class="kpi-label">Pending</div>
                                </div>
                                <div class="kpi-value">${pendingCount}</div>
                            </div>

                            <div class="kpi-card approved">
                                <div class="kpi-info">
                                    <div class="kpi-icon">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="kpi-label">Approved</div>
                                </div>
                                <div class="kpi-value">${approvedCount}</div>
                            </div>

                            <div class="kpi-card rejected">
                                <div class="kpi-info">
                                    <div class="kpi-icon">
                                        <i class="fas fa-times"></i>
                                    </div>
                                    <div class="kpi-label">Rejected</div>
                                </div>
                                <div class="kpi-value">${rejectedCount}</div>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/student/leave/history" class="btn-history">
                            <span>View History</span>
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Leave Guidelines -->
                    <div class="guidelines-panel">
                        <div class="guidelines-header">
                            <div class="guidelines-icon">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <h3 class="guidelines-title">Guidelines</h3>
                        </div>

                        <ul class="guidelines-list">
                            <li class="guidelines-item">
                                <div class="guidelines-check">
                                    <i class="fas fa-check"></i>
                                </div>
                                <p class="guidelines-text">Apply at least 2 days in advance</p>
                            </li>
                            <li class="guidelines-item">
                                <div class="guidelines-check">
                                    <i class="fas fa-check"></i>
                                </div>
                                <p class="guidelines-text">Medical certificate for >3 days</p>
                            </li>
                            <li class="guidelines-item">
                                <div class="guidelines-check">
                                    <i class="fas fa-check"></i>
                                </div>
                                <p class="guidelines-text">Max 30 days per request</p>
                            </li>
                            <li class="guidelines-item">
                                <div class="guidelines-check">
                                    <i class="fas fa-check"></i>
                                </div>
                                <p class="guidelines-text">Attendance marked absent until approved</p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>

        <footer class="footer">
            &copy; <c:out value="${copyrightYear}" default="2026" /> <c:out value="${universityName}" default="University" />. All rights reserved.
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const MAX_LEAVE_DAYS = 30; // Maximum 30 days (approximately 1 month)

    // Character Counter
    function updateCharCounter(textarea) {
        const count = textarea.value.length;
        document.getElementById('charCount').textContent = count;
        
        if (count > 450) {
            document.getElementById('charCount').style.color = '#ef4444';
        } else if (count > 400) {
            document.getElementById('charCount').style.color = '#f59e0b';
        } else {
            document.getElementById('charCount').style.color = '#718096';
        }
    }

    // Calculate and Validate Duration
    function calculateDuration() {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        const alert = document.getElementById('durationAlert');
        const durationText = document.getElementById('durationText');
        const submitBtn = document.getElementById('submitBtn');
        const startDateError = document.getElementById('startDateError');
        const endDateError = document.getElementById('endDateError');

        // Reset errors
        startDateError.classList.remove('show');
        endDateError.classList.remove('show');
        alert.classList.remove('show', 'success', 'error', 'warning');

        if (startDate && endDate) {
            const start = new Date(startDate);
            const end = new Date(endDate);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            // Validate start date is not in the past
            if (start < today) {
                startDateError.textContent = 'Start date cannot be in the past';
                startDateError.classList.add('show');
                submitBtn.disabled = true;
                return;
            }

            // Validate end date is not before start date
            if (end < start) {
                endDateError.textContent = 'End date must be after start date';
                endDateError.classList.add('show');
                submitBtn.disabled = true;
                return;
            }

            // Calculate duration
            const diffTime = Math.abs(end - start);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;

            // Validate maximum duration (30 days)
            if (diffDays > MAX_LEAVE_DAYS) {
                endDateError.textContent = `Maximum leave duration is ${MAX_LEAVE_DAYS} days. You selected ${diffDays} days.`;
                endDateError.classList.add('show');
                
                alert.classList.add('show', 'error');
                durationText.innerHTML = `<strong>${diffDays} days</strong> - Exceeds maximum limit of ${MAX_LEAVE_DAYS} days`;
                submitBtn.disabled = true;
                return;
            }

            // Show duration with appropriate styling
            alert.classList.add('show');
            if (diffDays > 7) {
                alert.classList.add('warning');
                durationText.innerHTML = `<strong>${diffDays} days</strong> - Long leave, ensure proper documentation`;
            } else {
                alert.classList.add('success');
                durationText.innerHTML = `<strong>${diffDays} day${diffDays > 1 ? 's' : ''}</strong> - Duration selected`;
            }

            // Enable submit button if all validations pass
            submitBtn.disabled = false;
        } else {
            submitBtn.disabled = true;
        }
    }

    // Add event listeners
    document.getElementById('startDate').addEventListener('change', calculateDuration);
    document.getElementById('endDate').addEventListener('change', calculateDuration);

    // Form Submission with Loading State
    document.getElementById('leaveForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('submitBtn');
        btn.classList.add('loading');
        btn.innerHTML = '<i class="fas fa-spinner"></i><span>Submitting...</span>';
        btn.disabled = true;
    });

    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('startDate').setAttribute('min', today);
    document.getElementById('endDate').setAttribute('min', today);
</script>
</body>
</html>