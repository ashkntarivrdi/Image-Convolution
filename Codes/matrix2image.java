import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import javax.imageio.ImageIO;

public class matrix2image {

    public static void main(String[] args) {
        String dataFilePath = "vay.txt";
        String outputImagePath = "avali.png";

        createImageFromData(dataFilePath, outputImagePath);
    }

    public static void createImageFromData(String dataFilePath, String outputImagePath) {
        try (BufferedReader fileReader = new BufferedReader(new FileReader(dataFilePath))) {
            int rowIndex = 0;
            int columnIndex = 0;
            BufferedImage image = new BufferedImage(1000, 1000, BufferedImage.TYPE_INT_RGB);

            String inputLine;
            while ((inputLine = fileReader.readLine()) != null) {
                String[] values = inputLine.trim().split("\\s+");

                for (String value : values) {
                    if (value.trim().isEmpty())
                        continue;
                    // Convert value from String to float
                    float floatValue = Float.parseFloat(value);

                    int intValue = (int) floatValue;
                    intValue = getTheValue(intValue);

                    // Create grayscale RGB value using the value
                    int red = intValue << 16;  // Use input value for red channel
                    int green = intValue << 8;  // Use input value for green channel
                    int blue = intValue;  // Fixed value for blue channel
                    int rgbValue = (red) | (green) | blue;
//                    int rgbValue = (intValue << 16) | (intValue << 8) | intValue;

                    // Set pixel in the new image
                    image.setRGB(columnIndex, rowIndex, rgbValue);

                    columnIndex++;
                }
                rowIndex++;
                columnIndex = 0;
            }

            // Save the generated image
            ImageIO.write(image, "png", new File(outputImagePath));

            System.out.println("Image has been created and saved to: " + outputImagePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static int getTheValue(int floatValue) {
        if (floatValue < 255 && floatValue > 0)
            return floatValue;
        else if (floatValue < 0)
            return 0;
        return 255;
    }
}
