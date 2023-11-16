package AlberodiNodi;

public class Nodo {
    private String valoreStringa;
    private Integer valoreIntero;
    private Nodo sinistro;
    private Nodo destro;

    public Nodo(String valoreStringa, Integer valoreIntero) {
        this.valoreStringa = valoreStringa;
        this.valoreIntero = valoreIntero;
        this.sinistro = null;
        this.destro = null;
    }

    public Integer getValoreIntero() {
        return valoreIntero;
    }

    public Nodo getSinistro() {
        return sinistro;
    }

    public void setSinistro(Nodo sinistro) {
        this.sinistro = sinistro;
    }

    public Nodo getDestro() {
        return destro;
    }

    public void setDestro(Nodo destro) {
        this.destro = destro;
    }

    public void stampaInfo() {
        System.out.println("Valore Stringa: " + valoreStringa);
        System.out.println("Valore Intero: " + valoreIntero);
    }

    public void stampaNodiFoglia() {
        if (sinistro == null && destro == null) {
            stampaInfo();
        } else {
            if (sinistro != null) {
                sinistro.stampaNodiFoglia();
            }
            if (destro != null) {
                destro.stampaNodiFoglia();
            }
        }
    }
}