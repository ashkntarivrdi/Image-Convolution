import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;
import java.util.Scanner;

public class crossProductRandom {
    private static final int RANDOM_LIMIT = 100;

    public static void main(String[] args) {
        long startTime = System.currentTimeMillis();

        Scanner scanner = new Scanner(System.in);

        // Get the input number
        System.out.print("Enter the size of the matrices (n): ");
        int n = scanner.nextInt();

        // Generate random matrices and write to file
        generateRandomMatricesToFile(n);

        // Read matrices from file
        int[][] matrix1 = readMatrixFromFile("JavaRandomMatrices.txt", n);
        int[][] matrix2 = readMatrixFromFile("JavaRandomMatrices.txt", n);


        // Check matrices validation
        if (!areMatricesValid(matrix1, matrix2)) {
            System.out.println("Invalid input from file. Please check the file contents.");
        } else {
            int[][] result = matrixCrossProduct(matrix1, matrix2);
            saveMatrixToFile(result, "JavaMatrixProductOutput.txt");
        }

        long endTime = System.currentTimeMillis();

        // Calculate total time of cross product operation
        long totalTime = endTime - startTime;
        System.out.println("Total execution time: " + totalTime + " milliseconds");

    }

    // Function for generating two random matrices with specific size
    private static void generateRandomMatricesToFile(int n) {
        try {
            FileWriter writer = new FileWriter("JavaRandomMatrices.txt");
            Random random = new Random();

            // Write size of matrices (n)
            writer.write(n + "\n");

            // Write elements for the first matrix
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    int randomValue = random.nextInt(RANDOM_LIMIT);
                    writer.write(randomValue + " ");
                }
                writer.write("\n");
            }

            // Write elements for the second matrix
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    int randomValue = random.nextInt(RANDOM_LIMIT);
                    writer.write(randomValue + " ");
                }
                writer.write("\n");
            }

            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Function for reading both matrices from a file
    private static int[][] readMatrixFromFile(String fileName, int n) {
        int[][] matrix = new int[n][n];

        try {
            Scanner scanner = new Scanner(new File(fileName));

            // Skip the first line (size of matrices)
            scanner.nextLine();

            // Read elements for the matrix
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    matrix[i][j] = scanner.nextInt();
                }
            }

            scanner.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return matrix;
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

    // Function for checking the validation of both matrices
    private static boolean areMatricesValid(int[][] matrix1, int[][] matrix2) {
        int n = matrix1.length;

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

    // Function for saving the result matrix into a file
    private static void saveMatrixToFile(int[][] result, String fileName) {
        try {
            FileWriter writer = new FileWriter(fileName);

            // Write the elements of the matrix to the file
            for (int[] row : result) {
                for (int element : row) {
                    writer.write(element + " ");
                }
                writer.write("\n");
            }

            writer.close();
            System.out.println("Result matrix saved to " + fileName);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
