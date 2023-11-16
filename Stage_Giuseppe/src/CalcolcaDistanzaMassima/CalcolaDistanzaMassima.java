package CalcolcaDistanzaMassima;

public class CalcolaDistanzaMassima {
    public static double calcolaDistanzaMassima(double carburante, double carburanteUtilizzo, int passeggeri, boolean ariaCondizionata) {
        double consumoBase = carburanteUtilizzo * (1 + (passeggeri * 0.05));
        double consumoTotale = consumoBase;
        
        if (ariaCondizionata) {
            consumoTotale += consumoBase * 0.1;
        }
        
        return carburante / consumoTotale * 100;
    }
    
    public static void main(String[] args) {
        double distanza1 = calcolaDistanzaMassima(70.0, 7.0, 0, false);
        double distanza2 = calcolaDistanzaMassima(36.1, 8.6, 3, true);
        double distanza3 = calcolaDistanzaMassima(55.5, 5.5, 5, false);
        
        System.out.println("Distanza massima 1: " + distanza1);
        System.out.println("Distanza massima 2: " + distanza2);
        System.out.println("Distanza massima 3: " + distanza3);
    }
}