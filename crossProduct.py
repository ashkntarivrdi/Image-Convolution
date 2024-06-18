def matrix_cross_product(matrix1, matrix2):
    n = len(matrix1)
    
    # Initialize the result matrix with zeros
    result_matrix = [[0.0] * n for _ in range(n)]

    # Calculate the cross product
    for i in range(n):
        for j in range(n):
            for k in range(n):
                result_matrix[i][j] += matrix1[i][k] * matrix2[k][j]

    return result_matrix

def input_matrix(n):
    matrix = []
    
    for _ in range(n):
        row_str = input("Enter a row of space-separated elements: ")
        row = list(map(float, row_str.split()))
        matrix.append(row)
    
    return matrix

if __name__ == "__main__":
    n_str = input("Enter the size of the matrices (n): ")
    n = int(n_str)

    print("Enter the elements of the first matrix:")
    matrix1 = input_matrix(n)

    print("Enter the elements of the second matrix:")
    matrix2 = input_matrix(n)

    if any(len(row) != n for row in matrix1) or any(len(row) != n for row in matrix2):
        print("Invalid input. Please enter valid n x n matrices.")
    else:
        result = matrix_cross_product(matrix1, matrix2)
        
        # Print the result
        print("Cross product of the matrices:")
        for row in result:
            print(" ".join(map(str, row)))
