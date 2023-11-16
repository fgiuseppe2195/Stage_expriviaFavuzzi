package AlberodiNodi;

public class AlberoBinario {
    private Nodo radice;

    public AlberoBinario() {
        radice = null;
    }

    public void inserisciNodo(String valoreStringa, Integer valoreIntero) {
        Nodo nuovoNodo = new Nodo(valoreStringa, valoreIntero);
        if (radice == null) {
            radice = nuovoNodo;
        } else {
            inserisciNodoRicorsivo(radice, nuovoNodo);
        }
    }

    private void inserisciNodoRicorsivo(Nodo nodoCorrente, Nodo nuovoNodo) {
        if (nuovoNodo.getValoreIntero() < nodoCorrente.getValoreIntero()) {
            if (nodoCorrente.getSinistro() == null) {
                nodoCorrente.setSinistro(nuovoNodo);
            } else {
                inserisciNodoRicorsivo(nodoCorrente.getSinistro(), nuovoNodo);
            }
        } else {
            if (nodoCorrente.getDestro() == null) {
                nodoCorrente.setDestro(nuovoNodo);
            } else {
                inserisciNodoRicorsivo(nodoCorrente.getDestro(), nuovoNodo);
            }
        }
    }

    public void stampaAlbero() {
        if (radice != null) {
            stampaAlberoRicorsivo(radice);
        }
    }

    private void stampaAlberoRicorsivo(Nodo nodoCorrente) {
        if (nodoCorrente != null) {
            nodoCorrente.stampaInfo();
            stampaAlberoRicorsivo(nodoCorrente.getSinistro());
            stampaAlberoRicorsivo(nodoCorrente.getDestro());
        }
    }

    public void stampaNodiFoglia() {
        if (radice != null) {
            stampaNodiFogliaRicorsivo(radice);
        }
    }

    private void stampaNodiFogliaRicorsivo(Nodo nodoCorrente) {
        if (nodoCorrente != null) {
            nodoCorrente.stampaNodiFoglia();
            stampaNodiFogliaRicorsivo(nodoCorrente.getSinistro());
            stampaNodiFogliaRicorsivo(nodoCorrente.getDestro());
        }
    }
}
