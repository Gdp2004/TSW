package it.unisa.Model.DAO;

import java.sql.SQLException;
import java.util.Collection;

public interface IBeanDao<T> {

    /**
     * Salva un nuovo bean nel data store.
     *
     * @param bean l'oggetto da salvare
     * @throws SQLException in caso di errore di accesso al database
     */
    void doSave(T bean) throws SQLException;

    /**
     * Elimina un bean in base alla chiave primaria (ISBN).
     *
     * @param key la chiave primaria (ISBN) del bean da eliminare
     * @return true se l'eliminazione è andata a buon fine, false altrimenti
     * @throws SQLException in caso di errore di accesso al database
     */
    boolean doDelete(String key) throws SQLException;

    /**
     * Recupera un bean in base alla chiave primaria (ISBN).
     *
     * @param key la chiave primaria (ISBN) del bean da recuperare
     * @return il bean trovato, o null se non esiste
     * @throws SQLException in caso di errore di accesso al database
     */
    T doRetrieveByKey(String key) throws SQLException;

    /**
     * Recupera tutti i bean, eventualmente ordinati in base a un campo.
     *
     * @param order la clausola ORDER BY (senza la keyword \"ORDER BY\"), o null/empty per nessun ordinamento
     * @return una Collection di bean
     * @throws SQLException in caso di errore di accesso al database
     */
    Collection<T> doRetrieveAll(String order) throws SQLException;
}
