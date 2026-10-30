public class JedliksToyCar {
    public static JedliksToyCar buy() {
        return new JedliksToyCar();
    }

    private int metersCovered = 0;
    private int batteryPercentage = 100;

    public String distanceDisplay() {
        return String.format("Driven %d meters", metersCovered);
    }

    public String batteryDisplay() {
        if (batteryPercentage <= 0) {
            return "Battery empty";
        }
        return String.format("Battery at %d%%", batteryPercentage);
    }

    public void drive() {
        if (batteryPercentage <= 0) {
            return;
        }
        metersCovered += 20;
        batteryPercentage -= 1;
    }
}
