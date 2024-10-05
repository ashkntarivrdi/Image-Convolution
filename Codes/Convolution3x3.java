import java.util.Scanner;

public class Convolution3x3 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter the size of the matrix (n): ");
        int n = scanner.nextInt();

        // Create n x n matrix
        int[][] matrix = new int[n][n];

        System.out.println("Enter the matrix elements:");
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                matrix[i][j] = scanner.nextInt();
            }
        }

        // Check the validation of input matrix
        String next = scanner.nextLine();
        if (!next.equals("")) {
            System.out.println("Error: Too many elements entered. Please enter exactly " + n * n + " elements.");
            System.exit(1); // Exit the program with an error code
        }

        // Create 3x3 kernel
        int[][] kernel = new int[3][3];

        System.out.println("Enter the 3x3 kernel matrix:");
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                kernel[i][j] = scanner.nextInt();
            }
        }

        // Check the validation of input matrix
        next = scanner.nextLine();
        if (!next.equals("")) {
            System.out.println("Error: Too many elements entered. Please enter exactly " + n * n + " elements.");
            System.exit(1); // Exit the program with an error code
        }

        int[][] paddedMatrix = padMatrix(matrix, n);

        int[][] result = performConvolution(paddedMatrix, kernel, n);

        // System.out.println("Resultant matrix after convolution:");
        // printMatrix(result);

    }

    // Function for creating the padded matrix
    private static int[][] padMatrix(int[][] matrix, int n) {
        int[][] paddedMatrix = new int[n + 2][n + 2];

        // Copy original matrix into the center of padded matrix
        for (int i = 0; i < n; i++) {
            System.arraycopy(matrix[i], 0, paddedMatrix[i + 1], 1, n);
        }

        // Pad the edges using the described pattern
        for (int i = 0; i < n; i++) {
            paddedMatrix[0][i+1] = paddedMatrix[1][i+1];
            paddedMatrix[i + 1][0] = paddedMatrix[i + 1][1];
            paddedMatrix[n + 1][i + 1] = paddedMatrix[n][i + 1];
            paddedMatrix[i+1][n + 1] = paddedMatrix[i+1][n];
        }

        // Fill the corners
        paddedMatrix[0][0] = paddedMatrix[1][1];
        paddedMatrix[0][n + 1] = paddedMatrix[1][n];
        paddedMatrix[n + 1][0] = paddedMatrix[n][1];
        paddedMatrix[n + 1][n + 1] = paddedMatrix[n][n];

        return paddedMatrix;
    }

    // Function to do the convolution
    private static int[][] performConvolution(int[][] matrix, int[][] kernel, int n) {
        int[][] result = new int[n][n];

        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                result[i - 1][j - 1] = convolve(matrix, kernel, i, j);
            }
        }

        return result;
    }

    // Function for calculating the convolution of two matrices
    private static int convolve(int[][] matrix, int[][] kernel, int row, int col) {
        int sum = 0;

        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                sum += matrix[row + i - 1][col + j - 1] * kernel[i][j];
            }
        }

        return sum;
    }

    // Function for printing the result matrix
    private static void printMatrix(int[][] matrix) {
        for (int[] row : matrix) {
            for (int value : row) {
                System.out.print(value + " ");
            }
            System.out.println();
        }
    }
}
