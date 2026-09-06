<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đơn hàng</title>
</head>
<body>
    <div class="container py-2">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-receipt me-2 text-primary"></i>Lịch sử Đơn hàng
                </h2>
                <p class="text-muted mb-0 small">Theo dõi trạng thái và lịch sử mua sắm của bạn</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary shadow-sm">
                <i class="bi bi-bag-plus me-1"></i>Mua sắm thêm
            </a>
        </div>

        <div class="card shadow-sm border-0 rounded-4 overflow-hidden mb-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th class="text-center" style="width: 120px;">Mã đơn</th>
                                <th>Ngày đặt hàng</th>
                                <th>Sản phẩm</th>
                                <th class="text-center" style="width: 150px;">Tổng tiền</th>
                                <th class="text-center" style="width: 160px;">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center fw-bold text-primary">#ORD-202601</td>
                                <td>01/09/2026 14:30</td>
                                <td>Điện thoại iPhone 15 Pro Max (x1)</td>
                                <td class="text-center fw-bold text-danger">32.990.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">
                                        <i class="bi bi-check2-circle me-1"></i>Đã giao hàng
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center fw-bold text-primary">#ORD-202602</td>
                                <td>05/09/2026 09:15</td>
                                <td>Laptop Dell XPS 13 (x1)</td>
                                <td class="text-center fw-bold text-danger">28.500.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-info-subtle text-info border border-info-subtle px-3 py-2">
                                        <i class="bi bi-truck me-1"></i>Đang vận chuyển
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
