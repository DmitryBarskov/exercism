class BirdWatcher {
    private final int[] birdsPerDay;

    public BirdWatcher(int[] birdsPerDay) {
        this.birdsPerDay = birdsPerDay.clone();
    }

    public static int[] getLastWeek() {
        return new int[]{0, 2, 5, 3, 7, 8, 4};
    }

    public int getToday() {
        return birdsPerDay[birdsPerDay.length - 1];
    }

    public void incrementTodaysCount() {
        birdsPerDay[birdsPerDay.length - 1] += 1;
    }

    public boolean hasDayWithoutBirds() {
        for (int day = 0; day < birdsPerDay.length; day++) {
            if (birdsPerDay[day] == 0) {
                return true;
            }
        }
        return false;
    }

    public int getCountForFirstDays(int numberOfDays) {
        int total = 0;
        for (int day = 0; day < numberOfDays && day < birdsPerDay.length; day++) {
            total += birdsPerDay[day];
        }
        return total;
    }

    public int getBusyDays() {
        int busyDays = 0;
        for (int day = 0; day < birdsPerDay.length; day++) {
            if (birdsPerDay[day] >= 5) {
                busyDays += 1;
            }
        }
        return busyDays;
    }
}
