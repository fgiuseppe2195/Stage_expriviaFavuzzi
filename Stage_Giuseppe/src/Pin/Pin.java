package Pin;

import java.util.regex.Pattern;

public class Pin {
    public static void main(String[] args) {
        // Esempi
        String pinValido = "123456";
        String pinNonValido = "12 34";

        String risultatoValido = verificaPIN(pinValido);
        String risultatoNonValido = verificaPIN(pinNonValido);

        System.out.println(risultatoValido);  // Output: PIN valido
        System.out.println(risultatoNonValido);  // Output: PIN non valido
    }

    public static String verificaPIN(String pin) {
        // Definisci l'espressione regolare per il PIN valido
        String regex = "^\\d{4}$|^\\d{6}$";

        // Verifica se la stringa corrisponde alla regex
        if (Pattern.matches(regex, pin) && !pin.contains(" ")) {
            return "PIN valido";
        } else {
            return "PIN non valido";
        }
    }
}
