class CalculatorConundrum {
    public String calculate(int operand1, int operand2, String operation) {
        try {
            int result = switch (operation) {
                case "+" -> operand1 + operand2;
                case "*" -> operand1 * operand2;
                case "/" -> operand1 / operand2;
                case "" -> throw new IllegalArgumentException(
                    "Operation cannot be empty"
                );
                case null -> throw new IllegalArgumentException(
                    "Operation cannot be null"
                );
                default -> throw new IllegalOperationException(
                    "Operation '" + operation + "' does not exist"
                );
            };
            return String.format(
                "%d %s %d = %d", operand1, operation, operand2, result
            );
        } catch (ArithmeticException exception) {
            throw new IllegalOperationException(
                "Division by zero is not allowed",
                exception
            );
        }
    }
}
