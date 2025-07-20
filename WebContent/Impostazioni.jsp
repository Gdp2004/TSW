<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.*, java.util.*, javax.naming.*, javax.sql.*" %>
<%
    // ————— Controllo login & admin —————
    String userEmail    = (String) session.getAttribute("email");
    Boolean isAdminPage = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/LoginForm.jsp?mode=login");
        return;
    }

    // ————— DataSource —————
    Context initCtx = new InitialContext();
    Context envCtx  = (Context) initCtx.lookup("java:comp/env");
    DataSource ds   = (DataSource) envCtx.lookup("jdbc/Database");

    // ————— Quale tab —————
    String tab = Optional.ofNullable(request.getParameter("tab")).orElse("orders");

    // ————— Filtri (solo admin/allOrders) —————
    String filterEmail = request.getParameter("filterEmail");
    String startDate   = request.getParameter("startDate");
    String endDate     = request.getParameter("endDate");

    // ————— Carica dati per ogni tab —————
    List<Map<String,Object>> userOrders = new ArrayList<>();
    List<Map<String,Object>> allOrders  = new ArrayList<>();
    String currName="", currSurname="", currMail="";

    if ("orders".equals(tab)) {
        String sql = "SELECT order_id, shipping_address, created_at, total_amount, status "
                   + "FROM Orders WHERE user_email=? ORDER BY created_at DESC";
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, userEmail);
            try (ResultSet rs = ps.executeQuery()) {
                int i=1;
                while(rs.next()) {
                    Map<String,Object> o=new HashMap<>();
                    o.put("id", i++);
                    o.put("addr", rs.getString("shipping_address"));
                    o.put("date", rs.getTimestamp("created_at"));
                    o.put("total", rs.getBigDecimal("total_amount"));
                    o.put("status", rs.getString("status"));
                    userOrders.add(o);
                }
            }
        }
    }

    if ("allOrders".equals(tab) && isAdminPage) {
        StringBuilder sb = new StringBuilder(
          "SELECT order_id,user_email,shipping_address,created_at,total_amount,status "
        + "FROM Orders WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (filterEmail!=null&&!filterEmail.isBlank()) {
            sb.append(" AND user_email=?"); params.add(filterEmail);
        }
        if (startDate!=null&&!startDate.isBlank()) {
            sb.append(" AND created_at>=?");
            params.add(Timestamp.valueOf(startDate+" 00:00:00"));
        }
        if (endDate!=null&&!endDate.isBlank()) {
            sb.append(" AND created_at<=?");
            params.add(Timestamp.valueOf(endDate+" 23:59:59"));
        }
        sb.append(" ORDER BY created_at DESC");

        try (Connection c=ds.getConnection();
             PreparedStatement ps=c.prepareStatement(sb.toString())) {
            for(int i=0;i<params.size();i++){
                Object p=params.get(i);
                if(p instanceof Timestamp) ps.setTimestamp(i+1,(Timestamp)p);
                else ps.setString(i+1,p.toString());
            }
            try (ResultSet rs=ps.executeQuery()){
                while(rs.next()){
                    Map<String,Object> o=new HashMap<>();
                    o.put("id", rs.getInt("order_id"));
                    o.put("email", rs.getString("user_email"));
                    o.put("addr", rs.getString("shipping_address"));
                    o.put("date", rs.getTimestamp("created_at"));
                    o.put("total", rs.getBigDecimal("total_amount"));
                    o.put("status", rs.getString("status"));
                    allOrders.add(o);
                }
            }
        }
    }

    if ("profile".equals(tab)) {
        String sql="SELECT name,surname,email FROM UserAccount WHERE email=?";
        try (Connection c=ds.getConnection();
             PreparedStatement ps=c.prepareStatement(sql)) {
            ps.setString(1,userEmail);
            try(ResultSet rs=ps.executeQuery()){
                if(rs.next()){
                    currName=rs.getString("name");
                    currSurname=rs.getString("surname");
                    currMail=rs.getString("email");
                }
            }
        }
    }

    List<Map<String,String>> categories=new ArrayList<>();
    if ("manageProducts".equals(tab) && isAdminPage) {
        String sql="SELECT category_id,name FROM Category ORDER BY name";
        try(Connection c=ds.getConnection();
            PreparedStatement ps=c.prepareStatement(sql);
            ResultSet rs=ps.executeQuery()){
            while(rs.next()){
                Map<String,String> m=new HashMap<>();
                m.put("id",rs.getString("category_id"));
                m.put("name",rs.getString("name"));
                categories.add(m);
            }
        }
    }
    
    if ("eliminateProduct".equals(tab) && isAdminPage) {
        String sql="SELECT category_id,name FROM Category ORDER BY name";
        try(Connection c=ds.getConnection();
            PreparedStatement ps=c.prepareStatement(sql);
            ResultSet rs=ps.executeQuery()){
            while(rs.next()){
                Map<String,String> m=new HashMap<>();
                m.put("id",rs.getString("category_id"));
                m.put("name",rs.getString("name"));
                categories.add(m);
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
  <style>
    body{margin:0;font-family:Verdana,sans-serif;background:#eef2f5;}
    .container{max-width:1000px;margin:2rem auto;padding:0 1rem;}
    .tabs{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:1rem;margin-bottom:2rem;}
    .tabs a{
      display:block;padding:.75rem 1rem;text-align:center;
      background:#fff;color:#2C6FA0;text-decoration:none;
      border-radius:6px;box-shadow:0 2px 6px rgba(0,0,0,0.1);
      transition:background .2s;
    }
    .tabs a.active, .tabs a:hover{background:linear-gradient(135deg,#2C6FA0,#5BB5E5);color:#fff;}
    .card{background:#fff;border-radius:8px;padding:1.5rem;
          box-shadow:0 2px 8px rgba(0,0,0,0.1);margin-bottom:2rem;}
    .card h2{margin-top:0;color:#2C6FA0;}
    table{width:100%;border-collapse:collapse;margin-top:1rem;}
    th,td{padding:.75rem 1rem;border-bottom:1px solid #ddd;}
    th{background:#f0f6fb;text-align:left;}
    .no-data{text-align:center;color:#555;padding:2rem;}
    form .form-group{margin-bottom:1rem;}
    form label{display:block;margin-bottom:.25rem;color:#333;}
    form input, form textarea, form select{
      width:100%;padding:.6rem;border:1px solid #ccc;border-radius:4px;
      font-size:1rem;
    }
    .btn-main{display:inline-block;padding:.75rem 1.5rem;
      background:linear-gradient(135deg,#2C6FA0,#5BB5E5);color:#fff;
      border:none;border-radius:6px;cursor:pointer;margin-top:1rem;
      transition:transform .15s;}
    .btn-main:hover{transform:translateY(-2px);}
    .grid-3{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:1rem;}
  </style>
</head>
<body>
  <%@ include file="/jsp/Nav-bar-1.jsp" %>
  <%@ include file="/jsp/Logo-Search-Cart.jsp" %>

  <div class="container">
    <div class="tabs">
      <a href="?tab=orders"   class="<%=tab.equals("orders")?"active":""%>">I miei ordini</a>
      <a href="?tab=profile"  class="<%=tab.equals("profile")?"active":""%>">Profilo</a>
      <% if(isAdminPage){ %>
        <a href="?tab=allOrders"      class="<%=tab.equals("allOrders")?"active":""%>">Tutti gli ordini</a>
        <a href="?tab=manageProducts" class="<%=tab.equals("manageProducts")?"active":""%>">Aggiungi libro</a>
        <a href="?tab=eliminateProduct" class="<%=tab.equals("eliminateProduct")?"active":"" %>">Elimina libro</a>
      <% } %>
    </div>

    <% if("orders".equals(tab)){ %>
      <div class="card">
        <h2>Storico ordini</h2>
        <% if(userOrders.isEmpty()){ %>
          <div class="no-data">Non hai ancora effettuato ordini.</div>
        <% } else { %>
          <table>
            <thead><tr><th>#</th><th>Indirizzo</th><th>Data</th><th>Importo</th><th>Stato</th></tr></thead>
            <tbody>
            <% for(var o:userOrders){ %>
              <tr>
                <td><%=o.get("id")%></td>
                <td><%=o.get("addr")%></td>
                <td><%=o.get("date")%></td>
                <td>€<%=((java.math.BigDecimal)o.get("total")).setScale(2)%></td>
                <td><%=o.get("status")%></td>
              </tr>
            <% } %>
            </tbody>
          </table>
        <% } %>
      </div>

    <% } else if("profile".equals(tab)){ %>
      <div class="card">
        <h2>Profilo Utente</h2>
        <form action="<%=request.getContextPath()%>/profileupdateservlet" method="post">
          <div class="form-group">
            <label>Nome</label>
            <input name="name" value="<%=currName%>" required/>
          </div>
          <div class="form-group">
            <label>Cognome</label>
            <input name="surname" value="<%=currSurname%>" required/>
          </div>
          <div class="form-group">
            <label>Email</label>
            <input name="email" type="email" value="<%=currMail%>" required/>
          </div>
          <div class="form-group">
            <label>Nuova Password</label>
            <input name="password" type="password" placeholder="(lascia vuoto)"/>
          </div>
          <button class="btn-main">Aggiorna Profilo</button>
        </form>
      </div>

    <% } else if("allOrders".equals(tab) && isAdminPage){ %>
      <div class="card">
        <h2>Gestione ordini (Admin)</h2>
        <form class="grid-3 filter-form" method="get">
          <input type="hidden" name="tab" value="allOrders"/>
          <input name="filterEmail" type="email" placeholder="Filtra per email" value="<%=filterEmail%>"/>
          <input name="startDate"   type="date" value="<%=startDate%>"/>
          <input name="endDate"     type="date" value="<%=endDate%>"/>
          <button class="btn-main">Applica Filtri</button>
        </form>
        <% if(allOrders.isEmpty()){ %>
          <div class="no-data">Nessun ordine trovato.</div>
        <% } else { %>
          <table>
            <thead>
              <tr><th>#</th><th>Email</th><th>Indirizzo</th><th>Data</th><th>Importo</th><th>Stato</th></tr>
            </thead>
            <tbody>
            <% for(var o:allOrders){ %>
              <tr>
                <td><%=o.get("id")%></td>
                <td><%=o.get("email")%></td>
                <td><%=o.get("addr")%></td>
                <td><%=o.get("date")%></td>
                <td>€<%=((java.math.BigDecimal)o.get("total")).setScale(2)%></td>
                <td><%=o.get("status")%></td>
              </tr>
            <% } %>
            </tbody>
          </table>
        <% } %>
      </div>

    <% } else if("manageProducts".equals(tab) && isAdminPage){ %>
      <div class="card">
        <h2>Aggiungi Nuovo Libro</h2>
        <form action="<%=request.getContextPath()%>/productmanagementservlet"
              method="post" enctype="multipart/form-data">
          <div class="form-group"><label>ISBN</label><input name="isbn" required/></div>
          <div class="form-group"><label>Titolo</label><input name="title" required/></div>
          <div class="form-group"><label>Autore</label><input name="author" required/></div>
          <div class="form-group"><label>Descrizione</label>
            <textarea name="description" rows="4" required></textarea>
          </div>
          <div class="grid-3">
            <div class="form-group"><label>Prezzo (€)</label>
              <input name="price" type="number" step="0.01" required/>
            </div>
            <div class="form-group"><label>Stock</label>
              <input name="stock_qty" type="number" min="0" required/>
            </div>
            <div class="form-group"><label>Copertina</label>
              <input name="image" type="file" accept="image/*"/>
            </div>
          </div>
          <div class="form-group">
            <label>Categorie (seleziona una o più)</label>
            <div class="categories">
              <% for(var cat:categories){ %>
                <label>
                  <input type="checkbox" name="categories" value="<%=cat.get("id")%>"/>
                  <%=cat.get("name")%>
                </label>
              <% } %>
            </div>
          </div>
          <button class="btn-main">Aggiungi Libro</button>
        </form>
      </div>
      
    <% }else if("eliminateProduct".equals(tab) && isAdminPage){ %>

    <!-- === Sezione elimina libro === -->
    <hr style="margin:2rem 0; border:none; border-top:1px solid #ddd;" />
    <h2 style="color:#D9534F;">Elimina Libro</h2>
    <form action="<%=request.getContextPath()%>/deletebookservlet"
          method="post">
      <div class="form-group">
        <label for="isbnDelete">ISBN del libro da eliminare</label>
        <input id="isbnDelete" name="isbn" type="text"
               placeholder="Es. 978-1234567890" required/>
      </div>
      <button type="submit"
              style="
                display:block;
                margin:1rem auto 0;
                padding:.75rem 1.5rem;
                background:#D9534F;
                color:#fff;
                border:none;
                border-radius:6px;
                cursor:pointer;
                transition:background .2s;
              "
              onmouseover="this.style.background='#C9302C';"
              onmouseout="this.style.background='#D9534F';">
        Elimina Libro
      </button>
    </form>
  
<% } %>


  </div>

  <%@ include file="/jsp/Footer.jsp" %>
</body>
</html>
