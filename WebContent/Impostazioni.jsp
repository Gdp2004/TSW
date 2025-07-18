<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.sql.*, java.util.*, javax.naming.*, javax.sql.*" %>
<%
    // Prendiamo l'email dell'utente loggato dalla sessione
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=login");
        return;
    }

    // Connessione al DataSource
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("jdbc/Database");

    // 1) Carica lo storico degli ordini di questo utente
    List<Map<String,Object>> orders = new ArrayList<>();
    String sqlOrders =
      "SELECT order_id, user_email, shipping_address, created_at, total_amount, status " +
      "FROM Orders WHERE user_email = ? ORDER BY created_at DESC";

    try (Connection conn = ds.getConnection();
         PreparedStatement ps = conn.prepareStatement(sqlOrders)) {
        ps.setString(1, userEmail);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> o = new HashMap<>();
                o.put("id",     rs.getInt("order_id"));
                o.put("email",  rs.getString("user_email"));
                o.put("address",rs.getString("shipping_address"));
                o.put("date",   rs.getTimestamp("created_at"));
                o.put("total",  rs.getBigDecimal("total_amount"));
                o.put("status", rs.getString("status"));
                orders.add(o);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>I tuoi Ordini – UniBook</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/Nav-bar-1.css"/>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/Logo-Search-Cart.css"/>
  <style>
    body { font-family: Arial,sans-serif; background:#f4f7fa; margin:0; }
    .container { max-width:900px; margin:2rem auto; padding:1rem; }
    h1, h2 { color:#2C6FA0; }
    table { width:100%; border-collapse:collapse; margin-bottom:2rem; }
    th,td { padding:.75rem 1rem; border:1px solid #ddd; }
    th { background:#e8f0f8; text-align:left; }
    .no-orders { text-align:center; color:#777; padding:2rem; }
  </style>
</head>
<body>
  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="container">
    <h1>Storico Ordini</h1>

    <table>
      <thead>
        <tr>
          <th># Ordine</th>
          <th>Email</th>
          <th>Indirizzo di Spedizione</th>
          <th>Data</th>
          <th>Importo</th>
          <th>Stato</th>
        </tr>
      </thead>
      <tbody>
        <% if (orders.isEmpty()) { %>
          <tr>
            <td colspan="6" class="no-orders">
              Non hai ancora effettuato ordini.
            </td>
          </tr>
        <% } else {
             for (Map<String,Object> o : orders) {
        %>
          <tr>
            <td><%= o.get("id") %></td>
            <td><%= o.get("email") %></td>
            <td><%= o.get("address") %></td>
            <td><%= o.get("date") %></td>
            <td>€<%= ((java.math.BigDecimal)o.get("total")).setScale(2) %></td>
            <td><%= o.get("status") %></td>
          </tr>
        <% }} %>
      </tbody>
    </table>
  </div>

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
