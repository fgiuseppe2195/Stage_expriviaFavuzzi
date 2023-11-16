package Inverti;

public class main {

    public static String inverti(int n) {
        int numeroAssoluto = Math.abs(n);
        int risultato = 0;

        while (numeroAssoluto != 0) {
            risultato = risultato * 10 + numeroAssoluto % 10;
            numeroAssoluto /= 10;
        }

        return (n < 0) ? "-" + risultato : Integer.toString(risultato);
    }

    public static void main(String[] args) {
        System.out.println(inverti(5121));
        System.out.println(inverti(69));
        System.out.println(inverti(-122157));
    }
}
