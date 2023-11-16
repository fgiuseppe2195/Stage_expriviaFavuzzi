package GuerradeiNumeri;

public class Guerra {

    public static void main(String[] args) {
        int[] numeri = {1, 2, 3, 4, 5, 6, 7, 8, 9}; // Puoi sostituire questo array con i tuoi dati

        int differenza = differenzaDispariPari(numeri);
        System.out.println("La differenza tra la somma dei numeri dispari e pari è: " + differenza);
    }

    public static int differenzaDispariPari(int[] numeri) {
        int sommaPari = 0;
        int sommaDispari = 0;

        for (int numero : numeri) {
            if (numero % 2 == 0) {
                // Numero pari
                sommaPari += numero;
            } else {
                // Numero dispari
                sommaDispari += numero;
            }
        }

        return sommaDispari - sommaPari;
    }
}