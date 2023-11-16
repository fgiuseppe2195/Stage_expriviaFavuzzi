package AlberodiNodi;

public class Main {
    public static void main(String[] args) {
        AlberoBinario albero = new AlberoBinario();
        
     
        albero.inserisciNodo("Nodo 1", 1);
        albero.inserisciNodo("Nodo 2", 2);
        albero.inserisciNodo("Nodo 3", 3);
        albero.inserisciNodo("Nodo 4", 4);
        albero.inserisciNodo("Nodo 5", 5);
        albero.inserisciNodo("Nodo 6", 6);
        albero.inserisciNodo("Nodo 7", 7);
        albero.inserisciNodo("Nodo 8", 8);
        albero.inserisciNodo("Nodo 9", 9);
        albero.inserisciNodo("Nodo 10", 10);
        albero.inserisciNodo("Nodo 11", 11);
        albero.inserisciNodo("Nodo 12", 12);
        
    
        albero.stampaAlbero();
        albero.stampaNodiFoglia();
    }
}