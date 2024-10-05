import java.util.Scanner;

public class crossProduct {
    static long startTime, endTime;
    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        // Getting size of the matrix from user
        System.out.print("Enter the size of the matrices (n): ");
        int n = scanner.nextInt();

        // Getting elements of matrices from user
        int[][] matrix1 = inputMatrix(n, "Enter the elements of the first matrix:");
        int[][] matrix2 = inputMatrix(n, "Enter the elements of the second matrix:");


        if (!areMatricesValid(matrix1, matrix2)) {
            System.out.println("Invalid input. Please enter valid n x n matrices.");
        } else {

            int[][] result = matrixCrossProduct(matrix1, matrix2);

            // Print the result
            System.out.println("Cross product of the matrices:");
            printMatrix(result);
        }
    }

    // Function for calculating the cross product of two matrices
    private static int[][] matrixCrossProduct(int[][] matrix1, int[][] matrix2) {

        int n = matrix1.length;
        int[][] resultMatrix = new int[n][n];

        // Calculate the cross product
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    resultMatrix[i][j] += matrix1[i][k] * matrix2[k][j];
                }
            }
        }

        return resultMatrix;
    }

    // Function for getting input from the user
    private static int[][] inputMatrix(int n, String message) {
        System.out.println(message);
        Scanner scanner = new Scanner(System.in);

        int[][] matrix = new int[n][n];

        // Get input from user
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                matrix[i][j] = scanner.nextInt();
            }
        }

        // Check if the number of entered elements is equal to n * n
        String next = scanner.nextLine();
        if (!next.equals("")) {
            System.out.println("Error: Too many elements entered. Please enter exactly " + n * n + " elements.");
            System.exit(1); // Exit the program with an error code
        }
        return matrix;
    }

    // Function for checking the validation of matrices
    private static boolean areMatricesValid(int[][] matrix1, int[][] matrix2) {
        int n = matrix1.length;
        System.out.println("n: " + n);

        // Check if the length of matrix 2 is equal to n or not
        if (matrix2.length != n) {
            return false;
        }

        for (int[] row : matrix1) {
            if (row.length != n) {
                return false;
            }
        }

        for (int[] row : matrix2) {
            if (row.length != n) {
                return false;
            }
        }

        return true;
    }

    // Function for printing the result matrix
    private static void printMatrix(int[][] matrix) {
        for (int[] row : matrix) {
            for (int element : row) {
                System.out.print(element + " ");
            }
            System.out.println();
        }
    }
}
