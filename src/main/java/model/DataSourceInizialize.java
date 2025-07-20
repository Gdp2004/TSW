package model;


import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class DataSourceInizialize implements ServletContextListener {
    @Override
	public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        DataSource ds = null;

        try{
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");

            ds= (DataSource) envCtx.lookup("jdbc/Bookstore");

        } catch (NamingException e){
            System.out.println("error: " + e.getMessage());
        }

        context.setAttribute("DataSource", ds);
        System.out.println("contextInitialized: ds is " + ds);
    }

    @Override
	public void contextDestroyed(ServletContextEvent sce) {

    }
}