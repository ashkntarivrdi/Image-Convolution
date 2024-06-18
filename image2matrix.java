import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import javax.imageio.ImageIO;

public class image2matrix {

    public static void main(String[] args) {
        String sourceImagePath = "photo.jpg";
        String targetMatrixPath = "output_data.txt";

        try {
            File file = new File(sourceImagePath);
            BufferedImage sourceImage = ImageIO.read(file);

            if (sourceImage != null) {
                int imageWidth = sourceImage.getWidth();
                int imageHeight = sourceImage.getHeight();

                // Create a FileWriter to write pixel brightness values to a file
                FileWriter matrixFileWriter = new FileWriter(targetMatrixPath);

                for (int y = 0; y < imageHeight; y++) {
                    for (int x = 0; x < imageWidth; x++) {
                        int pixelRGB = sourceImage.getRGB(x, y);

                        // Extracting brightness from RGB value
                        int redValue = (pixelRGB >> 16) & 0xFF;
                        int greenValue = (pixelRGB >> 8) & 0xFF;
                        int blueValue = pixelRGB & 0xFF;

                        // Calculate brightness (average of RGB values)
                        int averageBrightness = (redValue + greenValue + blueValue) / 3;

                        // Write brightness value to file
                        matrixFileWriter.write(averageBrightness + " ");
                    }
                    // Move to the next line in the file after each row of pixels
                    matrixFileWriter.write("\n");
                }

                // Close the FileWriter
                matrixFileWriter.close();

                System.out.println("Pixel brightness values have been saved to: " + targetMatrixPath);
            } else {
                System.err.println("Failed to read the image.");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
