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
    <title>Giỏ hàng của bạn</title>
</head>
<body>
    <div class="container py-2">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-cart3 me-2 text-primary"></i>Giỏ hàng
                </h2>
                <p class="text-muted mb-0 small">Các sản phẩm bạn đã chọn mua</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left me-1"></i>Tiếp tục mua sắm
            </a>
        </div>

        <div class="card shadow-sm border-0 rounded-4 overflow-hidden mb-4">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Sản phẩm</th>
                                <th class="text-center" style="width: 140px;">Đơn giá</th>
                                <th class="text-center" style="width: 120px;">Số lượng</th>
                                <th class="text-end" style="width: 160px;">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light rounded p-2 me-3 border">
                                            <i class="bi bi-laptop fs-3 text-primary"></i>
                                        </div>
                                        <div>
                                            <h6 class="fw-bold mb-0">Sản phẩm mẫu thử nghiệm</h6>
                                            <small class="text-muted">Mã SP: #DEMO-01</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center fw-semibold">15.000.000 đ</td>
                                <td class="text-center">
                                    <span class="badge bg-secondary-subtle text-secondary px-3 py-2">1</span>
                                </td>
                                <td class="text-end fw-bold text-danger">15.000.000 đ</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                    <div>
                        <span class="text-muted">Tổng cộng (1 sản phẩm):</span>
                        <h4 class="fw-bold text-danger mb-0">15.000.000 đ</h4>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-success px-4 py-2 fw-semibold shadow-sm">
                            <i class="bi bi-credit-card me-1"></i>Tiến hành thanh toán
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
