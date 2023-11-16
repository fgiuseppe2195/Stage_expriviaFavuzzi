package ArrayMultipli;

public class Risultati {
    public static void main(String[] args) {
        int[] risultato1 = arraydiMultipli(7, 5);
        int[] risultato2 = arraydiMultipli(12, 10);
        int[] risultato3 = arraydiMultipli(17, 6);

        stampaArray(risultato1);
        stampaArray(risultato2);
        stampaArray(risultato3);
    }

    public static int[] arraydiMultipli(int num, int lunghezza) {
        int[] multipliArray = new int[lunghezza];

        for (int i = 0; i < lunghezza; i++) {
            multipliArray[i] = num * (i + 1);
        }

        return multipliArray;
    }

    public static void stampaArray(int[] array) {
        System.out.print("[");
        for (int i = 0; i < array.length; i++) {
            System.out.print(array[i]);
            if (i < array.length - 1) {
                System.out.print(", ");
            }
        }
        System.out.println("]");
    }
}