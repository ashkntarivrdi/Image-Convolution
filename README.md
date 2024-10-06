# Image Convolution in Assembly

This project demonstrates **image convolution** using **assembly language**, applying filters such as sharpen, blur, and edge detection by manipulating convolution kernels. The project showcases how assembly-level programming can efficiently handle image processing tasks with a focus on low-level optimizations.

## Overview

Convolution operations modify pixel values based on their neighbors, a technique commonly used in image processing. This project implements convolution with different kernels to achieve various effects on images.

### Features

- **Filters Implemented**:
  - **Sharpen**: Enhances edges and fine details.
  - **Edge Detection**: Identifies and highlights boundaries within the image.

- **Assembly-Language Optimization**:
  - Direct control over hardware allows **optimized performance** and **efficient memory usage**.
  - **Matrix operations** apply a 3x3 kernel (or custom sizes) for each pixel in the image, processing them in real-time.

- **Performance-Oriented**: The project is designed for fast image processing by leveraging the power of assembly.

## Project Structure

- **Kernel Definitions**: Located in `cross_normal.asm` and `cross_parallel.asm`, defining the convolution filters.
- **Image Processing**: The assembly routines handle pixel-by-pixel image transformations.
- **Matrix Operations**: Utilities such as matrix transposition are implemented to enhance convolution efficiency.
- **Sample Images**: Included test images demonstrate the visual effect of each filter.

## Workflow

1. **Input**: Load an image as a pixel matrix.
2. **Kernel Application**: Apply a 3x3 convolution kernel to modify pixel values.
3. **Output**: Save the processed image after the convolution is complete.

## Example Filters

Here’s an example of a **sharpen kernel**:

```plaintext
 0  -1  0
-1   5  -1
 0  -1  0
```

## Processed Image Samples

### Prheprocced Image
![normal_img](https://github.com/user-attachments/assets/a4be765e-f1fe-4490-855e-aaa77d5711ee)


Examples of images after applying different filters:

1. **Sharpened Image**: Enhanced edges and details.
![sharpened_img](https://github.com/user-attachments/assets/7ba73521-29a6-456f-b813-ffe105415add)

2. **Edge Detection**: Highlighted boundaries of objects in the image.
![edge_img](https://github.com/user-attachments/assets/80360425-c5bf-44b6-992f-5c7163596e7e)



## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/ashkntarivrdi/Image-Convolution.git
2. Compile the assembly code using NASM:

   ```bash
   nasm -f elf64 cross_normal.asm
3. Run the program with your input image:

   ```bash
   ./convolution input_image.bmp

## References

- [Convolution Theorem](https://en.wikipedia.org/wiki/Convolution_theorem)
- [Convolution in Image Processing](https://en.wikipedia.org/wiki/Kernel_(image_processing))
- [Assembly Language Optimizations](https://en.wikipedia.org/wiki/Assembly_language)
