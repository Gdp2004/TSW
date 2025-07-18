<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.*, java.util.*, javax.naming.*, javax.sql.*" %>
<%
    // Controllo login
    String userEmail = (String) session.getAttribute("email");
    Integer userId   = (Integer) session.getAttribute("userId");
    Integer orderId = (Integer) session.getAttribute("orderId");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=login");
        return;
    }

    // Intestazione DataSource
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("jdbc/Database");

    // Quale “tab” mostrare?
    String tab = request.getParameter("tab");
    if (tab == null) tab = "orders";

    // Preparo dati per entrambi i tab
    // --- Storico Ordini ---
    List<Map<String,Object>> orders = new ArrayList<>();
    if ("orders".equals(tab)) {
        String sqlOrders =
          "SELECT user_id, shipping_address, created_at, total_amount, status " +
          "FROM Orders WHERE user_email = ? ORDER BY created_at DESC";
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sqlOrders)) {
            ps.setString(1, userEmail);
            try (ResultSet rs = ps.executeQuery()) {
            	int i = 1;
                while (rs.next()) {
                    Map<String,Object> o = new HashMap<>();
                    o.put("id",     i++);
                    o.put("addr",   rs.getString("shipping_address"));
                    o.put("date",   rs.getTimestamp("created_at"));
                    o.put("total",  rs.getBigDecimal("total_amount"));
                    o.put("status", rs.getString("status"));
                    orders.add(o);
                }
            }
        }
    }
    // --- Dati Utente correnti ---
    String currName="", currSurname="", currEmail="";
    if ("profile".equals(tab)) {
        String sqlUser = "SELECT name, surname, email FROM UserAccount WHERE email=?";
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sqlUser)) {
            ps.setString(1, userEmail);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    currName    = rs.getString("name");
                    currSurname = rs.getString("surname");
                    currEmail   = rs.getString("email");
                    
                    session.setAttribute(currEmail,"currEmail");
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Impostazioni – UniBook</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/Nav-bar-1.css"/>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/Logo-Search-Cart.css"/>
  <style>
    body { font-family:Arial,sans-serif; background:#f4f7fa; margin:0; }
    .container { max-width:900px; margin:2rem auto; padding:1rem; background:#fff; border-radius:6px; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
    h1 { color:#2C6FA0; }
    .tabs { margin-bottom:2rem; }
    .tabs a {
      display:inline-block; padding:0.5rem 1rem; margin-right:0.5rem;
      color:#2C6FA0; text-decoration:none; border-bottom:2px solid transparent;
    }
    .tabs a.active { border-bottom-color:#2C6FA0; font-weight:bold; }
    table { width:100%; border-collapse:collapse; margin-bottom:1.5rem; }
    th,td { padding:0.75rem 1rem; border:1px solid #ddd; }
    th { background:#e8f0f8; text-align:left; }
    form { margin-top:1rem; }
    label { display:block; margin:0.75rem 0 0.25rem; color:#555; }
    input[type=text], input[type=email], input[type=password] {
      width:100%; padding:0.6rem; border:1px solid #ccc; border-radius:4px;
    }
    .no-data { text-align:center; color:#777; padding:2rem; }
    
    .btn {
  display: block;         /* diventa un blocco */
  margin: 1.5rem auto 0;  /* 1.5rem top, auto a sx/dx, 0 bottom */
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #2C6FA0 0%, #5BB5E5 100%);
  border: none;
  border-radius: 6px;
  cursor: pointer;
  box-shadow: inset 0 -2px 0 rgba(0,0,0,0.15), 0 4px 6px rgba(0,0,0,0.1);
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: inset 0 -3px 0 rgba(0,0,0,0.2), 0 6px 8px rgba(0,0,0,0.15);
}

.btn:active {
  transform: translateY(0);
  box-shadow: inset 0 -1px 0 rgba(0,0,0,0.1), 0 2px 4px rgba(0,0,0,0.1);
}
  </style>
</head>
<body>
  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="container">
    <h1>Le tue impostazioni</h1>

    <div class="tabs">
      <a href="?tab=orders" class="<%= tab.equals("orders")?"active":"" %>">Storico Ordini</a>
      <a href="?tab=profile" class="<%= tab.equals("profile")?"active":"" %>">Profilo Utente</a>
    </div>

    <% if ("orders".equals(tab)) { %>
      <% if (orders.isEmpty()) { %>
        <div class="no-data">Non hai ancora effettuato ordini.</div>
      <% } else { %>
        <table>
          <thead>
            <tr>
              <th># Ordine</th>
              <th>Indirizzo Spedizione</th>
              <th>Data</th>
              <th>Importo</th>
              <th>Stato</th>
            </tr>
          </thead>
          <tbody>
            <% for (Map<String,Object> o : orders) { %>
            <tr>
              <td><%= o.get("id") %></td>
              <td><%= o.get("addr") %></td>
              <td><%= o.get("date") %></td>
              <td>€<%= ((java.math.BigDecimal)o.get("total")).setScale(2) %></td>
              <td><%= o.get("status") %></td>
            </tr>
            <% } %>
          </tbody>
        </table>
      <% } %>

    <% } else if ("profile".equals(tab)) { %>
      <form action="<%=request.getContextPath()%>/profileupdateservlet" method="post">
        <label for="name">Nome</label>
        <input id="name" name="nome" type="text" value="<%= currName %>" required/>

        <label for="surname">Cognome</label>
        <input id="surname" name="surname" type="text" value="<%= currSurname %>" required/>

        <label for="email">E-mail</label>
        <input id="email" name="email" type="email" value="<%= currEmail %>" required/>

        <label for="password">Nuova Password (lascia vuoto per mantenere quella attuale)</label>
        <input id="password" name="password" type="password" />

        <button type="submit" class="btn rounded"><p>Aggiorna Profilo</p></button>
      </form>
    <% } %>

  </div>

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
