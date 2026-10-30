class SqueakyClean {
    static String clean(String identifier) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < identifier.length(); i++) {
            char character = identifier.charAt(i);
            if (Character.isLetter(character)) {
                if (i > 0 && identifier.charAt(i - 1) == '-') {
                    result.append(Character.toUpperCase(character));
                } else {
                    result.append(character);
                }
                continue;
            }

            String replacement = switch (character) {
                case ' ' -> "_";
                case '4' -> "a";
                case '3' -> "e";
                case '0' -> "o";
                case '1' -> "l";
                case '7' -> "t";
                default -> "";
            };
            result.append(replacement);
        }
        return result.toString();
    }
}
